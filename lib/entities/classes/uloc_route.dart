part of '../../uloc.dart';

class ULoCRoute {
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
      _routeParams[key] = routeParams?[i] ?? '';
    }
  }

  ULoCRoute.fromString(String? url) : name = url ?? '';

  final String name;
  final Map<String, dynamic> _arguments = {};
  final Map<String, String> _routeParams = {};

  List<String> _paramNames = <String>[];

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

  String get path => uri.toString();

  Uri get uri => Uri.parse(toString());

  T? arguments<T>(String? key) {
    try {
      final value = _arguments[key];
      if (value == null) {
        throw Exception("Cannot find arguments of name $key");
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

  String? param(String? key) => key == null ? null : _routeParams[key];

  Uri withQuery(Map<String, dynamic> query) {
    return uri.replace(queryParameters: query);
  }

  Uri addQuery(Map<String, dynamic> query) {
    return uri.replace(queryParameters: {...uri.queryParametersAll, ...query});
  }
}
