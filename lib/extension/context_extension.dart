part of '../uloc.dart';

// const _deprecatedText =
//     '''Navigational function is deprecated. Please nagivate using function from ULoCProvider

//     ```dart
//     class MyController extends ULoCProvider {
//       MyController(super.context);

//       @override
//       void onReady() {
//         super.onReady();
//         getTo(Routes.Home);
//       }
//     }
//     ```

//     ''';

/// context utilities
extension ContextExtension on BuildContext {
  void closeKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  bool get hasParentRoute => ModalRoute.of(this)?.canPop ?? false;

  Object? get routeArguments => ModalRoute.of(this)?.settings.arguments;

  /// Route Name of this page
  Uri get location => Uri.parse(ModalRoute.of(this)?.settings.name ?? '');

  /// navigational methods
  void pop<T extends Object?>([T? result]) {
    if (hasParentRoute) {
      Navigator.of(this).pop<T>(result);
    } else {
      closeKeyboard();
    }
  }

  /// navigational methods
  void popUntil(String routeName) {
    if (hasParentRoute) {
      Navigator.of(this).popUntil(ModalRoute.withName(routeName));
    } else {
      closeKeyboard();
    }
  }

  /// navigational methods
  Future<T?> getTo<T>(
    ULoCRoute route, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('getTo ${route.path}');
    closeKeyboard();
    final ulocArguments = _RouteUtilities.buildUlocArguments(
      route: route,
      flutterArguments: arguments,
      arguments: route._arguments,
      transition: transition,
      curve: curve,
    );
    return await Navigator.of(
      this,
    ).pushNamed<T>(route.path, arguments: ulocArguments);
  }

  /// navigational methods
  Future<T?> off<T, J>(
    ULoCRoute route, {
    Object? arguments,
    J? result,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('off ${route.path}');
    closeKeyboard();
    final ulocArguments = _RouteUtilities.buildUlocArguments(
      route: route,
      flutterArguments: arguments,
      arguments: route._arguments,
      transition: transition,
      curve: curve,
    );
    return await Navigator.of(this).pushReplacementNamed<T, J>(
      route.path,
      result: result,
      arguments: ulocArguments,
    );
  }

  /// navigational methods
  Future<T?> offAll<T>(
    ULoCRoute route, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('offAll ${route.path}');
    closeKeyboard();
    final ulocArguments = _RouteUtilities.buildUlocArguments(
      route: route,
      flutterArguments: arguments,
      arguments: route._arguments,
      transition: transition,
      curve: curve,
    );
    return await Navigator.of(this).pushNamedAndRemoveUntil<T>(
      route.path,
      (route) => false,
      arguments: ulocArguments,
    );
  }

  /// navigational methods
  Future<T?> addRoute<T, P extends ULoCProvider>(
    Widget screen, {
    P Function(BuildContext context)? provider,
    Object? arguments,
    String? name,
    PageTransition? transition,
    Curve curve = Curves.ease,
  }) async {
    _RouteUtilities.log('addRoute ${name ?? screen.runtimeType}');
    closeKeyboard();

    Widget screenWidget = screen;

    if (provider != null) {
      screenWidget = _buildCustomWidgetPage<P>(screen, provider);
    }

    return await Navigator.of(this).push<T>(
      _RouteUtilities.buildRoute(
        page: screenWidget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
    );
  }

  /// navigational methods
  Future<T?> replaceRoute<T, J, P extends ULoCProvider>(
    Widget screen, {
    P Function(BuildContext context)? provider,
    Object? arguments,
    String? name,
    PageTransition? transition,
    Curve curve = Curves.ease,
  }) async {
    _RouteUtilities.log('offRoute ${name ?? screen.runtimeType}');
    closeKeyboard();

    Widget screenWidget = screen;

    if (provider != null) {
      screenWidget = _buildCustomWidgetPage<P>(screen, provider);
    }

    return await Navigator.of(this).pushReplacement<T, J>(
      _RouteUtilities.buildRoute(
        page: screenWidget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
    );
  }

  /// navigational methods
  Future<T?> replaceAllRoute<T, P extends ULoCProvider>(
    Widget screen, {
    P Function(BuildContext context)? provider,
    Object? arguments,
    String? name,
    PageTransition? transition,
    Curve curve = Curves.ease,
    bool Function(Route<dynamic>)? predicate,
  }) async {
    _RouteUtilities.log('offAllRoute ${name ?? screen.runtimeType}');
    closeKeyboard();

    Widget screenWidget = screen;

    if (provider != null) {
      screenWidget = _buildCustomWidgetPage<P>(screen, provider);
    }

    return await Navigator.of(this).pushAndRemoveUntil<T>(
      _RouteUtilities.buildRoute(
        page: screenWidget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
      (r) {
        if (predicate != null) {
          return predicate(r);
        } else {
          return false;
        }
      },
    );
  }

  Widget _buildCustomWidgetPage<P extends ULoCProvider>(
    Widget screen,
    P Function(BuildContext context) provider,
  ) {
    return ChangeNotifierProvider<P>(
      create: (context) => provider(context),
      child: _RouteWithProvider<P>(child: screen),
    );
  }
}
