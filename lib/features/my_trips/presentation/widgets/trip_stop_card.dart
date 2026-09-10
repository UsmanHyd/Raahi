import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/trip_memory.dart';
import '../../domain/entities/trip_stop.dart';
import 'memory_upload_grid.dart';

/// One stop/action within a day's itinerary — a header (icon, title,
/// subtitle, time), a notes field, a collapsible memories uploader, and a
/// Save button. Owns its own notes/memories/saved state; nothing is
/// persisted beyond this screen's lifetime yet, matching the rest of the
/// app's mock-data-first UI.
class TripStopCard extends StatefulWidget {
  const TripStopCard({super.key, required this.stop});

  final TripStop stop;

  @override
  State<TripStopCard> createState() => _TripStopCardState();
}

class _TripStopCardState extends State<TripStopCard> {
  final _notesController = TextEditingController();
  List<TripMemory> _memories = const [];
  bool _saved = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  IconData get _typeIcon => switch (widget.stop.type) {
    StopType.drive => LucideIcons.car,
    StopType.food => LucideIcons.utensils,
    StopType.lodging => LucideIcons.bedDouble,
    StopType.sightseeing => LucideIcons.mountain,
    StopType.activity => LucideIcons.compass,
  };

  void _markUnsaved() {
    if (_saved) setState(() => _saved = false);
  }

  void _onMemoriesChanged(List<TripMemory> memories) {
    setState(() {
      _memories = memories;
      _saved = false;
    });
  }

  void _save() {
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.stop.title} saved'),
        backgroundColor: AppColors.primary700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface0,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary100,
                  shape: BoxShape.circle,
                ),
                child: Icon(_typeIcon, size: 18, color: AppColors.primary700),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.stop.title, style: AppTypography.bodyEmphasis),
                    Text(
                      widget.stop.subtitle,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.ink600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                widget.stop.time,
                style: AppTypography.captionEmphasis.copyWith(
                  color: AppColors.primary700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.lg),
          Text('Notes', style: AppTypography.bodyEmphasis),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _notesController,
            onChanged: (_) => _markUnsaved(),
            maxLines: 3,
            style: AppTypography.body,
            decoration: InputDecoration(
              hintText: 'Add a note you want to remember...',
              hintStyle: AppTypography.body.copyWith(color: AppColors.ink300),
              filled: true,
              fillColor: AppColors.surface100,
              contentPadding: const EdgeInsets.all(AppSpacing.md),
              border: OutlineInputBorder(
                borderRadius: AppRadius.chipRadius,
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _MemoriesSection(memories: _memories, onChanged: _onMemoriesChanged),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: _saved ? 'Saved' : 'Save',
            onPressed: _saved ? null : _save,
            expand: true,
          ),
        ],
      ),
    );
  }
}

/// A collapsed trigger — "Save your memories for this trip" — that expands
/// into the photo/video upload grid on tap, so a stop's card stays compact
/// until the traveler actually wants to add or view memories.
class _MemoriesSection extends StatefulWidget {
  const _MemoriesSection({required this.memories, required this.onChanged});

  final List<TripMemory> memories;
  final ValueChanged<List<TripMemory>> onChanged;

  @override
  State<_MemoriesSection> createState() => _MemoriesSectionState();
}

class _MemoriesSectionState extends State<_MemoriesSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final count = widget.memories.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface100,
              borderRadius: AppRadius.chipRadius,
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.imagePlus,
                  size: 18,
                  color: AppColors.primary700,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Save your memories for this trip',
                    style: AppTypography.bodyEmphasis,
                  ),
                ),
                if (count > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary100,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$count',
                      style: AppTypography.captionEmphasis.copyWith(
                        color: AppColors.primary700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Icon(
                  _expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  size: 18,
                  color: AppColors.ink300,
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: AppSpacing.md),
          MemoryUploadGrid(
            memories: widget.memories,
            onChanged: widget.onChanged,
          ),
        ],
      ],
    );
  }
}
