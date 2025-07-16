///
/// **************************************************
/// **** [GENERATED CODE - DO NOT MODIFY BY HAND] ****
/// **************************************************
///
// ignore_for_file: constant_identifier_names, non_constant_identifier_names, dangling_library_doc_comments
import 'package:uloc/uloc.dart';
import 'package:uloc_example/app/screens/detail/class/detail.dart';
import 'package:uloc_example/app/screens/detail/controllers/detail_controller.dart';
import 'package:uloc_example/app/screens/detail/views/pages/detail_page.dart';
import 'package:uloc_example/app/screens/home/controllers/home_controller.dart';
import 'package:uloc_example/app/screens/home/views/pages/home_page.dart';

/// use this for [named navigation]
class Routes {
  Routes._();

  static ULoCRoute WILDCARD = ULoCRoute('*');
  static ULoCRoute HOME = ULoCRoute('/');
  static ULoCRoute DETAIL({String? id, Detail? data}) =>
      ULoCRoute('/detail/:id', routeParams: [id], arguments: {'data': data});

  static ULoCRoute fromString(String? url) => ULoCRoute.fromString(url);

  /// use this to pass to [MaterialApp] Route setting
  static final ULoCRouteConfiguration ulocRouteConfiguration =
      ULoCRouteConfiguration([
        RouteProperties<HomeController>(
          routeName: Routes.WILDCARD,
          provider: (context, _) => HomeController(context),
          child: HomePage(),
        ),
        RouteProperties<HomeController>(
          routeName: Routes.HOME,
          provider: (context, _) => HomeController(context),
          child: HomePage(),
        ),
        RouteProperties<DetailController>(
          routeName: Routes.DETAIL(),
          provider: (context, route) => DetailController(
            context,
            id: route?.param('id'),
            data: route?.arguments<Detail>('data'),
          ),
          child: DetailPage(),
        ),
      ]);
}
