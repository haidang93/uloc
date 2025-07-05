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
  ]) {
    return ChangeNotifierProvider<P>(
      create: (context) => provider(context, params),
      child: _RouteWithProvider<P>(child: child),
    );
  }
}
