import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../auth/presentation/auth_screen.dart';
import 'premium_membership_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  static const _languageOptions = <String>['Turkce', 'English'];
  static const _dateFormatOptions = <String>[
    'dd/MM/yyyy',
    'MM/dd/yyyy',
    'yyyy-MM-dd',
  ];

  bool _isLoading = true;
  bool _isPremium = false;
  DateTime? _premiumExpireDate;

  String _language = 'Turkce';
  String _dateFormat = 'dd/MM/yyyy';
  bool _use24HourFormat = true;
  bool _notificationsEnabled = true;
  bool _vibrationEnabled = true;
  bool _showDeletedFriends = false;

  bool _hasPasswordProvider = false;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) {
        return;
      }
      setState(() => _isLoading = false);
      _showSnack('Kullanıcı oturumu bulunamadı.');
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = snapshot.data() ?? <String, dynamic>{};
      final settings = _asMap(data['appSettings']);

      final loadedLanguage = (settings['language'] as String?)?.trim();
      final loadedDateFormat = (settings['dateFormat'] as String?)?.trim();

      _isPremium = data['isPremium'] as bool? ?? false;
      _premiumExpireDate = (data['premiumExpireDate'] as Timestamp?)?.toDate();

      _language = _languageOptions.contains(loadedLanguage)
          ? loadedLanguage!
          : _language;
      _dateFormat = _dateFormatOptions.contains(loadedDateFormat)
          ? loadedDateFormat!
          : _dateFormat;

      _use24HourFormat = settings['use24HourFormat'] as bool? ?? true;
      _notificationsEnabled = settings['notificationsEnabled'] as bool? ?? true;
      _vibrationEnabled = settings['vibrationEnabled'] as bool? ?? true;
      _showDeletedFriends = settings['showDeletedFriends'] as bool? ?? false;

      _hasPasswordProvider = user.providerData.any(
        (provider) => provider.providerId == 'password',
      );
      _userEmail = user.email?.trim() ?? '';
    } catch (_) {
      _showSnack('Hesap ayarlari yuklenemedi.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final membershipText = _isPremium ? 'Premium' : 'Standart';
    final premiumInfo = _premiumExpireDate == null
        ? membershipText
        : '$membershipText (${_formatDate(_premiumExpireDate!)})';

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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                    children: [
                      _buildTopBar(),
                      _buildPickerTile(
                        label: 'Dil',
                        value: _language,
                        onTap: () => _pickLanguage(),
                      ),
                      _buildActionTile(
                        label: 'Premium Üyelik',
                        value: premiumInfo,
                        onTap: _onPremiumMembershipTap,
                      ),
                      _buildActionTile(
                        label: 'Aboneligi Geri Yukle',
                        value: 'Talep olustur',
                        onTap: _requestSubscriptionRestore,
                      ),
                      _buildPickerTile(
                        label: 'Tarih Formati',
                        value: _sampleDateByFormat(_dateFormat),
                        helper: _dateFormat,
                        onTap: () => _pickDateFormat(),
                      ),
                      _buildSwitchTile(
                        label: '24 Saat Formati',
                        value: _use24HourFormat,
                        onChanged: (value) async {
                          final old = _use24HourFormat;
                          setState(() => _use24HourFormat = value);
                          final ok = await _persistSetting(
                            key: 'use24HourFormat',
                            value: value,
                          );
                          if (!ok && mounted) {
                            setState(() => _use24HourFormat = old);
                          }
                        },
                      ),
                      _buildSwitchTile(
                        label: 'Bildirim Ayarlari',
                        value: _notificationsEnabled,
                        onChanged: (value) async {
                          final old = _notificationsEnabled;
                          setState(() => _notificationsEnabled = value);
                          final ok = await _persistSetting(
                            key: 'notificationsEnabled',
                            value: value,
                          );
                          if (!ok && mounted) {
                            setState(() => _notificationsEnabled = old);
                          }
                        },
                      ),
                      _buildSwitchTile(
                        label: 'Titresim Ayarlari',
                        value: _vibrationEnabled,
                        onChanged: (value) async {
                          final old = _vibrationEnabled;
                          setState(() => _vibrationEnabled = value);
                          final ok = await _persistSetting(
                            key: 'vibrationEnabled',
                            value: value,
                          );
                          if (!ok && mounted) {
                            setState(() => _vibrationEnabled = old);
                          }
                        },
                      ),
                      _buildSwitchTile(
                        label: 'Silinen Arkadaşları Göster',
                        value: _showDeletedFriends,
                        onChanged: (value) async {
                          final old = _showDeletedFriends;
                          setState(() => _showDeletedFriends = value);
                          final ok = await _persistSetting(
                            key: 'showDeletedFriends',
                            value: value,
                          );
                          if (!ok && mounted) {
                            setState(() => _showDeletedFriends = old);
                          }
                        },
                      ),
                      _buildActionTile(
                        label: 'Şifre Değiştir',
                        value: _hasPasswordProvider
                            ? 'Şifreyi güncelle'
                            : 'Şifre sıfırlama maili gönder',
                        onTap: _handlePasswordAction,
                      ),
                      _buildDangerTile(
                        label: 'Hesabi Sil',
                        onTap: _confirmDeleteAccount,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Color(0xFFF2E9CF)),
          ),
          const Expanded(
            child: Text(
              'Hesap Ayarlari',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF2D28E),
                fontSize: 28 / 2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildPickerTile({
    required String label,
    required String value,
    required VoidCallback onTap,
    String? helper,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
        decoration: _lineDecoration,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32 / 2,
                    ),
                  ),
                  if (helper != null && helper.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      helper,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: Color(0xFFF2D28E), size: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
        decoration: _lineDecoration,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32 / 2,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFF2D28E), size: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
      decoration: _lineDecoration,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFFF2D28E),
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerTile({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 14, 2, 14),
        decoration: _lineDecoration,
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB7B9C6),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _pickLanguage() async {
    final selected = await _pickOption(
      title: 'Dil Sec',
      options: _languageOptions,
      current: _language,
    );
    if (selected == null || selected == _language) {
      return;
    }

    final old = _language;
    setState(() => _language = selected);
    final ok = await _persistSetting(key: 'language', value: selected);
    if (!ok && mounted) {
      setState(() => _language = old);
    }
  }

  Future<void> _pickDateFormat() async {
    final selected = await _pickOption(
      title: 'Tarih Formati Sec',
      options: _dateFormatOptions,
      current: _dateFormat,
    );
    if (selected == null || selected == _dateFormat) {
      return;
    }

    final old = _dateFormat;
    setState(() => _dateFormat = selected);
    final ok = await _persistSetting(key: 'dateFormat', value: selected);
    if (!ok && mounted) {
      setState(() => _dateFormat = old);
    }
  }

  Future<String?> _pickOption({
    required String title,
    required List<String> options,
    required String current,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF1B224B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFF2D28E),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final selected = option == current;
                    return ListTile(
                      title: Text(
                        option,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: selected
                          ? const Icon(Icons.check, color: Color(0xFFF2D28E))
                          : null,
                      onTap: () => Navigator.of(context).pop(option),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _persistSetting({
    required String key,
    required dynamic value,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      _showSnack('Kullanıcı oturumu bulunamadı.');
      return false;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'appSettings.$key': value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return true;
    } catch (_) {
      _showSnack('Ayar kaydedilemedi. Tekrar dene.');
      return false;
    }
  }

  Future<void> _requestSubscriptionRestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      _showSnack('Kullanıcı oturumu bulunamadı.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'subscriptionRestoreRequestedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (!mounted) {
        return;
      }
      _showSnack('Abonelik geri yukleme talebin alindi.');
    } catch (_) {
      _showSnack('Talep olusturulamadi. Tekrar dene.');
    }
  }

  Future<void> _onPremiumMembershipTap() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PremiumMembershipScreen()));
  }

  Future<void> _handlePasswordAction() async {
    if (!_hasPasswordProvider) {
      if (_userEmail.isEmpty) {
        _showSnack('Bu hesapta şifre güncelleme kullanılamıyor.');
        return;
      }
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _userEmail);
        _showSnack('Şifre sıfırlama maili gönderildi.');
      } on FirebaseAuthException catch (e) {
        _showSnack(_authErrorMessage(e));
      } catch (_) {
        _showSnack('Şifre sıfırlama maili gönderilemedi.');
      }
      return;
    }

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChangePasswordSheet(onSubmit: _changePassword),
    );

    if (result == true && mounted) {
      _showSnack('Şifren başarıyla güncellendi.');
    }
  }

  Future<String?> _changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    if (user == null || email == null || email.isEmpty) {
      return 'Kullanıcı bilgisi eksik.';
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e);
    } catch (_) {
      return 'Şifre güncellenemedi. Tekrar dene.';
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hesabi sil'),
          content: const Text(
            'Bu islem geri alinamaz. Tum profil verilerin silinir. Devam etmek istiyor musun?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Iptal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    if (_hasPasswordProvider) {
      final password = await _askCurrentPasswordForDelete();
      if (password == null) {
        return;
      }
      final error = await _reauthenticateForDelete(password);
      if (error != null) {
        _showSnack(error);
        return;
      }
    }

    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (user == null || uid == null || uid.isEmpty) {
      _showSnack('Kullanıcı oturumu bulunamadı.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      await user.delete();
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      _showSnack(_authErrorMessage(e));
    } catch (_) {
      _showSnack('Hesap silinemedi. Tekrar dene.');
    }
  }

  Future<String?> _askCurrentPasswordForDelete() async {
    final controller = TextEditingController();
    var obscure = true;
    var submitting = false;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return AlertDialog(
              title: const Text('Şifre doğrulama'),
              content: TextField(
                controller: controller,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: 'Mevcut şifre',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setSheetState(() => obscure = !obscure);
                    },
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Iptal'),
                ),
                TextButton(
                  onPressed: submitting
                      ? null
                      : () {
                          final value = controller.text.trim();
                          if (value.isEmpty) {
                            return;
                          }
                          setSheetState(() => submitting = true);
                          Navigator.of(context).pop(value);
                        },
                  child: const Text('Devam Et'),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
    return result;
  }

  Future<String?> _reauthenticateForDelete(String password) async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    if (user == null || email == null || email.isEmpty) {
      return 'Kullanıcı bilgisi eksik.';
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e);
    } catch (_) {
      return 'Şifre doğrulaması başarısız.';
    }
  }

  String _sampleDateByFormat(String format) {
    const date = '19/08/2025';
    switch (format) {
      case 'MM/dd/yyyy':
        return '08/19/2025';
      case 'yyyy-MM-dd':
        return '2025-08-19';
      default:
        return date;
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, val) => MapEntry('$key', val));
    }
    return <String, dynamic>{};
  }

  String _authErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return 'Mevcut şifre hatalı.';
      case 'weak-password':
        return 'Yeni şifre en az 6 karakter olmalı.';
      case 'requires-recent-login':
        return 'Guvenlik nedeniyle tekrar giris yapman gerekli.';
      case 'too-many-requests':
        return 'Çok fazla deneme yapıldı. Lütfen daha sonra tekrar dene.';
      default:
        return e.message ?? 'Islem basarisiz.';
    }
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        content: Text(message),
      ),
    );
  }

  BoxDecoration get _lineDecoration {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
      ),
    );
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet({required this.onSubmit});

  final Future<String?> Function({
    required String currentPassword,
    required String newPassword,
  })
  onSubmit;

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _currentObscure = true;
  bool _newObscure = true;
  bool _confirmObscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1B224B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Şifre Değiştir',
                style: TextStyle(
                  color: Color(0xFFF2D28E),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              _buildPasswordField(
                label: 'Mevcut şifre',
                controller: _currentController,
                obscure: _currentObscure,
                onToggle: () {
                  setState(() => _currentObscure = !_currentObscure);
                },
              ),
              const SizedBox(height: 10),
              _buildPasswordField(
                label: 'Yeni şifre',
                controller: _newController,
                obscure: _newObscure,
                onToggle: () {
                  setState(() => _newObscure = !_newObscure);
                },
              ),
              const SizedBox(height: 10),
              _buildPasswordField(
                label: 'Yeni şifre (tekrar)',
                controller: _confirmController,
                obscure: _confirmObscure,
                onToggle: () {
                  setState(() => _confirmObscure = !_confirmObscure);
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2D9A6),
                    foregroundColor: const Color(0xFF131A3F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Şifreyi Güncelle',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final current = _currentController.text;
    final next = _newController.text;
    final confirm = _confirmController.text;

    if (current.trim().isEmpty) {
      _showLocalSnack('Mevcut şifreni gir.');
      return;
    }
    if (next.trim().length < 6) {
      _showLocalSnack('Yeni şifre en az 6 karakter olmalı.');
      return;
    }
    if (next != confirm) {
      _showLocalSnack('Yeni şifreler eşleşmiyor.');
      return;
    }

    setState(() => _submitting = true);
    final error = await widget.onSubmit(
      currentPassword: current,
      newPassword: next,
    );
    if (!mounted) {
      return;
    }

    setState(() => _submitting = false);

    if (error != null) {
      _showLocalSnack(error);
      return;
    }

    Navigator.of(context).pop(true);
  }

  void _showLocalSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        content: Text(message),
      ),
    );
  }
}
