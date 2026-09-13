import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../widgets/settings_nav_row.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_segmented_control.dart';
import '../widgets/settings_toggle_row.dart';

enum _DistanceUnit { km, miles }

enum _ThemePreference { light, dark, system }

const List<String> _languages = ['English', 'Urdu', 'Pashto'];

/// The Settings tab body: general preferences, appearance, notifications,
/// permissions, and app info. Rendered inside [AppShell]'s Scaffold, so it
/// has no Scaffold or bottom nav of its own.
///
/// Everything here is local widget state for this pass — nothing persists
/// across app restarts yet, matching the rest of the app's mock-data-first
/// UI (and the Theme/Permissions sections are UI-only: there's no dark
/// palette or real OS permission check behind them yet).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _defaultDistanceUnit = _DistanceUnit.km;
  static const _defaultThemePreference = _ThemePreference.system;
  static const _defaultLanguage = 'English';

  _DistanceUnit _distanceUnit = _defaultDistanceUnit;
  _ThemePreference _themePreference = _defaultThemePreference;
  String _language = _defaultLanguage;

  bool _tripReminders = true;
  bool _weatherAlerts = true;
  bool _roadUpdates = true;

  bool _locationPermission = true;
  bool _cameraPermission = true;
  bool _photosPermission = true;

  Future<void> _pickLanguage() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(child: Text('Language', style: AppTypography.h2)),
                ],
              ),
            ),
            for (final language in _languages)
              ListTile(
                title: Text(language, style: AppTypography.bodyEmphasis),
                trailing: language == _language
                    ? const Icon(LucideIcons.check, color: AppColors.primary700)
                    : null,
                onTap: () => Navigator.of(context).pop(language),
              ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );

    if (picked == null) return;
    setState(() => _language = picked);
  }

  void _resetToDefaults() {
    setState(() {
      _distanceUnit = _defaultDistanceUnit;
      _themePreference = _defaultThemePreference;
      _language = _defaultLanguage;
      _tripReminders = true;
      _weatherAlerts = true;
      _roadUpdates = true;
      _locationPermission = true;
      _cameraPermission = true;
      _photosPermission = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings reset to defaults'),
        backgroundColor: AppColors.primary700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        children: [
          Text('Settings', style: AppTypography.display),
          const SizedBox(height: AppSpacing.xxl),
          SettingsSection(
            title: 'General settings',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.ruler,
                      size: 20,
                      color: AppColors.primary700,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Distance units',
                        style: AppTypography.bodyEmphasis,
                      ),
                    ),
                    SettingsSegmentedControl<_DistanceUnit>(
                      options: const [
                        SegmentOption(value: _DistanceUnit.km, label: 'km'),
                        SegmentOption(
                          value: _DistanceUnit.miles,
                          label: 'miles',
                        ),
                      ],
                      selected: _distanceUnit,
                      onChanged: (value) =>
                          setState(() => _distanceUnit = value),
                    ),
                  ],
                ),
              ),
              SettingsNavRow(
                icon: LucideIcons.languages,
                label: 'Language',
                value: _language,
                onTap: _pickLanguage,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          SettingsSection(
            title: 'Appearance',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.palette,
                      size: 20,
                      color: AppColors.primary700,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text('Theme', style: AppTypography.bodyEmphasis),
                    ),
                    SettingsSegmentedControl<_ThemePreference>(
                      options: const [
                        SegmentOption(
                          value: _ThemePreference.light,
                          label: 'Light',
                        ),
                        SegmentOption(
                          value: _ThemePreference.dark,
                          label: 'Dark',
                        ),
                        SegmentOption(
                          value: _ThemePreference.system,
                          label: 'Auto',
                        ),
                      ],
                      selected: _themePreference,
                      onChanged: (value) =>
                          setState(() => _themePreference = value),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          SettingsSection(
            title: 'Notifications',
            children: [
              SettingsToggleRow(
                icon: LucideIcons.luggage,
                label: 'Trip reminders',
                value: _tripReminders,
                onChanged: (value) => setState(() => _tripReminders = value),
              ),
              SettingsToggleRow(
                icon: LucideIcons.cloudRain,
                label: 'Weather alerts',
                value: _weatherAlerts,
                onChanged: (value) => setState(() => _weatherAlerts = value),
              ),
              SettingsToggleRow(
                icon: LucideIcons.triangleAlert,
                label: 'Road updates',
                value: _roadUpdates,
                onChanged: (value) => setState(() => _roadUpdates = value),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          SettingsSection(
            title: 'Permissions',
            children: [
              SettingsToggleRow(
                icon: LucideIcons.mapPin,
                label: 'Location',
                subtitle: 'Find nearby places and plan routes',
                value: _locationPermission,
                onChanged: (value) =>
                    setState(() => _locationPermission = value),
              ),
              SettingsToggleRow(
                icon: LucideIcons.camera,
                label: 'Camera',
                subtitle: 'Capture photos and videos for trip memories',
                value: _cameraPermission,
                onChanged: (value) => setState(() => _cameraPermission = value),
              ),
              SettingsToggleRow(
                icon: LucideIcons.image,
                label: 'Photos & media',
                subtitle: 'Attach existing photos and videos to your trips',
                value: _photosPermission,
                onChanged: (value) => setState(() => _photosPermission = value),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          SettingsSection(
            title: 'About',
            children: [
              SettingsNavRow(
                icon: LucideIcons.info,
                label: 'App version',
                value: '1.0.2',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Center(
            child: TextButton(
              onPressed: _resetToDefaults,
              child: Text(
                'Reset to defaults',
                style: AppTypography.bodyEmphasis.copyWith(
                  color: AppColors.ink600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
