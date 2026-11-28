import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../onboarding/onboarding_layout.dart';
import '../onboarding/onboarding_style.dart';

class PermissionDeniedScreen extends StatelessWidget {
  const PermissionDeniedScreen({
    super.key,
    required this.onTryAgain,
    required this.onContinue,
  });

  final VoidCallback onTryAgain;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const style = OnboardingStyle();

    return OnboardingLayout(
      primaryLabel: l10n.openSettings,
      onPrimary: onTryAgain,
      secondaryLabel: l10n.continueAnyway,
      onSecondary: onContinue,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            (MediaQuery.sizeOf(context).height * .14).clamp(40.0, 133.0),
            24,
            12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.permissionDeniedTitle,
                  style: style.title(constraints.maxWidth),
                ),
              ),
              const SizedBox(height: 13),
              Text(l10n.permissionDeniedBody, style: style.body),
            ],
          ),
        ),
      ),
    );
  }
}
