import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'kozmik_rehber_chat_page.dart';
import 'kozmik_rehber_tarot_chat_page.dart';
import 'kozmik_rehber_uyum_chat_page.dart';

class KozmikRehberHistoryPage extends StatelessWidget {
  const KozmikRehberHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0520),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xCC1A0848), Color(0xEE130535)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 14, 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Sohbet Geçmişi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFF8E5BE),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: uid == null
                      ? const Center(
                          child: Text(
                            'Giriş yapmanız gerekiyor.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection('kozmikRehberChats')
                              .orderBy('updatedAt', descending: true)
                              .snapshots(),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final docs = snap.data?.docs ?? [];

                            if (docs.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      size: 64,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Henüz sohbet geçmişin yok.',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: docs.length,
                              itemBuilder: (context, i) {
                                final data = docs[i].data();
                                final chatId = docs[i].id;
                                final type =
                                    data['type'] as String? ?? 'dogumHaritasi';
                                final preview =
                                    data['previewText'] as String? ?? '';
                                final updatedAt =
                                    (data['updatedAt'] as Timestamp?)?.toDate();
                                final msgCount =
                                    (data['messages'] as List<dynamic>?)
                                        ?.length ??
                                    0;

                                final typeLabel = switch (type) {
                                  'dogumHaritasi' => 'Doğum Haritası Analizi',
                                  'burcYorumu' => 'Burç Yorumu',
                                  'tarotYorumu' => 'Tarot Yorumu',
                                  'uyumAnalizi' => 'Uyum Analizi',
                                  _ => type,
                                };

                                final typeIcon = switch (type) {
                                  'dogumHaritasi' => Icons.circle_outlined,
                                  'burcYorumu' => Icons.stars_rounded,
                                  'tarotYorumu' => Icons.style_rounded,
                                  'uyumAnalizi' => Icons.favorite_rounded,
                                  _ => Icons.auto_awesome,
                                };

                                // Uyum: arkadaş adını subtitle olarak göster
                                final friendName =
                                    data['friendName'] as String?;

                                final dateStr = updatedAt != null
                                    ? '${updatedAt.day.toString().padLeft(2, '0')}.'
                                          '${updatedAt.month.toString().padLeft(2, '0')}.'
                                          '${updatedAt.year}'
                                    : '';

                                return GestureDetector(
                                  onTap: () {
                                    switch (type) {
                                      case 'uyumAnalizi':
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                KozmikRehberUyumChatPage(
                                                  chatId: chatId,
                                                ),
                                          ),
                                        );
                                      case 'tarotYorumu':
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                KozmikRehberTarotChatPage(
                                                  chatId: chatId,
                                                ),
                                          ),
                                        );
                                      default:
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                KozmikRehberChatPage(
                                                  chatId: chatId,
                                                ),
                                          ),
                                        );
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xCC3D1E7A),
                                          Color(0xB32E1568),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.12,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF5C2D91),
                                                  Color(0xFF2E1568),
                                                ],
                                              ),
                                            ),
                                            child: Icon(
                                              typeIcon,
                                              color: const Color(0xFFF2D293),
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      typeLabel,
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFFF2D293,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      dateStr,
                                                      style: const TextStyle(
                                                        color: Colors.white38,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Uyum: arkadaş adı subtitle
                                                if (friendName != null &&
                                                    friendName.isNotEmpty) ...[
                                                  const SizedBox(height: 3),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.person_outline,
                                                        color: Colors.white54,
                                                        size: 13,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        friendName,
                                                        style: const TextStyle(
                                                          color: Colors.white54,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                                if (preview.isNotEmpty) ...[
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    preview,
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.65,
                                                          ),
                                                      fontSize: 12,
                                                      height: 1.4,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                                const SizedBox(height: 5),
                                                Text(
                                                  '$msgCount mesaj',
                                                  style: const TextStyle(
                                                    color: Colors.white38,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.chevron_right_rounded,
                                            color: Colors.white38,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
