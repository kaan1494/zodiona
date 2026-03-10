import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key, this.entryPoint = 'profile'});

  final String entryPoint;

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _questionController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  String _userName = 'Bilinmiyor';

  @override
  void initState() {
    super.initState();
    _prefillUserData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _questionController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _prefillUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    if ((user.email ?? '').trim().isNotEmpty) {
      _emailController.text = user.email!.trim();
    }

    String resolvedName = (user.displayName ?? '').trim();
    if (resolvedName.isEmpty) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      resolvedName = (doc.data()?['name'] as String?)?.trim() ?? '';
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _userName = resolvedName.isEmpty ? 'Bilinmiyor' : resolvedName;
    });
  }

  Future<void> _submitMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnack('Mesaj göndermek için giriş yapmalısın.');
      return;
    }

    final email = _emailController.text.trim();
    final subject = _subjectController.text.trim();
    final question = _questionController.text.trim();
    final message = _messageController.text.trim();

    if (email.isEmpty ||
        subject.isEmpty ||
        question.isEmpty ||
        message.isEmpty) {
      _showSnack('Lütfen tüm alanları doldur.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('supportMessages').add({
        'uid': user.uid,
        'userName': _userName,
        'userEmail': (user.email ?? '').trim(),
        'contactEmail': email,
        'subject': subject,
        'question': question,
        'message': message,
        'entryPoint': widget.entryPoint,
        'isRead': false,
        'status': 'new',
        'createdAt': FieldValue.serverTimestamp(),
        'createdAtClient': Timestamp.fromDate(DateTime.now()),
      });

      _subjectController.clear();
      _questionController.clear();
      _messageController.clear();

      if (!mounted) {
        return;
      }

      _showSnack('Mesajın başarıyla iletildi. Teşekkür ederiz.');
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('supportMessages write error: ${e.code} - ${e.message}');
      }
      final detail = e.code.trim().isEmpty ? '' : ' (Hata kodu: ${e.code})';
      _showSnack('Mesaj gönderilemedi$detail. Lütfen tekrar dene.');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('supportMessages unknown write error: $e');
      }
      _showSnack('Mesaj gönderilemedi. Lütfen tekrar dene.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x66051025), Color(0xCC051025)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFF2E9CF),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Bize Ulaşın',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF2D28E),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Değerli görüşlerini bizimle paylaşabilirsin ✨',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 18),
                _label('Email Adresi'),
                _input(_emailController, hintText: 'Email Adresi'),
                const SizedBox(height: 12),
                _label('Konu'),
                _input(_subjectController, hintText: 'Konu'),
                const SizedBox(height: 12),
                _label('Soru'),
                _input(_questionController, hintText: 'Soru'),
                const SizedBox(height: 12),
                _label('Mesajın'),
                _input(
                  _messageController,
                  minLines: 6,
                  maxLines: 8,
                  hintText:
                      'Lütfen yaşadığınız problemi detaylı anlatın. Sorunun hangi ekranda gerçekleştiğini ve problem oluşmadan önce en son ne yaptığınızı da belirtmenizi rica ederiz.',
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE7E7EB),
                      foregroundColor: const Color(0xFF1A1A1A),
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Gönder',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFF2D28E),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller, {
    int minLines = 1,
    int maxLines = 1,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 22 / 2),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE7E7EB),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 22 / 2),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
