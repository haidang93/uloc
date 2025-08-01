part of '../../uloc.dart';

mixin _WidgetNavigationModule on ULoCProviderInterface {
  /// This is to build the page widget
  Widget _buildWidgetPageWithNotifierProvider<P extends ULoCProvider>(
    Widget screen,
    P Function(BuildContext context) provider,
  ) {
    return ChangeNotifierProvider<P>(
      create: provider,
      child: _RouteWithProvider<P>(
        ancestorContext: _ancestorContexts,
        child: screen,
      ),
    );
  }

  /// Navigates to a new screen by adding a route to the navigation stack.
  ///
  /// This function allows you to push a new route to the navigation stack,
  /// optionally wrapping the screen with a provider of type [P] and passing
  /// additional arguments or custom transitions.
  ///
  /// Type Parameters:
  /// - [T]: The expected return type when the pushed route is popped.
  /// - [P]: The provider type that extends [ULoCProvider], used to wrap the screen.
  ///
  /// Parameters:
  /// - [screen]: The widget representing the new screen to navigate to.
  /// - [provider]: (Optional) A function that returns a provider of type [P]
  ///   which will be used to wrap the screen with a `ChangeNotifierProvider`.
  /// - [arguments]: (Optional) Any additional arguments to pass to the route.
  /// - [name]: (Optional) A custom name for the route, used for debugging/logging.
  /// - [transition]: (Optional) A custom page transition animation.
  /// - [curve]: The animation curve to apply to the transition. Defaults to [Curves.ease].
  ///
  /// Returns:
  /// A [Future] of type [T?] that completes when the new route is popped.
  ///
  /// Example:
  /// ```dart
  /// final result = await addRoute<String, MyProvider>(
  ///   MyScreen(),
  ///   provider: (context) => MyProvider(),
  ///   arguments: {'id': 42},
  ///   name: 'my_screen',
  /// );
  /// ```
  Future<T?> addRoute<T, P extends ULoCProvider>(
    Widget screen, {
    P Function(BuildContext context)? provider,
    Object? arguments,
    String? name,
    PageTransition? transition,
    Curve curve = Curves.ease,
  }) async {
    _RouteUtilities.log('addRoute ${name ?? screen.runtimeType}');
    context.closeKeyboard();

    Widget screenWidget = screen;
    if (provider != null) {
      screenWidget = _buildWidgetPageWithNotifierProvider<P>(screen, provider);
    }

    return await Navigator.of(context).push<T>(
      _RouteUtilities.buildRoute(
        page: screenWidget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
    );
  }

  /// Replaces the current route with a new screen.
  ///
  /// This function pushes a new route and removes the current one from the stack.
  /// It optionally wraps the screen with a provider of type [P] and allows
  /// passing arguments or custom transitions.
  ///
  /// Type Parameters:
  /// - [T]: The return type of the new route when popped.
  /// - [J]: The return type sent back to the previous route (the one being replaced).
  /// - [P]: The provider type that extends [ULoCProvider], used to wrap the screen.
  ///
  /// Parameters:
  /// - [screen]: The widget representing the new screen.
  /// - [provider]: (Optional) A function that returns a provider of type [P]
  ///   to wrap the screen with a `ChangeNotifierProvider`.
  /// - [arguments]: (Optional) Additional arguments to pass to the route.
  /// - [name]: (Optional) A custom route name, useful for debugging/logging.
  /// - [transition]: (Optional) A custom transition animation.
  /// - [curve]: The animation curve for the transition. Defaults to [Curves.ease].
  ///
  /// Returns:
  /// A [Future] of type [T?] that completes when the new route is popped.
  ///
  /// Example:
  /// ```dart
  /// final result = await replaceRoute<String, bool, MyProvider>(
  ///   MyScreen(),
  ///   provider: (context) => MyProvider(),
  ///   arguments: {'flag': true},
  ///   name: 'my_screen',
  /// );
  /// ```
  Future<T?> replaceRoute<T, J, P extends ULoCProvider>(
    Widget screen, {
    P Function(BuildContext context)? provider,
    Object? arguments,
    String? name,
    PageTransition? transition,
    Curve curve = Curves.ease,
  }) async {
    _RouteUtilities.log('offRoute ${name ?? screen.runtimeType}');
    context.closeKeyboard();

    Widget screenWidget = screen;

    if (provider != null) {
      screenWidget = _buildWidgetPageWithNotifierProvider<P>(screen, provider);
    }

    return await Navigator.of(context).pushReplacement<T, J>(
      _RouteUtilities.buildRoute(
        page: screenWidget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
    );
  }

  /// Replaces the entire route stack with a new route.
  ///
  /// This function pushes the given [screen] onto the navigator and removes
  /// all the previous routes according to the provided [predicate].
  ///
  /// Optionally, a [provider] can be passed to wrap the screen with a
  /// `ChangeNotifierProvider`.
  ///
  /// [arguments] are passed to the new route.
  ///
  /// You can provide a [name] for the route, a [transition] type,
  /// and a [curve] for the transition animation (default is [Curves.ease]).
  ///
  /// If [predicate] is not provided, all previous routes will be removed.
  ///
  /// Returns a [Future] that completes with a value when the pushed route is popped.
  ///
  /// Example usage:
  /// ```dart
  /// await replaceAllRoute(MyScreen(), name: '/home');
  /// ```
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
    context.closeKeyboard();

    Widget screenWidget = screen;

    if (provider != null) {
      screenWidget = _buildWidgetPageWithNotifierProvider<P>(screen, provider);
    }

    return await Navigator.of(context).pushAndRemoveUntil<T>(
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
}
