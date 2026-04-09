import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/jeton_service.dart';
import '../../../../services/kozmik_rehber_service.dart';
import '../../../../services/tarot_selection_service.dart';
import 'tarot_card_page.dart';

// ─── Tarot Yorumu Chat Sayfası ───────────────────────────────────────────────

class KozmikRehberTarotChatPage extends StatefulWidget {
  const KozmikRehberTarotChatPage({super.key, this.chatId});

  final String? chatId;

  @override
  State<KozmikRehberTarotChatPage> createState() =>
      _KozmikRehberTarotChatPageState();
}

class _KozmikRehberTarotChatPageState extends State<KozmikRehberTarotChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitLoading = true;

  KozmikRehberUserProfile? _userProfile;
  List<TarotSelectedCard> _selectedCards = [];
  List<Map<String, String>> _cardContext = [];

  String? _chatId;
  List<ChatMessage> _memoryMessages = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final results = await Future.wait([
      FirebaseFirestore.instance.collection('users').doc(uid).get(),
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('kozmikRehberMemory')
          .doc('global')
          .get(),
      TarotSelectionService.getPreviousSelection(),
    ]);

    final userDoc = results[0] as DocumentSnapshot<Map<String, dynamic>>;
    final memoryDoc = results[1] as DocumentSnapshot<Map<String, dynamic>>;
    final cards = results[2] as List<TarotSelectedCard>;

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
    List<TarotSelectedCard> chatCards = cards;

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
      // Chat'e kaydedilmiş kartları kullan
      final rawCards = data['cards'] as List<dynamic>? ?? [];
      if (rawCards.isNotEmpty) {
        chatCards = rawCards
            .map((c) => TarotSelectedCard.fromJson(c as Map<String, dynamic>))
            .toList();
      }
    }

    if (!mounted) return;
    setState(() {
      _userProfile = userProfile;
      _selectedCards = chatCards;
      _cardContext = chatCards
          .map((c) => {'name': c.name, 'description': c.description})
          .toList();
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
        'type': 'tarotYorumu',
        'cards': _selectedCards.map((c) => c.toJson()).toList(),
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
      final reply = await KozmikRehberService.sendTarotMessage(
        messages: List.unmodifiable(_messages),
        profile: _userProfile!,
        cards: _cardContext,
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

  List<String> get _suggestedQuestions {
    if (_cardContext.isEmpty) return [];
    final names = _cardContext.map((c) => c['name']!).join(', ');
    return [
      '$names kartlarının genel mesajı ne?',
      'Bu kartlar aşk hayatım hakkında ne söylüyor?',
      'Bu kartlar kariyer ve para konusunda ne öneriyor?',
      'Bu kartların uyarısı var mı, nelere dikkat etmeliyim?',
      'Bu kartların birlikte yorumu nedir?',
    ];
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
                                'Tarot Yorumu',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFF8E5BE),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            // Tarot seç sayfasına git
                            IconButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const TarotCardPage(),
                                ),
                              ),
                              icon: const Icon(
                                Icons.style_rounded,
                                color: Color(0xFFF2D293),
                                size: 22,
                              ),
                              tooltip: 'Kart seç',
                            ),
                          ],
                        ),
                      ),

                      // Chat list
                      Expanded(
                        child: _selectedCards.isEmpty
                            ? _buildNoCards()
                            : ListView(
                                controller: _scrollController,
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  8,
                                ),
                                children: [
                                  // Seçilen kartlar
                                  _TarotCardsDisplay(cards: _selectedCards),
                                  const SizedBox(height: 16),

                                  // Divider
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Divider(
                                          color: Colors.white24,
                                          height: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          'Kozmik Rehbere Sor',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Divider(
                                          color: Colors.white24,
                                          height: 1,
                                        ),
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
                                                      offset: _controller
                                                          .text
                                                          .length,
                                                    ),
                                                  );
                                            },
                                            child: Container(
                                              width: 190,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
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
                      if (_selectedCards.isNotEmpty)
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
                                      hintText: 'Buraya yazın...',
                                      hintStyle: TextStyle(
                                        color: Colors.white38,
                                      ),
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

  Widget _buildNoCards() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.style_rounded,
              color: Colors.white.withValues(alpha: 0.15),
              size: 72,
            ),
            const SizedBox(height: 20),
            const Text(
              'Henüz tarot kartı seçmedin.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tarot sayfasından önce kartlarını seç, sonra Kozmik Rehber\'e sor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const TarotCardPage(),
                  ),
                );
                // Geri döndüğünde kartları yenile
                final cards =
                    await TarotSelectionService.getPreviousSelection();
                if (!mounted) return;
                setState(() {
                  _selectedCards = cards;
                  _cardContext = cards
                      .map(
                        (c) => {'name': c.name, 'description': c.description},
                      )
                      .toList();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B52C1), Color(0xFF3D1E7A)],
                  ),
                  border: Border.all(
                    color: const Color(0xFFF2D293).withValues(alpha: 0.4),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.style_rounded,
                      color: Color(0xFFF2D293),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tarot Kartı Seç',
                      style: TextStyle(
                        color: Color(0xFFF2D293),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tarot Cards Display ─────────────────────────────────────────────────────

class _TarotCardsDisplay extends StatelessWidget {
  const _TarotCardsDisplay({required this.cards});
  final List<TarotSelectedCard> cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          child: Row(
            children: [
              const Icon(
                Icons.style_rounded,
                color: Color(0xFFF2D293),
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                'Seçtiğin Kartlar',
                style: TextStyle(
                  color: Color(0xFFF2D293),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.62,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: cards.length,
          itemBuilder: (_, i) => _TarotCardItem(card: cards[i]),
        ),
      ],
    );
  }
}

class _TarotCardItem extends StatelessWidget {
  const _TarotCardItem({required this.card});
  final TarotSelectedCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xCC3D1E7A), Color(0xB32E1568)],
        ),
        border: Border.all(
          color: const Color(0xFFF2D293).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.asset(
                card.asset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFF2E1568),
                  child: const Icon(
                    Icons.style_rounded,
                    color: Color(0xFFF2D293),
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.name,
                    style: const TextStyle(
                      color: Color(0xFFF2D293),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Text(
                      card.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 9.5,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
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
