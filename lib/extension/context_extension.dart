part of '../uloc.dart';

/// Extension on [BuildContext] providing convenient utilities for
/// keyboard control and ULoC-based navigation.
///
/// This extension enhances the usability of [BuildContext] by offering:
/// - Keyboard dismissal
/// - Access to route metadata
/// - Simplified navigation with optional providers, transitions, and curves
extension ContextExtension on BuildContext {
  /// Closes the soft keyboard if it is open.
  ///
  /// This checks if the current [FocusScope] does not have the primary focus
  /// but still has a focus node, and then calls `unfocus` to dismiss the keyboard.
  void closeKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  /// Returns `true` if the current route can be popped (i.e., has a parent route).
  bool get hasParentRoute => ModalRoute.of(this)?.canPop ?? false;

  /// Retrieves the Flutter navigation arguments associated with the current route.
  Object? get routeArguments => ModalRoute.of(this)?.settings.arguments;

  /// Gets the URI representation of the current route's name.
  Uri get location => Uri.parse(ModalRoute.of(this)?.settings.name ?? '');

  /// Attempts to pop the current route with an optional [result].
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  /// Pops routes until the specified [routeName] is reached.
  ///
  /// All routes above the given route will be removed from the stack.
  void popUntil(String routeName) {
    Navigator.of(this).popUntil(ModalRoute.withName(routeName));
  }

  /// Pushes a named route ([ULoCRoute]) onto the stack.
  ///
  /// Optionally accepts [arguments], [transition], and [curve] for animated navigation.
  /// Returns a [Future] that resolves when the route is popped.
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

  /// Replaces the current route with a named route ([ULoCRoute]).
  ///
  /// Optionally accepts [arguments], [result], [transition], and [curve].
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

  /// Replaces all existing routes with the specified [ULoCRoute].
  ///
  /// Useful for resetting the navigation stack.
  /// Accepts optional [arguments], [transition], and [curve].
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

  /// Pushes a new widget [screen] onto the navigation stack.
  ///
  /// Optionally wraps it with a provider, accepts [arguments], route [name],
  /// animation [transition], and animation [curve].
  ///
  /// Returns a [Future] resolving when the route is popped.
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

  /// Replaces the current route with a new widget [screen].
  ///
  /// Supports optional provider wrapping, [arguments], route [name], animation [transition],
  /// and animation [curve].
  ///
  /// Returns a [Future] resolving when the new route is popped.
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

  /// Replaces the entire navigation stack with a new widget [screen].
  ///
  /// Supports optional provider wrapping, [arguments], route [name], animation [transition],
  /// and animation [curve]. Can optionally keep some routes using [predicate].
  ///
  /// Returns a [Future] resolving when the new route is popped.
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

  /// Internal utility to wrap a [screen] with a [ChangeNotifierProvider] for [P].
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
