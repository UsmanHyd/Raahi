import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, color: AppColors.ink900),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 80),
                            Text(
                              'Set up your profile',
                              style: AppTypography.h1,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Tell us a bit about yourself',
                              style: AppTypography.body.copyWith(
                                color: AppColors.ink600,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: _ProfilePicturePicker(
                                image: _profileImage,
                                onTap: _pickProfilePicture,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            AppTextField(
                              label: 'Full name',
                              hintText: 'Enter your full name',
                              controller: _fullNameController,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              label: 'Phone Number',
                              hintText: '+9200000000',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              label: 'Home city (optional)',
                              hintText: 'e.g. Islamabad, Lahore',
                              controller: _homeCityController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface0,
                borderRadius: AppRadius.sheetRadius,
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
  const _ProfilePicturePicker({required this.onTap, this.image});

  final VoidCallback onTap;
  final File? image;

  static const double _size = 100;
  static const double _badgeSize = 30;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: _size,
        height: _size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                color: AppColors.primary100,
                shape: BoxShape.circle,
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
                      size: 52,
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
                  color: AppColors.primary700,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface50, width: 2),
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
