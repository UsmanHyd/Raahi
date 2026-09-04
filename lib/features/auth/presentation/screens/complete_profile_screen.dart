import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_shell.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _homeCityController = TextEditingController();

  File? _profileImage;

  static const double _avatarSize = 112;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _homeCityController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePicture() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const _PickerOptionIcon(
                icon: Icons.photo_camera_outlined,
              ),
              title: Text('Take a photo', style: AppTypography.bodyEmphasis),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const _PickerOptionIcon(
                icon: Icons.photo_library_outlined,
              ),
              title: Text(
                'Choose from gallery',
                style: AppTypography.bodyEmphasis,
              ),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() => _profileImage = File(picked.path));
  }

  void _continue() {
    // TODO: wire to the auth/profile repository once the backend is in place.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AppShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg,
                          AppSpacing.xxxxl + AppSpacing.xl,
                        ),
                        decoration: const BoxDecoration(
                          gradient: AppGradients.primary,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(AppRadius.sheet),
                          ),
                        ),
                        child: SafeArea(
                          bottom: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _BackButton(
                                onTap: () => Navigator.of(context).maybePop(),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Text(
                                'Set up your profile',
                                style: AppTypography.h1.copyWith(
                                  color: AppColors.surface0,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Tell us a bit about yourself',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.surface0.withValues(
                                    alpha: 0.85,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -(_avatarSize / 2),
                        child: _ProfilePicturePicker(
                          image: _profileImage,
                          onTap: _pickProfilePicture,
                          size: _avatarSize,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      (_avatarSize / 2) + AppSpacing.xl,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface0,
                        borderRadius: AppRadius.cardRadius,
                        boxShadow: AppShadows.card,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            label: 'Full name',
                            hintText: 'Enter your full name',
                            controller: _fullNameController,
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: AppColors.ink300,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            label: 'Phone Number',
                            hintText: '+9200000000',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              color: AppColors.ink300,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            label: 'Home city (optional)',
                            hintText: 'e.g. Islamabad, Lahore',
                            controller: _homeCityController,
                            prefixIcon: const Icon(
                              Icons.location_city_outlined,
                              color: AppColors.ink300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface0,
              boxShadow: AppShadows.card,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: SafeArea(
                top: false,
                child: PrimaryButton(
                  label: 'Continue',
                  onPressed: _continue,
                  expand: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface0.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Icon(Icons.arrow_back, color: AppColors.surface0, size: 20),
        ),
      ),
    );
  }
}

class _PickerOptionIcon extends StatelessWidget {
  const _PickerOptionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.primary100,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: AppColors.primary700),
    );
  }
}

class _ProfilePicturePicker extends StatelessWidget {
  const _ProfilePicturePicker({
    required this.onTap,
    required this.size,
    this.image,
  });

  final VoidCallback onTap;
  final double size;
  final File? image;

  static const double _badgeSize = 32;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.primary100,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface0, width: 4),
                boxShadow: AppShadows.glow(AppColors.primary500),
                image: image != null
                    ? DecorationImage(
                        image: FileImage(image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: image == null
                  ? const Icon(
                      Icons.person_outline,
                      size: 56,
                      color: AppColors.primary700,
                    )
                  : null,
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: _badgeSize,
                height: _badgeSize,
                decoration: BoxDecoration(
                  gradient: AppGradients.sunset,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface0, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 18,
                  color: AppColors.surface0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
