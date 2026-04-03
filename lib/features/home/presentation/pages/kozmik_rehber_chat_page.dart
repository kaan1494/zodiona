import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/kozmik_rehber_service.dart';
import '../widgets/natal_chart_widget.dart';
import 'birth_chart_detail_page.dart';

class KozmikRehberChatPage extends StatefulWidget {
  const KozmikRehberChatPage({super.key, this.chatId});

  /// Geçmiş sohbet açılıyorsa doldurulur; null ise yeni sohbet başlatılır.
  final String? chatId;

  @override
  State<KozmikRehberChatPage> createState() => _KozmikRehberChatPageState();
}

class _KozmikRehberChatPageState extends State<KozmikRehberChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sohbet geçmişi
  final List<ChatMessage> _messages = [];

  // Yükleme durumu
  bool _isLoading = false;

  // Kullanıcı profili (Firestore'dan)
  KozmikRehberUserProfile? _profile;

  // Aktif sohbet belgesi ID'si (null = henüz kaydedilmedi)
  String? _chatId;

  // Önceki oturumlardan gelen global hafıza (tutarlılık için GPT'ye geçirilir)
  List<ChatMessage> _memoryMessages = [];

  static const List<String> _suggestedQuestions = [
    'Doğum haritama göre en uygun kariyer alanım nedir?',
    'Güçlü olduğumu sandığım ama aslında beni yoran tarafım ne?',
    'İlişkilerimi etkileyen en belirgin harita özelliğim hangisi?',
    'Hayatımda en şanslı olduğum alan hangisi ve bu potansiyeli nasıl kullanabilirim?',
    'Venüs burcum aşk ve ilişkilerimi nasıl şekillendiriyor?',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Kullanıcı belgesi + geçmiş sohbet + global hafıza eş zamanlı yükle
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

    // Global hafızayı yükle
    final rawMemory = memoryDoc.data()?['messages'] as List<dynamic>? ?? [];
    final memory = rawMemory
        .map(
          (m) => ChatMessage(
            role: (m as Map<String, dynamic>)['role'] as String,
            content: m['content'] as String,
          ),
        )
        .toList();

    // Geçmiş sohbet yükleme
    List<ChatMessage> loaded = [];
    if (widget.chatId != null) {
      _chatId = widget.chatId;
      final chatDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('kozmikRehberChats')
          .doc(_chatId)
          .get();
      final rawMsgs = chatDoc.data()?['messages'] as List<dynamic>? ?? [];
      loaded = rawMsgs
          .map(
            (m) => ChatMessage(
              role: (m as Map<String, dynamic>)['role'] as String,
              content: m['content'] as String,
            ),
          )
          .toList();
    }

    if (!mounted) return;
    setState(() {
      _profile = KozmikRehberUserProfile.fromFirestore(userDoc.data() ?? {});
      _memoryMessages = memory;
      _messages.addAll(loaded);
    });
  }

  /// Mevcut sohbeti Firestore'a kaydeder / günceller.
  /// Mesajlar 50 ile sınırlandırılır.
  Future<void> _saveChat() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('kozmikRehberChats');

    final lastMsg = _messages.isNotEmpty ? _messages.last.content : '';
    final preview = lastMsg.length > 120 ? lastMsg.substring(0, 120) : lastMsg;

    // Firestore'da en fazla 50 mesaj sakla
    const int maxStored = 50;
    final start = _messages.length > maxStored
        ? _messages.length - maxStored
        : 0;
    final msgs = _messages
        .sublist(start)
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();

    if (_chatId == null) {
      final docRef = await ref.add({
        'type': 'dogumHaritasi',
        'startedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'previewText': preview,
        'messages': msgs,
      });
      _chatId = docRef.id;
      // Admin panelinin bu kullanıcıyı görebilmesi için flag yaz
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

  /// Global hafızayı günceller — son 50 mesaj tüm oturumlar boyunca korunur.
  Future<void> _updateMemory() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    const int memorySize = 50;
    final start = _messages.length > memorySize
        ? _messages.length - memorySize
        : 0;
    final memoryToSave = _messages.sublist(start);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('kozmikRehberMemory')
        .doc('global')
        .set({
          'updatedAt': FieldValue.serverTimestamp(),
          'messages': memoryToSave
              .map((m) => {'role': m.role, 'content': m.content})
              .toList(),
        });
    _memoryMessages = memoryToSave;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _fillQuestion(String question) {
    _controller.text = question;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading || _profile == null) return;

    _controller.clear();

    setState(() {
      _messages.add(ChatMessage(role: 'user', content: text));
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final reply = await KozmikRehberService.sendMessage(
        messages: List.unmodifiable(_messages),
        profile: _profile!,
        memoryMessages: _memoryMessages,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(role: 'assistant', content: reply));
      });
      await _saveChat();
      await _updateMemory();
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
  Widget build(BuildContext context) {
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
                      const Expanded(
                        child: Text(
                          'Doğum Haritam',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFF8E5BE),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const BirthChartDetailPage(),
                          ),
                        ),
                        icon: const Icon(
                          Icons.open_in_full_rounded,
                          color: Color(0xFFF2D293),
                          size: 22,
                        ),
                        tooltip: 'Tam haritayı gör',
                      ),
                    ],
                  ),
                ),

                // Chat list
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    children: [
                      // Natal chart at top
                      const NatalChartDisplayWidget(chartSize: 310),
                      const SizedBox(height: 20),

                      // Divider with label
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

                      // Suggested questions — only before first message
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
                                onTap: () =>
                                    _fillQuestion(_suggestedQuestions[index]),
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
                                      fontWeight: FontWeight.w400,
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

                      // Chat messages
                      ..._messages.map((msg) => _ChatBubble(message: msg)),

                      // Typing indicator
                      if (_isLoading) const _TypingIndicator(),
                    ],
                  ),
                ),

                // Chat input bar
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF5C2D91), Color(0xFF2E1568)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: IconButton(
                          onPressed: _send,
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Color(0xFFF2D293),
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

// ---------------------------------------------------------------------------
// Chat bubble widget
// ---------------------------------------------------------------------------
class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  bool get _isUser => message.role == 'user';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: _isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isUser) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8, top: 2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF5C2D91), Color(0xFF2E1568)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFFF2D293),
                size: 16,
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(_isUser ? 18 : 4),
                  bottomRight: Radius.circular(_isUser ? 4 : 18),
                ),
                gradient: _isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF5C2D91), Color(0xFF3D1E7A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: _isUser ? null : Colors.white.withValues(alpha: 0.07),
                border: Border.all(
                  color: _isUser
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: _isUser
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.92),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Typing indicator (three animated dots)
// ---------------------------------------------------------------------------
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 8, top: 2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF5C2D91), Color(0xFF2E1568)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFFF2D293),
              size: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              color: Colors.white.withValues(alpha: 0.07),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final t = (_ctrl.value - i * 0.15).clamp(0.0, 1.0);
                    final opacity =
                        (0.3 + 0.7 * (t < 0.5 ? t * 2 : (1 - t) * 2)).clamp(
                          0.3,
                          1.0,
                        );
                    return Container(
                      width: 7,
                      height: 7,
                      margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(
                          0xFFF2D293,
                        ).withValues(alpha: opacity),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
