part of '../../uloc.dart';

abstract class ULoCProviderInterface {
  /// The context of the provider.
  BuildContext context;

  /// The constructor for the Provider.
  ULoCProviderInterface(this.context) {
    onCreate();
  }

  @mustCallSuper
  void onCreate() {
    printLog('Created');
  }

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

  /// ancestorProvider
  List<BuildContext> _ancestorContexts = [];

  /// Find provider from previous route
  P? findAncestorProviderOfType<P extends ULoCProviderInterface>({
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

  /// Print log with class name
  ///
  /// For readability purpose
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
}
