import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/kozmik_rehber_service.dart';

// ─── Uyum Analizi Arkadaş Seç + Chat Sayfası ────────────────────────────────

class KozmikRehberUyumChatPage extends StatefulWidget {
  const KozmikRehberUyumChatPage({
    super.key,
    this.chatId,
    this.friendId,
    this.friendData,
  });

  /// Geçmiş sohbet açılıyorsa
  final String? chatId;

  /// Yeni sohbet başlatılıyorsa seçilen arkadaş
  final String? friendId;
  final Map<String, dynamic>? friendData;

  @override
  State<KozmikRehberUyumChatPage> createState() =>
      _KozmikRehberUyumChatPageState();
}

class _KozmikRehberUyumChatPageState extends State<KozmikRehberUyumChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  KozmikRehberUserProfile? _userProfile;
  KozmikRehberFriendProfile? _friendProfile;
  List<ChatMessage> _memoryMessages = [];

  String? _chatId;

  // Arkadaş listesi için (sadece arkadaş seçim ekranında kullanılır)
  Map<String, Map<String, dynamic>> _friends = {};
  bool _loadingFriends = false;

  // Hangi arkadaş seçildi (ID)
  String? _selectedFriendId;

  static const List<String> _suggestedQuestions = [
    'İkimiz arasındaki en güçlü uyum noktası nedir?',
    'Bu ilişkide karşılaşabileceğimiz zorluklar neler?',
    'Birbirimizi nasıl daha iyi anlayabiliriz?',
    'İkimizin Venüs burcları ilişkimizi nasıl etkiliyor?',
    'Bu ilişkide hangi alanlar çok uyumlu, hangiler zorlu?',
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _loadingFriends = true);

    final results = await Future.wait([
      FirebaseFirestore.instance.collection('users').doc(uid).get(),
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('kozmikRehberMemory')
          .doc('global')
          .get(),
    ]);

    final userDoc = results[0];
    final memoryDoc = results[1];

    final rawMemory = memoryDoc.data()?['messages'] as List<dynamic>? ?? [];
    _memoryMessages = rawMemory
        .map(
          (m) => ChatMessage(
            role: (m as Map<String, dynamic>)['role'] as String,
            content: m['content'] as String,
          ),
        )
        .toList();

    final userProfile = KozmikRehberUserProfile.fromFirestore(
      userDoc.data() ?? {},
    );

    // Arkadaşları yükle
    final rawFriends =
        userDoc.data()?['compatibilityFriends'] as Map<String, dynamic>? ?? {};
    final friends = rawFriends.map(
      (k, v) => MapEntry(k, v as Map<String, dynamic>),
    );

    if (!mounted) return;
    setState(() {
      _userProfile = userProfile;
      _friends = friends;
      _loadingFriends = false;
    });

    // Eğer önceden arkadaş seçildiyse veya geçmiş chat açılıyorsa
    if (widget.friendId != null && widget.friendData != null) {
      _selectFriend(widget.friendId!, widget.friendData!);
    } else if (widget.chatId != null) {
      await _loadExistingChat(uid, widget.chatId!);
    }
  }

  void _selectFriend(String friendId, Map<String, dynamic> data) {
    setState(() {
      _selectedFriendId = friendId;
      _friendProfile = KozmikRehberFriendProfile.fromData(data);
    });
  }

  Future<void> _loadExistingChat(String uid, String chatId) async {
    _chatId = chatId;

    final chatDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('kozmikRehberChats')
        .doc(chatId)
        .get();

    final data = chatDoc.data() ?? {};
    final friendId = data['friendId'] as String?;
    final rawMsgs = data['messages'] as List<dynamic>? ?? [];
    final msgs = rawMsgs
        .map(
          (m) => ChatMessage(
            role: (m as Map<String, dynamic>)['role'] as String,
            content: m['content'] as String,
          ),
        )
        .toList();

    if (!mounted) return;

    // Arkadaş verisini yükle
    if (friendId != null && _friends.containsKey(friendId)) {
      _selectFriend(friendId, _friends[friendId]!);
    } else if (friendId != null) {
      setState(() {
        _selectedFriendId = friendId;
      });
    }

    setState(() => _messages.addAll(msgs));
  }

  Future<void> _saveChat() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || _friendProfile == null) return;

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('kozmikRehberChats');

    final lastMsg = _messages.isNotEmpty ? _messages.last.content : '';
    final preview = lastMsg.length > 120 ? lastMsg.substring(0, 120) : lastMsg;

    const int maxStored = 50;
    final start =
        _messages.length > maxStored ? _messages.length - maxStored : 0;
    final msgs = _messages
        .sublist(start)
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();

    if (_chatId == null) {
      final docRef = await ref.add({
        'type': 'uyumAnalizi',
        'friendId': _selectedFriendId,
        'friendName': _friendProfile!.name,
        'startedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'previewText': preview,
        'messages': msgs,
      });
      _chatId = docRef.id;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'hasKozmikChats': true,
      });
    } else {
      await ref.doc(_chatId).update({
        'updatedAt': FieldValue.serverTimestamp(),
        'previewText': preview,
        'messages': msgs,
      });
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading || _userProfile == null || _friendProfile == null) {
      return;
    }

    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(role: 'user', content: text));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final reply = await KozmikRehberService.sendUyumMessage(
        messages: List.unmodifiable(_messages),
        userProfile: _userProfile!,
        friendProfile: _friendProfile!,
        memoryMessages: _memoryMessages,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(role: 'assistant', content: reply));
      });
      await _saveChat();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            role: 'assistant',
            content: 'Üzgünüm, bir sorun oluştu. Lütfen tekrar dene.\n\n($e)',
          ),
        );
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Arkadaş seçilmediyse → arkadaş listesi göster
    if (_selectedFriendId == null && widget.chatId == null) {
      return _buildFriendSelectScreen();
    }
    return _buildChatScreen();
  }

  // ── Arkadaş Seçim Ekranı ──────────────────────────────────────────────────

  Widget _buildFriendSelectScreen() {
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
                          'Uyum Analizi',
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

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(
                    'Kozmik Rehber ile hangi ilişkini analiz etmek istiyorsun?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Friends list
                Expanded(
                  child: _loadingFriends
                      ? const Center(child: CircularProgressIndicator())
                      : _friends.isEmpty
                      ? _buildNoFriends()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: _friends.length,
                          itemBuilder: (_, i) {
                            final entry = _friends.entries.elementAt(i);
                            return _FriendCard(
                              data: entry.value,
                              onTap: () =>
                                  _selectFriend(entry.key, entry.value),
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

  Widget _buildNoFriends() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            color: Colors.white.withValues(alpha: 0.15),
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz uyum eklediğin biri yok.',
            style: TextStyle(color: Colors.white38, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            'Uyum sayfasından arkadaş veya partner ekleyebilirsin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ── Chat Ekranı ───────────────────────────────────────────────────────────

  Widget _buildChatScreen() {
    final friend = _friendProfile;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0520),
      resizeToAvoidBottomInset: true,
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
                      Expanded(
                        child: Text(
                          'Uyum Analizi',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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

                // Chat list
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    children: [
                      // Arkadaş bilgi kartı
                      if (friend != null) _FriendInfoCard(friend: friend),
                      const SizedBox(height: 16),

                      // Divider
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: Colors.white24, height: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Kozmik Rehbere Sor',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: Colors.white24, height: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Öneri soruları
                      if (_messages.isEmpty) ...[
                        SizedBox(
                          height: 72,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            itemCount: _suggestedQuestions.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _controller.text =
                                      _suggestedQuestions[index];
                                  _controller.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _controller.text.length,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 180,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xCC3D1E7A),
                                        Color(0xB32E1568),
                                      ],
                                    ),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Text(
                                    _suggestedQuestions[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Chat mesajları
                      ..._messages.map((msg) => _ChatBubble(message: msg)),

                      if (_isLoading) const _TypingIndicator(),
                    ],
                  ),
                ),

                // Input bar
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF130535).withValues(alpha: 0.95),
                    border: const Border(
                      top: BorderSide(color: Colors.white12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white.withValues(alpha: 0.08),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Buraya yazın...',
                              hintStyle: TextStyle(color: Colors.white38),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: 3,
                            minLines: 1,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _send,
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF7B52C1), Color(0xFF3D1E7A)],
                            ),
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
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

// ─── Friend Card (seçim ekranında) ──────────────────────────────────────────

class _FriendCard extends StatelessWidget {
  const _FriendCard({required this.data, required this.onTap});

  final Map<String, dynamic> data;
  final VoidCallback onTap;

  String _sign(dynamic v) {
    final s = (v as String? ?? '').trim();
    return switch (s) {
      'Koc' => 'Koç',
      'Boga' => 'Boğa',
      'Ikizler' => 'İkizler',
      'Yengec' => 'Yengeç',
      'Basak' => 'Başak',
      'Oglak' => 'Oğlak',
      'Balik' => 'Balık',
      _ => s.isEmpty ? '?' : s,
    };
  }

  @override
  Widget build(BuildContext context) {
    final name = (data['name'] as String? ?? 'İsimsiz').trim();
    final sun = _sign(data['zodiacSign']);
    final moon = _sign(data['moonSign']);
    final rising = _sign(data['risingSign']);
    final rel = (data['relationshipType'] as String? ?? '').trim();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xCC3D1E7A), Color(0xB32E1568)],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5C2D91).withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF5C2D91), Color(0xFF2E1568)],
                ),
                border: Border.all(
                  color: const Color(0xFFF2D293).withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Color(0xFFF2D293),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '☉ $sun  ☾ $moon  ↑ $rising',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 12,
                    ),
                  ),
                  if (rel.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      rel,
                      style: const TextStyle(
                        color: Color(0xFFF2D293),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFF2D293),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Friend Info Card (chat ekranı üstünde) ──────────────────────────────────

class _FriendInfoCard extends StatelessWidget {
  const _FriendInfoCard({required this.friend});

  final KozmikRehberFriendProfile friend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xCC3D1E7A), Color(0x993D1E7A)],
        ),
        border: Border.all(color: const Color(0xFFF2D293).withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFF2D293),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                friend.name,
                style: const TextStyle(
                  color: Color(0xFFF2D293),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              if (friend.age != null)
                Text(
                  '(${friend.age} yaş)',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 13,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _InfoChip(label: '☉ ${friend.sunSign}'),
              _InfoChip(label: '☾ ${friend.moonSign}'),
              _InfoChip(label: '↑ ${friend.risingSign}'),
            ],
          ),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.cake_outlined, text: friend.birthDate),
          if (friend.birthTime != 'Bilinmiyor')
            _InfoRow(
              icon: Icons.schedule_outlined,
              text: friend.birthTime,
            ),
          if (friend.birthPlace != 'Bilinmiyor')
            _InfoRow(icon: Icons.location_on_outlined, text: friend.birthPlace),
          if (friend.job != 'Bilinmiyor')
            _InfoRow(icon: Icons.work_outline, text: friend.job),
          if (friend.relationshipType != 'Bilinmiyor')
            _InfoRow(
              icon: Icons.favorite_border_rounded,
              text: friend.relationshipType,
            ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF4B1FA8).withValues(alpha: 0.6),
        border: Border.all(
          color: const Color(0xFFF2D293).withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFF2D293),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Chat Bubble ─────────────────────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: isUser
              ? const LinearGradient(
                  colors: [Color(0xFF4B2D9A), Color(0xFF7B52C1)],
                )
              : null,
          color: isUser ? null : const Color(0xFF1A1040),
          border: isUser
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isUser) ...[
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFF2D293),
                size: 16,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                message.content,
                style: TextStyle(
                  color: isUser
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.92),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Typing Indicator ────────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FadeTransition(
        opacity: _anim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFF1A1040),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFFF2D293), size: 16),
              SizedBox(width: 8),
              Text(
                '···',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
