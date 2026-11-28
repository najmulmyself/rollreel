import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

/// Counts a play once per visit to a clip, even across pause, loops, or an
/// expansion to landscape. Preloading and paused scrubbing do not count.
class WatchPlaybackSession {
  WatchPlaybackSession(this._onPlay);

  final VoidCallback _onPlay;
  bool _recorded = false;

  void reset() => _recorded = false;

  VoidCallback observe(
    VideoPlayerController controller, {
    required bool Function() isActive,
  }) {
    var lastPosition = controller.value.position;
    void onPlaybackChanged() {
      final value = controller.value;
      final advance = value.position - lastPosition;
      lastPosition = value.position;
      if (_recorded ||
          !value.isPlaying ||
          value.isBuffering ||
          value.hasError ||
          advance <= Duration.zero ||
          advance > const Duration(seconds: 1) ||
          WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed ||
          !isActive()) {
        return;
      }
      _recorded = true;
      _onPlay();
    }

    controller.addListener(onPlaybackChanged);
    return () => controller.removeListener(onPlaybackChanged);
  }
}
