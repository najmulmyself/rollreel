import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../core/theme/colors.dart';

class DynamicBackground extends StatefulWidget {
  const DynamicBackground({
    super.key,
    required this.thumbnailBytes,
    required this.active,
    required this.child,
  });

  final Uint8List? thumbnailBytes;
  final bool active;
  final Widget child;

  @override
  State<DynamicBackground> createState() => _DynamicBackgroundState();
}

class _DynamicBackgroundState extends State<DynamicBackground> {
  Color _bgColor = RRColors.bgDeep;
  Uint8List? _sampled;
  Timer? _sampleTimer;

  @override
  void initState() {
    super.initState();
    _queueSample();
  }

  @override
  void didUpdateWidget(DynamicBackground old) {
    super.didUpdateWidget(old);
    if (widget.thumbnailBytes != old.thumbnailBytes ||
        widget.active != old.active) {
      _queueSample();
    }
  }

  void _queueSample() {
    _sampleTimer?.cancel();
    final bytes = widget.thumbnailBytes;
    if (!widget.active || bytes == null || identical(bytes, _sampled)) return;
    _sampleTimer = Timer(
      const Duration(milliseconds: 140),
      () => _extract(bytes),
    );
  }

  Future<void> _extract(Uint8List bytes) async {
    try {
      final palette = await PaletteGenerator.fromImageProvider(
        ResizeImage(
          MemoryImage(bytes),
          width: 48,
          height: 48,
          policy: ResizeImagePolicy.fit,
        ),
        maximumColorCount: 6,
        timeout: const Duration(seconds: 2),
      );
      if (!mounted || !identical(widget.thumbnailBytes, bytes)) return;
      final dominant = palette.dominantColor?.color;
      if (dominant == null) return;
      final hsl = HSLColor.fromColor(dominant);
      final darkened = hsl
          .withLightness((hsl.lightness * .35).clamp(0.0, .25))
          .withSaturation((hsl.saturation * 1.2).clamp(0.0, 1.0))
          .toColor();
      setState(() {
        _sampled = bytes;
        _bgColor = darkened;
      });
    } catch (_) {
      // Keep the existing background if the thumbnail cannot be decoded.
    }
  }

  @override
  void dispose() {
    _sampleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_bgColor, RRColors.bgDeep],
          stops: const [0.0, .65],
        ),
      ),
      child: widget.child,
    );
  }
}
