part of '../uloc.dart';

/// Extension methods for [String] to manipulate URL query parameters.
extension StringExtension on String {
  /// Replaces any existing query parameters in the URL with the given [query].
  ///
  /// Example:
  /// ```dart
  /// 'https://example.com'.withQuery({'id': 123});
  /// // Returns: 'https://example.com?id=123'
  /// ```
  String withQuery(Map<String, dynamic> query) {
    final uri = Uri.parse(this);
    final newUri = uri.replace(queryParameters: query);
    return newUri.toString();
  }

  /// Adds or overrides query parameters in the current URL with the given [query].
  ///
  /// Existing parameters will be preserved unless a key in [query] matches and overrides them.
  ///
  /// Example:
  /// ```dart
  /// 'https://example.com?page=1'.addQuery({'id': 123});
  /// // Returns: 'https://example.com?page=1&id=123'
  /// ```
  String addQuery(Map<String, dynamic> query) {
    final uri = Uri.parse(this);
    final newUri = uri.replace(
      queryParameters: {...uri.queryParameters, ...query},
    );
    return newUri.toString();
  }
}
