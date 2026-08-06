import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

// Stats dashboard ("Home" tab). All numbers here are the exact static demo
// values from the reference design — no watch-time/play-count/streak
// tracking exists in the app yet, so this screen isn't wired to real data.
// Swap in live providers once that tracking is built.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.onOpenSettings});

  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RRColors.bgTint,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              RRSpace.sp16, RRSpace.sp16, RRSpace.sp16, RRSpace.sp24),
          children: [
            _Header(onOpenSettings: onOpenSettings),
            const SizedBox(height: RRSpace.sp20),
            const _TodayCard(),
            const SizedBox(height: RRSpace.sp16),
            const _StatTilesRow(),
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
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({this.onOpenSettings});
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your viewing habits and achievements.',
                style: TextStyle(
                  fontSize: 14,
                  color: RRColors.textSecond,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        // Placeholder header illustration — swap for the real
        // avatar/chart graphic once provided.
        const SizedBox(
          width: 88,
          height: 88,
          child: _HeaderIllustration(),
        ),
        const SizedBox(width: RRSpace.sp8),
        GestureDetector(
          onTap: onOpenSettings,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
              ],
            ),
            child: const Icon(CupertinoIcons.gear_alt_fill,
                color: RRColors.accentViolet, size: 18),
          ),
        ),
      ],
    );
  }
}

class _HeaderIllustration extends StatelessWidget {
  const _HeaderIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 8,
          top: 4,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: RRColors.gradPro,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x338B5CF6), blurRadius: 16, offset: Offset(0, 6)),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(CupertinoIcons.person_fill,
                color: Colors.white, size: 30),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 40,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 2)),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(CupertinoIcons.chart_bar_fill,
                color: RRColors.accentViolet, size: 16),
          ),
        ),
        const Positioned(
          left: 0,
          top: 0,
          child: Icon(CupertinoIcons.sparkles,
              color: RRColors.accentPink, size: 14),
        ),
        const Positioned(
          right: 10,
          top: 20,
          child: Icon(CupertinoIcons.sparkles,
              color: RRColors.accentAmber, size: 12),
        ),
      ],
    );
  }
}

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
                  color: RRColors.accentBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(CupertinoIcons.videocam_fill,
                    color: RRColors.accentBlue, size: 17),
              ),
              const SizedBox(width: 10),
              const Text(
                'Today',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E)),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: RRColors.accentBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                ),
                child: const Text(
                  '0%',
                  style: TextStyle(
                    color: RRColors.accentBlue,
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
                  iconColor: RRColors.accentViolet,
                  value: '0m',
                  label: 'Total watch time',
                ),
              ),
              const SizedBox(width: RRSpace.sp12),
              Expanded(
                child: _StatBlock(
                  icon: CupertinoIcons.play_fill,
                  iconColor: RRColors.accentBlue,
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
              backgroundColor: const Color(0xFFEDEDF2),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(RRColors.accentViolet),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'vs last week',
              style: TextStyle(color: RRColors.textSecond, fontSize: 12),
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
                    color: Color(0xFF1A1A2E)),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: RRColors.textSecond, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── 4 stat tiles ─────────────────────────────────────────────────────────────

class _StatTilesRow extends StatelessWidget {
  const _StatTilesRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatTile(
            icon: CupertinoIcons.video_camera_solid,
            iconColor: RRColors.accentViolet,
            value: '3',
            label: 'Videos',
          ),
        ),
        SizedBox(width: RRSpace.sp8),
        Expanded(
          child: _StatTile(
            icon: CupertinoIcons.heart_fill,
            iconColor: RRColors.accentPink,
            value: '2',
            label: 'Liked',
          ),
        ),
        SizedBox(width: RRSpace.sp8),
        Expanded(
          child: _StatTile(
            icon: CupertinoIcons.chart_bar_alt_fill,
            iconColor: RRColors.accentBlue,
            value: '32',
            label: 'Plays',
          ),
        ),
        SizedBox(width: RRSpace.sp8),
        Expanded(
          child: _StatTile(
            icon: CupertinoIcons.device_phone_portrait,
            iconColor: RRColors.iconGreen,
            value: '0 GB',
            label: 'Storage',
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
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
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: RRSpace.sp8, vertical: RRSpace.sp16),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(RRSpace.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E)),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: RRColors.textSecond, fontSize: 11),
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
        gradient: const LinearGradient(
          colors: [Color(0xFFFDF0E0), Color(0xFFFCE8E0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
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
            child: const Icon(CupertinoIcons.flame_fill,
                color: Color(0xFFF5943C), size: 22),
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
                      color: Color(0xFF1A1A2E)),
                ),
                SizedBox(height: 2),
                Text(
                  'Watch 3+ minutes today\nto start a streak',
                  style: TextStyle(color: Color(0xFF8A7A6E), fontSize: 12.5),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Best',
                  style: TextStyle(color: RRColors.textSecond, fontSize: 12)),
              const Text(
                '0 days',
                style: TextStyle(
                    color: Color(0xFFF5943C),
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(width: 6),
          const Icon(CupertinoIcons.chevron_right,
              color: Color(0xFFC9A98E), size: 16),
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
              const Text(
                'Watch Activity',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E)),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: RRColors.accentViolet.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Today',
                        style: TextStyle(
                            color: RRColors.accentViolet,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                    SizedBox(width: 4),
                    Icon(CupertinoIcons.chevron_down,
                        color: RRColors.accentViolet, size: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RRSpace.sp20),
          const SizedBox(
            height: 150,
            child: _FlatActivityChart(),
          ),
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
                Text(label,
                    style:
                        TextStyle(color: RRColors.textDisabled, fontSize: 11)),
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
              Text('Thu',
                  style: TextStyle(color: RRColors.textSecond, fontSize: 12)),
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
      ..color = const Color(0xFFE9E9F0)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final baseY = size.height - 4;
    final dx = size.width / (_points - 1);
    final linePaint = Paint()
      ..color = RRColors.accentViolet
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

    final dotPaint = Paint()..color = RRColors.accentViolet;
    for (var i = 0; i < _points; i++) {
      canvas.drawCircle(Offset(dx * i, baseY), 4, dotPaint);
      canvas.drawCircle(
          Offset(dx * i, baseY), 4, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
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
      final segmentEnd =
          (covered + dashWidth) > total ? total : covered + dashWidth;
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
                  color: RRColors.accentBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(CupertinoIcons.folder_fill,
                    color: RRColors.accentBlue, size: 20),
              ),
              const SizedBox(width: RRSpace.sp12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review Demo Library',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E)),
                    ),
                    SizedBox(height: 2),
                    Text('3 videos',
                        style: TextStyle(
                            color: RRColors.textSecond, fontSize: 13)),
                  ],
                ),
              ),
              const Text(
                '0m',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E)),
              ),
              const SizedBox(width: 6),
              Icon(CupertinoIcons.chevron_right,
                  color: RRColors.textDisabled, size: 16),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '0:04',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
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
              color: Color(0xFF1A1A2E)),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(CupertinoIcons.play_fill,
                color: RRColors.accentViolet, size: 10),
            const SizedBox(width: 3),
            Text(item.plays,
                style: TextStyle(color: RRColors.textSecond, fontSize: 11)),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '2026 Recap 🎉',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: RRSpace.sp12),
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
          ),
          const SizedBox(width: RRSpace.sp8),
          // Placeholder trophy illustration — swap for the real asset
          // once provided.
          const SizedBox(
            width: 90,
            height: 130,
            child: _TrophyIllustration(),
          ),
        ],
      ),
    );
  }
}

class _RecapRow extends StatelessWidget {
  const _RecapRow(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: RRColors.accentViolet, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: RRColors.textSecond, fontSize: 12.5),
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E)),
          ),
        ],
      ),
    );
  }
}

class _TrophyIllustration extends StatelessWidget {
  const _TrophyIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Positioned(
            top: 4, left: 4, child: Icon(CupertinoIcons.sparkles,
                color: RRColors.accentPink, size: 14)),
        const Positioned(
            bottom: 10, right: 0, child: Icon(CupertinoIcons.sparkles,
                color: RRColors.accentAmber, size: 12)),
        Icon(Icons.emoji_events_rounded,
            color: RRColors.accentViolet, size: 76),
      ],
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
        Text(
          title,
          style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E)),
        ),
        const Spacer(),
        Text(
          'View all',
          style: TextStyle(
              color: RRColors.accentViolet,
              fontWeight: FontWeight.w600,
              fontSize: 13),
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
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}
