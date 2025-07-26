part of '../../uloc.dart';

/// route properties
class RouteProperties<P extends ULoCProvider> {
  RouteProperties({
    required this.routeName,
    required this.provider,
    required this.child,
  });

  /// route
  final ULoCRoute routeName;

  /// provider builder
  final P Function(BuildContext context, ULoCRoute? route) provider;

  /// the page
  final Widget child;

  /// to build element
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
