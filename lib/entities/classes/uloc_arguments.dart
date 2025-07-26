part of '../../uloc.dart';

/// uloc arguments, use this to pass route properties
class UlocArguments {
  UlocArguments._private({
    required this.route,
    this.flutterArguments,
    this.argumentsMap,
  });

  /// Flutter regular arguments will save here
  final Object? flutterArguments;

  /// ULoC arguments
  final Map<String, dynamic>? argumentsMap;

  /// The previous route
  final ULoCRoute route;
}
