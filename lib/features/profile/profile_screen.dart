import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';
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
                  Text(
                    l10n.homeActivityPreview,
                    style: RRTypography.subheadline.copyWith(
                      color: isDark
                          ? RRColors.textSecond
                          : RRColors.brandMutedInk,
                    ),
                  ),
                  const SizedBox(height: RRSpace.sp12),
                  const _TodayCard(),
                  const SizedBox(height: RRSpace.sp16),
                  const _StatTiles(),
                  const SizedBox(height: RRSpace.sp16),
                  const _StreakBanner(),
                  const SizedBox(height: RRSpace.sp16),
                  const _WatchActivityCard(),
                  const SizedBox(height: RRSpace.sp16),
                  const _TopFoldersCard(),
                  const SizedBox(height: RRSpace.sp16),
                  const _MostWatchedCard(),
                  const SizedBox(height: RRSpace.sp16),
                  const _RecapCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Dashboard figures are sample data until watch activity is recorded.
// ─── Today card ───────────────────────────────────────────────────────────────

class _TodayCard extends StatelessWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: RRColors.brandBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.videocam_fill,
                  color: RRColors.brandBlue,
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: RRColors.brandInk,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: RRColors.brandBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                ),
                child: const Text(
                  '0%',
                  style: TextStyle(
                    color: RRColors.brandBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: RRSpace.sp16),
          Row(
            children: [
              Expanded(
                child: _StatBlock(
                  icon: CupertinoIcons.clock_fill,
                  iconColor: RRColors.brandBlue,
                  value: '0m',
                  label: 'Total watch time',
                ),
              ),
              const SizedBox(width: RRSpace.sp12),
              Expanded(
                child: _StatBlock(
                  icon: CupertinoIcons.play_fill,
                  iconColor: RRColors.brandBlue,
                  value: '0',
                  label: 'Videos watched',
                ),
              ),
            ],
          ),
          const SizedBox(height: RRSpace.sp16),
          ClipRRect(
            borderRadius: BorderRadius.circular(RRSpace.radiusFull),
            child: LinearProgressIndicator(
              value: 0,
              minHeight: 6,
              backgroundColor: const Color(0xFFE1EDF4),
              valueColor: const AlwaysStoppedAnimation<Color>(
                RRColors.brandBlue,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'vs last week',
              style: TextStyle(color: RRColors.brandMutedInk, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: RRColors.brandInk,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: RRColors.brandMutedInk, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── 4 stat tiles ─────────────────────────────────────────────────────────────

class _StatTiles extends StatelessWidget {
  const _StatTiles();

  static const _tiles = [
    _StatTile(icon: CupertinoIcons.videocam, value: '3', label: 'Videos'),
    _StatTile(icon: CupertinoIcons.heart, value: '2', label: 'Liked'),
    _StatTile(icon: CupertinoIcons.play, value: '32', label: 'Plays'),
    _StatTile(
      icon: CupertinoIcons.device_phone_portrait,
      value: '0 GB',
      label: 'Storage',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final width = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final tile in _tiles) SizedBox(width: width, child: tile),
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Row(
        children: [
          Icon(icon, color: RRColors.brandBlue, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: RRTypography.headline.copyWith(
                    color: RRColors.brandInk,
                  ),
                ),
                Text(
                  label,
                  style: RRTypography.caption.copyWith(
                    color: RRColors.brandMutedInk,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Watch streak banner ────────────────────────────────────────────────────

class _StreakBanner extends StatelessWidget {
  const _StreakBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RRSpace.sp16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F4FA),
        borderRadius: BorderRadius.circular(RRSpace.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              CupertinoIcons.flame_fill,
              color: RRColors.brandCyan,
              size: 22,
            ),
          ),
          const SizedBox(width: RRSpace.sp12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Watch streak',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: RRColors.brandInk,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Watch 3+ minutes today\nto start a streak',
                  style: TextStyle(
                    color: RRColors.brandMutedInk,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Best',
                style: TextStyle(color: RRColors.brandMutedInk, fontSize: 12),
              ),
              const Text(
                '0 days',
                style: TextStyle(
                  color: RRColors.brandCyan,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          const Icon(
            CupertinoIcons.chevron_right,
            color: RRColors.brandMutedInk,
            size: 16,
          ),
        ],
      ),
    );
  }
}

// ─── Watch activity chart ───────────────────────────────────────────────────

class _WatchActivityCard extends StatelessWidget {
  const _WatchActivityCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Watch Activity',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: RRColors.brandInk,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: RRColors.brandBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(
                        color: RRColors.brandBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: RRColors.brandBlue,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RRSpace.sp20),
          const _FlatActivityChart(),
        ],
      ),
    );
  }
}

class _FlatActivityChart extends StatelessWidget {
  const _FlatActivityChart();

  static const _yLabels = ['10m', '6m', '3m', '0m'];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          height: 128,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final label in _yLabels)
                Text(
                  label,
                  style: TextStyle(color: RRColors.textDisabled, fontSize: 11),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 128,
                child: CustomPaint(
                  size: const Size(double.infinity, 128),
                  painter: _FlatLinePainter(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Thu',
                style: TextStyle(color: RRColors.brandMutedInk, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FlatLinePainter extends CustomPainter {
  static const _points = 7;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = RRColors.brandOutline
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final baseY = size.height - 4;
    final dx = size.width / (_points - 1);
    final linePaint = Paint()
      ..color = RRColors.brandBlue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final path = Path();
    for (var i = 0; i < _points; i++) {
      final x = dx * i;
      if (i == 0) {
        path.moveTo(x, baseY);
      } else {
        path.lineTo(x, baseY);
      }
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = RRColors.brandBlue;
    for (var i = 0; i < _points; i++) {
      canvas.drawCircle(Offset(dx * i, baseY), 4, dotPaint);
      canvas.drawCircle(
        Offset(dx * i, baseY),
        4,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    final total = (b - a).distance;
    final dir = (b - a) / total;
    var covered = 0.0;
    while (covered < total) {
      final start = a + dir * covered;
      final segmentEnd = (covered + dashWidth) > total
          ? total
          : covered + dashWidth;
      final end = a + dir * segmentEnd;
      canvas.drawLine(start, end, paint);
      covered += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Top folders ─────────────────────────────────────────────────────────────

class _TopFoldersCard extends StatelessWidget {
  const _TopFoldersCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeader(title: 'Top Folders'),
          const SizedBox(height: RRSpace.sp12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: RRColors.brandBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.folder_fill,
                  color: RRColors.brandBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: RRSpace.sp12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Review Demo Library',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: RRColors.brandInk,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '3 videos',
                      style: TextStyle(
                        color: RRColors.brandMutedInk,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '0m',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: RRColors.brandInk,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                CupertinoIcons.chevron_right,
                color: RRColors.textDisabled,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Most watched ─────────────────────────────────────────────────────────────

class _MostWatchedCard extends StatelessWidget {
  const _MostWatchedCard();

  static const _items = [
    (
      title: 'Demo: Morning...',
      plays: '14 plays',
      colors: [Color(0xFF1E3A8A), Color(0xFF0EA5E9)],
    ),
    (
      title: 'Demo: City Lights',
      plays: '9 plays',
      colors: [Color(0xFF9D174D), Color(0xFFF97316)],
    ),
    (
      title: 'Demo: Weekend...',
      plays: '9 plays',
      colors: [Color(0xFF4C1D95), Color(0xFF6366F1)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeader(title: 'Most Watched'),
          const SizedBox(height: RRSpace.sp12),
          Row(
            children: [
              for (var i = 0; i < _items.length; i++) ...[
                if (i > 0) const SizedBox(width: RRSpace.sp8),
                Expanded(child: _MostWatchedTile(item: _items[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MostWatchedTile extends StatelessWidget {
  const _MostWatchedTile({required this.item});

  final ({String title, String plays, List<Color> colors}) item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(RRSpace.radiusMd),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: item.colors,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 3,
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 5,
                bottom: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '0:04',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: RRColors.brandInk,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(
              CupertinoIcons.play_fill,
              color: RRColors.brandBlue,
              size: 10,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                item.plays,
                style: const TextStyle(
                  color: RRColors.brandMutedInk,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── 2026 Recap ───────────────────────────────────────────────────────────────

class _RecapCard extends StatelessWidget {
  const _RecapCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '2026 Recap',
                  style: RRTypography.headline.copyWith(
                    color: RRColors.brandInk,
                  ),
                ),
              ),
              const Icon(
                CupertinoIcons.rosette,
                color: RRColors.brandCyan,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _RecapRow(
            icon: CupertinoIcons.clock,
            label: 'Total watch time',
            value: '0m',
          ),
          const _RecapRow(
            icon: CupertinoIcons.play,
            label: 'Videos watched',
            value: '17',
          ),
          const _RecapRow(
            icon: CupertinoIcons.star,
            label: 'Most watched',
            value: 'Demo: Morning Highlights',
          ),
          const _RecapRow(
            icon: CupertinoIcons.folder,
            label: 'Top folder',
            value: 'Review Demo Library',
          ),
          const _RecapRow(
            icon: CupertinoIcons.add_circled,
            label: 'Videos added',
            value: '3',
          ),
        ],
      ),
    );
  }
}

class _RecapRow extends StatelessWidget {
  const _RecapRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: RRColors.brandBlue, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: RRColors.brandMutedInk, fontSize: 12.5),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: RRColors.brandInk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared bits ──────────────────────────────────────────────────────────────

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: RRColors.brandInk,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'View all',
          style: TextStyle(
            color: RRColors.brandBlue,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(RRSpace.sp16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RRSpace.radiusLg),
        border: Border.all(color: RRColors.brandOutline),
      ),
      child: child,
    );
  }
}
