part of '../../uloc.dart';

/// A set of predefined animation curves used for page transitions in routing.
///
/// Each enum value wraps a [Curve] from Flutter's [Curves] class.
/// Typically used to control the transition behavior in [getTo].
///
/// Example:
/// ```dart
/// getTo(
///   Routes.Detail,
///   curve: CurveEnum.easeInOut,
/// );
/// ```
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
