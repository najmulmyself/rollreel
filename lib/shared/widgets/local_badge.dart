import 'package:flutter/cupertino.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class LocalBadge extends StatelessWidget {
  const LocalBadge({super.key, this.label = 'Local'});

  final String label;

  @override
  Widget build(BuildContext context) {
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
          const Icon(CupertinoIcons.cloud_fill, color: RRColors.accentGreen, size: 12),
          const SizedBox(width: RRSpace.sp4),
          Text(
            label,
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
