import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

class OnboardingStyle {
  const OnboardingStyle._({
    required this.background,
    required this.ink,
    required this.secondary,
    required this.line,
    required this.action,
    required this.onAction,
    required this.progress,
    required this.accent,
    required this.artworkFrame,
    required this.artworkAccent,
    required this.systemOverlay,
  });

  static OnboardingStyle get current => RRColors.isDark.value ? _dark : _light;

  static const _light = OnboardingStyle._(
    background: RRColors.brandLightBackground,
    ink: RRColors.brandInk,
    secondary: RRColors.brandMutedInk,
    line: RRColors.brandOutline,
    action: RRColors.brandBlue,
    onAction: Color(0xFFFFFFFF),
    progress: RRColors.brandCyan,
    accent: Color(0xFFD5F2FA),
    artworkFrame: Color(0xFF102D43),
    artworkAccent: Color(0xFFB4EDF8),
    systemOverlay: SystemUiOverlayStyle.dark,
  );

  static const _dark = OnboardingStyle._(
    background: Color(0xFF1E1A23),
    ink: Color(0xFFF9F6F0),
    secondary: Color(0xFFCEC4D1),
    line: Color(0xFF544A59),
    action: Color(0xFFE6DCF5),
    onAction: Color(0xFF2D203D),
    progress: Color(0xFFE6DCF5),
    accent: Color(0xFF3F334B),
    artworkFrame: Color(0xFF252124),
    artworkAccent: Color(0xFFE6DCF5),
    systemOverlay: SystemUiOverlayStyle.light,
  );

  final Color background;
  final Color ink;
  final Color secondary;
  final Color line;
  final Color action;
  final Color onAction;
  final Color progress;
  final Color accent;
  final Color artworkFrame;
  final Color artworkAccent;

  final SystemUiOverlayStyle systemOverlay;

  TextStyle title([double fontSize = 34]) => RRTypography.title1.copyWith(
    fontSize: fontSize,
    height: 1.12,
    color: ink,
  );

  TextStyle get body =>
      RRTypography.body.copyWith(height: 1.45, color: secondary);

  TextStyle get label => RRTypography.headline.copyWith(fontSize: 15);

  ButtonStyle get primaryButton => FilledButton.styleFrom(
    backgroundColor: action,
    foregroundColor: onAction,
    disabledBackgroundColor: action.withValues(alpha: 0.16),
    disabledForegroundColor: secondary,
    visualDensity: VisualDensity.standard,
    minimumSize: const Size(0, 54),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    textStyle: label.copyWith(fontSize: 16),
  );
}
