part of '../../uloc.dart';

class RouteProperties<P extends ULoCProvider> {
  RouteProperties({
    required this.routeName,
    required this.provider,
    required this.child,
  });
  final RouteName routeName;
  final P Function(BuildContext context, Map<String, dynamic>? params) provider;
  final Widget child;

  Widget buildRouteMapElement(
    BuildContext context, [
    Map<String, dynamic>? params = const {},
    List<BuildContext>? ancestorContext,
  ]) {
    return ChangeNotifierProvider<P>(
      create: (context) => provider(context, params),
      child: _RouteWithProvider<P>(
        ancestorContext: ancestorContext,
        child: child,
      ),
    );
  }
}
