part of '../../uloc.dart';

/// Signature for a function that returns a widget for a given route configuration.
///
/// This typedef is used in route mapping systems to generate widgets based on routing data.
/// The parameters are wrapped in optional brackets to avoid being misinterpreted by
/// [MaterialPageRoute] and other Flutter navigation mechanisms.
///
/// - [context]: The current [BuildContext].
/// - [route] (optional): The parsed [ULoCRoute] object, if applicable. Contains
///   details such as path, arguments, or query parameters.
/// - [ancestorContexts] (optional): A list of parent [BuildContext]s in the navigation
///   hierarchy. Useful for deeply nested navigation scenarios or scoped lookups.
///
/// Example:
/// ```dart
/// final routeMap = <String, RouteMapItem>{
///   '/profile': (context, [route, ancestors]) => ProfileScreen(userId: route?.params['id']),
/// };
/// ```
typedef RouteMapItem =
    Widget Function(
      BuildContext context, [
      ULoCRoute? route,
      List<BuildContext>? ancestorContexts,
    ]);

typedef _RouteMap = Map<String, RouteMapItem>;
