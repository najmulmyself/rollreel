import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../l10n/app_localizations.dart';

class LocalBadge extends StatelessWidget {
  const LocalBadge({super.key, this.label});

  /// Badge text; defaults to the localized "Local" label when null.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final effectiveLabel = label ?? AppLocalizations.of(context)!.localBadge;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: RRSpace.sp4),
      decoration: BoxDecoration(
        color: RRColors.accentGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(RRSpace.radiusFull),
        border: Border.all(color: RRColors.accentGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: RRColors.accentGreen,
            ),
          ),
          const SizedBox(width: RRSpace.sp4),
          Text(
            effectiveLabel,
            style: const TextStyle(
              fontFamily: '.SF Pro Text',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: RRColors.accentGreen,
            ),
          ),
        ],
      ),
    );
  }
}
