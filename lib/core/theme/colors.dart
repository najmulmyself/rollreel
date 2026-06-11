import 'package:flutter/material.dart';

class RRColors {
  const RRColors._();

  static const Color bgDeep = Color(0xFF07070F);
  static const Color bgSurface = Color(0xFF111118);
  static const Color bgElevated = Color(0xFF1C1C26);

  static const Color glassLight = Color(0x33FFFFFF);
  static const Color glassDark = Color(0x99000000);
  static const Color glassBorder = Color(0x22FFFFFF);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecond = Color(0xFFAAAAAB);
  static const Color textDisabled = Color(0xFF555565);

  static const Color divider = Color(0xFF1E1E2E);

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
