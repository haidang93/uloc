part of '../../uloc.dart';

class ULoCRoute<P extends ULoCProvider> {
  ULoCRoute({required this.route, required this.provider, required this.child});
  final String route;
  final P Function(BuildContext context, Map<String, dynamic>? params) provider;
  final Type child;
}

abstract class ULoCRouteDeclaration {
  /// Map \<RouteName, Properties\>
  Map<String, ULoCRoute> get route;
}
