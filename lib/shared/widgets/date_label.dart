import 'package:flutter/material.dart';

import '../../core/theme/spacing.dart';
import 'glass_panel.dart';

class DateLabel extends StatelessWidget {
  const DateLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: BorderRadius.circular(RRSpace.radiusFull),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: '.SF Pro Text',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
