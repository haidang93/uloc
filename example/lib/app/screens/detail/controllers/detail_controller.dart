import 'package:uloc/uloc.dart';

class DetailController extends ULoCProvider {
  final String? id;
  final String? type;
  DetailController(super.context, {this.id, this.type});
  String name = "Detail";
  String content = "Detail has not yet implemented";

  int count = 0;

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

  void increment() {
    count++;
    setstate();
  }

  void decrement() {
    setstate(() {
      count--;
    });
  }
}
