import 'package:flutter/widgets.dart';

/// Keeps previews available while the page moves and commits playback after
/// the drag and page snap finish.
class SettledVideoPager extends StatefulWidget {
  const SettledVideoPager({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.selectedIndex,
    required this.preloadDirection,
    required this.allowPreload,
    required this.onPageSettled,
    required this.itemBuilder,
  });

  final PageController controller;
  final int itemCount;
  final int selectedIndex;
  final int preloadDirection;
  final bool allowPreload;
  final ValueChanged<int> onPageSettled;
  final Widget Function(BuildContext, int index, bool preload) itemBuilder;

  @override
  State<SettledVideoPager> createState() => _SettledVideoPagerState();
}

class _SettledVideoPagerState extends State<SettledVideoPager> {
  bool _scrolling = false;

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth != 0 ||
        notification.metrics is! PageMetrics ||
        (notification is! ScrollStartNotification &&
            notification is! ScrollEndNotification)) {
      return false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.controller.hasClients) return;
      final scrolling = widget.controller.position.isScrollingNotifier.value;
      if (scrolling != _scrolling) setState(() => _scrolling = scrolling);
      if (scrolling) return;
      final page = widget.controller.page?.round();
      if (page != null &&
          page != widget.selectedIndex &&
          page >= 0 &&
          page < widget.itemCount) {
        widget.onPageSettled(page);
      }
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final preferred = widget.selectedIndex + widget.preloadDirection;
    final neighbor = preferred >= 0 && preferred < widget.itemCount
        ? preferred
        : widget.selectedIndex - widget.preloadDirection;

    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: PageView.builder(
        controller: widget.controller,
        scrollDirection: Axis.vertical,
        allowImplicitScrolling: true,
        itemCount: widget.itemCount,
        itemBuilder: (context, index) => widget.itemBuilder(
          context,
          index,
          widget.allowPreload && !_scrolling && index == neighbor,
        ),
      ),
    );
  }
}
