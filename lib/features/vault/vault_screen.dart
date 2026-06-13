import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
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

  // ── Top nav ──────────────────────────────────────────────────────────────────

  Widget _buildNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: RRSpace.sp8, vertical: RRSpace.sp4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: CupertinoButton(
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
      ),
    );
  }

  // ── Locked state ─────────────────────────────────────────────────────────────

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

  // ── Unlocked state (empty vault placeholder) ──────────────────────────────────

  Widget _buildUnlocked() {
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
            'Add private videos from your library',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
