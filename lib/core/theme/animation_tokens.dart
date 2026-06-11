import 'package:flutter/animation.dart';

class RRAnimation {
  const RRAnimation._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration color = Duration(milliseconds: 600);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve feedSwipe = Curves.easeInOutCubic;
}
