import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/astro_story.dart';
import '../../../../services/astro_story_service.dart';

Widget _storyImage({
  required String source,
  required BoxFit fit,
  required Widget error,
}) {
  if (source.startsWith('assets/')) {
    return Image.asset(
      source,
      fit: fit,
      errorBuilder: (_, _, _) => error,
    );
  }

  if (source.startsWith('data:image')) {
    try {
      final commaIndex = source.indexOf(',');
      if (commaIndex > 0) {
        final bytes = base64Decode(source.substring(commaIndex + 1));
        return Image.memory(
          bytes,
          fit: fit,
          errorBuilder: (_, _, _) => error,
        );
      }
    } catch (_) {
      return error;
    }
    return error;
  }

  return Image.network(
    source,
    fit: fit,
    errorBuilder: (_, _, _) => error,
  );
}

class AstroStoryStrip extends StatelessWidget {
  const AstroStoryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userStream = uid == null
        ? Stream.value(null)
        : FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      stream: userStream,
      builder: (context, userSnap) {
        final data = userSnap.data?.data() ?? const <String, dynamic>{};
        final sun = ((data['zodiacSign'] as String?)?.trim().isNotEmpty ?? false)
            ? (data['zodiacSign'] as String).trim()
            : 'Burcun';
        final moon = ((data['moonSign'] as String?)?.trim().isNotEmpty ?? false)
            ? (data['moonSign'] as String).trim()
            : 'Ay Burcun';
        final rising = ((data['risingSign'] as String?)?.trim().isNotEmpty ?? false)
            ? (data['risingSign'] as String).trim()
            : 'Yukselen';

        final special = AstroStory.special(
          id: 'special_${uid ?? 'guest'}',
          title: 'Sana Ozel',
          subtitle: 'Gunun mesaji',
          text:
              '$sun etkisiyle odagini koru. $moon ruh halini dengelerken $rising seni yeni adimlara tasiyor.',
        );

        return StreamBuilder<List<AstroStory>>(
          stream: const AstroStoryService().watchActiveStories(),
          builder: (context, storySnap) {
            final generalStories = storySnap.data ?? const <AstroStory>[];
            final stories = [special, ...generalStories];

            if (stories.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 130,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    scrollDirection: Axis.horizontal,
                    itemCount: stories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final story = stories[index];
                      return _StoryBubble(
                        story: story,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AstroStoryViewerScreen(
                                stories: stories,
                                initialStoryIndex: index,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _StoryBubble extends StatelessWidget {
  const _StoryBubble({required this.story, required this.onTap});

  final AstroStory story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 84,
        child: Column(
          children: [
            Container(
              width: 78,
              height: 78,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF2D28E), Color(0xFFB56A2A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF0B1026),
                ),
                child: ClipOval(
                  child: story.thumbnailUrl.isNotEmpty
                      ? _storyImage(
                          source: story.thumbnailUrl,
                          fit: BoxFit.cover,
                          error: _fallbackIcon(story),
                        )
                      : _fallbackIcon(story),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              story.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackIcon(AstroStory story) {
    return Container(
      color: const Color(0xFF1E2242),
      child: Icon(
        story.isSpecial ? Icons.auto_awesome : Icons.brightness_3_outlined,
        color: const Color(0xFFF2D28E),
        size: 28,
      ),
    );
  }
}

class AstroStoryViewerScreen extends StatefulWidget {
  const AstroStoryViewerScreen({
    super.key,
    required this.stories,
    required this.initialStoryIndex,
  });

  final List<AstroStory> stories;
  final int initialStoryIndex;

  @override
  State<AstroStoryViewerScreen> createState() => _AstroStoryViewerScreenState();
}

class _AstroStoryViewerScreenState extends State<AstroStoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late int _storyIndex;
  int _segmentIndex = 0;
  late AnimationController _progress;

  AstroStory get _story => widget.stories[_storyIndex];
  AstroStorySegment get _segment => _story.segments[_segmentIndex];

  @override
  void initState() {
    super.initState();
    _storyIndex = widget.initialStoryIndex.clamp(0, widget.stories.length - 1);
    _progress = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _next();
        }
      });
    _startCurrent();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  void _startCurrent() {
    _progress
      ..stop()
      ..duration = _segment.duration
      ..value = 0
      ..forward();
  }

  void _next() {
    if (_segmentIndex < _story.segments.length - 1) {
      setState(() => _segmentIndex++);
      _startCurrent();
      return;
    }

    if (_storyIndex < widget.stories.length - 1) {
      setState(() {
        _storyIndex++;
        _segmentIndex = 0;
      });
      _startCurrent();
      return;
    }

    Navigator.of(context).pop();
  }

  void _previous() {
    if (_segmentIndex > 0) {
      setState(() => _segmentIndex--);
      _startCurrent();
      return;
    }

    if (_storyIndex > 0) {
      setState(() {
        _storyIndex--;
        _segmentIndex = widget.stories[_storyIndex].segments.length - 1;
      });
      _startCurrent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final width = MediaQuery.of(context).size.width;
          if (details.localPosition.dx < width * 0.35) {
            _previous();
          } else {
            _next();
          }
        },
        onLongPressStart: (_) => _progress.stop(),
        onLongPressEnd: (_) => _progress.forward(),
        child: Stack(
          children: [
            Positioned.fill(
              child: _segment.imageUrl.isNotEmpty
                  ? _storyImage(
                      source: _segment.imageUrl,
                      fit: BoxFit.cover,
                      error: _storyGradientFallback(),
                    )
                  : _storyGradientFallback(),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x55000000), Color(0x99000000)],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(_story.segments.length, (i) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                minHeight: 3,
                                value: i < _segmentIndex
                                    ? 1
                                    : (i == _segmentIndex ? _progress.value : 0),
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _story.title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _segment.text,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storyGradientFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1E4A), Color(0xFF381F58)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.auto_awesome, color: Color(0xFFF2D28E), size: 80),
      ),
    );
  }
}
