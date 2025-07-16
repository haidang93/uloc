part of '../../uloc.dart';

class RouteProperties<P extends ULoCProvider> {
  RouteProperties({
    required this.routeName,
    required this.provider,
    required this.child,
  });
  final ULoCRoute routeName;
  final P Function(BuildContext context, ULoCRoute? route) provider;
  final Widget child;

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
