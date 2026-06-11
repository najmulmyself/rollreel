import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class ProBadge extends StatelessWidget {
  const ProBadge({super.key, this.large = false});

  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? RRSpace.sp16 : RRSpace.sp8,
        vertical: large ? RRSpace.sp8 : RRSpace.sp4,
      ),
      decoration: BoxDecoration(
        gradient: RRColors.gradPro,
        borderRadius: BorderRadius.circular(RRSpace.radiusFull),
      ),
      child: Text(
        'PRO',
        style: TextStyle(
          fontFamily: '.SF Pro Text',
          fontSize: large ? 16 : 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
          color: RRColors.textPrimary,
        ),
      ),
    );
  }
}
