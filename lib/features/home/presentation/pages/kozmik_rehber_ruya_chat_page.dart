import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/jeton_service.dart';
import '../../../../services/kozmik_rehber_service.dart';

// ─── Rüya Tabiri Chat Sayfası ─────────────────────────────────────────────────

class KozmikRehberRuyaChatPage extends StatefulWidget {
  const KozmikRehberRuyaChatPage({super.key, this.chatId});

  final String? chatId;

  @override
  State<KozmikRehberRuyaChatPage> createState() =>
      _KozmikRehberRuyaChatPageState();
}

class _KozmikRehberRuyaChatPageState extends State<KozmikRehberRuyaChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitLoading = true;

  KozmikRehberUserProfile? _userProfile;
  String? _chatId;
  List<ChatMessage> _memoryMessages = [];

  static const String _welcomeMessage =
      '✨ Merhaba! Ben senin Kozmik Rehberinim ve rüyalarını birlikte keşfetmeye hazırım.\n\n'
      'Geçen gece ya da aklında kalan herhangi bir rüyanı anlat; sembolleri, '
      'duyguları, karakterleri — ne kadar detay verirsen yorum o kadar derinleşir. 🌙';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDocFuture = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final memoryDocFuture = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('kozmikRehberMemory')
        .doc('global')
        .get();

    final userDoc = await userDocFuture;
    final memoryDoc = await memoryDocFuture;

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

    List<ChatMessage> loaded = [];

    if (widget.chatId != null) {
      _chatId = widget.chatId;
      final chatDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('kozmikRehberChats')
          .doc(_chatId)
          .get();
      final data = chatDoc.data() ?? {};
      final rawMsgs = data['messages'] as List<dynamic>? ?? [];
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
      _userProfile = userProfile;
      _messages.addAll(loaded);
      _isInitLoading = false;
    });
  }

  Future<void> _saveChat() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('kozmikRehberChats');

    final lastMsg = _messages.isNotEmpty ? _messages.last.content : '';
    final preview = lastMsg.length > 120 ? lastMsg.substring(0, 120) : lastMsg;

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
        'type': 'ruyaTabiri',
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

  void _showNoTokenDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A0848),
        title: const Text(
          '⚡ Jeton Yetersiz',
          style: TextStyle(color: Color(0xFFF2D293)),
        ),
        content: const Text(
          'Mesaj göndermek için jetonunuz kalmadı.\nKozmik Rehber sayfasından jeton satın alabilir veya reklam izleyerek kazanabilirsiniz.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tamam',
              style: TextStyle(color: Color(0xFFF2D293)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading || _userProfile == null) return;

    // Jeton kontrolü
    final spent = await JetonService.spend();
    if (!spent) {
      if (!mounted) return;
      _showNoTokenDialog();
      return;
    }

    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(role: 'user', content: text));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final reply = await KozmikRehberService.sendRuyaMessage(
        messages: List.unmodifiable(_messages),
        profile: _userProfile!,
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

  static const List<String> _suggestedQuestions = [
    'Düşerken uyandığım bir rüya gördüm, ne anlama geliyor?',
    'Sürekli aynı rüyayı görüyorum, bu ne anlama gelir?',
    'Rüyamda ölen biri vardı, korkutucu muydu?',
    'Rüyamda uçuyordum, bu ne ifade eder?',
    'Rüyamda diş dökülüyordu, ne anlama gelir?',
  ];

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
            child: _isInitLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
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
                                'Rüya Tabiri',
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

                      // Chat list
                      Expanded(
                        child: ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          children: [
                            // Hoş geldin mesajı
                            _WelcomeBubble(message: _welcomeMessage),
                            const SizedBox(height: 16),

                            // Öneri soruları (sadece ilk mesaj yokken)
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
                                        width: 190,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xCC3D1E7A),
                                              Color(0xB32E1568),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: Colors.white24,
                                          ),
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
                            ..._messages.map(
                              (msg) => _ChatBubble(message: msg),
                            ),

                            if (_isLoading) const _TypingIndicator(),
                          ],
                        ),
                      ),

                      // Input bar
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF130535,
                          ).withValues(alpha: 0.95),
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
                                    hintText: 'Rüyanı anlat...',
                                    hintStyle: TextStyle(color: Colors.white38),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 4,
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
                                    colors: [
                                      Color(0xFF7B52C1),
                                      Color(0xFF3D1E7A),
                                    ],
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

// ─── Hoş Geldin Balonu ────────────────────────────────────────────────────────

class _WelcomeBubble extends StatelessWidget {
  const _WelcomeBubble({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF5C2D91), Color(0xFF2E1568)],
              ),
            ),
            child: const Icon(
              Icons.bedtime_rounded,
              color: Color(0xFFF2D293),
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xCC3D1E7A), Color(0xB32E1568)],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
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

// ─── Chat Balonu ──────────────────────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF5C2D91), Color(0xFF2E1568)],
                ),
              ),
              child: const Icon(
                Icons.bedtime_rounded,
                color: Color(0xFFF2D293),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4A2687), Color(0xFF6B3FCC)],
                      )
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xCC3D1E7A), Color(0xB32E1568)],
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: isUser ? const Radius.circular(18) : Radius.zero,
                  topRight: isUser ? Radius.zero : const Radius.circular(18),
                  bottomLeft: const Radius.circular(18),
                  bottomRight: const Radius.circular(18),
                ),
                border: Border.all(
                  color: isUser ? Colors.white24 : Colors.white12,
                ),
              ),
              child: Text(
                message.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─── Yazıyor göstergesi ───────────────────────────────────────────────────────

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
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF5C2D91), Color(0xFF2E1568)],
              ),
            ),
            child: const Icon(
              Icons.bedtime_rounded,
              color: Color(0xFFF2D293),
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xCC3D1E7A), Color(0xB32E1568)],
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: Colors.white12),
            ),
            child: FadeTransition(
              opacity: _anim,
              child: const Text(
                '✦ ✦ ✦',
                style: TextStyle(
                  color: Color(0xFFF2D293),
                  fontSize: 14,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
