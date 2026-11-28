import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/settings_provider.dart';
import '../../core/theme/typography.dart';

class DurationBadge extends ConsumerWidget {
  const DurationBadge({super.key, required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(settingsProvider.select((s) => s.showDurationBadges))) {
      return const SizedBox.shrink();
    }
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    final label = '$m:$s';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0x99000000),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: RRTypography.caption.copyWith(color: Colors.white),
      ),
    );
  }
}
