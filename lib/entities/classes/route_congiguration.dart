part of '../../uloc.dart';

class _RoutesConfiguration {
  _RoutesConfiguration(this._routes);

  final List<RouteProperties> _routes;

  RouteMap get routes {
    final RouteMap result = {};
    for (var route in _routes) {
      result[route.routeName] = route.buildRouteMapElement;
    }
    return result;
  }

  Route<dynamic>? routeBuilder(RouteSettings settings) {
    final route = Uri.parse(settings.name ?? '');
    final declaredRouteName = _getDeclaredRoute(route);

    // Handle unknown routes
    if (declaredRouteName == null) {
      throw Exception(
        'Route "${route.path}" is not declared in routes.dart.\n'
        'Make sure you have registered this route using the correct name.\n'
        'Hint: Check for typos or missing route declarations in your routes.dart.',
      );
    }

    PageTransition? transition = PageTransition.values.firstWhere(
      (e) => e.name == route.queryParameters[transitionParamKey],
      orElse: () => PageTransition.none,
    );
    Curve curve = CurveEnum.values
        .firstWhere(
          (e) => e.name == route.queryParameters[curveParamKey],
          orElse: () => CurveEnum.ease,
        )
        .curve;

    Object? arguments = settings.arguments;
    if (arguments == null || arguments is Map<String, dynamic>) {
      arguments ??= <String, dynamic>{};
      arguments = {
        ...(arguments as Map<String, dynamic>),
        ...route.queryParametersAll,
      };
    }

    // Handle routes with parameters
    final param = _RouteUtilities._parseParam(declaredRouteName, route);
    final previousProviderCache = ULoCProvider._takePreviousProviderCache();

    if (transition == PageTransition.none) {
      return MaterialPageRoute(
        builder: (context) {
          return routes[declaredRouteName.path]!(
            context,
            param,
            previousProviderCache?._ancestorContexts,
          );
        },
        settings: RouteSettings(name: route.toString(), arguments: arguments),
      );
    } else {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            routes[declaredRouteName.path]!(
              context,
              param,
              previousProviderCache?._ancestorContexts,
            ),
        settings: RouteSettings(name: route.toString(), arguments: arguments),
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
      } else if (routes.containsKey(routeName.path)) {
        return Uri.parse(
          routes.keys.firstWhere((key) => key == routeName.path),
        );
      }

      for (var route in routes.keys) {
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
      if (routes['*'] != null) {
        _RouteUtilities.log("User WILDCARD route}");
        return Uri.parse('*');
      }

      return null;
    }
  }
}
