import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/favorites/favorites_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../l10n/app_localizations.dart';
import '../states/loading_state.dart';

// Theme-aware — follows the app's light/dark setting like Home/Library/
// Settings (both variants confirmed against reference screenshots).
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key, this.onPlayAt, this.onOpenLibrary});

  final void Function(String assetId)? onPlayAt;
  final VoidCallback? onOpenLibrary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final assetsAsync = ref.watch(favoriteAssetsProvider);

    return Scaffold(
      backgroundColor: RRColors.bgTint,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  RRSpace.sp16, RRSpace.sp16, RRSpace.sp16, RRSpace.sp8),
              child: Text(
                l10n.favorites,
                style: TextStyle(
                  color: RRColors.textPrimary,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
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
                    return _EmptyFavorites(onOpenLibrary: onOpenLibrary);
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

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites({this.onOpenLibrary});

  final VoidCallback? onOpenLibrary;

  List<TextSpan> _titleSpans(String title) {
    final baseStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w800);
    final words = title.split(' ');
    if (words.length < 2) {
      return [
        TextSpan(
            text: title,
            style: baseStyle.copyWith(color: RRColors.textPrimary)),
      ];
    }
    // Colors every word violet except the first and last.
    return [
      for (var i = 0; i < words.length; i++) ...[
        TextSpan(
          text: words[i],
          style: baseStyle.copyWith(
            color: (i == 0 || i == words.length - 1)
                ? RRColors.textPrimary
                : RRColors.accentViolet,
          ),
        ),
        if (i < words.length - 1) const TextSpan(text: ' '),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _EmptyFavoritesHero(),
            const SizedBox(height: RRSpace.sp24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: _titleSpans(l10n.favoritesEmptyTitle)),
            ),
            const SizedBox(height: RRSpace.sp12),
            Text(
              l10n.favoritesEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: RRColors.textSecond, fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: RRSpace.sp32),
            GestureDetector(
              onTap: onOpenLibrary,
              child: Container(
                height: RRSpace.buttonHeight,
                padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [RRColors.accentViolet, Color(0xFF6366F1)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                  boxShadow: [
                    BoxShadow(
                      color: RRColors.accentViolet.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.folder_fill,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      l10n.goToLibrary,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavoritesHero extends StatelessWidget {
  const _EmptyFavoritesHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  RRColors.accentViolet.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const Positioned(
            top: 12,
            left: 30,
            child: Icon(CupertinoIcons.sparkles,
                color: RRColors.accentViolet, size: 14),
          ),
          const Positioned(
            bottom: 40,
            left: 10,
            child: Icon(CupertinoIcons.sparkles,
                color: RRColors.accentViolet, size: 12),
          ),
          const Positioned(
            top: 60,
            right: 10,
            child: Icon(CupertinoIcons.sparkles,
                color: RRColors.accentViolet, size: 13),
          ),
          // Stacked cards behind the heart
          Positioned(
            top: 30,
            child: Container(
              width: 130,
              height: 110,
              decoration: BoxDecoration(
                color: RRColors.accentViolet.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: RRColors.accentViolet.withValues(alpha: 0.15)),
              ),
            ),
          ),
          Positioned(
            top: 50,
            child: Container(
              width: 150,
              height: 120,
              decoration: BoxDecoration(
                color: RRColors.accentViolet.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: RRColors.accentViolet.withValues(alpha: 0.15)),
              ),
            ),
          ),
          // Outline heart accent, above the solid heart
          const Positioned(
            top: 20,
            child: Icon(CupertinoIcons.heart,
                color: RRColors.accentViolet, size: 26),
          ),
          // Solid gradient heart
          Positioned(
            bottom: 30,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: RRColors.accentViolet.withValues(alpha: 0.5),
                    blurRadius: 30,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  colors: [Color(0xFFB794F6), RRColors.accentViolet],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(rect),
                child: const Icon(CupertinoIcons.heart_fill,
                    color: Colors.white, size: 88),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Favorite thumbnail ─────────────────────────────────────────────────────

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
