import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/vault/vault_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/duration_badge.dart';
import '../../shared/widgets/primary_button.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  final _auth = LocalAuthentication();
  bool _unlocked = false;
  bool _authenticating = false;

  Future<void> _unlock() async {
    if (_authenticating) return;
    setState(() => _authenticating = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) {
        _showError(l10n.faceIdUnavailable);
        return;
      }
      final ok = await _auth.authenticate(
        localizedReason: l10n.unlockVaultReason,
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (ok && mounted) setState(() => _unlocked = true);
    } catch (_) {
      if (mounted) _showError(l10n.authFailed);
    } finally {
      if (mounted) setState(() => _authenticating = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: RRColors.bgElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RRSpace.radiusMd),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RRColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            _buildNav(),
            Expanded(
              child: _unlocked ? _buildUnlocked() : _buildLocked(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top nav ────────────────────────────────────────────────────────────────

  Widget _buildNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: RRSpace.sp8, vertical: RRSpace.sp4),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(
                horizontal: RRSpace.sp8, vertical: RRSpace.sp8),
            onPressed: widget.onBack,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.chevron_left,
                    color: RRColors.accentCyan, size: 16),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!.back,
                  style: const TextStyle(
                      color: RRColors.accentCyan, fontSize: 16),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (_unlocked)
            Padding(
              padding: const EdgeInsets.only(right: RRSpace.sp8),
              child: Text(
                AppLocalizations.of(context)!.vaultTitle,
                style: TextStyle(
                  color: RRColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Locked state ───────────────────────────────────────────────────────────

  Widget _buildLocked() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.lock_fill,
              size: 80,
              color: RRColors.textDisabled,
            ),
            const SizedBox(height: RRSpace.sp24),
            Text(
              l10n.vaultLocked,
              style: TextStyle(
                color: RRColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: RRSpace.sp8),
            Text(
              l10n.vaultLockedSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RRColors.textSecond,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: RRSpace.sp32),
            PrimaryButton(
              label: l10n.unlockWithFaceId,
              icon: Icons.face_retouching_natural,
              onPressed: _authenticating ? null : _unlock,
            ),
          ],
        ),
      ),
    );
  }

  // ── Unlocked state ─────────────────────────────────────────────────────────

  Widget _buildUnlocked() {
    final assetsAsync = ref.watch(vaultAssetsProvider);
    final l10n = AppLocalizations.of(context)!;

    return assetsAsync.when(
      loading: () => Center(
        child: CupertinoActivityIndicator(color: RRColors.accentCyan),
      ),
      error: (_, __) => Center(
        child: Padding(
          padding: const EdgeInsets.all(RRSpace.sp24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.exclamationmark_triangle,
                  size: 60, color: RRColors.textDisabled),
              const SizedBox(height: RRSpace.sp16),
              Text(l10n.vaultLoadFailed,
                  style: RRTypography.title1, textAlign: TextAlign.center),
              const SizedBox(height: RRSpace.sp20),
              PrimaryButton(
                label: l10n.retry,
                onPressed: () => ref.invalidate(vaultAssetsProvider),
              ),
            ],
          ),
        ),
      ),
      data: (assets) {
        if (assets.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.lock_open_fill,
                    size: 64, color: RRColors.textDisabled),
                const SizedBox(height: RRSpace.sp16),
                Text(
                  l10n.vaultEmpty,
                  style: TextStyle(
                    color: RRColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: RRSpace.sp8),
                Text(
                  l10n.vaultEmptyHint,
                  style: TextStyle(color: RRColors.textSecond, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(RRSpace.sp4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: RRSpace.sp4,
            mainAxisSpacing: RRSpace.sp4,
            childAspectRatio: 9 / 16,
          ),
          itemCount: assets.length,
          itemBuilder: (context, index) =>
              _VaultThumb(asset: assets[index]),
        );
      },
    );
  }
}

// ─── Vault thumbnail ──────────────────────────────────────────────────────────

class _VaultThumb extends ConsumerStatefulWidget {
  const _VaultThumb({required this.asset});
  final AssetEntity asset;

  @override
  ConsumerState<_VaultThumb> createState() => _VaultThumbState();
}

class _VaultThumbState extends ConsumerState<_VaultThumb> {
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

  void _confirmRemove(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showCupertinoDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(l10n.removeFromVaultTitle),
        content: Text(l10n.removeFromVaultBody),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              ref.read(vaultIdsProvider.notifier).toggle(widget.asset.id);
            },
            child: Text(l10n.remove),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _confirmRemove(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RRSpace.radiusSm),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _thumb != null
                ? Image.memory(_thumb!, fit: BoxFit.cover)
                : ColoredBox(color: RRColors.bgElevated),
            Positioned(
              right: 4,
              bottom: 4,
              child: DurationBadge(seconds: widget.asset.duration),
            ),
          ],
        ),
      ),
    );
  }
}
