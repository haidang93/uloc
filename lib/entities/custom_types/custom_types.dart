part of '../../uloc.dart';

typedef RouteName = String;

// params in optional [ ] so Material route won't get confuse with this param
typedef RouteMapItem =
    Widget Function(
      BuildContext context, [
      Map<String, dynamic>? params,
      List<BuildContext>? ancestorContexts,
    ]);
typedef RouteMap = Map<String, RouteMapItem>;
