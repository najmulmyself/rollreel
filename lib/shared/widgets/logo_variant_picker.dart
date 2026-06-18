import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/logo_variant.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import 'logo_mark.dart';

class LogoVariantPicker extends ConsumerWidget {
  const LogoVariantPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(logoVariantProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: RRSpace.sp20, bottom: RRSpace.sp12),
          child: Text(
            'APP ICON STYLE',
            style: TextStyle(
              color: RRColors.textDisabled,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Row(
          children: LogoVariant.values.map((variant) {
            final selected = variant == current;
            return Expanded(
              child: GestureDetector(
                onTap: () => ref.read(logoVariantProvider.notifier).select(variant),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: RRSpace.sp8),
                  padding: const EdgeInsets.symmetric(vertical: RRSpace.sp20),
                  decoration: BoxDecoration(
                    color: selected ? RRColors.bgElevated : RRColors.bgSurface,
                    borderRadius: BorderRadius.circular(RRSpace.radiusLg),
                    border: Border.all(
                      color: selected ? RRColors.accentCoral : RRColors.divider,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      LogoMark(
                        variant: variant,
                        iconSize: 64,
                        showTagline: false,
                      ),
                      const SizedBox(height: RRSpace.sp12),
                      Text(
                        variant == LogoVariant.classic ? 'Classic' : 'Iconic',
                        style: RRTypography.caption.copyWith(
                          color: selected ? RRColors.accentCoral : RRColors.textSecond,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                      if (selected)
                        const Padding(
                          padding: EdgeInsets.only(top: RRSpace.sp8),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: RRColors.accentCoral,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
