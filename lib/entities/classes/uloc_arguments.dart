part of '../../uloc.dart';

class UlocArguments {
  UlocArguments._private({
    required this.route,
    this.flutterArguments,
    this.argumentsMap,
  });
  final Object? flutterArguments;
  final Map<String, dynamic>? argumentsMap;
  final ULoCRoute route;
}
