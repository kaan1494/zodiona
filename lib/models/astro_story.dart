import 'package:cloud_firestore/cloud_firestore.dart';

class AstroStorySegment {
  const AstroStorySegment({
    required this.text,
    required this.imageUrl,
    required this.duration,
  });

  final String text;
  final String imageUrl;
  final Duration duration;

  factory AstroStorySegment.fromMap(Map<String, dynamic> map) {
    final durationMs = (map['durationMs'] as num?)?.toInt() ?? 5000;
    return AstroStorySegment(
      text: (map['text'] as String?)?.trim() ?? '',
      imageUrl: (map['imageUrl'] as String?)?.trim() ?? '',
      duration: Duration(milliseconds: durationMs.clamp(1500, 15000)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'imageUrl': imageUrl,
      'durationMs': duration.inMilliseconds,
    };
  }
}

class AstroStory {
  const AstroStory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    required this.segments,
    required this.isActive,
    this.isSpecial = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String thumbnailUrl;
  final List<AstroStorySegment> segments;
  final bool isActive;
  final bool isSpecial;

  factory AstroStory.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final segmentsRaw = (data['segments'] as List?) ?? const [];
    final segments = segmentsRaw
        .whereType<Map>()
        .map((e) => AstroStorySegment.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    return AstroStory(
      id: doc.id,
      title: (data['title'] as String?)?.trim() ?? 'Hikaye',
      subtitle: (data['subtitle'] as String?)?.trim() ?? '',
      thumbnailUrl: (data['thumbnailUrl'] as String?)?.trim() ?? '',
      isActive: (data['isActive'] as bool?) ?? true,
      segments: segments.isEmpty
          ? const [
              AstroStorySegment(
                text: 'Yakinda yeni astro hikayeler burada olacak.',
                imageUrl: '',
                duration: Duration(seconds: 5),
              ),
            ]
          : segments,
    );
  }

  factory AstroStory.special({
    required String id,
    required String title,
    required String subtitle,
    required String text,
  }) {
    return AstroStory(
      id: id,
      title: title,
      subtitle: subtitle,
      thumbnailUrl: '',
      isActive: true,
      isSpecial: true,
      segments: [
        AstroStorySegment(
          text: text,
          imageUrl: '',
          duration: const Duration(seconds: 6),
        ),
      ],
    );
  }
}
