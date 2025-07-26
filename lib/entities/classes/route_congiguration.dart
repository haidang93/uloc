part of '../../uloc.dart';

class _RoutesConfiguration {
  _RoutesConfiguration(List<RouteProperties> routes) {
    final RouteMap result = {};
    for (var route in routes) {
      result[route.routeName.name] = route.buildRouteMapElement;
    }
    _routes = result;
  }

  RouteMap _routes = {};

  Route<dynamic>? routeBuilder(RouteSettings settings) {
    // reconstruct ULoCRoute from string
    final uri = Uri.parse(settings.name ?? '');
    final declaredRouteName = _getDeclaredRoute(uri);
    // Handle unknown routes
    if (declaredRouteName == null) {
      if (settings.name == '/') {
        return MaterialPageRoute(
          builder: (context) => Scaffold(),
          settings: settings,
        );
      }
      throw Exception(
        'Route "${uri.path}" is not declared in routes.dart.\n'
        'Make sure you have registered this route using the correct name.\n'
        'Hint: Check for typos or missing route declarations in your routes.dart.',
      );
    }
    final param = _RouteUtilities._parseParam(declaredRouteName, uri);
    final ulocRoute = ULoCRoute(declaredRouteName.path, routeParams: param);

    PageTransition transition = PageTransition.none;
    Curve curve = CurveEnum.ease.curve;
    List<BuildContext> ancestorContexts = [];
    final arguments = settings.arguments;
    if (arguments is UlocArguments) {
      final transitionName = arguments.argumentsMap?[_transitionParamKey];
      transition = PageTransition.values.firstWhere(
        (e) => e.name == transitionName,
        orElse: () => PageTransition.none,
      );
      curve = arguments.argumentsMap?[_curveParamKey] ?? CurveEnum.ease.curve;
      ancestorContexts = arguments.argumentsMap?[_ancestorContextsKey] ?? [];
    }

    // Handle routes with parameters

    if (transition == PageTransition.none) {
      return MaterialPageRoute(
        builder: (context) {
          return _routes[declaredRouteName.path]!(
            context,
            ulocRoute,
            ancestorContexts,
          );
        },
        settings: RouteSettings(
          name: ulocRoute.toString(),
          arguments: arguments,
        ),
      );
    } else {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _routes[declaredRouteName.path]!(
              context,
              ulocRoute,
              ancestorContexts,
            ),
        settings: RouteSettings(
          name: ulocRoute.toString(),
          arguments: arguments,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _RouteUtilities.buildTransition(
            context,
            animation,
            secondaryAnimation,
            child,
            curve,
            transition,
          );
        },
      );
    }
  }

  /// get the route definition from declared [routes]
  Uri? _getDeclaredRoute(Uri? routeName) {
    try {
      if (routeName == null || routeName.path.isEmpty) {
        throw Exception();
      } else if (_routes.containsKey(routeName.path)) {
        return Uri.parse(
          _routes.keys.firstWhere((key) => key == routeName.path),
        );
      }

      for (var route in _routes.keys) {
        final patternSegments = Uri.parse(route).pathSegments;
        final pathSegments = routeName.pathSegments;

        if (patternSegments.length != pathSegments.length) {
          continue;
        }

        bool matched = true;
        for (int i = 0; i < patternSegments.length; i++) {
          final patternSegment = patternSegments[i];
          final pathSegment = pathSegments[i];

          // If segment starts with ':', it's a parameter and can match anything
          if (!patternSegment.startsWith(':') &&
              patternSegment != pathSegment) {
            matched = false;
            break;
          }
        }
        if (matched) return Uri.parse(route);
      }
      throw Exception();
    } catch (e) {
      if (_routes['*'] != null) {
        _RouteUtilities.log("User WILDCARD route");
        return Uri.parse('*');
      }

      return null;
    }
  }
}
