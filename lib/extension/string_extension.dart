part of '../uloc.dart';

extension StringExtension on String {
  String withQuery(Map<String, dynamic> query) {
    final uri = Uri.parse(this);
    final newUri = uri.replace(queryParameters: query);
    return newUri.toString();
  }

  String addQuery(Map<String, dynamic> query) {
    final uri = Uri.parse(this);
    final newUri = uri.replace(
      queryParameters: {...uri.queryParameters, ...query},
    );
    return newUri.toString();
  }
}
