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

  /// navigational function
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

  /// navigational function
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

  /// navigational function
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
