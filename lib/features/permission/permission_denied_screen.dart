import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
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
    final style = OnboardingStyle.current;
    return AnnotatedRegion(
      value: style.systemOverlay,
      child: Scaffold(
        backgroundColor: style.background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: style.accent,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: SizedBox.square(
                                dimension: 68,
                                child: Icon(
                                  CupertinoIcons.photo_on_rectangle,
                                  color: style.ink,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 23),
                          Semantics(
                            header: true,
                            child: Text(
                              l10n.permissionDeniedTitle,
                              style: style.title(53),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(l10n.permissionDeniedBody, style: style.body),
                          const SizedBox(height: 28),
                          FilledButton(
                            onPressed: onTryAgain,
                            style: style.primaryButton,
                            child: Text(
                              l10n.openSettings,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: onContinue,
                            style: TextButton.styleFrom(
                              foregroundColor: style.ink,
                              minimumSize: const Size(0, 48),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Text(
                              l10n.continueAnyway,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
