part of '../uloc.dart';

class _RouteUtilities {
  /// extract route parameter from route name
  static List<String?> _parseParam(Uri? routeName, Uri route) {
    final result = <String?>[];

    if (routeName == null) return result;

    final patternSegments = routeName.pathSegments;
    final pathSegments = route.pathSegments;

    if (patternSegments.length != pathSegments.length) {
      return [];
    }

    for (int i = 0; i < patternSegments.length; i++) {
      final patternSegment = patternSegments[i];
      final pathSegment = pathSegments[i];

      if (patternSegment.startsWith(':') && pathSegment.isNotEmpty) {
        if (patternSegment != pathSegment) {
          result.add(pathSegment);
        } else {
          result.add(null);
        }
      }
    }

    return result;
  }

  static void log(String? message) {
    if (message != null) {
      dev.log(message, name: 'ULoC', time: DateTime.now());
    }
  }

  static UlocArguments buildUlocArguments({
    required ULoCRoute route,
    List<BuildContext>? ancestorContexts,
    Object? flutterArguments,
    Map<String, dynamic> arguments = const {},
    PageTransition? transition,
    CurveEnum? curve,
  }) => UlocArguments._private(
    route: route,
    flutterArguments: flutterArguments,
    argumentsMap: {
      ...arguments,
      _transitionParamKey: transition?.name,
      _curveParamKey: curve?.name,
      _ancestorContextsKey: ancestorContexts ?? [],
    },
  );

  static Route<T> buildRoute<T>({
    required Widget page,
    dynamic arguments,
    String? name,
    PageTransition? transition,
    Curve curve = Curves.ease,
  }) {
    final settings = RouteSettings(
      arguments: arguments,
      name: name ?? page.runtimeType.toString(),
    );

    Route<T> route;
    if (transition == null) {
      route = MaterialPageRoute(builder: (_) => page, settings: settings);
    } else {
      route = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return buildTransition(
            context,
            animation,
            secondaryAnimation,
            child,
            curve,
            transition,
          );
        },
        settings: settings,
      );
    }
    return route;
  }

  static Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    Curve curve,
    PageTransition transition,
  ) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    switch (transition) {
      case PageTransition.zoom:
        final tween = Tween(begin: 0.0, end: 1.0);
        return ScaleTransition(
          scale: tween.animate(curvedAnimation),
          child: child,
        );
      case PageTransition.fade:
        final tween = Tween(begin: 0.0, end: 1.0);
        return FadeTransition(
          opacity: tween.animate(curvedAnimation),
          child: child,
        );
      case PageTransition.downToUp:
        final tween = Tween(begin: const Offset(0, 1.0), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      case PageTransition.leftToRight:
        final tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      case PageTransition.rightToLeft:
        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      default:
        final tween = Tween(begin: 0.0, end: 1.0);
        return FadeTransition(
          opacity: tween.animate(curvedAnimation),
          child: child,
        );
    }
  }
}
