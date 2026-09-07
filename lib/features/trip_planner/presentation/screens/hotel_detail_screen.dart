import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/loading_progress_screen.dart';
import 'hotels_screen.dart' show Hotel, HotelAmenity;
import 'travel_plan_screen.dart';

/// Opened by tapping a hotel card on [HotelsScreen] — full details plus the
/// two actions that actually finish the trip-planning flow.
class HotelDetailScreen extends StatelessWidget {
  const HotelDetailScreen({
    super.key,
    required this.hotel,
    required this.startingFrom,
    required this.destinationName,
    this.dateRange,
  });

  final Hotel hotel;
  final String startingFrom;
  final String destinationName;
  final DateTimeRange? dateRange;

  void _callLodge(BuildContext context) {
    // TODO: launch a real phone call once a contact number is available.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${hotel.name} isn\'t available yet'),
        backgroundColor: AppColors.ink900,
      ),
    );
  }

  void _selectHotel(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoadingProgressScreen(
          stepLabels: [
            'Confirming your dates...',
            'Reserving your room...',
            'Locking in ${hotel.name}...',
            'Booked!',
          ],
          // TODO: wire to the booking repository once the backend is in
          // place — the steps above should track real request progress
          // instead of a fixed timer.
          onFinished: () => _finishBooking(context),
        ),
      ),
    );
  }

  void _finishBooking(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TravelPlanScreen(
          startingFrom: startingFrom,
          destinationName: destinationName,
          hotelName: hotel.name,
          dateRange: dateRange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _HeroImage(hotel: hotel),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(hotel.name, style: AppTypography.h1),
                          ),
                          const Icon(
                            LucideIcons.star,
                            size: 18,
                            color: AppColors.accentAmber,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            hotel.rating.toStringAsFixed(1),
                            style: AppTypography.bodyEmphasis,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        hotel.pricePerNight,
                        style: AppTypography.h2.copyWith(
                          color: AppColors.accentTerracotta,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Amenities offered',
                        style: AppTypography.bodyEmphasis,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final amenity in hotel.amenities)
                            _AmenityChip(amenity: amenity),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Location', style: AppTypography.bodyEmphasis),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            LucideIcons.mapPin,
                            size: 16,
                            color: AppColors.primary700,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              hotel.address,
                              style: AppTypography.body.copyWith(
                                color: AppColors.ink600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(color: AppColors.surface0),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _callLodge(context),
                        icon: const Icon(LucideIcons.phone, size: 16),
                        label: const Text('Call lodge'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary700,
                          side: const BorderSide(color: AppColors.primary700),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          shape: const StadiumBorder(),
                          textStyle: AppTypography.buttonLabel,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _selectHotel(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.accentTerracotta,
                          foregroundColor: AppColors.surface0,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          shape: const StadiumBorder(),
                          textStyle: AppTypography.buttonLabel,
                        ),
                        child: const Text('Select this hotel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.hotel});

  final Hotel hotel;

  static const double _height = 260;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            hotel.imageAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.primary),
              child: Icon(
                LucideIcons.building2,
                color: AppColors.surface0,
                size: 48,
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x66000000), Colors.transparent],
                stops: [0, 0.3],
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.lg,
            child: SafeArea(
              bottom: false,
              child: CircleIconButton(
                icon: LucideIcons.arrowLeft,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({required this.amenity});

  final HotelAmenity amenity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: AppRadius.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(amenity.icon, size: 15, color: AppColors.primary700),
          const SizedBox(width: AppSpacing.xs),
          Text(
            amenity.label,
            style: AppTypography.captionEmphasis.copyWith(
              color: AppColors.primary700,
            ),
          ),
        ],
      ),
    );
  }
}
