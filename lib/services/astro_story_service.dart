import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/astro_story.dart';

class AstroStoryService {
  const AstroStoryService();

  CollectionReference<Map<String, dynamic>> get _collection =>
      FirebaseFirestore.instance.collection('astro_stories');

  Stream<List<AstroStory>> watchActiveStories({int limit = 20}) {
    return _collection
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .where((d) => (d.data()['isActive'] as bool?) ?? true)
              .map(AstroStory.fromFirestore)
              .toList(),
        );
  }

  Stream<List<AstroStory>> watchAllStories({int limit = 100}) {
    return _collection
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(AstroStory.fromFirestore).toList());
  }

  Future<void> createStory({
    required String title,
    required String subtitle,
    required String thumbnailUrl,
    required bool isActive,
    required List<AstroStorySegment> segments,
  }) async {
    await _collection.add({
      'title': title,
      'subtitle': subtitle,
      'thumbnailUrl': thumbnailUrl,
      'isActive': isActive,
      'segments': segments.map((e) => e.toMap()).toList(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setStoryActive({required String id, required bool isActive}) async {
    await _collection.doc(id).update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteStory(String id) {
    return _collection.doc(id).delete();
  }
}
