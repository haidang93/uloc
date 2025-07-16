part of '../../uloc.dart';

/// Route definition:
///
/// The developer will use this class to define routes
///
/// The code generator will base on this definition to generate route configuration
///
///
/// ```dart
///  @ULoCDeclaration()
/// class MyRoutes extends ULoCRouteDeclaration {
///   @override
///   Map<String, ULoCRouteDefine<ULoCProvider>> get route => {
///     'WILDCARD': ULoCRouteDefine(
///       route: '*',
///       provider: (context, _) => HomeController(context),
///       child: HomePage,
///     ),
///     'HOME': ULoCRouteDefine(
///       route: '/',
///       provider: (context, _) => HomeController(context),
///       child: HomePage,
///     ),
///     'DETAIL': ULoCRouteDefine(
///       route: '/detail/:id/:type',
///       provider: (context, params) =>
///           DetailController(context, id: params?['id'], type: params?['type']),
///       child: DetailPage,
///     ),
///   };
/// }
/// ```
///
/// Developer can also use command
/// ```sh
/// uloc gen-page home --gen-route
/// # or
/// uloc gen-page home -g
/// ```
/// to generate new page and route at the same time
class ULoCRouteDefine<P extends ULoCProvider> {
  ULoCRouteDefine({
    required this.route,
    required this.provider,
    required this.child,
  });
  final String route;
  final P Function(BuildContext context, ULoCRoute? route) provider;
  final Type child;
}

abstract class ULoCRouteDeclaration {
  /// Map \<RouteName, Properties\>
  Map<String, ULoCRouteDefine> get route;
}
