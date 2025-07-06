import 'package:uloc/uloc.dart';
import 'package:uloc_example/app/screens/controllers/home_controller.dart';
import 'package:uloc_example/app/screens/detail/controllers/detail_controller.dart';
import 'package:uloc_example/app/screens/detail/views/pages/detail_page.dart';
import 'package:uloc_example/app/screens/views/pages/home_page.dart';

@ULoCDeclaration()
class MyRoutes extends ULoCRouteDeclaration {
  @override
  Map<String, ULoCRoute<ULoCProvider>> get route => {
    'HOME': ULoCRoute(
      route: '/',
      provider: (context, _) => HomeController(context),
      child: HomePage,
    ),
    'DETAIL': ULoCRoute(
      route: '/detail/:id/:name',
      provider: (context, params) =>
          DetailController(context, id: params?['id'], type: params?['type']),
      child: DetailPage,
    ),
  };
}
