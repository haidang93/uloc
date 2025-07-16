part of '../../uloc.dart';

// params in optional [ ] so Material route won't get confuse with this param
typedef RouteMapItem =
    Widget Function(
      BuildContext context, [
      ULoCRoute? route,
      List<BuildContext>? ancestorContexts,
    ]);
typedef RouteMap = Map<String, RouteMapItem>;
