import 'package:flutter/material.dart';

import 'colors.dart';

class RRTypography {
  const RRTypography._();

  static TextStyle get title1 => TextStyle(
    fontFamily: '.SF Pro Display',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    color: RRColors.textPrimary,
  );

  static TextStyle get title2 => TextStyle(
    fontFamily: '.SF Pro Display',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    color: RRColors.textPrimary,
  );

  static TextStyle get headline => TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: RRColors.textPrimary,
  );

  static TextStyle get body => TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: RRColors.textPrimary,
  );

  static TextStyle get subheadline => TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 14,
    color: RRColors.textSecond,
  );

  static TextStyle get caption => TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 12,
    color: RRColors.textSecond,
  );
}
