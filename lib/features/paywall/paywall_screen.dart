import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/pro_badge.dart';
import '../../shared/widgets/secondary_button.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RRSpace.sp20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onClose,
                  icon: const Icon(CupertinoIcons.xmark_circle_fill),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(RRSpace.sp20),
                decoration: BoxDecoration(
                  gradient: RRColors.gradPro,
                  borderRadius: BorderRadius.circular(RRSpace.radiusLg),
                ),
                child: const Column(
                  children: [
                    ProBadge(large: true),
                    SizedBox(height: RRSpace.sp12),
                    Text('RollReel Pro', style: RRTypography.title1),
                    SizedBox(height: RRSpace.sp8),
                    Text('Watch more. Worry less.', style: RRTypography.subheadline),
                  ],
                ),
              ),
              const SizedBox(height: RRSpace.sp24),
              const _Feature(text: 'Ad-Free Experience'),
              const _Feature(text: 'Privacy Vault with Face ID'),
              const _Feature(text: 'Playback Speed Controls'),
              const _Feature(text: 'Smart Collections'),
              const Spacer(),
              PrimaryButton(label: 'Unlock RollReel Pro - USD 4.99', onPressed: () {}),
              const SizedBox(height: RRSpace.sp12),
              SecondaryButton(label: 'Restore Purchases', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: const Icon(CupertinoIcons.check_mark_circled_solid, color: RRColors.accentGreen),
      title: Text(text),
    );
  }
}
