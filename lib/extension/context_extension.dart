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
    closeKeyboard();
    Uri uri = Uri.parse(routeName);
    uri = _processTransition(uri, transition, curve);
    return await Navigator.of(
      this,
    ).pushNamed<T>(uri.toString(), arguments: arguments);
  }

  Future<T?> offNamed<T, J>(
    RouteName routeName, {
    Object? arguments,
    J? result,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    closeKeyboard();
    Uri uri = Uri.parse(routeName);
    uri = _processTransition(uri, transition, curve);
    return await Navigator.of(this).pushReplacementNamed<T, J>(
      uri.toString(),
      result: result,
      arguments: arguments,
    );
  }

  Future<T?> offAllNamed<T>(
    RouteName routeName, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    closeKeyboard();
    Uri uri = Uri.parse(routeName);
    uri = _processTransition(uri, transition, curve);
    return await Navigator.of(this).pushNamedAndRemoveUntil<T>(
      uri.toString(),
      (route) => false,
      arguments: arguments,
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
}
