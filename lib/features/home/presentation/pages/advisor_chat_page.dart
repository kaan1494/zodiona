import 'package:flutter/material.dart';

import '../../../../services/advisor_chat_service.dart';

class AdvisorChatPage extends StatefulWidget {
  const AdvisorChatPage({
    super.key,
    required this.chatId,
    required this.advisorName,
    required this.consultationType,
    required this.advisorImagePath,
  });

  final String chatId;
  final String advisorName;
  final String consultationType;
  final String advisorImagePath;

  @override
  State<AdvisorChatPage> createState() => _AdvisorChatPageState();
}

class _AdvisorChatPageState extends State<AdvisorChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _service = AdvisorChatService();
  bool _isSending = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;
    setState(() => _isSending = true);
    _textController.clear();
    try {
      await _service.sendMessage(
        chatId: widget.chatId,
        text: text,
        senderType: 'user',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030B2A),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xCC04184A), Color(0xF004133C)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                const Divider(color: Color(0x33FFFFFF), height: 1),
                Expanded(child: _buildMessages()),
                _buildInputBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEAD8AE), width: 1.4),
            ),
            child: ClipOval(
              child: Image.asset(
                widget.advisorImagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFF2D3566),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFFEAD8AE),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.advisorName,
                  style: const TextStyle(
                    color: Color(0xFFF2D9A6),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.consultationType,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF1E7A3E).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Çevrimiçi',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return StreamBuilder<List<AdvisorChatMessage>>(
      stream: _service.messagesStream(widget.chatId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFF2D9A6)),
          );
        }

        final messages = snap.data ?? [];

        if (messages.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 56,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Danışmanınıza sorunuzu yazın.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'En kısa sürede yanıt alacaksınız.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          }
        });

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          itemCount: messages.length,
          itemBuilder: (context, i) {
            return _MessageBubble(
              message: messages[i],
              advisorName: widget.advisorName,
              advisorImagePath: widget.advisorImagePath,
            );
          },
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0830).withValues(alpha: 0.92),
        border: const Border(top: BorderSide(color: Color(0x33FFFFFF))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1E5A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x55F2D9A6)),
              ),
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Sorunuzu yazın...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: _isSending ? Colors.grey.shade700 : const Color(0xFFF2D9A6),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _isSending ? null : _sendMessage,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.send_rounded,
                  color: Color(0xFF2E3B67),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.advisorName,
    required this.advisorImagePath,
  });

  final AdvisorChatMessage message;
  final String advisorName;
  final String advisorImagePath;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isFromUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEAD8AE), width: 1.2),
              ),
              child: ClipOval(
                child: Image.asset(
                  advisorImagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: const Color(0xFF2D3566),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFFEAD8AE),
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFFF2D9A6)
                    : const Color(0xFF2A2F6A),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? const Color(0xFF2E3B67) : Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 6),
        ],
      ),
    );
  }
}
