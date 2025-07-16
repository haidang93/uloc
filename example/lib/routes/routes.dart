import 'package:uloc/uloc.dart';
import 'package:uloc_example/app/screens/detail/class/detail.dart';
import 'package:uloc_example/app/screens/detail/controllers/detail_controller.dart';
import 'package:uloc_example/app/screens/detail/views/pages/detail_page.dart';
import 'package:uloc_example/app/screens/home/controllers/home_controller.dart';
import 'package:uloc_example/app/screens/home/views/pages/home_page.dart';

@ULoCDeclaration()
class MyRoutes extends ULoCRouteDeclaration {
  @override
  Map<String, ULoCRouteDefine<ULoCProvider>> get route => {
    'WILDCARD': ULoCRouteDefine(
      route: '*',
      provider: (context, _) => HomeController(context),
      child: HomePage,
    ),
    'HOME': ULoCRouteDefine(
      route: '/',
      provider: (context, _) => HomeController(context),
      child: HomePage,
    ),
    'DETAIL': ULoCRouteDefine(
      route: '/detail/:id',
      provider: (context, route) => DetailController(
        context,
        id: route?.param('id'),
        data: route?.arguments<Detail>('data'),
      ),
      child: DetailPage,
    ),
  };
}
