import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/primary_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String body;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(RRSpace.sp24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60),
            const SizedBox(height: RRSpace.sp16),
            Text(title, style: RRTypography.title1, textAlign: TextAlign.center),
            const SizedBox(height: RRSpace.sp12),
            Text(body, style: RRTypography.body, textAlign: TextAlign.center),
            const SizedBox(height: RRSpace.sp20),
            PrimaryButton(label: buttonLabel, onPressed: onPressed),
          ],
        ),
      ),
    );
  }
}
