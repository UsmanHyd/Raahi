import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../auth/presentation/screens/complete_profile_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';
import '../widgets/profile_menu_tile.dart';

/// The Profile tab body: a gradient hero card (avatar, name, contact info),
/// a stats strip, and an account menu card. Rendered inside [AppShell]'s
/// Scaffold, so it has no Scaffold or bottom nav of its own.
///
/// Data below is hardcoded for this UI-first pass, same as every other
/// screen in the app — it will move behind a provider once the feature is
/// wired to real data.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  static const String _fullName = 'Ahmed Khan';
  static const String _initials = 'AK';
  static const String _phone = '+92 312 345 6789';
  static const String _city = 'Islamabad';
  static const String _memberSince = 'Member since Jan 2025';

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
        title: Text('Log out of Raahi?', style: AppTypography.h2),
        content: Text(
          "You'll need to sign in again to plan or view your trips.",
          style: AppTypography.body.copyWith(color: AppColors.ink600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: AppTypography.bodyEmphasis.copyWith(
                color: AppColors.ink600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Log out',
              style: AppTypography.bodyEmphasis.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
        title: Text('Delete your account?', style: AppTypography.h2),
        content: Text(
          'This permanently deletes your account and all your trip data. '
          "This can't be undone.",
          style: AppTypography.body.copyWith(color: AppColors.ink600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: AppTypography.bodyEmphasis.copyWith(
                color: AppColors.ink600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: AppTypography.bodyEmphasis.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxxl,
            ),
            children: [
              _ProfileHeroCard(
                fullName: _fullName,
                initials: _initials,
                phone: _phone,
                city: _city,
                memberSince: _memberSince,
                onEditProfile: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CompleteProfileScreen(),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const _ProfileStatsRow(),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(title: 'Account'),
              const SizedBox(height: AppSpacing.md),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface0,
                  borderRadius: AppRadius.cardRadius,
                  boxShadow: AppShadows.card,
                ),
                child: ProfileMenuTile(
                  icon: LucideIcons.logOut,
                  label: 'Log out',
                  color: AppColors.error,
                  onTap: () => _confirmLogout(context),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Danger zone',
                style: AppTypography.captionEmphasis.copyWith(
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.05),
                  borderRadius: AppRadius.cardRadius,
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: ProfileMenuTile(
                  icon: LucideIcons.trash2,
                  label: 'Delete account',
                  color: AppColors.error,
                  onTap: () => _confirmDeleteAccount(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The gradient banner + overlapping-ring avatar + contact info, all in one
/// elevated card — the same "gradient header, white content below" idiom
/// used across the app's pushed screens, adapted into a self-contained hero
/// card for this tab-root screen.
class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.fullName,
    required this.initials,
    required this.phone,
    required this.city,
    required this.memberSince,
    required this.onEditProfile,
  });

  final String fullName;
  final String initials;
  final String phone;
  final String city;
  final String memberSince;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.glow(AppColors.primary500),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.cardRadius,
        child: Container(
          color: AppColors.surface0,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                decoration: const BoxDecoration(gradient: AppGradients.primary),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.surface0,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primary100,
                        child: Text(
                          initials,
                          style: AppTypography.h1.copyWith(
                            color: AppColors.primary700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          fullName,
                          style: AppTypography.h1.copyWith(
                            color: AppColors.surface0,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(
                          LucideIcons.badgeCheck,
                          size: 18,
                          color: AppColors.surface0,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      phone,
                      style: AppTypography.body.copyWith(
                        color: AppColors.surface0.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.mapPin,
                          size: 13,
                          color: AppColors.surface0.withValues(alpha: 0.85),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          city,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.surface0.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      memberSince,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.ink300,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton(
                      onPressed: onEditProfile,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary700,
                        side: const BorderSide(color: AppColors.primary700),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.md,
                        ),
                        shape: const StadiumBorder(),
                        textStyle: AppTypography.buttonLabel.copyWith(
                          color: AppColors.primary700,
                        ),
                      ),
                      child: const Text('Edit profile'),
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
}

/// "Trips · Cities · Reviews" summary — same icon+value+label stat idiom
/// used on the Trip Detail and My Trips screens, for visual consistency.
class _ProfileStatsRow extends StatelessWidget {
  const _ProfileStatsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: AppRadius.chipRadius,
        boxShadow: AppShadows.card,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(icon: LucideIcons.luggage, value: '3', label: 'Trips'),
          _StatDivider(),
          _StatItem(icon: LucideIcons.mapPin, value: '5', label: 'Cities'),
          _StatDivider(),
          _StatItem(icon: LucideIcons.star, value: '2', label: 'Reviews'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary700),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.bodyEmphasis.copyWith(
            color: AppColors.primary700,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.ink600),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: AppColors.border);
  }
}
