///
/// **************************************************
/// **** [GENERATED CODE - DO NOT MODIFY BY HAND] ****
/// **************************************************
///
// ignore_for_file: constant_identifier_names, non_constant_identifier_names, dangling_library_doc_comments
import 'package:uloc/uloc.dart';
import 'package:uloc_example/detail/controllers/detail_controller.dart';
import 'package:uloc_example/detail/views/detail.dart';
import 'package:uloc_example/home/controllers/home_controller.dart';
import 'package:uloc_example/home/views/home.dart';

/// use this for [named navigation]
class Routes {
  Routes._();

  static const RouteName HOME = '/';
  static RouteName DETAIL({String? id, String? name}) =>
      id == null && name == null ? '/detail/:id/:name' : '/detail/$id/$name';
}

/// use this to pass to [MaterialApp] Route setting
final ULoC uloc = ULoC([
  RouteProperties<HomeController>(
    routeName: Routes.HOME,
    provider: (context, _) => HomeController(context),
    child: Home(),
  ),
  RouteProperties<DetailController>(
    routeName: Routes.DETAIL(),
    provider: (context, params) =>
        DetailController(context, params?['id'], params?['name']),
    child: Detail(),
  ),
]);
