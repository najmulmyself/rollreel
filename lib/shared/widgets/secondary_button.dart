import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: RRSpace.buttonHeight,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: RRColors.glassBorder, width: 1.4),
          foregroundColor: RRColors.textSecond,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RRSpace.radiusFull),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
