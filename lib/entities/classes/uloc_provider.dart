part of '../../uloc.dart';

class ULoCProvider with ChangeNotifier {
  /// The context of the provider.
  BuildContext context;

  /// The constructor for the BaseProvider.
  ULoCProvider(this.context);

  /// get arguments from previous route
  Object? get arguments {
    if (context.routeArguments is UlocArguments) {
      return (context.routeArguments as UlocArguments).flutterArguments;
    }
    return context.routeArguments;
  }

  /// moute state of this controller/widget
  bool get mounted => context.mounted;

  /// The query from routeName.
  /// ex: /home?utm_source=facebook&utm_medium=social
  Map<String, dynamic> get queryParametersAll {
    final result = <String, dynamic>{};
    for (var entry in context.location.queryParametersAll.entries) {
      if (entry.value.length == 1) {
        result[entry.key] = entry.value.first;
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  /// get query from routeName.
  /// ex: /home?utm_source=facebook&utm_medium=social
  Object? query(String? key) {
    return queryParametersAll[key];
  }

  ///

  /// ancestorProvider
  List<BuildContext> _ancestorContexts = [];

  /// Find provider from previous route
  P? findAncestorProviderOfType<P extends ULoCProvider>({
    bool listen = false,
    String? location,
  }) {
    try {
      for (BuildContext ancestorContext in _ancestorContexts) {
        P? found;

        if (location != null &&
            ancestorContext.location.path != Uri.parse(location).path) {
          continue;
        }

        if (listen) {
          found = ancestorContext.watch<P?>();
        } else {
          found = ancestorContext.read<P?>();
        }
        if (found != null) {
          return found;
        }
      }
      throw Exception();
    } catch (e) {
      _RouteUtilities.log("Can't find any provider with name $P");
      return null;
    }
  }

  void onInit() {
    _RouteUtilities.log('$runtimeType created');
  }

  void onReady() {
    _RouteUtilities.log('$runtimeType ready');
  }

  void onDispose() {
    _RouteUtilities.log('$runtimeType disposed');
  }

  void setstate([FutureOr<void> Function()? fn]) async {
    if (!mounted) return;
    if (fn != null) {
      await fn();
    }

    notifyListeners();
  }

  void printLog([Object? message]) {
    _RouteUtilities.log('[$runtimeType]: $message');
  }

  void pop<T extends Object?>([T? result]) {
    if (context.hasParentRoute) {
      Navigator.of(context).pop<T>(result);
    } else {
      context.closeKeyboard();
    }
  }

  void popUntil(ULoCRoute route) {
    if (context.hasParentRoute) {
      Navigator.of(context).popUntil(ModalRoute.withName(route.name));
    } else {
      context.closeKeyboard();
    }
  }

  Future<T?> getTo<T, P>(
    ULoCRoute route, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('getTo ${route.path}');
    context.closeKeyboard();
    final ulocArguments = _buildUlocArguments(
      route,
      arguments,
      route._arguments,
      transition,
      curve,
      _ancestorContexts,
    );
    return await Navigator.of(
      context,
    ).pushNamed<T>(route.path, arguments: ulocArguments);
  }

  Future<T?> off<T, J>(
    ULoCRoute route, {
    Object? arguments,
    J? result,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('off ${route.path}');
    context.closeKeyboard();
    final ulocArguments = _buildUlocArguments(
      route,
      arguments,
      route._arguments,
      transition,
      curve,
      _ancestorContexts,
    );
    return await Navigator.of(context).pushReplacementNamed<T, J>(
      route.path,
      result: result,
      arguments: ulocArguments,
    );
  }

  Future<T?> offAll<T>(
    ULoCRoute route, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('offAll ${route.path}');
    context.closeKeyboard();
    final ulocArguments = _buildUlocArguments(
      route,
      arguments,
      route._arguments,
      transition,
      curve,
      _ancestorContexts,
    );
    return await Navigator.of(context).pushNamedAndRemoveUntil<T>(
      route.path,
      (route) => false,
      arguments: ulocArguments,
    );
  }

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
      screenWidget = _buildCustomWidgetPage<P>(screen, provider);
    }

    return await Navigator.of(context).push<T>(
      _buildRoute(
        page: screenWidget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
    );
  }

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
      screenWidget = _buildCustomWidgetPage<P>(screen, provider);
    }

    return await Navigator.of(context).pushReplacement<T, J>(
      _buildRoute(
        page: screenWidget,
        arguments: arguments,
        name: name,
        transition: transition,
        curve: curve,
      ),
    );
  }

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
      screenWidget = _buildCustomWidgetPage<P>(screen, provider);
    }

    return await Navigator.of(context).pushAndRemoveUntil<T>(
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

  UlocArguments _buildUlocArguments(
    ULoCRoute route,
    Object? flutterArguments,
    Map<String, dynamic> arguments,
    PageTransition? transition,
    CurveEnum? curve,
    List<BuildContext> ancestorContexts,
  ) => UlocArguments._private(
    route: route,
    flutterArguments: arguments,
    argumentsMap: {
      ...arguments,
      transitionParamKey: transition?.name,
      curveParamKey: curve?.name,
      ancestorContextsKey: _ancestorContexts,
    },
  );

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
      create: provider,
      child: _RouteWithProvider<P>(
        ancestorContext: _ancestorContexts,
        child: screen,
      ),
    );
  }
}
