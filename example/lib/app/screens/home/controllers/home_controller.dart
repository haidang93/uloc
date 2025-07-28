import 'package:uloc/uloc.dart';
import 'package:uloc_example/app/screens/detail/class/detail.dart';
import 'package:uloc_example/routes/routes.uloc.g.dart';

class HomeController extends ULoCProvider {
  HomeController(super.context);
  String name = "Home";
  String content = "Click to go to detail page";
  final detail = Detail();

  @override
  void init() {
    super.init();
  }

  @override
  void ready() {
    super.ready();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void nextRouteHandle() {
    getTo(
      Routes.DETAIL(id: detail.id, data: detail),
      transition: PageTransition.rightToLeft,
    );
  }
}
