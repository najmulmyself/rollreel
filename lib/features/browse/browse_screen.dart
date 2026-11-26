import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:photo_manager/photo_manager.dart';

import '../../core/ads/banner_ad_widget.dart';
import '../../core/memories/on_this_day_provider.dart';
import '../../core/permissions/permission_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/vault/vault_provider.dart';
import '../../core/video/capture_video.dart';
import '../../core/video/video_library_provider.dart';
import '../../l10n/app_localizations.dart';
import '../feed/video_feed_item.dart' show VideoInfoSheet;
import 'filter_sheet.dart';
import 'library_widgets.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({
    super.key,
    this.onPlayAt,
    this.initialScrollOffset = 0.0,
    this.onScrollChanged,
    this.onOpenMemories,
  });

  final ValueChanged<String>? onPlayAt;
  final double initialScrollOffset;
  final ValueChanged<double>? onScrollChanged;
  final VoidCallback? onOpenMemories;

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

enum _VideoAction { info, vault, delete }

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  late final ScrollController _scrollController;
  final _search = TextEditingController();
  String _query = '';
  bool _recording = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: widget.initialScrollOffset,
    );
    _search.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _search.text.trim().toLowerCase();
    if (_query == query) return;
    setState(() => _query = query);
    _scrollToStart();
  }

  void _scrollToStart() {
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  void _setFilter(BrowseFilter filter) {
    ref.read(browseFilterProvider.notifier).state = filter;
    _scrollToStart();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    FocusScope.of(context).unfocus();
    final filter = await showLibrarySheet<BrowseFilter>(
      context,
      (_) => FilterSheet(initialFilter: ref.read(browseFilterProvider)),
    );
    if (mounted && filter != null) _setFilter(filter);
  }

  Future<void> _showOptions(AssetEntity asset, String title) async {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;
    final inVault = ref.read(vaultIdsProvider).contains(asset.id);
    final action = await showLibrarySheet<_VideoAction>(
      context,
      (sheetContext) => SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  children: [
                    Expanded(child: Text(title, style: libraryHeading)),
                    TextButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      style: TextButton.styleFrom(
                        foregroundColor: libraryAccent,
                      ),
                      child: Text(l10n.libraryClose),
                    ),
                  ],
                ),
              ),
              for (final (action, label) in [
                (_VideoAction.info, l10n.getInfo),
                (
                  _VideoAction.vault,
                  inVault ? l10n.removeFromVault : l10n.addToVault,
                ),
                (_VideoAction.delete, l10n.deleteVideo),
              ])
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: libraryLine)),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      alignment: AlignmentDirectional.centerStart,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 49),
                      foregroundColor: action == _VideoAction.delete
                          ? libraryDanger
                          : libraryInk,
                    ),
                    onPressed: () => Navigator.pop(sheetContext, action),
                    child: Text(label),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (!mounted || action == null) return;
    switch (action) {
      case _VideoAction.info:
        await showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => VideoInfoSheet(asset: asset),
        );
      case _VideoAction.vault:
        await ref.read(vaultIdsProvider.notifier).toggle(asset.id);
      case _VideoAction.delete:
        await _confirmDelete(asset, title);
    }
  }

  Future<void> _confirmDelete(AssetEntity asset, String title) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (dialogContext) => CupertinoActionSheet(
        title: Text(title),
        message: Text(l10n.deleteVideoWarning),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.deleteVideo),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.cancel),
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final deleted = await PhotoManager.editor.deleteWithIds([asset.id]);
      if (!mounted || !deleted.contains(asset.id)) return;
      ref.invalidate(videoLibraryProvider);
      messenger.showSnackBar(SnackBar(content: Text(l10n.videoDeleted)));
    } on Exception catch (error) {
      debugPrint('Could not delete video: $error');
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.libraryDeleteFailed)),
        );
      }
    }
  }

  Future<void> _openCamera() async {
    if (_recording) return;
    setState(() => _recording = true);
    try {
      final clip = await recordVideo();
      if (clip == null) return;
      await saveRecordedVideo(clip);
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      ref.invalidate(videoLibraryProvider);
    } on Exception catch (error) {
      debugPrint('Could not record or save video: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.homeCaptureFailed),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _recording = false);
    }
  }

  Future<void> _requestPhotosAccess() async {
    try {
      final permission = await ref.read(permissionProvider.notifier).request();
      if (mounted && permission.hasAccess) ref.invalidate(videoLibraryProvider);
    } on Exception {
      // The permission provider exposes the retry state.
    }
  }

  void _retry() {
    ref.invalidate(permissionProvider);
    ref.invalidate(videoLibraryProvider);
  }

  bool _hasFilters(BrowseFilter filter) =>
      filter.period != VideoTimePeriod.all ||
      filter.duration != VideoDurationFilter.any ||
      filter.sort != VideoSortOrder.newest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final permission = ref.watch(permissionProvider);
    final hasAccess = permission.valueOrNull?.hasAccess ?? false;
    final visible = hasAccess ? ref.watch(visibleVideosProvider) : null;
    final currentCount = visible?.valueOrNull?.length;
    final filter = ref.watch(browseFilterProvider);
    final hasFilters = _hasFilters(filter);
    final dark = RRColors.isDark.value;
    // Use the full window height so showing the keyboard cannot swap the
    // sliver that owns the focused search field.
    final canPin =
        MediaQuery.sizeOf(context).height >= 520 &&
        MediaQuery.textScalerOf(context).scale(16) < 24;
    return AnnotatedRegion(
      value: (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: libraryHeader,
        bottomNavigationBar: ColoredBox(
          color: librarySurface,
          child: SafeArea(
            top: false,
            child: canRecordVideo
                ? const Center(heightFactor: 1, child: BannerAdWidget())
                : const SizedBox.shrink(),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: ColoredBox(
            color: librarySurface,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final controls = _LibraryControls(
                      search: _search,
                      hasFilters: hasFilters,
                      onOpenFilters: _openFilters,
                      filter: filter,
                      onFilter: _setFilter,
                    );
                    return CustomScrollView(
                      key: const PageStorageKey('library'),
                      controller: _scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        SliverToBoxAdapter(
                          child: ColoredBox(
                            color: libraryHeader,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                13,
                                20,
                                16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Semantics(
                                      header: true,
                                      child: Text(
                                        l10n.library,
                                        style: RRTypography.title1.copyWith(
                                          fontSize: constraints.maxWidth < 350
                                              ? 34
                                              : 38,
                                          letterSpacing: -1.5,
                                          color: libraryInk,
                                          height: 1.05,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (currentCount != null) ...[
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 2,
                                        ),
                                        child: Text(
                                          l10n.libraryDeviceCount(currentCount),
                                          textAlign: TextAlign.end,
                                          style: libraryNote.copyWith(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (canPin)
                          PinnedHeaderSliver(child: controls)
                        else
                          SliverToBoxAdapter(child: controls),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 12),
                          sliver: _libraryContent(
                            context,
                            permission: permission,
                            visible: visible,
                            filter: filter,
                            hasFilters: hasFilters,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _libraryContent(
    BuildContext context, {
    required AsyncValue<PermissionState> permission,
    required AsyncValue<List<AssetEntity>>? visible,
    required BrowseFilter filter,
    required bool hasFilters,
  }) {
    final l10n = AppLocalizations.of(context)!;

    Widget stateMessage({
      required String title,
      required String body,
      required String action,
      required VoidCallback? onPressed,
      IconData? icon,
    }) => SliverToBoxAdapter(
      child: LibraryMessage(
        title: title,
        description: body,
        action: action,
        onPressed: onPressed,
        icon: icon,
      ),
    );

    Widget error() => stateMessage(
      title: l10n.homeLoadFailed,
      body: l10n.homeLoadFailedBody,
      action: l10n.retry,
      onPressed: _retry,
      icon: CupertinoIcons.exclamationmark_circle,
    );

    if (permission.hasError || visible?.hasError == true) return error();
    if (permission.isLoading || visible?.isLoading == true) {
      return const _LibraryLoading();
    }
    if (permission.valueOrNull?.hasAccess != true) {
      final canRequest =
          permission.valueOrNull == PermissionState.notDetermined;
      return stateMessage(
        title: canRequest ? l10n.homeAccessTitle : l10n.libraryAccessOff,
        body: canRequest ? l10n.onboardingPermissionBody : l10n.homeAccessBody,
        action: canRequest ? l10n.allowAccess : l10n.openSettings,
        onPressed: canRequest ? _requestPhotosAccess : PhotoManager.openSetting,
        icon: CupertinoIcons.photo_on_rectangle,
      );
    }
    if (visible!.requireValue.isEmpty) {
      return stateMessage(
        title: l10n.libraryEmptyTitle,
        body: l10n.homeEmptyBody,
        action: canRecordVideo ? l10n.homeOpenCamera : l10n.retry,
        onPressed: canRecordVideo ? (_recording ? null : _openCamera) : _retry,
      );
    }
    final filtered = ref.watch(browseVideosProvider);
    if (filtered.hasError) return error();
    if (filtered.isLoading) return const _LibraryLoading();

    var videos = filtered.requireValue;
    if (_query.isNotEmpty) {
      var titles = const <String, String>{};
      if (videos.any((video) => video.title?.trim().isNotEmpty != true)) {
        final lookedUp = ref.watch(browseVideoTitlesProvider);
        if (lookedUp.isLoading) return const _LibraryLoading();
        if (lookedUp.hasError) return error();
        titles = lookedUp.requireValue;
      }
      videos = videos.where((video) {
        final title = titles[video.id] ?? video.title ?? '';
        return title.toLowerCase().contains(_query);
      }).toList();
    }
    if (videos.isEmpty) {
      final searching = _query.isNotEmpty;
      return stateMessage(
        title: searching ? l10n.libraryNoMatches : l10n.libraryNoFilterMatches,
        body: searching ? l10n.librarySearchHelp : l10n.libraryFilterHelp,
        action: searching ? l10n.clearSearch : l10n.clearFilters,
        onPressed: searching
            ? _search.clear
            : () => _setFilter(const BrowseFilter()),
        icon: searching
            ? CupertinoIcons.search
            : CupertinoIcons.slider_horizontal_3,
      );
    }

    final entries = _entries(context, videos, filter.sort);
    return SliverMainAxisGroup(
      slivers: [
        if (_query.isEmpty && !hasFilters)
          SliverToBoxAdapter(
            child: _LibraryMemories(onTap: widget.onOpenMemories),
          )
        else
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                [
                  l10n.videosCount(videos.length),
                  if (filter.period != VideoTimePeriod.all)
                    libraryPeriodLabel(l10n, filter.period),
                  if (filter.duration != VideoDurationFilter.any)
                    libraryDurationLabel(l10n, filter.duration),
                  if (filter.sort != VideoSortOrder.newest)
                    librarySortLabel(l10n, filter.sort),
                ].join(' · '),
                style: libraryNote,
              ),
            ),
          ),
        SliverList.builder(
          itemCount: entries.length,
          itemBuilder: (context, i) {
            final entry = entries[i];
            if (entry is String) {
              return Padding(
                padding: EdgeInsets.only(top: i == 0 ? 2 : 15, bottom: 8),
                child: Semantics(
                  header: true,
                  child: Text(
                    entry,
                    style: libraryHeading.copyWith(fontSize: 19),
                  ),
                ),
              );
            }
            final video = entry as AssetEntity;
            final chronological =
                filter.sort == VideoSortOrder.newest ||
                filter.sort == VideoSortOrder.oldest;
            final locale = Localizations.localeOf(context).toString();
            final date = video.createDateSecond == null
                ? l10n.libraryUnknownDate
                : (chronological
                          ? DateFormat.jm(locale)
                          : DateFormat.yMMMd(locale))
                      .format(video.createDateTime);
            return LibraryVideoRow(
              key: ValueKey(video.id),
              asset: video,
              dateLabel: date,
              showDivider:
                  i + 1 < entries.length && entries[i + 1] is AssetEntity,
              onOptions: (title) => _showOptions(video, title),
              onPlay: widget.onPlayAt == null
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();
                      widget.onScrollChanged?.call(_scrollController.offset);
                      widget.onPlayAt?.call(video.id);
                    },
            );
          },
        ),
      ],
    );
  }

  List<Object> _entries(
    BuildContext context,
    List<AssetEntity> videos,
    VideoSortOrder sort,
  ) {
    if (sort == VideoSortOrder.shortest || sort == VideoSortOrder.longest) {
      return videos;
    }
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final l10n = AppLocalizations.of(context)!;
    final format = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    String? previous;
    final entries = <Object>[];
    for (final asset in videos) {
      final label = _dateGroup(asset, now, yesterday, format, l10n);
      if (label != previous) {
        entries.add(label);
        previous = label;
      }
      entries.add(asset);
    }
    return entries;
  }

  String _dateGroup(
    AssetEntity asset,
    DateTime now,
    DateTime yesterday,
    DateFormat format,
    AppLocalizations l10n,
  ) {
    if (asset.createDateSecond == null) return l10n.libraryUnknownDate;
    final date = asset.createDateTime;
    if (DateUtils.isSameDay(date, now)) return l10n.today;
    if (DateUtils.isSameDay(date, yesterday)) return l10n.yesterday;
    return format.format(date);
  }
}

class _LibraryControls extends StatelessWidget {
  const _LibraryControls({
    required this.search,
    required this.hasFilters,
    required this.onOpenFilters,
    required this.filter,
    required this.onFilter,
  });

  final TextEditingController search;
  final bool hasFilters;
  final VoidCallback onOpenFilters;
  final BrowseFilter filter;
  final ValueChanged<BrowseFilter> onFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quick = [
      (l10n.filterAll, const BrowseFilter()),
      (l10n.filterToday, const BrowseFilter(period: VideoTimePeriod.today)),
      (
        l10n.filterShorts,
        const BrowseFilter(duration: VideoDurationFilter.short),
      ),
      (l10n.filterLong, const BrowseFilter(duration: VideoDurationFilter.long)),
      (l10n.filterRecent, const BrowseFilter(period: VideoTimePeriod.thisWeek)),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: libraryHeader,
        border: Border(bottom: BorderSide(color: libraryLine)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LayoutBuilder(
              builder: (context, constraints) => Row(
                children: [
                  Expanded(
                    child: CupertinoSearchTextField(
                      controller: search,
                      placeholder: l10n.searchVideos,
                      placeholderStyle: libraryBody.copyWith(
                        color: libraryMuted,
                        fontSize: 15,
                      ),
                      style: libraryBody.copyWith(fontSize: 15),
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        8,
                        12,
                        8,
                        12,
                      ),
                      prefixInsets: const EdgeInsetsDirectional.only(start: 10),
                      itemSize: 17,
                      itemColor: libraryMuted,
                      decoration: BoxDecoration(
                        color: librarySurface,
                        border: Border.all(color: libraryLine),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth * .46,
                    ),
                    child: OutlinedButton.icon(
                      icon: const Icon(
                        CupertinoIcons.slider_horizontal_3,
                        size: 17,
                      ),
                      label: Text(l10n.libraryFilters),
                      onPressed: onOpenFilters,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(89, 46),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 8,
                        ),
                        foregroundColor: hasFilters
                            ? libraryOnAccent
                            : libraryAccent,
                        backgroundColor: hasFilters
                            ? libraryAccent
                            : libraryTint,
                        side: BorderSide(
                          color: hasFilters ? libraryAccent : libraryLine,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: RRTypography.subheadline.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 11),
            child: Row(
              spacing: 7,
              children: [
                for (final (label, choice) in quick)
                  LibraryChip(
                    label: label,
                    selected:
                        filter.period == choice.period &&
                        filter.duration == choice.duration,
                    onPressed: () => onFilter(choice),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryMemories extends ConsumerWidget {
  const _LibraryMemories({required this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memories = ref.watch(onThisDayProvider).valueOrNull;
    if (memories == null || memories.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    final count = memories.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Material(
        color: libraryTint,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                LibraryThumbnail(asset: memories.first, width: 57, height: 46),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.onThisDay,
                        style: RRTypography.headline.copyWith(
                          fontSize: 15,
                          color: libraryInk,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.libraryMemoriesCount(count),
                        style: libraryNote,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? CupertinoIcons.chevron_left
                      : CupertinoIcons.chevron_right,
                  size: 14,
                  color: libraryAccent,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LibraryLoading extends StatelessWidget {
  const _LibraryLoading();

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: Semantics(
      label: AppLocalizations.of(context)!.loadingLibrary,
      child: ExcludeSemantics(
        child: Column(
          children: [
            for (var i = 0; i < 5; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      height: 59,
                      width: 94,
                      decoration: BoxDecoration(
                        color: libraryTint,
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Flexible(
                      child: Container(
                        height: 12,
                        width: 142,
                        decoration: BoxDecoration(
                          color: libraryTint,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
