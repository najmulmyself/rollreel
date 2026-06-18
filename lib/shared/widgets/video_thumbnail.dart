import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import 'duration_badge.dart';

class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({
    super.key,
    required this.bytes,
    required this.durationSeconds,
    this.size = 48,
  });

  final Uint8List? bytes;
  final int durationSeconds;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(RRSpace.radiusMd),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (bytes != null)
              Image.memory(bytes!, fit: BoxFit.cover)
            else
              Container(
                color: RRColors.bgElevated,
                child: Center(
                  child: Icon(CupertinoIcons.play_fill, size: 18, color: RRColors.textDisabled),
                ),
              ),
            Positioned(
              bottom: 4,
              right: 4,
              child: DurationBadge(seconds: durationSeconds),
            ),
          ],
        ),
      ),
    );
  }
}
