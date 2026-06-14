import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/vault/vault_provider.dart';

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
    try {
      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) {
        _showError('Face ID is not available on this device.');
        return;
      }
      final ok = await _auth.authenticate(
        localizedReason: 'Unlock your Private Vault',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (ok && mounted) setState(() => _unlocked = true);
    } catch (_) {
      if (mounted) _showError('Authentication failed. Please try again.');
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF120F35),
              Color(0xFF4E3AAA),
              Color(0xFF7C55E0),
            ],
            stops: [0.0, 0.45, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildNav(),
              Expanded(
                child: _unlocked ? _buildUnlocked() : _buildLocked(),
              ),
            ],
          ),
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.chevron_left,
                    color: Colors.white54, size: 16),
                SizedBox(width: 4),
                Text(
                  'Back',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (_unlocked)
            Padding(
              padding: const EdgeInsets.only(right: RRSpace.sp8),
              child: const Text(
                'Private Vault',
                style: TextStyle(
                  color: Colors.white,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.lock_fill,
              size: 80,
              color: Colors.white38,
            ),
            const SizedBox(height: RRSpace.sp24),
            const Text(
              'Vault Locked',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: RRSpace.sp8),
            const Text(
              'Your private videos are safe here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: RRSpace.sp32),
            GestureDetector(
              onTap: _authenticating ? null : _unlock,
              child: Container(
                height: RRSpace.buttonHeight,
                decoration: BoxDecoration(
                  gradient: RRColors.gradBrand,
                  borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                ),
                child: _authenticating
                    ? const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.face_retouching_natural,
                              color: Colors.white, size: 22),
                          SizedBox(width: RRSpace.sp8),
                          Text(
                            'Unlock with Face ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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

  // ── Unlocked state ─────────────────────────────────────────────────────────

  Widget _buildUnlocked() {
    final assetsAsync = ref.watch(vaultAssetsProvider);

    return assetsAsync.when(
      loading: () => const Center(
        child: CupertinoActivityIndicator(color: Colors.white),
      ),
      error: (_, __) => const Center(
        child: Text('Failed to load vault',
            style: TextStyle(color: Colors.white60)),
      ),
      data: (assets) {
        if (assets.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.lock_open_fill,
                    size: 64, color: Colors.white54),
                const SizedBox(height: RRSpace.sp16),
                const Text(
                  'Vault is empty',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: RRSpace.sp8),
                const Text(
                  'Tap ••• on any video to add it here',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(RRSpace.sp4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
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
    showCupertinoDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Remove from Vault?'),
        content: const Text('This video will return to your main library.'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              ref.read(vaultIdsProvider.notifier).toggle(widget.asset.id);
            },
            child: const Text('Remove'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _confirmRemove(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _thumb != null
              ? Image.memory(_thumb!, fit: BoxFit.cover)
              : const ColoredBox(color: Color(0xFF1A1535)),
          // Duration badge
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _fmtDuration(widget.asset.duration),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
