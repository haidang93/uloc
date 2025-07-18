part of '../uloc.dart';

const _deprecatedText =
    '''Navigational function is deprecated. Please nagivate using function from ULoCProvider

    ```dart
    class MyController extends ULoCProvider {
      MyController(super.context);

      @override
      void onReady() {
        super.onReady();
        getTo(Routes.Home);
      }
    }
    ```


    ''';

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

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /// navigational methods
  @Deprecated(_deprecatedText)
  void pop<T extends Object?>([T? result]) {
    if (hasParentRoute) {
      Navigator.of(this).pop<T>(result);
    } else {
      closeKeyboard();
    }
  }

  @Deprecated(_deprecatedText)
  void popUntil(String routeName) {
    if (hasParentRoute) {
      Navigator.of(this).popUntil(ModalRoute.withName(routeName));
    } else {
      closeKeyboard();
    }
  }

  @Deprecated(_deprecatedText)
  Future<T?> getTo<T>(
    String routeName, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('getTo $routeName');

    closeKeyboard();
    Uri uri = Uri.parse(routeName);
    uri = _processRouteQuery(uri, transition, curve);
    return await Navigator.of(
      this,
    ).pushNamed<T>(uri.toString(), arguments: arguments);
  }

  @Deprecated(_deprecatedText)
  Future<T?> off<T, J>(
    String routeName, {
    Object? arguments,
    J? result,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('off $routeName');

    closeKeyboard();
    Uri uri = Uri.parse(routeName);
    uri = _processRouteQuery(uri, transition, curve);
    return await Navigator.of(this).pushReplacementNamed<T, J>(
      uri.toString(),
      result: result,
      arguments: arguments,
    );
  }

  @Deprecated(_deprecatedText)
  Future<T?> offAll<T>(
    String routeName, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('offAll $routeName');

    closeKeyboard();
    Uri uri = Uri.parse(routeName);
    uri = _processRouteQuery(uri, transition, curve);
    return await Navigator.of(this).pushNamedAndRemoveUntil<T>(
      uri.toString(),
      (route) => false,
      arguments: arguments,
    );
  }

  @Deprecated(_deprecatedText)
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
      _buildRoute(
        page: screenWidget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
    );
  }

  @Deprecated(_deprecatedText)
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
      _buildRoute(
        page: screenWidget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
    );
  }

  @Deprecated(_deprecatedText)
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
      _buildRoute(
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

  Uri _processRouteQuery(
    Uri uri,
    PageTransition? transition,
    CurveEnum? curve,
  ) {
    return uri.replace(
      queryParameters: {
        ...uri.queryParametersAll,
        transitionParamKey: transition?.name,
        if (curve != null) curveParamKey: curve.name,
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
