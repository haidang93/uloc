part of '../../uloc.dart';

/// Base interface for all ULoC providers.
///
/// This abstract class defines the foundational structure for both
/// stateful and stateless providers in the ULoC (Universal Logic Component)
/// architecture. It provides common lifecycle hooks, context-aware routing,
/// argument access, and provider traversal capabilities.
///
/// ### Lifecycle
/// - The `onCreate()` method is called immediately upon construction.
/// - Subclasses can override `onCreate()` to perform setup logic.
///
/// ### Navigation Utilities
/// Includes navigation methods such as:
/// - `getTo()`, `off()`, `offAll()` for named route navigation
/// - `pop()` and `popUntil()` for back navigation
///
/// ### Arguments & Query Access
/// - Use `arguments` and `ulocArguments` to access route arguments.
/// - Use `query()` and `queryParametersAll` to retrieve URL query parameters.
///
/// ### Provider Traversal
/// - `findAncestorProviderOfType<P>()` allows retrieving providers
///   from previous routes, optionally filtered by location.
///
/// ### Example:
/// ```dart
/// class MyProvider extends ULoCProviderInterface {
///   MyProvider(BuildContext context) : super(context);
///
///   @override
///   void onCreate() {
///     super.onCreate();
///     // Custom setup
///   }
/// }
/// ```
///
/// This class should be extended by custom provider implementations
/// and is not meant to be used directly.
abstract class ULoCProviderInterface {
  /// The [BuildContext] associated with this provider.
  ///
  /// This context is typically tied to the widget tree from which the
  /// provider is initialized. It is used for accessing route arguments,
  /// navigation, and other context-based operations within the provider.
  ///
  /// Always available after the provider is constructed.
  BuildContext context;

  /// Creates a new [ULoCProviderInterface] with the given [context].
  ///
  /// Automatically calls [onCreate] during construction, allowing subclasses
  /// to perform initialization logic as soon as the provider is created.
  ///
  /// Subclasses should call `super(context)` in their constructors to ensure
  /// proper setup.
  ULoCProviderInterface(this.context) {
    onCreate();
  }

  /// Called immediately after the provider is constructed.
  ///
  /// Use this method to perform any initial setup or logic that should
  /// happen as soon as the provider is created. This includes setting
  /// default values, fetching initial data, or registering listeners.
  ///
  /// Subclasses **must** call `super.onCreate()` when overriding this method,
  /// as it ensures essential base initialization runs.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void onCreate() {
  ///   super.onCreate();
  ///   // Custom setup here
  /// }
  /// ```
  @mustCallSuper
  void onCreate() {
    printLog('Created');
  }

  /// Returns the arguments passed to the route.
  ///
  /// If the route arguments are wrapped in a [UlocArguments] object,
  /// this extracts and returns the underlying `flutterArguments`.
  /// Otherwise, it returns the raw `routeArguments` as-is.
  ///
  /// This is useful when you want to access the actual data passed
  /// to a screen regardless of how it's internally packaged.
  ///
  /// Example:
  /// ```dart
  /// final args = arguments;
  /// if (args is MyDataModel) {
  ///   // Use args
  /// }
  /// ```
  Object? get arguments {
    if (context.routeArguments is UlocArguments) {
      return (context.routeArguments as UlocArguments).flutterArguments;
    }
    return context.routeArguments;
  }

  /// Accesses the named `ULoC` arguments passed to the route.
  ///
  /// Returns a `Map<String, dynamic>` if the current route's arguments
  /// are wrapped inside a [UlocArguments] object. Otherwise, returns `null`.
  ///
  /// This is useful for retrieving key-value data passed via `ULoC` routing,
  /// such as query-style parameters or configuration values.
  ///
  /// Example:
  /// ```dart
  /// final id = ulocArguments?['id'];
  /// ```
  Map<String, dynamic>? get ulocArguments {
    if (context.routeArguments is UlocArguments) {
      return (context.routeArguments as UlocArguments).argumentsMap;
    }
    return null;
  }

  /// Whether the widget is still mounted in the widget tree.
  ///
  /// This is a convenience getter that forwards [BuildContext.mounted]
  /// so developers don't need to access `context` manually.
  bool get mounted => context.mounted;

  /// The parsed query parameters from the current route name.
  ///
  /// For example, given the route: `/home?utm_source=facebook&utm_medium=social`,
  /// this will return:
  /// ```dart
  /// {
  ///   "utm_source": "facebook",
  ///   "utm_medium": "social"
  /// }
  /// ```
  ///
  /// If a key appears multiple times in the query, its value will be a `List<String>`.
  /// Otherwise, it returns a single `String`.
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

  /// A list of ancestor `BuildContext`s that are associated with providers
  /// from previous widget trees or routes.
  ///
  /// This is especially useful in scenarios where the widget has navigated
  /// to a new route, but still needs to retain access to the providers
  /// from the previous route. For example, after a page transition using
  /// a route like `Navigator.push`, the current context might not be able
  /// to access certain inherited providers directly, because they were
  /// defined higher up in the widget tree or within the previous route.
  ///
  /// By storing the previous contexts in `_ancestorContexts`, we can
  /// enable lookup of those older providers manually when needed —
  /// helping to maintain consistent business logic, user session state,
  /// or service references across route transitions without having to
  /// reinitialize or duplicate them.
  ///
  /// This pattern is particularly valuable for global or semi-global
  /// state management architectures where some logic must persist
  /// beyond the lifetime of a single widget or page.
  List<BuildContext> _ancestorContexts = [];

  /// Attempts to find a provider of type [P] from a previously stored route's context.
  ///
  /// This is especially useful after a navigation event (like `Navigator.push`)
  /// where the current context may no longer have access to the provider from
  /// the previous route. By searching through `_ancestorContexts`, this function
  /// allows you to continue interacting with providers instantiated earlier
  /// in the app lifecycle.
  ///
  /// Type parameter:
  /// - [P]: The type of the provider you're trying to find. Must extend [ULoCProviderInterface].
  ///
  /// Parameters:
  /// - [listen] (default: false): Whether the returned provider should rebuild the
  ///   widget when the provider changes. Set to `true` if you want to subscribe to updates.
  /// - [location]: An optional route identifier to narrow the search. Can be:
  ///   - `String` (e.g., "/settings")
  ///   - `ULoCRoute`
  ///   - `null` (if you want to match any location)
  ///
  /// Returns:
  /// - The found provider of type [P], or `null` if no match was found.
  ///
  /// Logs a warning if no provider is found, including the type and location (if provided).
  P? findAncestorProviderOfType<P extends ULoCProviderInterface>({
    bool listen = false,

    /// Optional location to match. Must be String, ULoCRoute, or null.
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
      // If no provider found, throw to trigger catch block
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

  /// Prints a log message prefixed with the class's runtime type.
  ///
  /// This is mainly for **readability** and **debugging clarity**, especially when
  /// working with multiple classes or providers. By automatically including the
  /// class name (`runtimeType`) in the log output, it helps developers quickly
  /// identify where the log is coming from.
  ///
  /// Example output:
  /// ```
  /// [MyCustomProvider]: Loaded user data successfully
  /// ```
  ///
  /// You can call this method with or without a message. If no message is provided,
  /// it still prints the class name.
  void printLog([Object? message]) {
    _RouteUtilities.log('[$runtimeType]: $message');
  }

  /// Pops the current route off the navigation stack.
  ///
  /// This is a general-purpose method to navigate back to the previous screen
  /// using Flutter's [Navigator]. If the current route was pushed onto the stack,
  /// this will remove it and optionally return a [result] to the previous route.
  ///
  /// If no [result] is provided, `null` will be returned to the previous route by default.
  ///
  /// Example usage:
  /// ```dart
  /// // Navigate back without a result
  /// pop();
  ///
  /// // Navigate back with a result
  /// pop<MyData>(myData);
  /// ```
  ///
  /// This method assumes that it is called from a valid [BuildContext] that is
  /// currently mounted in the widget tree and has access to a [Navigator].
  ///
  /// Throws if there is no back route to pop.
  void pop<T extends Object?>([T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  /// Pops routes until the specified [route] is reached in the navigation stack.
  ///
  /// This function removes all routes above the given [route] and makes it the current visible route.
  /// It uses [Navigator.popUntil] internally, with [ModalRoute.withName] to match the route name.
  ///
  /// This is useful when you want to return to a specific screen in your app,
  /// discarding any intermediate routes that were pushed after it.
  ///
  /// Example:
  /// ```dart
  /// // Assume you're on /details and want to go back to /home
  /// popUntil(ULoCRoute.home);
  /// ```
  ///
  /// If the route is not found in the stack, nothing will be popped.
  ///
  /// Make sure the [route.name] matches a named route that exists in the current navigation stack.
  void popUntil(ULoCRoute route) {
    Navigator.of(context).popUntil(ModalRoute.withName(route.path));
  }

  /// Pushes a named route onto the navigation stack.
  ///
  /// Navigates to the given [route] using its resolved `path`, passing along any
  /// provided [arguments], transition configuration, and animation curve.
  ///
  /// This method also ensures the keyboard is dismissed before navigation.
  ///
  /// Returns a [Future] that completes with the result value when the pushed
  /// route is popped.
  ///
  /// Type [T] is the expected return type from the pushed route.
  /// Type [P] can be used for strongly-typed route arguments (optional).
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

  /// Replaces the current route with a new one.
  ///
  /// Navigates to the given [route] using its resolved `path`, replacing the
  /// current route in the stack. Optionally provides [arguments] for the new route,
  /// a [result] to return to the previous route, and custom transition settings.
  ///
  /// This method also dismisses the keyboard before navigation.
  ///
  /// Returns a [Future] that completes with the result value [T] when the
  /// replacement route is later popped.
  ///
  /// Type [T] is the expected return type from the pushed route.
  /// Type [J] is the return type passed to the replaced route.
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

  /// Clears the entire navigation stack and navigates to a new route.
  ///
  /// Pushes the given [route] using its resolved `path`, and removes all
  /// previous routes in the stack, effectively resetting the navigation history.
  ///
  /// Optionally accepts [arguments] for the new route, as well as [transition]
  /// and [curve] settings for custom navigation animations.
  ///
  /// This method also ensures the keyboard is dismissed before navigating.
  ///
  /// Returns a [Future] that completes with a value of type [T] when the
  /// pushed route is later popped.
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
