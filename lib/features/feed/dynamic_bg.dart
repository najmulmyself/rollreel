import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../core/theme/colors.dart';

class DynamicBackground extends StatefulWidget {
  const DynamicBackground({
    super.key,
    required this.thumbnailBytes,
    required this.child,
  });

  final Uint8List? thumbnailBytes;
  final Widget child;

  @override
  State<DynamicBackground> createState() => _DynamicBackgroundState();
}

class _DynamicBackgroundState extends State<DynamicBackground> {
  Color _bgColor = RRColors.bgDeep;

  @override
  void initState() {
    super.initState();
    _extract(widget.thumbnailBytes);
  }

  @override
  void didUpdateWidget(DynamicBackground old) {
    super.didUpdateWidget(old);
    if (widget.thumbnailBytes != old.thumbnailBytes) {
      _extract(widget.thumbnailBytes);
    }
  }

  Future<void> _extract(Uint8List? bytes) async {
    if (bytes == null) return;
    try {
      final palette = await PaletteGenerator.fromImageProvider(
        MemoryImage(bytes),
        size: const Size(80, 80),
      );
      final dominant = palette.dominantColor?.color;
      if (dominant != null && mounted) {
        final hsl = HSLColor.fromColor(dominant);
        final darkened = hsl
            .withLightness((hsl.lightness * 0.35).clamp(0.0, 0.25))
            .withSaturation((hsl.saturation * 1.2).clamp(0.0, 1.0))
            .toColor();
        if (mounted) setState(() => _bgColor = darkened);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_bgColor, RRColors.bgDeep],
          stops: const [0.0, 0.65],
        ),
      ),
      child: widget.child,
    );
  }
}
