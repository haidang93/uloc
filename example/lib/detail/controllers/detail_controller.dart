import 'package:uloc/uloc.dart';

class DetailController extends ULoCProvider {
  DetailController(super.context, this.id, this.name);
  final String id;
  final String name;
}
