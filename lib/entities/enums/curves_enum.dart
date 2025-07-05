part of '../../uloc.dart';

enum CurveEnum {
  ease(Curves.ease),
  bounceOut(Curves.bounceOut),
  easeIn(Curves.easeIn),
  easeOut(Curves.easeOut),
  easeInOut(Curves.easeInOut),
  linear(Curves.linear);

  final Curve curve;
  const CurveEnum(this.curve);
}
