import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/section_header.dart';
import '../widgets/destination_card.dart';
import '../widgets/home_greeting_header.dart';
import '../widgets/plan_trip_hero_card.dart';
import '../widgets/trip_card.dart';

/// The Home tab body: greeting, "plan a trip" CTA, recent trips, and
/// popular destinations. Rendered inside [AppShell]'s Scaffold, so it has
/// no Scaffold or bottom nav of its own.
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
          const HomeGreetingHeader(),
          const SizedBox(height: AppSpacing.xl),
          const PlanTripHeroCard(),
          const SizedBox(height: AppSpacing.xxl),
          SectionHeader(
            title: 'Recent trips',
            actionLabel: 'View all',
            onActionTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 190,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TripCard(
                  imageAsset: 'assets/home/trip_hunza_valley.jpg',
                  name: 'Hunza Valley',
                  dateRangeLabel: 'Jun 12-15',
                  travelerCount: 2,
                ),
                SizedBox(width: AppSpacing.md),
                TripCard(
                  imageAsset: 'assets/home/trip_naran_kaghan.jpg',
                  name: 'Naran Kaghan',
                  dateRangeLabel: 'Jul 3-6',
                  travelerCount: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(title: 'Popular destinations'),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.85,
            children: const [
              DestinationCard(
                imageAsset: 'assets/home/destination_swat_valley.jpg',
                name: 'Swat Valley',
                subtitle: 'Alpine forests & rivers',
              ),
              DestinationCard(
                imageAsset: 'assets/home/destination_fairy_meadows.jpg',
                name: 'Fairy Meadows',
                subtitle: 'Nanga Parbat basecamp',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
