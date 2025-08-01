part of '../../uloc.dart';

/// Route definition class.
///
/// This class is used by developers to declare routes for the application.
/// It serves as a base for code generation, where the `uloc` generator will
/// use these declarations to generate route configurations.
///
/// ### Example
///
/// ```dart
/// @ULoCDeclaration()
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
///       provider: (context, params) => DetailController(
///         context,
///         id: params?['id'],
///         type: params?['type'],
///       ),
///       child: DetailPage,
///     ),
///   };
/// }
/// ```
///
/// ### Quick Route Generation
///
/// Developers can also use the CLI to generate new pages and associated routes:
///
/// ```sh
/// uloc gen-page home --gen-route
/// # or
/// uloc gen-page home -g
/// ```
///
/// This command generates both the page and route configuration automatically.
class ULoCRouteDefine<P extends ULoCProvider> {
  ULoCRouteDefine({
    required this.route,
    required this.provider,
    required this.child,
  });

  /// Route pattern (e.g., '/', '/detail/:id').
  final String route;

  /// Provider function used to initialize the corresponding controller or state.
  final P Function(BuildContext context, ULoCRoute? route) provider;

  /// The widget class type to display for this route.
  final Type child;
}

/// Abstract class to be extended for route declaration.
///
/// Must override the [route] getter to provide a map of route names
/// and their corresponding route definitions.
///
/// ### Example:
///
/// ```dart
/// @ULoCDeclaration()
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
///       route: '/detail/:id',
///       provider: (context, route) => DetailController(
///         context,
///         id: route?.param('id'),
///         data: route?.arguments<Detail>('data'),
///       ),
///       child: DetailPage,
///     ),
///   };
/// }
///
/// ```
abstract class ULoCRouteDeclaration {
  /// A map of route keys to [ULoCRouteDefine] configurations.
  Map<String, ULoCRouteDefine> get route;
}
