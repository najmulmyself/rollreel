import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';

class OnboardingStyle {
  const OnboardingStyle._({
    required this.background,
    required this.ink,
    required this.secondary,
    required this.line,
    required this.action,
    required this.onAction,
    required this.accent,
    required this.systemOverlay,
  });

  static OnboardingStyle get current => RRColors.isDark.value ? _dark : _light;

  static const _light = OnboardingStyle._(
    background: Color(0xFFF9F6F0),
    ink: Color(0xFF211D25),
    secondary: Color(0xFF5E5662),
    line: Color(0xFFD9D1D9),
    action: Color(0xFF2D203D),
    onAction: Color(0xFFFFFFFF),
    accent: Color(0xFFE6DCF5),
    systemOverlay: SystemUiOverlayStyle.dark,
  );

  static const _dark = OnboardingStyle._(
    background: Color(0xFF1E1A23),
    ink: Color(0xFFF9F6F0),
    secondary: Color(0xFFCEC4D1),
    line: Color(0xFF544A59),
    action: Color(0xFFE6DCF5),
    onAction: Color(0xFF2D203D),
    accent: Color(0xFF3F334B),
    systemOverlay: SystemUiOverlayStyle.light,
  );

  final Color background;
  final Color ink;
  final Color secondary;
  final Color line;
  final Color action;
  final Color onAction;
  final Color accent;

  final SystemUiOverlayStyle systemOverlay;

  TextStyle title(double fontSize) => TextStyle(
    fontFamily: 'Instrument Serif',
    fontSize: fontSize,
    height: 0.98,
    letterSpacing: -0.55,
    color: ink,
  );

  TextStyle get body => TextStyle(fontSize: 16, height: 1.45, color: secondary);

  ButtonStyle get primaryButton => FilledButton.styleFrom(
    backgroundColor: action,
    foregroundColor: onAction,
    disabledBackgroundColor: action.withValues(alpha: 0.16),
    disabledForegroundColor: secondary,
    visualDensity: VisualDensity.standard,
    minimumSize: const Size(0, 54),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );
}
