import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/secondary_button.dart';

class PermissionDeniedScreen extends StatelessWidget {
  const PermissionDeniedScreen({super.key, required this.onTryAgain, required this.onContinue});

  final VoidCallback onTryAgain;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RRSpace.sp20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.photo_fill_on_rectangle_fill, size: 64),
              const SizedBox(height: RRSpace.sp16),
              Text(l10n.permissionDeniedTitle, style: RRTypography.title1, textAlign: TextAlign.center),
              const SizedBox(height: RRSpace.sp12),
              Text(
                l10n.permissionDeniedBody,
                style: RRTypography.body.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RRSpace.sp24),
              PrimaryButton(label: l10n.openSettings, onPressed: onTryAgain),
              const SizedBox(height: RRSpace.sp12),
              SecondaryButton(label: l10n.continueAnyway, onPressed: onContinue),
            ],
          ),
        ),
      ),
    );
  }
}
