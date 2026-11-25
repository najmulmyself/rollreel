import 'package:flutter/material.dart';

import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';
import 'onboarding_style.dart';

class OnboardingLayout extends StatelessWidget {
  const OnboardingLayout({
    super.key,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    this.step,
    this.onBack,
    this.onSkip,
    this.secondaryLabel,
    this.onSecondary,
  });

  final Widget body;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final int? step;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  static const stepCount = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const style = OnboardingStyle();
    final showBack = step == 1 || step == 2;
    final showSkip = step == 0 || step == 1;
    return AnnotatedRegion(
      value: style.systemOverlay,
      child: Scaffold(
        backgroundColor: style.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: LayoutBuilder(
                builder: (context, constraints) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        showBack ? 9 : 24,
                        constraints.maxHeight < 620 ? 2 : 10,
                        16,
                        8,
                      ),
                      child: Row(
                        children: [
                          if (showBack)
                            IconButton(
                              tooltip: l10n.back,
                              onPressed: onBack,
                              icon: const BackButtonIcon(),
                              color: style.action,
                              iconSize: 19,
                              visualDensity: VisualDensity.standard,
                            ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/icons/icon.png',
                              width: 29,
                              height: 29,
                              excludeFromSemantics: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'RollReel',
                              style: RRTypography.headline.copyWith(
                                color: style.ink,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -.65,
                              ),
                            ),
                          ),
                          if (showSkip)
                            TextButton(
                              onPressed: onSkip,
                              style: style.textButton,
                              child: Text(l10n.skip),
                            )
                          else
                            const SizedBox(height: 44),
                        ],
                      ),
                    ),
                    Expanded(child: body),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (step case final current?)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: Semantics(
                                label: l10n.onboardingStep(
                                  current + 1,
                                  stepCount,
                                ),
                                child: ExcludeSemantics(
                                  child: Row(
                                    children: [
                                      for (var i = 0; i < stepCount; i++)
                                        Container(
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                end: 5,
                                              ),
                                          width: current == i ? 28 : 15,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: current == i
                                                ? style.action
                                                : style.progressTrack,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          FilledButton(
                            onPressed: onPrimary,
                            style: style.primaryButton,
                            child: Text(
                              primaryLabel,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (secondaryLabel case final label?)
                            Center(
                              child: TextButton(
                                onPressed: onSecondary,
                                style: style.textButton,
                                child: Text(label, textAlign: TextAlign.center),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
