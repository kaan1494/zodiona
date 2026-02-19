import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/astro_story.dart';
import '../../../services/astro_story_service.dart';
import '../../../utils/web_image_picker.dart';

class AdminStoryAdminScreen extends StatefulWidget {
  const AdminStoryAdminScreen({super.key});

  @override
  State<AdminStoryAdminScreen> createState() => _AdminStoryAdminScreenState();
}

class _AdminStoryAdminScreenState extends State<AdminStoryAdminScreen> {
  static const List<_PresetStoryImage> _presetImages = [
    _PresetStoryImage('Story 01', 'assets/admin_story_presets/story_01.png'),
    _PresetStoryImage('Story 02', 'assets/admin_story_presets/story_02.png'),
    _PresetStoryImage('Story 03', 'assets/admin_story_presets/story_03.png'),
    _PresetStoryImage('Story 04', 'assets/admin_story_presets/story_04.png'),
    _PresetStoryImage('Story 05', 'assets/admin_story_presets/story_05.png'),
    _PresetStoryImage('Story 06', 'assets/admin_story_presets/story_06.png'),
    _PresetStoryImage('Story 07', 'assets/admin_story_presets/story_07.png'),
    _PresetStoryImage('Story 08', 'assets/admin_story_presets/story_08.png'),
    _PresetStoryImage('Story 09', 'assets/admin_story_presets/story_09.png'),
    _PresetStoryImage('Story 10', 'assets/admin_story_presets/story_10.png'),
    _PresetStoryImage('Story 11', 'assets/admin_story_presets/story_11.png'),
    _PresetStoryImage('Story 12', 'assets/admin_story_presets/story_12.png'),
    _PresetStoryImage('Story 13', 'assets/admin_story_presets/story_13.png'),
    _PresetStoryImage('Story 14', 'assets/admin_story_presets/story_14.png'),
    _PresetStoryImage('Story 15', 'assets/admin_story_presets/story_15.png'),
    _PresetStoryImage('Story 16', 'assets/admin_story_presets/story_16.png'),
    _PresetStoryImage('Story 17', 'assets/admin_story_presets/story_17.png'),
    _PresetStoryImage('Story 18', 'assets/admin_story_presets/story_18.png'),
    _PresetStoryImage('Story 19', 'assets/admin_story_presets/story_19.png'),
    _PresetStoryImage('Story 20', 'assets/admin_story_presets/story_20.png'),
  ];

  final _service = const AstroStoryService();
  final _titleController = TextEditingController();
  bool _isActive = true;
  bool _isSaving = false;

  final List<_SegmentDraft> _segments = [
    _SegmentDraft(),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    for (final s in _segments) {
      s.dispose();
    }
    super.dispose();
  }

  Future<void> _createStory() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Baslik gerekli.')));
      return;
    }

    final segments = _segments
        .map((s) => s.toSegment())
        .where((s) => s.text.trim().isNotEmpty)
        .toList();

    final coverImage = segments
      .map((s) => s.imageUrl.trim())
      .firstWhere((url) => url.isNotEmpty, orElse: () => '');

    if (segments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En az 1 hikaye sayfasi ekle.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _service.createStory(
        title: title,
        subtitle: '',
        thumbnailUrl: coverImage,
        isActive: _isActive,
        segments: segments,
      );

      _titleController.clear();
      for (final s in _segments) {
        s.dispose();
      }
      _segments
        ..clear()
        ..add(_SegmentDraft());

      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hikaye kaydedildi.')),
        );
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kaydetme hatasi: ${e.code}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kaydetme hatasi: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _setStoryActive({required String id, required bool isActive}) async {
    try {
      await _service.setStoryActive(id: id, isActive: isActive);
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guncelleme hatasi: ${e.code}')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guncelleme hatasi: $e')),
      );
    }
  }

  Future<void> _deleteStory(String id) async {
    try {
      await _service.deleteStory(id);
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silme hatasi: ${e.code}')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silme hatasi: $e')),
      );
    }
  }

  Future<String?> _pickAndUploadImage() async {
    if (!kIsWeb) {
      throw Exception('Bu secim su an yalnizca web panelde destekleniyor.');
    }

    final picked = await pickImageForWebSafe();
    if (picked == null) {
      return null;
    }

    final bytes = picked['bytes'] as Uint8List?;
    final name = (picked['name'] as String?) ?? 'image.jpg';
    if (bytes == null) {
      throw Exception('Secilen dosya okunamadi.');
    }

    final ext = name.contains('.') ? name.split('.').last : 'jpg';
    final safeExt = ext.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    const maxBytes = 350 * 1024;
    if (bytes.length > maxBytes) {
      throw Exception('Gorsel boyutu cok buyuk (maks 350 KB).');
    }

    final base64 = base64Encode(bytes);
    return 'data:image/$safeExt;base64,$base64';
  }

  Future<void> _pickAndUploadSegmentImage(_SegmentDraft segment) async {
    setState(() => segment.isUploading = true);
    try {
      final url = await _pickAndUploadImage();
      if (url == null || !mounted) {
        return;
      }
      setState(() => segment.imageController.text = url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sayfa resmi eklendi.')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sayfa resmi yuklenemedi: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => segment.isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Astro Hikayeler')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Yeni Hikaye Ekle'),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Baslik'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Aktif Olsun'),
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
          ),
          const SizedBox(height: 8),
          _sectionTitle('Hikaye Sayfalari'),
          const SizedBox(height: 8),
          ..._segments.asMap().entries.map((entry) {
            final index = entry.key;
            final segment = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Sayfa ${index + 1}'),
                        const Spacer(),
                        if (_segments.length > 1)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                segment.dispose();
                                _segments.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                      ],
                    ),
                    TextField(
                      controller: segment.textController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'Metin'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: segment.imageController,
                      decoration: const InputDecoration(
                        labelText: 'Resim Kaynagi (URL / Asset / Data)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    _presetSelector(
                      selectedValue: segment.imageController.text.trim(),
                      title: 'Sayfa icin sabit gorseller',
                      onSelected: (value) =>
                          setState(() => segment.imageController.text = value),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: segment.isUploading
                            ? null
                            : () => _pickAndUploadSegmentImage(segment),
                        icon: segment.isUploading
                            ? const SizedBox(
                                height: 14,
                                width: 14,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.upload_file),
                        label: Text(
                          segment.isUploading
                              ? 'Resim ekleniyor...'
                              : 'Galeriden Sayfa Resmi Sec',
                        ),
                      ),
                    ),
                    if (segment.imageController.text.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: _buildPreviewImage(
                          segment.imageController.text.trim(),
                          height: 120,
                          errorText: 'Sayfa resmi onizlenemedi',
                        ),
                      ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: segment.durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Sure (ms) - orn 5000',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _segments.add(_SegmentDraft())),
              icon: const Icon(Icons.add),
              label: const Text('Sayfa Ekle'),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _isSaving ? null : _createStory,
            child: _isSaving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Hikayeyi Kaydet'),
          ),
          const SizedBox(height: 20),
          _sectionTitle('Yayindaki Hikayeler'),
          const SizedBox(height: 8),
          StreamBuilder<List<AstroStory>>(
            stream: _service.watchAllStories(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  'Firestore erisim hatasi. Rules izinlerini kontrol edin.',
                );
              }

              final stories = snapshot.data ?? const <AstroStory>[];
              if (stories.isEmpty) {
                return const Text('Henuz hikaye yok.');
              }

              return Column(
                children: stories.map((story) {
                  final isActive = story.isActive;
                  return Card(
                    child: ListTile(
                      title: Text(story.title),
                      subtitle: Text('${story.segments.length} sayfa'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: isActive,
                            onChanged: (v) => _setStoryActive(
                              id: story.id,
                              isActive: v,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deleteStory(story.id),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildPreviewImage(
    String source, {
    required double height,
    required String errorText,
  }) {
    Widget errorBox() => Container(
      height: height,
      alignment: Alignment.center,
      color: Colors.white10,
      child: Text(errorText),
    );

    if (source.startsWith('data:image')) {
      try {
        final commaIndex = source.indexOf(',');
        if (commaIndex < 0) {
          return errorBox();
        }
        final bytes = base64Decode(source.substring(commaIndex + 1));
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            bytes,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => errorBox(),
          ),
        );
      } catch (_) {
        return errorBox();
      }
    }

    if (source.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          source,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => errorBox(),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        source,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => errorBox(),
      ),
    );
  }

  Widget _presetSelector({
    required String title,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _presetImages.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = _presetImages[index];
              final selected = selectedValue == item.url;
              return GestureDetector(
                onTap: () => onSelected(item.url),
                child: Container(
                  width: 86,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? const Color(0xFFF2D28E) : Colors.white24,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.url,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PresetStoryImage {
  const _PresetStoryImage(this.name, this.url);

  final String name;
  final String url;
}

class _SegmentDraft {
  _SegmentDraft() {
    durationController.text = '5000';
  }

  final textController = TextEditingController();
  final imageController = TextEditingController();
  final durationController = TextEditingController();
  bool isUploading = false;

  AstroStorySegment toSegment() {
    final durationMs = int.tryParse(durationController.text.trim()) ?? 5000;
    return AstroStorySegment(
      text: textController.text.trim(),
      imageUrl: imageController.text.trim(),
      duration: Duration(milliseconds: durationMs.clamp(1500, 15000)),
    );
  }

  void dispose() {
    textController.dispose();
    imageController.dispose();
    durationController.dispose();
  }
}
