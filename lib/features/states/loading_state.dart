import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class LoadingState extends StatefulWidget {
  const LoadingState({super.key});

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) => Scaffold(
        backgroundColor: RRColors.bgDeep,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar skeleton
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp16, RRSpace.sp16, RRSpace.sp12),
                child: _bone(height: 36, width: 190, radius: RRSpace.radiusFull),
              ),

              // Filter chips row skeleton
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    left: RRSpace.sp16, bottom: RRSpace.sp12),
                child: Row(
                  children: [
                    _bone(height: 32, width: 66, radius: RRSpace.radiusFull),
                    const SizedBox(width: RRSpace.sp8),
                    _bone(height: 32, width: 74, radius: RRSpace.radiusFull),
                    const SizedBox(width: RRSpace.sp8),
                    _bone(height: 32, width: 84, radius: RRSpace.radiusFull),
                    const SizedBox(width: RRSpace.sp8),
                    _bone(height: 32, width: 70, radius: RRSpace.radiusFull),
                    const SizedBox(width: RRSpace.sp8),
                    _bone(height: 32, width: 78, radius: RRSpace.radiusFull),
                  ],
                ),
              ),

              // Divider
              const Divider(height: 1, color: RRColors.divider),

              // Date label skeleton
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp12, RRSpace.sp16, RRSpace.sp8),
                child: _bone(height: 12, width: 80, radius: RRSpace.radiusSm),
              ),

              // Video row skeletons
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: RRSpace.sp16, vertical: 10),
                    child: Row(
                      children: [
                        _bone(
                            height: 72,
                            width: 72,
                            radius: RRSpace.radiusMd),
                        const SizedBox(width: RRSpace.sp12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _bone(
                                  height: 13,
                                  width: _titleWidths[i],
                                  radius: RRSpace.radiusSm),
                              const SizedBox(height: RRSpace.sp8),
                              _bone(
                                  height: 11,
                                  width: _subtitleWidths[i],
                                  radius: RRSpace.radiusSm),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Spinner + label
              Padding(
                padding: const EdgeInsets.only(bottom: RRSpace.sp24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CupertinoActivityIndicator(
                        color: RRColors.accentCyan),
                    const SizedBox(width: 10),
                    const Text(
                      'Loading your library...',
                      style: TextStyle(
                        color: RRColors.textSecond,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const List<double> _titleWidths = [260, 230, 248, 222, 240, 252];
  static const List<double> _subtitleWidths = [198, 192, 185, 200, 176, 205];

  Widget _bone({
    required double height,
    required double width,
    required double radius,
  }) {
    return Opacity(
      opacity: _pulse.value,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: RRColors.bgElevated,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
