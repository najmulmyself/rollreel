import 'package:flutter/material.dart';

/// App-wide light/dark switch. Video-playback screens (Feed) intentionally
/// stay black regardless of this value — only chrome screens (Settings,
/// Paywall, Browse, Vault, onboarding, etc.) read it.
class RRColors {
  const RRColors._();

  static final ValueNotifier<bool> isDark = ValueNotifier<bool>(true);

  static Color get bgDeep =>
      isDark.value ? const Color(0xFF07070F) : const Color(0xFFF5F5F7);
  static Color get bgSurface =>
      isDark.value ? const Color(0xFF111118) : const Color(0xFFFFFFFF);
  static Color get bgElevated =>
      isDark.value ? const Color(0xFF1C1C26) : const Color(0xFFFFFFFF);

  static Color get glassLight =>
      isDark.value ? const Color(0x33FFFFFF) : const Color(0x33000000);
  static Color get glassDark =>
      isDark.value ? const Color(0x99000000) : const Color(0x99FFFFFF);
  static Color get glassBorder =>
      isDark.value ? const Color(0x22FFFFFF) : const Color(0x22000000);

  static Color get textPrimary =>
      isDark.value ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0F);
  static Color get textSecond =>
      isDark.value ? const Color(0xFFAAAAAB) : const Color(0xFF6B6B76);
  static Color get textDisabled =>
      isDark.value ? const Color(0xFF555565) : const Color(0xFFB0B0BA);

  static Color get divider =>
      isDark.value ? const Color(0xFF1E1E2E) : const Color(0xFFE2E2E8);

  static const Color accentCoral = Color(0xFFFF5E5E);
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color accentAmber = Color(0xFFFFB347);
  static const Color accentViolet = Color(0xFF8B5CF6);
  static const Color accentGreen = Color(0xFF4ADE80);
  static const Color accentPink = Color(0xFFFF5E8B);

  static const LinearGradient gradBrand = LinearGradient(
    colors: [accentCoral, accentViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradFeedOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.4, 1],
  );

  static const LinearGradient gradPro = LinearGradient(
    colors: [accentViolet, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
