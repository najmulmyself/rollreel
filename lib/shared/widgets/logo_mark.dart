import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/logo_variant.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

class LogoMark extends StatelessWidget {
  const LogoMark({
    super.key,
    required this.variant,
    this.iconSize = 88,
    this.showTagline = true,
  });

  final LogoVariant variant;
  final double iconSize;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _icon(iconSize),
        const SizedBox(height: RRSpace.sp20),
        _wordmark(),
        if (showTagline) ...[
          const SizedBox(height: RRSpace.sp8),
          _tagline(),
        ],
      ],
    );
  }

  Widget _icon(double size) {
    final asset = switch (variant) {
      LogoVariant.classic => 'assets/icons/icon_sec.png',
      LogoVariant.iconic  => 'assets/icons/icon.png',
    };
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.22),
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );
  }

  static const _gradClassic = LinearGradient(
    colors: [RRColors.accentCyan, RRColors.accentViolet],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  Widget _wordmark() {
    switch (variant) {
      case LogoVariant.classic:
        return ShaderMask(
          shaderCallback: (bounds) => _gradClassic.createShader(bounds),
          child: const Text(
            'RollReel',
            style: TextStyle(
              fontFamily: '.SF Pro Display',
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              color: Colors.white,
            ),
          ),
        );

      case LogoVariant.iconic:
        return const Text(
          'RollReel',
          style: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
            color: RRColors.accentCoral,
          ),
        );
    }
  }

  Widget _tagline() {
    final text = switch (variant) {
      LogoVariant.classic => 'Your Videos. Your Way.',
      LogoVariant.iconic  => 'Watch. Feel. Remember.',
    };
    return Text(text, style: RRTypography.subheadline);
  }
}
