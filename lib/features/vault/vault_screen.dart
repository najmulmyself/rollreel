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

  // "Enter Passcode" reuses the same platform prompt with biometricOnly
  // disabled — iOS/Android already fall back to the device passcode UI
  // when biometrics aren't used or fail, so no separate passcode screen
  // is needed.
  Future<void> _unlockWithPasscode() async {
    if (_authenticating) return;
    setState(() => _authenticating = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final ok = await _auth.authenticate(
        localizedReason: l10n.unlockVaultReason,
        options: const AuthenticationOptions(biometricOnly: false),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background artwork for the locked state only — its own
          // dark-to-black gradient blends into bgDeep, so the unlocked
          // video grid (a different visual context) stays clean.
          if (!_unlocked)
            Positioned.fill(
              child: Image.asset(
                'assets/images/vault_hero.webp',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                _buildNav(),
                Expanded(
                  child: _unlocked ? _buildUnlocked() : _buildLocked(),
                ),
              ],
            ),
          ),
        ],
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
                    color: RRColors.accentViolet, size: 16),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!.back,
                  style: TextStyle(
                      color: RRColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
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

  // Colors the first word violet and the rest coral; falls back to a solid
  // violet title when the string has no separate first word to split.
  List<TextSpan> _titleSpans(String title) {
    const baseStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w800);
    final firstSpace = title.indexOf(' ');
    if (firstSpace < 0) {
      return [
        TextSpan(
            text: title,
            style: baseStyle.copyWith(color: RRColors.accentViolet)),
      ];
    }
    return [
      TextSpan(
        text: title.substring(0, firstSpace),
        style: baseStyle.copyWith(color: RRColors.accentViolet),
      ),
      TextSpan(
        text: title.substring(firstSpace),
        style: baseStyle.copyWith(color: RRColors.accentCoral),
      ),
    ];
  }

  // ── Locked state ───────────────────────────────────────────────────────────

  Widget _buildLocked() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The lock/photos hero artwork lives in the background image
          // behind this screen — reserve space for it instead of drawing
          // a placeholder tile over it.
          const SizedBox(height: 260),
          const SizedBox(height: RRSpace.sp24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: _titleSpans(l10n.vaultLocked)),
          ),
          const SizedBox(height: RRSpace.sp12),
          Text(
            l10n.vaultLockedSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RRColors.textSecond,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: RRSpace.sp24),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: RRColors.bgElevated,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              CupertinoIcons.viewfinder,
              color: RRColors.accentViolet,
              size: 22,
            ),
          ),
          const SizedBox(height: RRSpace.sp20),
          PrimaryButton(
            label: l10n.unlockWithFaceId,
            icon: CupertinoIcons.viewfinder,
            onPressed: _authenticating ? null : _unlock,
          ),
          const SizedBox(height: RRSpace.sp20),
          Row(
            children: [
              Expanded(child: Divider(color: RRColors.divider)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: RRSpace.sp12),
                child: Text(
                  l10n.orDivider,
                  style: TextStyle(color: RRColors.textDisabled, fontSize: 12),
                ),
              ),
              Expanded(child: Divider(color: RRColors.divider)),
            ],
          ),
          const SizedBox(height: RRSpace.sp20),
          GestureDetector(
            onTap: _authenticating ? null : _unlockWithPasscode,
            child: Container(
              height: RRSpace.buttonHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                border: Border.all(color: RRColors.divider),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.square_grid_3x2,
                      color: RRColors.accentViolet, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    l10n.enterPasscode,
                    style: const TextStyle(
                      color: RRColors.accentViolet,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: RRSpace.sp24),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: RRSpace.sp12, vertical: RRSpace.sp16),
            decoration: BoxDecoration(
              color: RRColors.bgElevated,
              borderRadius: BorderRadius.circular(RRSpace.radiusLg),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _VaultBadge(
                    icon: CupertinoIcons.checkmark_shield_fill,
                    title: l10n.vaultBadgeSecureTitle,
                    subtitle: l10n.vaultBadgeSecureSub,
                  ),
                ),
                Expanded(
                  child: _VaultBadge(
                    icon: CupertinoIcons.lock_fill,
                    title: l10n.vaultBadgeEncryptedTitle,
                    subtitle: l10n.vaultBadgeEncryptedSub,
                  ),
                ),
                Expanded(
                  child: _VaultBadge(
                    icon: CupertinoIcons.eye_slash,
                    title: l10n.vaultBadgeHiddenTitle,
                    subtitle: l10n.vaultBadgeHiddenSub,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: RRSpace.sp24),
        ],
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

// ─── Vault feature badge ──────────────────────────────────────────────────────

class _VaultBadge extends StatelessWidget {
  const _VaultBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: RRColors.accentViolet.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: RRColors.accentViolet, size: 18),
        ),
        const SizedBox(height: RRSpace.sp8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: RRColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: RRColors.textSecond,
            fontSize: 11,
          ),
        ),
      ],
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
