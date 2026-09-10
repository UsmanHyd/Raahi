import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/trip_memory.dart';

/// Up to 5 photos + 5 videos a traveler attaches to a [TripStop] as
/// memories. Picking reuses the same camera/gallery bottom-sheet pattern
/// already established for the profile picture picker. Stateless — the
/// parent (a [TripStopCard]) owns the memory list and gets it back via
/// [onChanged].
class MemoryUploadGrid extends StatelessWidget {
  const MemoryUploadGrid({
    super.key,
    required this.memories,
    required this.onChanged,
  });

  final List<TripMemory> memories;
  final ValueChanged<List<TripMemory>> onChanged;

  static const int maxPhotos = 5;
  static const int maxVideos = 5;

  List<TripMemory> get _photos =>
      memories.where((memory) => memory.type == TripMemoryType.photo).toList();

  List<TripMemory> get _videos =>
      memories.where((memory) => memory.type == TripMemoryType.video).toList();

  Future<ImageSource?> _chooseSource(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                LucideIcons.camera,
                color: AppColors.primary700,
              ),
              title: Text('Take a photo', style: AppTypography.bodyEmphasis),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(
                LucideIcons.image,
                color: AppColors.primary700,
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
  }

  Future<void> _addPhoto(BuildContext context) async {
    if (_photos.length >= maxPhotos) return;
    final source = await _chooseSource(context);
    if (source == null) return;
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null) return;
    onChanged([
      ...memories,
      TripMemory(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: TripMemoryType.photo,
        path: picked.path,
      ),
    ]);
  }

  Future<void> _addVideo(BuildContext context) async {
    if (_videos.length >= maxVideos) return;
    final source = await _chooseSource(context);
    if (source == null) return;
    final picked = await ImagePicker().pickVideo(source: source);
    if (picked == null) return;
    onChanged([
      ...memories,
      TripMemory(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: TripMemoryType.video,
        path: picked.path,
      ),
    ]);
  }

  void _remove(TripMemory memory) {
    onChanged(memories.where((m) => m.id != memory.id).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos (${_photos.length}/$maxPhotos)',
          style: AppTypography.caption,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final memory in _photos)
              _MemoryTile(memory: memory, onRemove: () => _remove(memory)),
            if (_photos.length < maxPhotos)
              _AddTile(
                icon: LucideIcons.imagePlus,
                onTap: () => _addPhoto(context),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Videos (${_videos.length}/$maxVideos)',
          style: AppTypography.caption,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final memory in _videos)
              _MemoryTile(memory: memory, onRemove: () => _remove(memory)),
            if (_videos.length < maxVideos)
              _AddTile(
                icon: LucideIcons.video,
                onTap: () => _addVideo(context),
              ),
          ],
        ),
      ],
    );
  }
}

class _MemoryTile extends StatelessWidget {
  const _MemoryTile({required this.memory, required this.onRemove});

  final TripMemory memory;
  final VoidCallback onRemove;

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: AppRadius.chipRadius,
            child: SizedBox(
              width: _size,
              height: _size,
              child: memory.type == TripMemoryType.photo
                  ? Image.file(
                      File(memory.path),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _VideoPlaceholder(),
                    )
                  : const _VideoPlaceholder(),
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color(0xB3000000),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.x,
                  size: 12,
                  color: AppColors.surface0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface100,
      alignment: Alignment.center,
      child: const Icon(LucideIcons.video, size: 22, color: AppColors.ink300),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: AppColors.surface50,
          borderRadius: AppRadius.chipRadius,
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: AppColors.ink300),
      ),
    );
  }
}
