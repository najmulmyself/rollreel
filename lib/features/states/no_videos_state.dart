import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class NoVideosState extends StatelessWidget {
  const NoVideosState({super.key, required this.onOpenPhotos});

  final VoidCallback onOpenPhotos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RRColors.bgDeep,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.film,
                size: 64,
                color: RRColors.textDisabled,
              ),
              const SizedBox(height: RRSpace.sp24),
              const Text(
                'No Videos Yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RRSpace.sp12),
              const Text(
                'Your camera roll videos will appear here.',
                style: TextStyle(
                  color: RRColors.textSecond,
                  fontSize: 15,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RRSpace.sp32),
              GestureDetector(
                onTap: onOpenPhotos,
                child: Container(
                  height: RRSpace.buttonHeight,
                  width: 236,
                  decoration: BoxDecoration(
                    gradient: RRColors.gradBrand,
                    borderRadius:
                        BorderRadius.circular(RRSpace.radiusFull),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Open Photos App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
