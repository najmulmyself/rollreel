import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';

class RRAppTheme {
  const RRAppTheme._();

  static ThemeData dark() {
    final colorScheme = ColorScheme.dark(
      primary: RRColors.accentCoral,
      secondary: RRColors.accentCyan,
      surface: RRColors.bgSurface,
      onPrimary: RRColors.textPrimary,
      onSecondary: RRColors.textPrimary,
      onSurface: RRColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: RRColors.bgDeep,
      colorScheme: colorScheme,
      dividerColor: RRColors.divider,
      textTheme: TextTheme(
        headlineLarge: RRTypography.title1,
        headlineMedium: RRTypography.title2,
        headlineSmall: RRTypography.headline,
        bodyLarge: RRTypography.body,
        bodyMedium: RRTypography.subheadline,
        bodySmall: RRTypography.caption,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: RRColors.bgDeep,
        primaryColor: RRColors.accentCoral,
      ),
    );
  }
}
