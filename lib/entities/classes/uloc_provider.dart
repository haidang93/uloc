part of '../../uloc.dart';

/// ```dart
/// class DetailController extends ULoCProvider {
///   final String? id;
///   final BookDetail? data;
///   DetailController(super.context, {this.id, this.data});
///   String name = "Detail";
///   String content = "Detail has not yet implemented";
///
///   int count = 0;
///
///   @override
///   void onInit() {
///     super.onInit();
///
///     // get query from route
///     String utmSource = query('utm_source');
///     Map<String, dynamic> allQuery = queryParametersAll;
///
///     // get Flutter route arguments
///     final dynamic args =  arguments;
///
///     // get ULoC route arguments
///     final Map<String, dynamic>? args =  ulocArguments;
///   }
///
///   @override
///   void onReady() {
///     super.onReady();
///   }
///
///   @override
///   void onDispose() {
///     super.onDispose();
///   }
///
///   void increment() {
///     count++;
///     setstate();
///   }
///
///   void decrement() {
///     setstate(() {
///       count--;
///     });
///   }
/// }
///
/// ```
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

  /// Access ULoC arguments
  Map<String, dynamic>? get ulocArguments {
    if (context.routeArguments is UlocArguments) {
      return (context.routeArguments as UlocArguments).argumentsMap;
    }
    return null;
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

    /// location must be String || ULoCRoute || null
    dynamic location,
  }) {
    assert(location == null || location is String || location is ULoCRoute);

    String? locationString;

    if (location is String) {
      locationString = location;
    } else if (location is ULoCRoute) {
      locationString = location.path;
    }

    try {
      for (BuildContext ancestorContext in _ancestorContexts) {
        if (locationString != null &&
            ancestorContext.location.path != Uri.parse(locationString).path) {
          continue;
        }

        P? found;
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
      if (locationString != null) {
        _RouteUtilities.log(
          "Can't find any provider with name $P with location: $locationString",
        );
      } else {
        _RouteUtilities.log("Can't find any provider with name $P");
      }
      return null;
    }
  }

  /// Run when provider created
  void onInit() {
    _RouteUtilities.log('$runtimeType created');
  }

  /// Run after widget finish render
  void onReady() {
    _RouteUtilities.log('$runtimeType ready');
  }

  /// Run when widget disposed
  void onDispose() {
    _RouteUtilities.log('$runtimeType disposed');
  }

  /// update state
  void setstate([FutureOr<void> Function()? fn]) async {
    if (!mounted) return;
    if (fn != null) {
      await fn();
    }

    notifyListeners();
  }

  /// log
  void printLog([Object? message]) {
    _RouteUtilities.log('[$runtimeType]: $message');
  }

  /// navigational function
  void pop<T extends Object?>([T? result]) {
    if (context.hasParentRoute) {
      Navigator.of(context).pop<T>(result);
    } else {
      context.closeKeyboard();
    }
  }

  /// navigational function
  void popUntil(ULoCRoute route) {
    if (context.hasParentRoute) {
      Navigator.of(context).popUntil(ModalRoute.withName(route.name));
    } else {
      context.closeKeyboard();
    }
  }

  /// navigational function
  Future<T?> getTo<T, P>(
    ULoCRoute route, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('getTo ${route.path}');
    context.closeKeyboard();
    final ulocArguments = _RouteUtilities.buildUlocArguments(
      route: route,
      flutterArguments: arguments,
      arguments: route._arguments,
      transition: transition,
      curve: curve,
      ancestorContexts: _ancestorContexts,
    );
    return await Navigator.of(
      context,
    ).pushNamed<T>(route.path, arguments: ulocArguments);
  }

  /// navigational function
  Future<T?> off<T, J>(
    ULoCRoute route, {
    Object? arguments,
    J? result,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('off ${route.path}');
    context.closeKeyboard();
    final ulocArguments = _RouteUtilities.buildUlocArguments(
      route: route,
      flutterArguments: arguments,
      arguments: route._arguments,
      transition: transition,
      curve: curve,
      ancestorContexts: _ancestorContexts,
    );
    return await Navigator.of(context).pushReplacementNamed<T, J>(
      route.path,
      result: result,
      arguments: ulocArguments,
    );
  }

  /// navigational function
  Future<T?> offAll<T>(
    ULoCRoute route, {
    Object? arguments,
    PageTransition? transition,
    CurveEnum? curve,
  }) async {
    _RouteUtilities.log('offAll ${route.path}');
    context.closeKeyboard();
    final ulocArguments = _RouteUtilities.buildUlocArguments(
      route: route,
      flutterArguments: arguments,
      arguments: route._arguments,
      transition: transition,
      curve: curve,
      ancestorContexts: _ancestorContexts,
    );
    return await Navigator.of(context).pushNamedAndRemoveUntil<T>(
      route.path,
      (route) => false,
      arguments: ulocArguments,
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
