import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/favorites/favorites_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../l10n/app_localizations.dart';
import '../states/empty_state.dart';
import '../states/loading_state.dart';

// Placeholder screen — no reference screenshot provided yet, so this keeps
// the existing favorite/like functionality reachable via the new nav bar
// with minimal styling. Will be rebuilt to spec once a mockup is provided.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key, this.onPlayAt, this.onOpenLibrary});

  final void Function(String assetId)? onPlayAt;
  final VoidCallback? onOpenLibrary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final assetsAsync = ref.watch(favoriteAssetsProvider);

    return Scaffold(
      backgroundColor: RRColors.bgDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  RRSpace.sp16, RRSpace.sp12, RRSpace.sp16, RRSpace.sp8),
              child: Text(
                l10n.favorites,
                style: TextStyle(
                  color: RRColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: assetsAsync.when(
                loading: () => const LoadingState(),
                error: (e, _) => Center(
                  child: Text(l10n.couldNotLoadVideos('$e'),
                      style: TextStyle(color: RRColors.textSecond)),
                ),
                data: (assets) {
                  if (assets.isEmpty) {
                    return EmptyState(
                      icon: CupertinoIcons.heart,
                      title: l10n.favoritesEmptyTitle,
                      body: l10n.favoritesEmptyBody,
                      buttonLabel: l10n.library,
                      onPressed: () => onOpenLibrary?.call(),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(RRSpace.sp4),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: RRSpace.sp4,
                      mainAxisSpacing: RRSpace.sp4,
                      childAspectRatio: 9 / 16,
                    ),
                    itemCount: assets.length,
                    itemBuilder: (context, index) => _FavoriteThumb(
                      asset: assets[index],
                      onTap: () => onPlayAt?.call(assets[index].id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteThumb extends StatefulWidget {
  const _FavoriteThumb({required this.asset, this.onTap});
  final AssetEntity asset;
  final VoidCallback? onTap;

  @override
  State<_FavoriteThumb> createState() => _FavoriteThumbState();
}

class _FavoriteThumbState extends State<_FavoriteThumb> {
  Uint8List? _thumb;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await widget.asset
        .thumbnailDataWithSize(const ThumbnailSize(200, 360));
    if (mounted) setState(() => _thumb = bytes);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RRSpace.radiusSm),
        child: _thumb != null
            ? Image.memory(_thumb!, fit: BoxFit.cover)
            : ColoredBox(color: RRColors.bgElevated),
      ),
    );
  }
}
