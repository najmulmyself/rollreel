import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/logo_variant.dart';
import '../../shared/widgets/logo_mark.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.5)),
    );

    _ctrl.forward();

    Timer(const Duration(milliseconds: 1800), widget.onComplete);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final variant = ref.watch(logoVariantProvider);

    final glowColor = variant == LogoVariant.iconic
        ? RRColors.accentCoral.withValues(alpha: 0.30)
        : RRColors.accentCyan.withValues(alpha: 0.22);

    return Scaffold(
      body: Container(
        color: RRColors.bgDeep,
        child: Center(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) => FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [glowColor, Colors.transparent],
                        ),
                      ),
                    ),
                    LogoMark(variant: variant),
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
