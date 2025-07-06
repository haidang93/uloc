import 'package:uloc/uloc.dart';
import 'package:uloc_example/routes/routes.uloc.g.dart';

class HomeController extends ULoCProvider {
  HomeController(super.context);
  String name = "Home";
  String content = "Click to go to detail page";

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onDispose() {
    super.onDispose();
  }

  void nextRouteHandle() {
    context.pushNamed(
      Routes.DETAIL(name: 'Detail Page'),
      transition: PageTransition.rightToLeft,
    );
  }
}
