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
    final declaredRouteName = _getRoute(route);

    // Handle unknown routes
    if (declaredRouteName == null) {
      throw Exception(
        'Route "${settings.name}" is not declared in routes.dart.\n'
        'Make sure you have registered this route using the correct name.\n'
        'Hint: Check for typos or missing route declarations in your routes.dart.',
      );
    }

    PageTransition? transition = PageTransition.values.firstWhere(
      (e) => e.name == route.queryParameters['transition'],
      orElse: () => PageTransition.none,
    );
    Curve curve = CurveEnum.values
        .firstWhere(
          (e) => e.name == route.queryParameters['curve'],
          orElse: () => CurveEnum.ease,
        )
        .curve;

    // Handle routes with parameters
    final param = _RouteUtilities._parseParam(declaredRouteName, route);

    if (transition == PageTransition.none) {
      return MaterialPageRoute(
        builder: (context) => routes[declaredRouteName.path]!(context, param),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      );
    } else {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            routes[declaredRouteName.path]!(context, param),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
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
  Uri? _getRoute(Uri? routeName) {
    try {
      if (routeName == null || routeName.path.isEmpty) {
        return null;
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
      return null;
    } catch (e) {
      return null;
    }
  }
}
