import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../shared/widgets/logo_variant_picker.dart';
import '../../shared/widgets/pro_badge.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key, required this.onBack, required this.onOpenPaywall});

  final VoidCallback onBack;
  final VoidCallback onOpenPaywall;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(CupertinoIcons.back),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(RRSpace.sp20),
        children: [
          _sectionLabel('APPEARANCE'),
          const SizedBox(height: RRSpace.sp4),
          const LogoVariantPicker(),
          const SizedBox(height: RRSpace.sp20),
          _sectionLabel('PLAYBACK'),
          const _ToggleRow(label: 'Loop Short Videos', initialValue: true),
          const _ToggleRow(label: 'Auto-play on Launch', initialValue: true),
          const _ValueRow(label: 'Default Filter', value: 'All'),
          const _ValueRow(label: 'Playback Speed', value: '1x'),
          const SizedBox(height: RRSpace.sp20),
          _sectionLabel('ROLLREEL PRO'),
          InkWell(
            onTap: onOpenPaywall,
            borderRadius: BorderRadius.circular(RRSpace.radiusLg),
            child: Container(
              padding: const EdgeInsets.all(RRSpace.sp16),
              decoration: BoxDecoration(
                gradient: RRColors.gradPro,
                borderRadius: BorderRadius.circular(RRSpace.radiusLg),
              ),
              child: const Row(
                children: [
                  ProBadge(),
                  SizedBox(width: RRSpace.sp12),
                  Expanded(
                    child: Text('Upgrade to RollReel Pro\nAd-free, Vault, Speed Controls'),
                  ),
                  Icon(CupertinoIcons.chevron_right),
                ],
              ),
            ),
          ),
          const SizedBox(height: RRSpace.sp20),
          _sectionLabel('ABOUT'),
          const _ValueRow(label: 'Version', value: '1.0.0 (Build 1)'),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RRSpace.sp8),
      child: Text(
        text,
        style: const TextStyle(
          color: RRColors.textDisabled,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ToggleRow extends StatefulWidget {
  const _ToggleRow({required this.label, required this.initialValue});

  final String label;
  final bool initialValue;

  @override
  State<_ToggleRow> createState() => _ToggleRowState();
}

class _ToggleRowState extends State<_ToggleRow> {
  late bool _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: RRSpace.sp12),
      tileColor: RRColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RRSpace.radiusMd)),
      title: Text(widget.label),
      trailing: CupertinoSwitch(
        value: _value,
        onChanged: (next) => setState(() => _value = next),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: RRSpace.sp12),
      tileColor: RRColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RRSpace.radiusMd)),
      title: Text(label),
      trailing: Text(value, style: const TextStyle(color: RRColors.textSecond)),
    );
  }
}
