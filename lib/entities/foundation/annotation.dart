part of '../../uloc.dart';

/// Annotation used to mark a class as a ULoC route declaration.
///
/// This annotation is primarily used for code generation or route registration.
/// Apply it to a class to indicate that it defines a route entry in the app.
///
/// Example:
/// ```dart
/// @ULoCDeclaration()
/// class MyRoutes extends ULoCRouteDeclaration { ... }
/// ```
class ULoCDeclaration {
  /// Creates a new [ULoCDeclaration] annotation.
  const ULoCDeclaration();
}
