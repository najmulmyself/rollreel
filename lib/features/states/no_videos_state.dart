import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class NoVideosState extends StatelessWidget {
  const NoVideosState({
    super.key,
    required this.onOpenSettings,
    required this.onContinue,
  });

  final VoidCallback onOpenSettings;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RRColors.bgDeep,
      body: SafeArea(
        child: Stack(
          children: [
            // Main centered content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Muted photo icon
                    const Icon(
                      Icons.image_outlined,
                      size: 76,
                      color: RRColors.textDisabled,
                    ),
                    const SizedBox(height: RRSpace.sp24),

                    // Title
                    const Text(
                      'No Videos Found',
                      style: TextStyle(
                        fontFamily: '.SF Pro Display',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: RRSpace.sp12),

                    // Body
                    const Text(
                      'RollReel needs access to your photo library. Your videos are never uploaded or shared.',
                      style: TextStyle(
                        fontSize: 16,
                        color: RRColors.textSecond,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: RRSpace.sp32),

                    // Open Settings — solid coral
                    SizedBox(
                      height: RRSpace.buttonHeight,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onOpenSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RRColors.accentCoral,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(RRSpace.radiusFull),
                          ),
                        ),
                        child: const Text(
                          'Open Settings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: RRSpace.sp16),

                    // Continue Anyway
                    TextButton(
                      onPressed: onContinue,
                      style: TextButton.styleFrom(
                        foregroundColor: RRColors.textSecond,
                      ),
                      child: const Text(
                        'Continue Anyway',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom breadcrumb hint
            const Positioned(
              bottom: RRSpace.sp20,
              left: 0,
              right: 0,
              child: Text(
                'Settings → Privacy → Photos → RollReel',
                style: TextStyle(
                  color: RRColors.textDisabled,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
