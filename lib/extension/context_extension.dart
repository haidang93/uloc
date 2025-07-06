part of '../uloc.dart';

extension ContextExtension on BuildContext {
  void closeKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  bool get hasParentRoute => ModalRoute.of(this)?.canPop ?? false;

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  // navigational methods
  void pop<T extends Object?>([T? result]) {
    if (hasParentRoute) {
      Navigator.of(this).pop<T>(result);
    } else {
      closeKeyboard();
    }
  }

  void popUntil(RouteName routeName) {
    if (hasParentRoute) {
      Navigator.of(this).popUntil(ModalRoute.withName(routeName));
    } else {
      closeKeyboard();
    }
  }

  Future<T?> pushNamed<T>(
    RouteName routeName, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('pushNamed $routeName');

    closeKeyboard();
    Uri uri = Uri.parse(routeName);
    uri = _processTransition(uri, transition, curve);
    return await Navigator.of(
      this,
    ).pushNamed<T>(uri.toString(), arguments: arguments);
  }

  Future<T?> pushReplacementNamed<T, J>(
    RouteName routeName, {
    Object? arguments,
    J? result,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('offNamed $routeName');

    closeKeyboard();
    Uri uri = Uri.parse(routeName);
    uri = _processTransition(uri, transition, curve);
    return await Navigator.of(this).pushReplacementNamed<T, J>(
      uri.toString(),
      result: result,
      arguments: arguments,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T>(
    RouteName routeName, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('offAllNamed $routeName');

    closeKeyboard();
    Uri uri = Uri.parse(routeName);
    uri = _processTransition(uri, transition, curve);
    return await Navigator.of(this).pushNamedAndRemoveUntil<T>(
      uri.toString(),
      (route) => false,
      arguments: arguments,
    );
  }

  Future<T?> push<T>(
    Widget widget, {
    Object? arguments,
    String? name,
    PageTransition? transition,
    Curve curve = Curves.ease,
  }) async {
    _RouteUtilities.log('pushNamed ${name ?? widget.runtimeType}');
    closeKeyboard();
    return await Navigator.of(this).push<T>(
      _buildRoute(
        page: widget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
    );
  }

  Future<T?> pushReplacement<T, J>(
    Widget widget, {
    Object? arguments,
    String? name,
    PageTransition? transition,
    Curve curve = Curves.ease,
  }) async {
    _RouteUtilities.log('pushNamed ${name ?? widget.runtimeType}');
    closeKeyboard();
    return await Navigator.of(this).pushReplacement<T, J>(
      _buildRoute(
        page: widget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
    );
  }

  Future<T?> pushAndRemoveUntil<T>(
    Widget widget, {
    Object? arguments,
    String? name,
    PageTransition? transition,
    Curve curve = Curves.ease,
    bool Function(Route<dynamic>)? predicate,
  }) async {
    _RouteUtilities.log('pushNamed ${name ?? widget.runtimeType}');
    closeKeyboard();
    return await Navigator.of(this).pushAndRemoveUntil<T>(
      _buildRoute(
        page: widget,
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

  Uri _processTransition(
    Uri uri,
    PageTransition? transition,
    CurveEnum? curve,
  ) {
    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        'transition': transition?.name,
        if (curve != null) 'curve': curve.name,
      },
    );
  }

  Route<T> _buildRoute<T>({
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
          return _RouteUtilities.buildTransition(
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
}
