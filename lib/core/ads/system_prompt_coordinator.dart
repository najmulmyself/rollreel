import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True while a native system prompt (ATT, App Store review) is being
/// requested. iOS can only present one system modal at a time — an
/// interstitial ad's show() call racing one of these prompts can be
/// silently dropped without firing a failure callback, showing up as
/// "matched" in AdMob but never actually displayed. Ad code checks this
/// before calling show() and holds off if a prompt is in flight.
final isSystemPromptActiveProvider = StateProvider<bool>((ref) => false);
