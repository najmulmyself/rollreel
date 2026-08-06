import 'package:flutter/material.dart';

/// App-wide light/dark switch. Video-playback screens (Feed) intentionally
/// stay black regardless of this value — only chrome screens (Settings,
/// Paywall, Browse, Vault, onboarding, etc.) read it.
class RRColors {
  const RRColors._();

  static final ValueNotifier<bool> isDark = ValueNotifier<bool>(true);

  static Color get bgDeep =>
      isDark.value ? const Color(0xFF07070F) : const Color(0xFFF5F5F7);
  // Light-lavender page background used by the new light-theme screens
  // (Profile, Library). Falls back to bgDeep in dark mode until a dark
  // variant of this design system exists.
  static Color get bgTint =>
      isDark.value ? const Color(0xFF07070F) : const Color(0xFFF3F1FB);
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
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentOrange = Color(0xFFF59E0B);

  // Flat icon-tile colors — same vivid value in both themes, matching
  // iOS Settings-style colorful glyph tiles.
  static const Color iconOrange = Color(0xFFFF9F43);
  static const Color iconGreen = Color(0xFF2ECC71);
  static const Color iconRed = Color(0xFFEE4D6E);
  static const Color iconPurple = Color(0xFF8B5CF6);
  static const Color iconBlue = Color(0xFF4A90E2);
  static const Color iconTeal = Color(0xFF34C9A3);

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
