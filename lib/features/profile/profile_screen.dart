import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/permissions/permission_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/video/video_library_provider.dart';
import '../../l10n/app_localizations.dart';
import 'home_dashboard.dart';
import 'home_video_sections.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    required this.onOpenLibrary,
    required this.onOpenMemories,
  });

  final VoidCallback onOpenLibrary;
  final ValueChanged<String?> onOpenMemories;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final AppLifecycleListener _lifecycle;
  bool _showActivity = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () async {
        await ref.read(permissionProvider.notifier).refresh();
        if (mounted) ref.invalidate(videoLibraryProvider);
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _selectTab(bool activity) {
    if (_showActivity == activity) return;
    HapticFeedback.selectionClick();
    setState(() => _showActivity = activity);
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    final surface = RRColors.bgSurface;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(42) / 42;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: surface,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = math.min(constraints.maxWidth, 640.0);
            final heroHeight =
                insets.top + 167 + 92 * math.max(0, textScale - 1);

            return ListView(
              key: const PageStorageKey('home'),
              padding: EdgeInsets.only(bottom: insets.bottom + 24),
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: heroHeight + 30,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF103A88),
                              Color(0xFF1666CB),
                              Color(0xFF60C5F0),
                            ],
                            stops: [0, .64, 1],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: width,
                        child: Stack(
                          children: [
                            PositionedDirectional(
                              top: insets.top + 4,
                              end: 0,
                              width: width * .5,
                              height: heroHeight - insets.top + 26,
                              child: const ClipRect(
                                child: CustomPaint(painter: _HeroRings()),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: heroHeight),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: surface,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(26),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: math.max(20, insets.left),
                                    right: math.max(20, insets.right),
                                  ),
                                  child: _HomeSheet(
                                    showActivity: _showActivity,
                                    onSelectTab: _selectTab,
                                    reduceMotion: reduceMotion,
                                    child: _showActivity
                                        ? const HomeDashboard()
                                        : HomeVideoSections(
                                            onOpenLibrary: widget.onOpenLibrary,
                                            onOpenMemories:
                                                widget.onOpenMemories,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              start: 22,
                              top: insets.top + 20,
                              width: width * .60,
                              child: _HomeMasthead(compact: width < 350),
                            ),
                            PositionedDirectional(
                              top: heroHeight - 163,
                              end: 4,
                              child: IgnorePointer(
                                child: Image.asset(
                                  'assets/images/home_kingfisher.webp',
                                  width: math.min(161, width * .38),
                                  height: 180,
                                  alignment: Alignment.bottomRight,
                                  fit: BoxFit.contain,
                                  excludeFromSemantics: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeMasthead extends StatelessWidget {
  const _HomeMasthead({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
                style: RRTypography.headline.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 23),
        Semantics(
          header: true,
          child: Text(
            l10n.homeCameraRoll,
            style: RRTypography.title1.copyWith(
              color: Colors.white,
              fontSize: compact ? 35 : 42,
              height: 1,
              letterSpacing: -1.7,
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeSheet extends StatelessWidget {
  const _HomeSheet({
    required this.showActivity,
    required this.onSelectTab,
    required this.reduceMotion,
    required this.child,
  });

  final bool showActivity;
  final ValueChanged<bool> onSelectTab;
  final bool reduceMotion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inactive = RRColors.isDark.value
        ? RRColors.textSecond
        : RRColors.brandMutedInk;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: homeRule)),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Row(
              children: [
                _HomeTab(
                  label: l10n.homeWatchTab,
                  icon: CupertinoIcons.film,
                  selectedIcon: CupertinoIcons.film_fill,
                  selected: !showActivity,
                  color: !showActivity ? homeAccent : inactive,
                  onPressed: () => onSelectTab(false),
                ),
                const SizedBox(width: 26),
                _HomeTab(
                  label: l10n.homeActivityTab,
                  icon: CupertinoIcons.waveform,
                  selectedIcon: CupertinoIcons.waveform,
                  selected: showActivity,
                  color: showActivity ? homeAccent : inactive,
                  onPressed: () => onSelectTab(true),
                ),
              ],
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 180),
          layoutBuilder: (current, previous) => Stack(
            alignment: Alignment.topCenter,
            children: [
              for (final child in previous)
                // Keep outgoing panels at their natural height as they fade.
                IgnorePointer(child: ExcludeSemantics(child: child)),
              if (current != null) current,
            ],
          ),
          child: Padding(
            key: ValueKey(showActivity),
            padding: EdgeInsets.only(top: showActivity ? 7 : 15),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Semantics(
        selected: selected,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: color,
            visualDensity: VisualDensity.standard,
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size(44, 56),
            shape: const RoundedRectangleBorder(),
          ),
          child: IntrinsicWidth(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(selected ? selectedIcon : icon, size: 17),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        label,
                        style: RRTypography.subheadline.copyWith(
                          color: color,
                          fontSize: 15,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (selected)
                  Positioned(
                    bottom: -15,
                    left: 0,
                    right: 0,
                    height: 3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroRings extends CustomPainter {
  const _HeroRings();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .72, size.height * .89);
    final paint = Paint()..style = PaintingStyle.stroke;
    for (final (radius, opacity) in [
      (123.0, .22),
      (137.0, .12),
      (159.0, .08),
    ]) {
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_HeroRings oldDelegate) => false;
}
