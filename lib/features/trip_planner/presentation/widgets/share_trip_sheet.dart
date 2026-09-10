import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// A share action, e.g. "Export as PDF" or "Share via WhatsApp".
class _ShareOption {
  const _ShareOption({
    required this.icon,
    required this.label,
    this.iconBackground = AppColors.surface100,
    this.iconColor = AppColors.ink600,
  });

  final IconData icon;
  final String label;
  final Color iconBackground;
  final Color iconColor;
}

const _shareOptions = [
  _ShareOption(icon: LucideIcons.fileText, label: 'Export as PDF'),
  _ShareOption(icon: LucideIcons.link, label: 'Copy shareable link'),
  _ShareOption(
    icon: LucideIcons.messageCircle,
    label: 'Share via WhatsApp',
    iconBackground: AppColors.primary100,
    iconColor: AppColors.primary700,
  ),
];

/// Bottom sheet opened from a share icon anywhere in the trip-planner flow.
/// Same visual language as [AddStopSheet] — surface-50 background, top
/// rounded corners, a drag-handle bar — but a fixed-height action list
/// rather than a draggable one, since the content here doesn't scroll.
///
/// None of the actions do real work yet (no PDF export, clipboard link, or
/// WhatsApp integration wired up) — each just confirms the tap for now.
/// Show with `showModalBottomSheet(backgroundColor: AppColors.surface50,
/// shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius))`.
class ShareTripSheet extends StatelessWidget {
  const ShareTripSheet({super.key});

  void _handleTap(BuildContext context, _ShareOption option) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${option.label} isn\'t available yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Share your trip', style: AppTypography.h2),
            ),
            const SizedBox(height: AppSpacing.md),
            for (var i = 0; i < _shareOptions.length; i++) ...[
              _ShareOptionRow(
                option: _shareOptions[i],
                onTap: () => _handleTap(context, _shareOptions[i]),
              ),
              if (i != _shareOptions.length - 1)
                const Divider(color: AppColors.border, height: 1),
            ],
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(
                'Cancel',
                style: AppTypography.bodyEmphasis.copyWith(
                  color: AppColors.ink600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareOptionRow extends StatelessWidget {
  const _ShareOptionRow({required this.option, required this.onTap});

  final _ShareOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: option.iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(option.icon, size: 18, color: option.iconColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(option.label, style: AppTypography.bodyEmphasis),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.ink300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
