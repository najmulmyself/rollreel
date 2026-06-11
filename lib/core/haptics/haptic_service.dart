import 'package:flutter/services.dart';

class HapticService {
  const HapticService();

  Future<void> light() => HapticFeedback.lightImpact();
  Future<void> medium() => HapticFeedback.mediumImpact();
  Future<void> heavy() => HapticFeedback.heavyImpact();
  Future<void> selection() => HapticFeedback.selectionClick();
}
