import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../config/admin_access.dart';
import 'admin_story_admin_screen.dart';

class AdminAccessGateScreen extends StatefulWidget {
  const AdminAccessGateScreen({super.key});

  @override
  State<AdminAccessGateScreen> createState() => _AdminAccessGateScreenState();
}

class _AdminAccessGateScreenState extends State<AdminAccessGateScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _obscure = true;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final id = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (id.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin ID ve sifre gerekli.')),
      );
      return;
    }

    final admin = findAdminByIdOrEmail(id);
    if (admin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tanimli admin bulunamadi. Render/Web icin ADMIN_ID_1 ve ADMIN_EMAIL_1 tanimlayin.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final auth = FirebaseAuth.instance;
      final currentEmail = auth.currentUser?.email?.toLowerCase();
      if (currentEmail != admin.email.toLowerCase()) {
        await auth.signOut();
        await auth.signInWithEmailAndPassword(
          email: admin.email,
          password: password,
        );
      }

      final uid = auth.currentUser?.uid;
      if (uid == null) {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'Admin kullanici oturumu acilamadi.',
        );
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final isAdmin = (doc.data()?['isAdmin'] as bool?) ?? false;

      if (!isAdmin) {
        await auth.signOut();
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bu hesap admin yetkisine sahip degil.')),
        );
        return;
      }

      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminStoryAdminScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giris hatasi: ${e.code}')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giris hatasi: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Girisi')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              TextField(
                controller: _idController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Admin ID veya Email',
                  hintText: 'admin1 veya admin1@zodiona.com',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                onSubmitted: (_) => _login(),
                decoration: InputDecoration(
                  labelText: 'Sifre',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _login,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Panele Giris Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
