part of '../uloc.dart';

class _RouteUtilities {
  /// extract route parameter from route name
  static Map<String, dynamic> _parseParam(Uri? routeName, Uri route) {
    final result = <String, dynamic>{};

    if (routeName == null) return result;

    final patternSegments = routeName.pathSegments;
    final pathSegments = route.pathSegments;

    if (patternSegments.length != pathSegments.length) {
      return {};
    }

    for (int i = 0; i < patternSegments.length; i++) {
      final patternSegment = patternSegments[i];
      final pathSegment = pathSegments[i];

      if (patternSegment.startsWith(':')) {
        result[patternSegment.substring(1)] = pathSegment;
      }
    }

    return result;
  }

  static void log(String? message) {
    if (message != null) {
      dev.log(message, name: 'ULoC:', time: DateTime.now());
    }
  }
}
