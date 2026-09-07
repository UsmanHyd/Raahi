import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import 'hotel_detail_screen.dart';

/// One amenity a hotel offers — icon + label, shown as a chip on
/// [HotelDetailScreen].
class HotelAmenity {
  const HotelAmenity({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// A single hotel option. Public (not the usual private `_Hotel` pattern)
/// because [HotelDetailScreen], in another file, needs the type.
class Hotel {
  const Hotel({
    required this.imageAsset,
    required this.name,
    required this.distanceLabel,
    required this.rating,
    required this.pricePerNight,
    required this.address,
    required this.amenities,
  });

  final String imageAsset;
  final String name;
  final String distanceLabel;
  final double rating;
  final String pricePerNight;
  final String address;
  final List<HotelAmenity> amenities;
}

/// Shown after Route Preview's "Continue to hotels" — a shortlist of stays
/// near the trip's overnight stop. Hardcoded list, no backend yet; tapping
/// a card opens [HotelDetailScreen], which is where the actual booking
/// action lives now.
class HotelsScreen extends StatelessWidget {
  const HotelsScreen({
    super.key,
    required this.startingFrom,
    required this.destinationName,
    this.dateRange,
  });

  final String startingFrom;
  final String destinationName;
  final DateTimeRange? dateRange;

  static const List<Hotel> _hotels = [
    Hotel(
      imageAsset: 'assets/home/hotel_kalam_forest_lodge.jpg',
      name: 'Kalam Forest Lodge',
      distanceLabel: '2.1 km from center',
      rating: 4.8,
      pricePerNight: 'PKR 8,500/night',
      address: 'Kalam Forest Road, Upper Kalam, Swat District, KP',
      amenities: [
        HotelAmenity(icon: LucideIcons.wifi, label: 'Free WiFi'),
        HotelAmenity(icon: LucideIcons.droplet, label: 'Hot Water'),
        HotelAmenity(icon: LucideIcons.circleParking, label: 'Parking'),
        HotelAmenity(icon: LucideIcons.utensils, label: 'Restaurant'),
      ],
    ),
    Hotel(
      imageAsset: 'assets/home/hotel_pine_top_resort.jpg',
      name: 'Pine Top Resort',
      distanceLabel: '0.8 km from center',
      rating: 4.9,
      pricePerNight: 'PKR 12,000/night',
      address: 'Main Kalam Road, Upper Kalam Forest, Swat District, KP',
      amenities: [
        HotelAmenity(icon: LucideIcons.wifi, label: 'Free WiFi'),
        HotelAmenity(icon: LucideIcons.droplet, label: 'Hot Water'),
        HotelAmenity(icon: LucideIcons.circleParking, label: 'Parking'),
        HotelAmenity(icon: LucideIcons.utensils, label: 'Restaurant'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            decoration: const BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.sheet),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  CircleIconButton(
                    icon: LucideIcons.arrowLeft,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Hotels',
                    style: AppTypography.h1.copyWith(color: AppColors.surface0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  'Where to stay in $destinationName',
                  style: AppTypography.h2,
                ),
                const SizedBox(height: AppSpacing.lg),
                for (final hotel in _hotels) ...[
                  _HotelCard(
                    hotel: hotel,
                    startingFrom: startingFrom,
                    destinationName: destinationName,
                    dateRange: dateRange,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  const _HotelCard({
    required this.hotel,
    required this.startingFrom,
    required this.destinationName,
    this.dateRange,
  });

  final Hotel hotel;
  final String startingFrom;
  final String destinationName;
  final DateTimeRange? dateRange;

  static const double _height = 230;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.glow(AppColors.primary500),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.cardRadius,
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => HotelDetailScreen(
                hotel: hotel,
                startingFrom: startingFrom,
                destinationName: destinationName,
                dateRange: dateRange,
              ),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                hotel.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: const BoxDecoration(
                    gradient: AppGradients.primary,
                  ),
                  child: const Icon(
                    LucideIcons.building2,
                    color: AppColors.surface0,
                    size: 40,
                  ),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xD9000000)],
                    stops: [0.35, 1],
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.md,
                left: AppSpacing.md,
                child: _Badge(
                  icon: LucideIcons.mapPin,
                  label: hotel.distanceLabel,
                ),
              ),
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: _Badge(
                  icon: LucideIcons.star,
                  iconColor: AppColors.accentAmber,
                  label: hotel.rating.toStringAsFixed(1),
                ),
              ),
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hotel.name,
                      style: AppTypography.h2.copyWith(
                        color: AppColors.surface0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hotel.pricePerNight,
                          style: AppTypography.bodyEmphasis.copyWith(
                            color: AppColors.surface0,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Details',
                              style: AppTypography.captionEmphasis.copyWith(
                                color: AppColors.surface0,
                              ),
                            ),
                            const Icon(
                              LucideIcons.chevronRight,
                              size: 14,
                              color: AppColors.surface0,
                            ),
                          ],
                        ),
                      ],
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

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    this.iconColor = AppColors.primary700,
  });

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface0.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.captionEmphasis),
        ],
      ),
    );
  }
}
