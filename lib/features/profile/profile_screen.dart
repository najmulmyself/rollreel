import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';
import 'home_dashboard.dart';
import 'home_video_sections.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.onOpenSettings,
    required this.onOpenLibrary,
    required this.onPlayAt,
    required this.onOpenMemories,
  });

  final VoidCallback onOpenSettings;
  final VoidCallback onOpenLibrary;
  final ValueChanged<String> onPlayAt;
  final ValueChanged<String?> onOpenMemories;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = RRColors.isDark.value;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: isDark
            ? RRColors.bgDeep
            : RRColors.brandLightBackground,
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                key: const PageStorageKey('home'),
                padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 24),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            l10n.home,
                            style: RRTypography.title1.copyWith(
                              fontSize: 34,
                              color: isDark
                                  ? RRColors.textPrimary
                                  : RRColors.brandInk,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.settings,
                        onPressed: onOpenSettings,
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/icons/icon.png',
                            width: 32,
                            height: 32,
                            excludeFromSemantics: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  HomeVideoSections(
                    onOpenLibrary: onOpenLibrary,
                    onPlayAt: onPlayAt,
                    onOpenMemories: onOpenMemories,
                  ),
                  const SizedBox(height: 30),
                  const HomeDashboard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
