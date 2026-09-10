/// Whether a [TripMemory] is a photo or a video.
enum TripMemoryType { photo, video }

/// A photo or video a traveler attaches to a [TripStop] as a memory.
/// Holds only a local file path — picking the file (via image_picker) is a
/// presentation-layer concern, kept out of the domain.
class TripMemory {
  const TripMemory({required this.id, required this.type, required this.path});

  final String id;
  final TripMemoryType type;
  final String path;
}
