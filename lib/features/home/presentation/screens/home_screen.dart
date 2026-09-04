import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../trip_planner/presentation/screens/plan_trip_screen.dart';
import '../widgets/explore_nearby_section.dart';
import '../widgets/home_profile_header.dart';
import '../widgets/plan_trip_hero_card.dart';
import '../widgets/recommended_card_stack.dart';

/// The Home tab body: profile header, headline, "Recommended" swipeable
/// stack, "Plan a new trip" CTA, and "Explore Nearby". Rendered inside
/// [AppShell]'s Scaffold, so it has no Scaffold or bottom nav of its own.
///
/// Data below is hardcoded for this UI-first pass; it will move behind a
/// provider once the home feature is wired to real data.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          const HomeProfileHeader(),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Where is the road taking you next?',
            style: AppTypography.display,
          ),
          const SizedBox(height: AppSpacing.xxl),
          SectionHeader(
            title: 'Recommended',
            actionLabel: 'View all',
            onActionTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          const RecommendedCardStack(),
          const SizedBox(height: AppSpacing.xxxxl),
          Row(
            children: [
              const Icon(
                LucideIcons.planeTakeoff,
                color: AppColors.primary700,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text("Let's plan your trip", style: AppTypography.h1),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanTripHeroCard(
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const PlanTripScreen())),
          ),
          const SizedBox(height: AppSpacing.xxl),
          SectionHeader(
            title: 'Explore Nearby',
            actionLabel: 'See all',
            onActionTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          const ExploreNearbySection(),
        ],
      ),
    );
  }
}
