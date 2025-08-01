part of '../../uloc.dart';

/// A representation of a route in the ULoC system.
///
/// This class supports parameterized route definitions (e.g., `/user/:id`) and allows
/// passing arguments to be used in routing logic. It also provides methods to retrieve
/// those arguments and route parameters dynamically.
class ULoCRoute {
  /// Creates a new [ULoCRoute] with a declared [name], optional [routeParams], and optional [arguments].
  ///
  /// The [name] should be a path string, such as `/user/:id`, where parameters are
  /// prefixed with a colon (`:`). The [routeParams] list should contain values that
  /// match the order and count of the named parameters in [name].
  ///
  /// An optional [arguments] map can be provided to pass custom key-value pairs
  /// associated with this route.
  ULoCRoute(
    this.name, {
    List<String?>? routeParams,
    Map<String, dynamic>? arguments,
  }) {
    _paramNames = name
        .split('/')
        .where((e) => e.contains(':'))
        .map((e) => e.substring(1))
        .toList();
    assert(_paramNames.length == (routeParams?.length ?? 0));

    _arguments.addAll(arguments ?? {});

    for (var i = 0; i < _paramNames.length; i++) {
      final key = _paramNames[i];
      _routeParams[key] = routeParams?[i];
    }
  }

  /// Creates a [ULoCRoute] directly from a string URL.
  ///
  /// The resulting route will only contain the [name] and no parameters or arguments.
  ULoCRoute.fromString(String? url) : name = url ?? '';

  /// The declared name of the route (e.g., `/profile/:userId`)
  final String name;
  final Map<String, dynamic> _arguments = {};
  final Map<String, String?> _routeParams = {};

  List<String> _paramNames = <String>[];

  /// Returns the final resolved path with parameters replaced by actual values.
  ///
  /// For example, if the declared route is `/user/:id` and `id` is set to `123`,
  /// this will return `/user/123`.
  @override
  String toString() {
    final result = <String>[];
    for (String segment in name.split('/')) {
      if (segment.startsWith(':')) {
        final key = segment.substring(1);
        final value = _routeParams[key] ?? '';
        result.add(value.isNotEmpty ? value : segment);
      } else {
        result.add(segment);
      }
    }
    return result.join('/');
  }

  /// Returns the full path of the route as a string.
  ///
  /// Equivalent to calling `uri.toString()`.
  String get path => uri.toString();

  /// Converts the route to a [Uri] object.
  Uri get uri => Uri.parse(toString());

  /// Retrieves a value from the route's argument map by [key], casted to type [T].
  ///
  /// Returns `null` if the key is missing or cannot be cast to type [T].
  T? arguments<T>(String? key) {
    try {
      final value = _arguments[key];
      if (value == null) {
        return null;
      } else if (value is! T) {
        throw Exception("Cannot find arguments of type $T");
      } else {
        return value;
      }
    } catch (e) {
      _RouteUtilities.log(e.toString());
      return null;
    }
  }

  /// Retrieves the actual value of a path parameter by [key].
  ///
  /// Returns `null` if the key does not exist or was not provided.
  String? param(String? key) => key == null ? null : _routeParams[key];

  /// Returns a new [Uri] with the given [query] parameters replacing any existing ones.
  Uri withQuery(Map<String, dynamic> query) {
    return uri.replace(queryParameters: query);
  }

  /// Returns a new [Uri] with the given [query] parameters added to the existing ones.
  Uri addQuery(Map<String, dynamic> query) {
    return uri.replace(queryParameters: {...uri.queryParametersAll, ...query});
  }
}
