part of '../../uloc.dart';

/// ULoC-specific wrapper for passing route arguments.
///
/// This class is used internally to carry both traditional Flutter arguments
/// and custom ULoC arguments (`argumentsMap`) along with the associated [ULoCRoute].
///
/// You typically access an instance of this through utility methods
/// like `context.ulocArguments` when working with a ULoC-based routing system.
///
/// This is especially useful when:
/// - You need to pass typed data via route navigation.
/// - You want to distinguish between Flutter’s native arguments and ULoC-specific data.
///

class UlocArguments {
  /// Private constructor. Use helper methods to create or retrieve instances.
  UlocArguments._private({
    required this.route,
    this.flutterArguments,
    this.argumentsMap,
  });

  /// The original Flutter-style arguments.
  final Object? flutterArguments;

  /// ULoC-style arguments passed as a key-value map for more structured access.
  final Map<String, dynamic>? argumentsMap;

  /// The current [ULoCRoute] associated with these arguments.
  final ULoCRoute route;
}
