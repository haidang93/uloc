part of '../../uloc.dart';

/// Holds all the essential information required to render a route in the application.
///
/// This class links a [ULoCRoute] with its corresponding provider and page widget.
/// It is typically generated based on a `ULoCRouteDefine` during code generation
/// and used internally for building route widgets with provider support.
///
/// Example usage:
/// ```dart
/// final props = RouteProperties<HomeProvider>(
///   routeName: ULoCRoute(path: '/home'),
///   provider: (context, route) => HomeProvider(context),
///   child: HomePage(),
/// );
///
/// final widget = props.buildRouteMapElement(context);
/// ```
///
/// - [P] must extend [ULoCProvider].
class RouteProperties<P extends ULoCProvider> {
  /// Creates a new [RouteProperties] instance.
  ///
  /// - [routeName]: The unique route associated with this page.
  /// - [provider]: A function that creates the provider for the route.
  /// - [child]: The widget (usually a page) associated with this route.
  RouteProperties({
    required this.routeName,
    required this.provider,
    required this.child,
  });

  /// The route definition for this page.
  final ULoCRoute routeName;

  /// The provider builder function.
  ///
  /// This function receives the [BuildContext] and optional [ULoCRoute] and
  /// returns an instance of [P], which must extend [ULoCProvider].
  final P Function(BuildContext context, ULoCRoute? route) provider;

  /// The widget that should be shown for this route.
  final Widget child;

  /// Builds the full widget tree for the route, including the provider and page.
  ///
  /// Wraps the [child] with a [ChangeNotifierProvider] for the given [provider].
  /// Optionally accepts a list of [ancestorContext] for advanced use cases.
  Widget buildRouteMapElement(
    BuildContext context, [
    ULoCRoute? route,
    List<BuildContext>? ancestorContext,
  ]) {
    return ChangeNotifierProvider<P>(
      create: (context) => provider(context, route),
      child: _RouteWithProvider<P>(
        ancestorContext: ancestorContext,
        child: child,
      ),
    );
  }
}
