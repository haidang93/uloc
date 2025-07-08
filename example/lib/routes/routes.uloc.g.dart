///
/// **************************************************
/// **** [GENERATED CODE - DO NOT MODIFY BY HAND] ****
/// **************************************************
///
// ignore_for_file: constant_identifier_names, non_constant_identifier_names, dangling_library_doc_comments
import 'package:uloc/uloc.dart';
import 'package:uloc_example/app/screens/detail/controllers/detail_controller.dart';
import 'package:uloc_example/app/screens/detail/views/pages/detail_page.dart';
import 'package:uloc_example/app/screens/home/controllers/home_controller.dart';
import 'package:uloc_example/app/screens/home/views/pages/home_page.dart';


/// use this for [named navigation]
class Routes {
  Routes._();

  static const RouteName HOME = '/';
  static RouteName DETAIL({String? id, String? type}) => id == null && type == null ? '/detail/:id/:type' : '/detail/${id ?? '' }/${type ?? '' }';

   /// use this to pass to [MaterialApp] Route setting
  static final ULoCRouteConfiguration ulocRouteConfiguration = ULoCRouteConfiguration([
    RouteProperties<HomeController>(
      routeName: Routes.HOME,
      provider: (context, _) => HomeController(context),
      child: HomePage(),
    ),
    RouteProperties<DetailController>(
      routeName: Routes.DETAIL(),
      provider: (context, params) => DetailController(context, id: params?['id'], type: params?['type']),
      child: DetailPage(),
    ),
  ]);
}
