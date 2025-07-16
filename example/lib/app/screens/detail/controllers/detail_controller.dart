import 'package:uloc/uloc.dart';
import 'package:uloc_example/app/screens/detail/class/detail.dart';

class DetailController extends ULoCProvider {
  final String? id;
  final Detail? data;
  DetailController(super.context, {this.id, this.data});
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
