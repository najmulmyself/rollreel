import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../shared/widgets/date_label.dart';
import '../../shared/widgets/glass_panel.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.onOpenBrowse,
    required this.onOpenSettings,
  });

  final VoidCallback onOpenBrowse;
  final VoidCallback onOpenSettings;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _pageController = PageController();
  int _index = 0;

  static const _mock = [
    ('Birthday Rooftop', 'June 5, 2024', Color(0xFF3B2E7E)),
    ('Beach Sunset', 'April 22, 2024', Color(0xFF503922)),
    ('Train Window Rain', 'January 10, 2023', Color(0xFF213445)),
  ];

  @override
  Widget build(BuildContext context) {
    final active = _mock[_index];

    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [active.$3, RRColors.bgDeep],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _mock.length,
              onPageChanged: (value) => setState(() => _index = value),
              itemBuilder: (context, index) {
                final item = _mock[index];
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(RRSpace.sp20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(RRSpace.radiusLg),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.2),
                        alignment: Alignment.center,
                        child: Text(item.$1, style: Theme.of(context).textTheme.headlineMedium),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp20, vertical: RRSpace.sp12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.onOpenBrowse,
                    icon: const Icon(CupertinoIcons.rectangle_stack_fill),
                  ),
                  const Spacer(),
                  const Text('RollReel'),
                  const Spacer(),
                  IconButton(
                    onPressed: widget.onOpenSettings,
                    icon: const Icon(CupertinoIcons.slider_horizontal_3),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + RRSpace.sp16,
            left: 0,
            right: 0,
            child: const Center(child: DateLabel(label: 'June 2024')),
          ),
          Positioned(
            left: RRSpace.sp20,
            right: RRSpace.sp20,
            bottom: MediaQuery.paddingOf(context).bottom + RRSpace.sp12,
            child: GlassPanel(
              borderRadius: BorderRadius.circular(RRSpace.radiusXl),
              padding: const EdgeInsets.all(RRSpace.sp16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(active.$1, style: Theme.of(context).textTheme.headlineSmall)),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.share),
                      ),
                    ],
                  ),
                  const SizedBox(height: RRSpace.sp8),
                  Text(active.$2, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: RRSpace.sp12),
                  const LinearProgressIndicator(value: 0.35, minHeight: 3),
                  const SizedBox(height: RRSpace.sp12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(CupertinoIcons.heart),
                      Icon(CupertinoIcons.gobackward_10),
                      Icon(CupertinoIcons.pause_solid, size: 34),
                      Icon(CupertinoIcons.goforward_10),
                      Icon(CupertinoIcons.ellipsis_circle),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
