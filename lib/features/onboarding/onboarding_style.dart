import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

class OnboardingStyle {
  const OnboardingStyle();

  Color get background => const Color(0xFFFAF9F5);
  Color get ink => const Color(0xFF102C40);
  Color get secondary => const Color(0xFF455D70);
  Color get line => const Color(0xFFD5DFE4);
  Color get progressTrack => const Color(0xFFC4D5DE);
  Color get action => RRColors.brandBlue;

  SystemUiOverlayStyle get systemOverlay => SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: background,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  TextStyle title(double width) => RRTypography.title1.copyWith(
    fontSize: (width * .111).clamp(35.0, 46.0),
    letterSpacing: -1.8,
    height: 1.0,
    color: ink,
  );

  TextStyle get body =>
      RRTypography.body.copyWith(height: 1.48, color: secondary);

  TextStyle get label =>
      RRTypography.headline.copyWith(fontSize: 15, color: action);

  ButtonStyle get primaryButton => FilledButton.styleFrom(
    backgroundColor: action,
    foregroundColor: Colors.white,
    disabledBackgroundColor: const Color(0xFFDCE7EE),
    disabledForegroundColor: secondary,
    visualDensity: VisualDensity.standard,
    minimumSize: const Size(0, 53),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    textStyle: label.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
  );

  ButtonStyle get textButton => TextButton.styleFrom(
    foregroundColor: action,
    disabledForegroundColor: secondary,
    visualDensity: VisualDensity.standard,
    minimumSize: const Size(44, 44),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    textStyle: label,
  );
}
