import 'package:uloc/uloc.dart';
import 'package:uloc_example/detail/controllers/detail_controller.dart';
import 'package:uloc_example/detail/views/detail.dart';
import 'package:uloc_example/home/controllers/home_controller.dart';
import 'package:uloc_example/home/views/home.dart';

@ULoCDeclaration()
class MyRoutes extends ULoCRouteDeclaration {
  @override
  Map<String, ULoCRoute<ULoCProvider>> get route => {
    'HOME': ULoCRoute(
      route: '/',
      provider: (context, _) => HomeController(context),
      child: Home,
    ),
    'DETAIL': ULoCRoute(
      route: '/detail/:id/:name',
      provider: (context, params) =>
          DetailController(context, params?['id'], params?['name']),
      child: Detail,
    ),
  };
}
