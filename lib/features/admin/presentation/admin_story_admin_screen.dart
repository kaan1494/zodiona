import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../models/astro_story.dart';
import '../../../services/advisor_chat_service.dart';
import '../../../services/astro_story_service.dart';
import '../../../utils/city_normalizer.dart';
import '../../../utils/web_image_picker.dart';
import '../../auth/presentation/auth_screen.dart';

enum _AdminPanelTab {
  dashboard,
  users,
  stories,
  support,
  premium,
  advisorChats,
  weeklyHoroscope,
  kozmikAiChats,
}

class AdminStoryAdminScreen extends StatefulWidget {
  const AdminStoryAdminScreen({super.key});

  @override
  State<AdminStoryAdminScreen> createState() => _AdminStoryAdminScreenState();
}

class _AdminStoryAdminScreenState extends State<AdminStoryAdminScreen> {
  static const List<_PresetStoryImage> _presetImages = [
    _PresetStoryImage('S 01', 'assets/admin_story_presets/s1.png'),
    _PresetStoryImage('S 02', 'assets/admin_story_presets/s2.png'),
    _PresetStoryImage('S 03', 'assets/admin_story_presets/s3.png'),
    _PresetStoryImage('S 04', 'assets/admin_story_presets/s4.png'),
    _PresetStoryImage('S 05', 'assets/admin_story_presets/s5.png'),
    _PresetStoryImage('S 06', 'assets/admin_story_presets/s6.png'),
    _PresetStoryImage('S 07', 'assets/admin_story_presets/s7.png'),
    _PresetStoryImage('S 08', 'assets/admin_story_presets/s8.png'),
    _PresetStoryImage('S 09', 'assets/admin_story_presets/s9.png'),
    _PresetStoryImage('S 10', 'assets/admin_story_presets/s10.png'),
    _PresetStoryImage('S 11', 'assets/admin_story_presets/s11.png'),
    _PresetStoryImage('Story 01', 'assets/admin_story_presets/story_01.png'),
    _PresetStoryImage('Story 02', 'assets/admin_story_presets/story_02.png'),
    _PresetStoryImage('Story 03', 'assets/admin_story_presets/story_03.png'),
    _PresetStoryImage('Story 04', 'assets/admin_story_presets/story_04.png'),
    _PresetStoryImage('Story 05', 'assets/admin_story_presets/story_05.png'),
    _PresetStoryImage('Story 06', 'assets/admin_story_presets/story_06.png'),
    _PresetStoryImage('Story 07', 'assets/admin_story_presets/story_07.png'),
    _PresetStoryImage('Story 08', 'assets/admin_story_presets/story_08.png'),
    _PresetStoryImage('Story 09', 'assets/admin_story_presets/story_09.png'),
    _PresetStoryImage('Story 10', 'assets/admin_story_presets/story_10.png'),
    _PresetStoryImage('Story 11', 'assets/admin_story_presets/story_11.png'),
    _PresetStoryImage('Story 12', 'assets/admin_story_presets/story_12.png'),
    _PresetStoryImage('Story 13', 'assets/admin_story_presets/story_13.png'),
    _PresetStoryImage('Story 14', 'assets/admin_story_presets/story_14.png'),
    _PresetStoryImage('Story 15', 'assets/admin_story_presets/story_15.png'),
    _PresetStoryImage('Story 16', 'assets/admin_story_presets/story_16.png'),
    _PresetStoryImage('Story 17', 'assets/admin_story_presets/story_17.png'),
    _PresetStoryImage('Story 18', 'assets/admin_story_presets/story_18.png'),
    _PresetStoryImage('Story 19', 'assets/admin_story_presets/story_19.png'),
    _PresetStoryImage('Story 20', 'assets/admin_story_presets/story_20.png'),
  ];

  final _service = const AstroStoryService();
  final _titleController = TextEditingController();
  final _userSearchController = TextEditingController();
  final _premiumSearchController = TextEditingController();

  _AdminPanelTab _activeTab = _AdminPanelTab.dashboard;
  bool _isSidebarExpanded = true;
  String _userSearchQuery = '';
  String _premiumSearchQuery = '';
  AdvisorChatSummary? _selectedAdvisorChat;
  String? _selectedKozmikUid;
  String? _selectedKozmikName;

  bool _isActive = true;
  bool _isSaving = false;

  final List<_SegmentDraft> _segments = [_SegmentDraft()];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _cachedUserDocs = [];

  @override
  void dispose() {
    _titleController.dispose();
    _userSearchController.dispose();
    _premiumSearchController.dispose();
    for (final s in _segments) {
      s.dispose();
    }
    super.dispose();
  }

  Future<void> _createStory() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Başlık gerekli.')));
      return;
    }

    final segments = _segments
        .map((s) => s.toSegment())
        .where((s) => s.text.trim().isNotEmpty)
        .toList();

    final coverImage = segments
        .map((s) => s.imageUrl.trim())
        .firstWhere((url) => url.isNotEmpty, orElse: () => '');

    if (segments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En az 1 hikaye sayfası ekle.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _service.createStory(
        title: title,
        subtitle: '',
        thumbnailUrl: coverImage,
        isActive: _isActive,
        segments: segments,
      );

      _titleController.clear();
      for (final s in _segments) {
        s.dispose();
      }
      _segments
        ..clear()
        ..add(_SegmentDraft());

      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Hikâye kaydedildi.')));
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Kaydetme hatası: ${e.code}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Kaydetme hatası: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _setStoryActive({
    required String id,
    required bool isActive,
  }) async {
    try {
      await _service.setStoryActive(id: id, isActive: isActive);
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Güncelleme hatası: ${e.code}')));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Güncelleme hatası: $e')));
    }
  }

  Future<void> _deleteStory(String id) async {
    try {
      await _service.deleteStory(id);
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Silme hatası: ${e.code}')));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Silme hatası: $e')));
    }
  }

  Future<String?> _pickAndUploadImage() async {
    if (!kIsWeb) {
      throw Exception('Bu seçim şu an yalnızca web panelde destekleniyor.');
    }

    final picked = await pickImageForWebSafe();
    if (picked == null) {
      return null;
    }

    final bytes = picked['bytes'] as Uint8List?;
    final name = (picked['name'] as String?) ?? 'image.jpg';
    if (bytes == null) {
      throw Exception('Seçilen dosya okunamadı.');
    }

    final ext = name.contains('.') ? name.split('.').last : 'jpg';
    final safeExt = ext.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    const maxBytes = 350 * 1024;
    if (bytes.length > maxBytes) {
      throw Exception('Görsel boyutu çok büyük (maks 350 KB).');
    }

    final base64 = base64Encode(bytes);
    return 'data:image/$safeExt;base64,$base64';
  }

  Future<void> _pickAndUploadSegmentImage(_SegmentDraft segment) async {
    setState(() => segment.isUploading = true);
    try {
      final url = await _pickAndUploadImage();
      if (url == null || !mounted) {
        return;
      }
      setState(() => segment.imageController.text = url);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sayfa resmi eklendi.')));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sayfa resmi yüklenemedi: $e')));
    } finally {
      if (mounted) {
        setState(() => segment.isUploading = false);
      }
    }
  }

  String get _panelTitle {
    switch (_activeTab) {
      case _AdminPanelTab.dashboard:
        return 'Admin - Dashboard';
      case _AdminPanelTab.users:
        return 'Admin - Kullanıcılar';
      case _AdminPanelTab.stories:
        return 'Admin - Astro Hikâyeler';
      case _AdminPanelTab.support:
        return 'Admin - Bize Ulaşın Mesajları';
      case _AdminPanelTab.premium:
        return 'Admin - Premium Kullanıcılar';
      case _AdminPanelTab.advisorChats:
        return 'Admin - Danışman Mesajları';
      case _AdminPanelTab.weeklyHoroscope:
        return 'Admin - Haftalık Yorumlar';
      case _AdminPanelTab.kozmikAiChats:
        return 'Admin - Kozmik AI Sohbetleri';
    }
  }

  void _openMainApp() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  DateTime? _resolveUserCreatedAt(Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    if (createdAt is Timestamp) {
      return createdAt.toDate();
    }
    if (createdAt is DateTime) {
      return createdAt;
    }
    if (createdAt is int) {
      return DateTime.fromMillisecondsSinceEpoch(createdAt);
    }

    final createdAtClient = data['createdAtClient'];
    if (createdAtClient is Timestamp) {
      return createdAtClient.toDate();
    }
    if (createdAtClient is DateTime) {
      return createdAtClient;
    }
    if (createdAtClient is int) {
      return DateTime.fromMillisecondsSinceEpoch(createdAtClient);
    }

    final updatedAt = data['updatedAt'];
    if (updatedAt is Timestamp) {
      return updatedAt.toDate();
    }
    if (updatedAt is DateTime) {
      return updatedAt;
    }
    if (updatedAt is int) {
      return DateTime.fromMillisecondsSinceEpoch(updatedAt);
    }

    return null;
  }

  DateTime _sortDateOrEpoch(Map<String, dynamic> data) {
    return _resolveUserCreatedAt(data) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  bool _asBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'evet';
    }
    return false;
  }

  DateTime? _resolveBirthDate(Map<String, dynamic> data) {
    final birthDate = data['birthDate'];
    if (birthDate is Timestamp) {
      return birthDate.toDate();
    }
    if (birthDate is DateTime) {
      return birthDate;
    }
    if (birthDate is int) {
      return DateTime.fromMillisecondsSinceEpoch(birthDate);
    }
    return null;
  }

  int? _resolveAge(Map<String, dynamic> data) {
    final birthDate = _resolveBirthDate(data);
    if (birthDate == null) {
      return null;
    }

    final now = DateTime.now();
    var age = now.year - birthDate.year;
    final hadBirthday =
        now.month > birthDate.month ||
        (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hadBirthday) {
      age -= 1;
    }
    if (age < 0 || age > 120) {
      return null;
    }
    return age;
  }

  String _resolveUserCity(Map<String, dynamic> data) {
    final candidates = <dynamic>[
      data['cityNormalized'],
      data['birthPlaceName'],
      data['birthPlace'],
      data['birthPlaceCity'],
      data['city'],
      data['locationCity'],
    ];

    for (final candidate in candidates) {
      if (candidate is! String) {
        continue;
      }
      final cleaned = candidate.trim();
      if (cleaned.isEmpty) {
        continue;
      }
      final normalizedCity = normalizeCityName(cleaned);
      if (normalizedCity.isNotEmpty) {
        return normalizedCity;
      }
    }

    return 'Belirtilmemiş';
  }

  String _resolveUserGender(Map<String, dynamic> data) {
    final raw = (data['gender'] as String?)?.trim().toLowerCase();
    if (raw == null || raw.isEmpty) {
      return 'Belirtilmemiş';
    }

    if (raw.contains('erkek') || raw == 'male') {
      return 'Erkek';
    }
    if (raw.contains('kadin') || raw.contains('kadın') || raw == 'female') {
      return 'Kadın';
    }
    if (raw.contains('non')) {
      return 'Non Binary';
    }

    return 'Belirtilmemiş';
  }

  String _usersErrorMessage(Object? error) {
    if (error is FirebaseException) {
      if (error.code == 'permission-denied') {
        return 'Kullanıcı verileri yüklenemedi (permission-denied). Firestore kuralları admin listeleme izni vermiyor.';
      }
      return 'Kullanıcı verileri yüklenemedi (${error.code}).';
    }
    return 'Kullanıcı verileri yüklenemedi.';
  }

  bool _isPermissionDeniedError(Object? error) {
    return error is FirebaseException && error.code == 'permission-denied';
  }

  Widget _firestorePermissionHintCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0x1AFF6A6A),
        border: Border.all(color: const Color(0x66FF6A6A)),
      ),
      child: const Text(
        'Not: Bu ekran tüm kullanıcıları users koleksiyonundan okur. permission-denied alındığında çözüm uygulama kodu değil Firestore Rules tarafındadır. Admin kullanıcıya users list/read izni tanımlanmalıdır.',
      ),
    );
  }

  String _resolveUserName(Map<String, dynamic> data) {
    final name = (data['name'] as String?)?.trim();
    final displayName = (data['displayName'] as String?)?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }
    return 'İsimsiz Kullanıcı';
  }

  String _resolveUserEmail(Map<String, dynamic> data) {
    final email = (data['email'] as String?)?.trim();
    return (email?.isNotEmpty ?? false) ? email! : '-';
  }

  DateTime? _resolveDateTimeValue(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }

  String _stringOrDash(dynamic value) {
    if (value == null) {
      return '-';
    }
    final text = value.toString().trim();
    return text.isEmpty ? '-' : text;
  }

  String _userBirthPlaceText(Map<String, dynamic> data) {
    final normalized = _stringOrDash(data['cityNormalized']);
    if (normalized != '-') {
      return normalized;
    }

    final placeName = _stringOrDash(data['birthPlaceName']);
    if (placeName != '-') {
      return placeName;
    }

    final place = _stringOrDash(data['birthPlace']);
    if (place != '-') {
      return place;
    }

    return 'Belirtilmemiş';
  }

  String _userBirthTimeText(Map<String, dynamic> data) {
    if (_asBool(data['birthTimeUnknown'])) {
      return 'Bilmiyorum (12:00 varsayılan)';
    }

    return _stringOrDash(data['birthTime']);
  }

  Widget _detailInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final width = _isSidebarExpanded ? 264.0 : 76.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF0E1330),
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 58,
            child: Row(
              children: [
                if (_isSidebarExpanded)
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Text(
                        'Yönetim Paneli',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                else
                  const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() => _isSidebarExpanded = !_isSidebarExpanded);
                  },
                  icon: Icon(
                    _isSidebarExpanded ? Icons.menu_open : Icons.menu,
                    color: const Color(0xFFF2D28E),
                  ),
                  tooltip: _isSidebarExpanded ? 'Menüyü daralt' : 'Menüyü aç',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _buildNavItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            tab: _AdminPanelTab.dashboard,
          ),
          _buildNavItem(
            icon: Icons.groups_outlined,
            title: 'Kullanıcılar',
            tab: _AdminPanelTab.users,
          ),
          _buildNavItem(
            icon: Icons.auto_stories_outlined,
            title: 'Story Sayfası',
            tab: _AdminPanelTab.stories,
          ),
          _buildNavItem(
            icon: Icons.contact_mail_outlined,
            title: 'Bize Ulaşın',
            tab: _AdminPanelTab.support,
          ),
          _buildNavItem(
            icon: Icons.workspace_premium_outlined,
            title: 'Premium Kullanıcılar',
            tab: _AdminPanelTab.premium,
          ),
          _buildNavItem(
            icon: Icons.chat_outlined,
            title: 'Danışman Mesajları',
            tab: _AdminPanelTab.advisorChats,
          ),
          _buildNavItem(
            icon: Icons.calendar_today_outlined,
            title: 'Haftalık Yorumlar',
            tab: _AdminPanelTab.weeklyHoroscope,
          ),
          _buildNavItem(
            icon: Icons.psychology_outlined,
            title: 'Kozmik AI Sohbetleri',
            tab: _AdminPanelTab.kozmikAiChats,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required _AdminPanelTab tab,
  }) {
    final isActive = _activeTab == tab;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isActive ? const Color(0x22F2C98A) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _activeTab = tab),
          child: SizedBox(
            height: 44,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(
                  icon,
                  color: isActive ? const Color(0xFFF2D28E) : Colors.white70,
                ),
                if (_isSidebarExpanded) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isActive
                            ? const Color(0xFFF2D28E)
                            : Colors.white,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _panelContent() {
    switch (_activeTab) {
      case _AdminPanelTab.dashboard:
        return _dashboardSection();
      case _AdminPanelTab.users:
        return _usersSection(premiumOnly: false);
      case _AdminPanelTab.stories:
        return _storiesSection();
      case _AdminPanelTab.support:
        return _supportSection();
      case _AdminPanelTab.premium:
        return _usersSection(premiumOnly: true);
      case _AdminPanelTab.advisorChats:
        return _advisorChatsSection();
      case _AdminPanelTab.weeklyHoroscope:
        return const _WeeklyHoroscopeMgmtSection();
      case _AdminPanelTab.kozmikAiChats:
        return const SizedBox.shrink(); // two-pane, rendered in build()
    }
  }

  Widget _dashboardSection() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, userSnapshot) {
        final hasUsersPermissionDenied = _isPermissionDeniedError(
          userSnapshot.error,
        );

        if (userSnapshot.hasData) {
          _cachedUserDocs =
              List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
                userSnapshot.data?.docs ?? const [],
              );
        }

        final docsSource = userSnapshot.data?.docs ?? _cachedUserDocs;
        final userDocs =
            hasUsersPermissionDenied
                  ? <QueryDocumentSnapshot<Map<String, dynamic>>>[]
                  : List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
                      docsSource,
                    )
              ..sort((a, b) {
                final aTs = _sortDateOrEpoch(a.data());
                final bTs = _sortDateOrEpoch(b.data());
                return bTs.compareTo(aTs);
              });

        if (!hasUsersPermissionDenied &&
            userDocs.isEmpty &&
            userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!hasUsersPermissionDenied &&
            userDocs.isEmpty &&
            userSnapshot.hasError) {
          return Text(_usersErrorMessage(userSnapshot.error));
        }

        final totalUsers = userDocs.length;
        final premiumCount = userDocs
            .where((doc) => _asBool(doc.data()['isPremium']))
            .length;
        final adminCount = userDocs.where((doc) {
          final data = doc.data();
          final role = (data['role'] as String?)?.trim().toLowerCase();
          return _asBool(data['isAdmin']) || role == 'admin';
        }).length;

        final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
        final newLast7Days = userDocs.where((doc) {
          final createdAt = _resolveUserCreatedAt(doc.data());
          return createdAt != null && createdAt.isAfter(sevenDaysAgo);
        }).length;

        final cityCounts = <String, int>{};
        final genderCounts = <String, int>{};
        final ageBuckets = <String, int>{
          '18 altı': 0,
          '18-24': 0,
          '25-34': 0,
          '35-44': 0,
          '45+': 0,
          'Bilinmiyor': 0,
        };

        for (final doc in userDocs) {
          final data = doc.data();

          final city = _resolveUserCity(data);
          cityCounts[city] = (cityCounts[city] ?? 0) + 1;

          final gender = _resolveUserGender(data);
          genderCounts[gender] = (genderCounts[gender] ?? 0) + 1;

          final age = _resolveAge(data);
          if (age == null) {
            ageBuckets['Bilinmiyor'] = (ageBuckets['Bilinmiyor'] ?? 0) + 1;
          } else if (age < 18) {
            ageBuckets['18 altı'] = (ageBuckets['18 altı'] ?? 0) + 1;
          } else if (age <= 24) {
            ageBuckets['18-24'] = (ageBuckets['18-24'] ?? 0) + 1;
          } else if (age <= 34) {
            ageBuckets['25-34'] = (ageBuckets['25-34'] ?? 0) + 1;
          } else if (age <= 44) {
            ageBuckets['35-44'] = (ageBuckets['35-44'] ?? 0) + 1;
          } else {
            ageBuckets['45+'] = (ageBuckets['45+'] ?? 0) + 1;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userSnapshot.hasError)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange.withValues(alpha: 0.12),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(_usersErrorMessage(userSnapshot.error)),
              ),
            if (hasUsersPermissionDenied) _firestorePermissionHintCard(),
            _sectionTitle('Dashboard'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _statCard(label: 'Toplam Kullanıcı', value: '$totalUsers'),
                _statCard(label: 'Premium Kullanıcı', value: '$premiumCount'),
                _statCard(label: 'Admin Kullanıcı', value: '$adminCount'),
                _statCard(label: 'Son 7 Gün Kayıt', value: '$newLast7Days'),
                StreamBuilder<List<AstroStory>>(
                  stream: _service.watchAllStories(),
                  builder: (context, storySnapshot) {
                    if (storySnapshot.hasError) {
                      return _statCard(label: 'Aktif Hikâye', value: '-');
                    }

                    final stories = storySnapshot.data ?? const <AstroStory>[];
                    final activeStories = stories
                        .where((s) => s.isActive)
                        .length;
                    return _statCard(
                      label: 'Aktif Hikâye',
                      value: '$activeStories',
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('supportMessages')
                      .limit(300)
                      .snapshots(),
                  builder: (context, supportSnapshot) {
                    if (supportSnapshot.hasError) {
                      return _statCard(label: 'Okunmamış Mesaj', value: '-');
                    }

                    final docs = supportSnapshot.data?.docs ?? const [];
                    final unread = docs
                        .where((doc) => (doc.data()['isRead'] as bool?) != true)
                        .length;
                    return _statCard(
                      label: 'Okunmamış Mesaj',
                      value: '$unread',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _distributionCard(
                  title: 'Şehir Dağılımı (Top 5)',
                  distribution: cityCounts,
                  accent: const Color(0xFF7AA8FF),
                  maxItems: 5,
                ),
                _distributionCard(
                  title: 'Cinsiyet Dağılımı',
                  distribution: genderCounts,
                  accent: const Color(0xFFE7A4C8),
                ),
                _distributionCard(
                  title: 'Yaş Dağılımı',
                  distribution: ageBuckets,
                  accent: const Color(0xFF9CE1AE),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _usersSection({required bool premiumOnly}) {
    final searchController = premiumOnly
        ? _premiumSearchController
        : _userSearchController;
    final currentQuery = premiumOnly ? _premiumSearchQuery : _userSearchQuery;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          premiumOnly ? 'Premium Kullanıcılar' : 'Tüm Kullanıcılar',
        ),
        const SizedBox(height: 10),
        TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              if (premiumOnly) {
                _premiumSearchQuery = value.trim().toLowerCase();
              } else {
                _userSearchQuery = value.trim().toLowerCase();
              }
            });
          },
          decoration: InputDecoration(
            labelText: premiumOnly
                ? 'Premium kullanıcı ara (isim, email, uid)'
                : 'Kullanıcı ara (isim, email, uid)',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: currentQuery.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        if (premiumOnly) {
                          _premiumSearchQuery = '';
                        } else {
                          _userSearchQuery = '';
                        }
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            final hasUsersPermissionDenied = _isPermissionDeniedError(
              snapshot.error,
            );

            if (snapshot.hasData) {
              _cachedUserDocs =
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
                    snapshot.data?.docs ?? const [],
                  );
            }

            if (hasUsersPermissionDenied) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Text(_usersErrorMessage(snapshot.error)),
                  ),
                  _firestorePermissionHintCard(),
                ],
              );
            }

            final docsSource = snapshot.data?.docs ?? _cachedUserDocs;

            if (docsSource.isEmpty &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (docsSource.isEmpty && snapshot.hasError) {
              return Text(_usersErrorMessage(snapshot.error));
            }

            final docs =
                List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
                  docsSource,
                )..sort((a, b) {
                  final aTs = _sortDateOrEpoch(a.data());
                  final bTs = _sortDateOrEpoch(b.data());
                  return bTs.compareTo(aTs);
                });

            final filtered = docs
                .where((doc) {
                  final data = doc.data();
                  final isPremium = _asBool(data['isPremium']);
                  if (premiumOnly && !isPremium) {
                    return false;
                  }

                  if (currentQuery.isEmpty) {
                    return true;
                  }

                  final name = _resolveUserName(data).toLowerCase();
                  final email = _resolveUserEmail(data).toLowerCase();
                  final uid = doc.id.toLowerCase();
                  return name.contains(currentQuery) ||
                      email.contains(currentQuery) ||
                      uid.contains(currentQuery);
                })
                .toList(growable: false);

            if (filtered.isEmpty) {
              return Text(
                premiumOnly
                    ? 'Premium kullanıcı bulunamadı.'
                    : 'Kullanıcı bulunamadı.',
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snapshot.hasError)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Text(
                      '${_usersErrorMessage(snapshot.error)} Önbellekteki son veri gösteriliyor.',
                    ),
                  ),
                ...filtered.map((doc) {
                  final data = doc.data();
                  final name = _resolveUserName(data);
                  final email = _resolveUserEmail(data);
                  final isPremium = _asBool(data['isPremium']);
                  final isAdmin =
                      _asBool(data['isAdmin']) ||
                      ((data['role'] as String?)?.toLowerCase() == 'admin');
                  final createdAt = _resolveUserCreatedAt(data);
                  final premiumExpire = _resolveDateTimeValue(
                    data['premiumExpireDate'],
                  );
                  final premiumExpireText = _formatDateTime(premiumExpire);

                  final detailRows = <MapEntry<String, String>>[
                    MapEntry<String, String>('Email', email),
                    MapEntry<String, String>('UID', doc.id),
                    MapEntry<String, String>(
                      'Kayıt Tarihi',
                      _formatDateTime(createdAt),
                    ),
                    MapEntry<String, String>(
                      'Premium Bitiş',
                      premiumExpireText,
                    ),
                    MapEntry<String, String>(
                      'Doğum Tarihi',
                      _formatDateTime(_resolveBirthDate(data)),
                    ),
                    MapEntry<String, String>(
                      'Doğum Saati',
                      _userBirthTimeText(data),
                    ),
                    MapEntry<String, String>(
                      'Meslek',
                      _stringOrDash(data['job']),
                    ),
                    MapEntry<String, String>(
                      'İlişki Durumu',
                      _stringOrDash(
                        data['relationshipStatus'] ?? data['relationshipType'],
                      ),
                    ),
                    MapEntry<String, String>(
                      'Doğum Yeri',
                      _userBirthPlaceText(data),
                    ),
                    MapEntry<String, String>(
                      'Doğum Ülkesi',
                      _stringOrDash(data['birthPlaceCountry']),
                    ),
                    MapEntry<String, String>(
                      'Doğum Koordinatları',
                      '${_stringOrDash(data['birthPlaceLat'])}, ${_stringOrDash(data['birthPlaceLon'])}',
                    ),
                    MapEntry<String, String>(
                      'Cinsiyet',
                      _resolveUserGender(data),
                    ),
                    MapEntry<String, String>(
                      'Burç (Güneş)',
                      _stringOrDash(data['zodiacSign']),
                    ),
                    MapEntry<String, String>(
                      'Ay Burcu',
                      _stringOrDash(data['moonSign']),
                    ),
                    MapEntry<String, String>(
                      'Yükselen',
                      _stringOrDash(data['risingSign']),
                    ),
                    MapEntry<String, String>(
                      'Saat Dilimi',
                      _stringOrDash(data['birthTimezone']),
                    ),
                  ];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          12,
                        ),
                        title: Text(name),
                        subtitle: Text(
                          'UID: ${doc.id}\nKayıt: ${_formatDateTime(createdAt)}',
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isPremium
                                    ? const Color(0x3344C767)
                                    : const Color(0x33FFFFFF),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                isPremium ? 'Premium' : 'Standart',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            if (isAdmin)
                              const Text(
                                'Admin',
                                style: TextStyle(
                                  color: Color(0xFFF2D28E),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            const Icon(Icons.expand_more),
                          ],
                        ),
                        children: [
                          const Divider(height: 1, color: Colors.white24),
                          const SizedBox(height: 12),
                          ...detailRows.map(
                            (entry) => _detailInfoRow(entry.key, entry.value),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _storiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Story Sayfası'),
        const SizedBox(height: 12),
        _storyComposerSection(),
        const SizedBox(height: 20),
        _publishedStoriesSection(),
      ],
    );
  }

  Widget _storyComposerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Yeni Hikâye Ekle'),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Başlık'),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Aktif Olsun'),
          value: _isActive,
          onChanged: (v) => setState(() => _isActive = v),
        ),
        const SizedBox(height: 8),
        _sectionTitle('Hikâye Sayfaları'),
        const SizedBox(height: 8),
        ..._segments.asMap().entries.map((entry) {
          final index = entry.key;
          final segment = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Sayfa ${index + 1}'),
                      const Spacer(),
                      if (_segments.length > 1)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              segment.dispose();
                              _segments.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                    ],
                  ),
                  TextField(
                    controller: segment.textController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Metin'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: segment.imageController,
                    decoration: const InputDecoration(
                      labelText: 'Resim Kaynağı (URL / Asset / Data)',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _presetSelector(
                    selectedValue: segment.imageController.text.trim(),
                    title: 'Sayfa için sabit görseller',
                    onSelected: (value) =>
                        setState(() => segment.imageController.text = value),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: segment.isUploading
                          ? null
                          : () => _pickAndUploadSegmentImage(segment),
                      icon: segment.isUploading
                          ? const SizedBox(
                              height: 14,
                              width: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.upload_file),
                      label: Text(
                        segment.isUploading
                            ? 'Resim ekleniyor...'
                            : 'Galeriden Sayfa Resmi Seç',
                      ),
                    ),
                  ),
                  if (segment.imageController.text.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _buildPreviewImage(
                        segment.imageController.text.trim(),
                        height: 120,
                        errorText: 'Sayfa resmi önizlenemedi',
                        storyFrame: true,
                      ),
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: segment.durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Süre (ms) - örn 5000',
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => _segments.add(_SegmentDraft())),
            icon: const Icon(Icons.add),
            label: const Text('Sayfa Ekle'),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _isSaving ? null : _createStory,
          child: _isSaving
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Hikâyeyi Kaydet'),
        ),
      ],
    );
  }

  Widget _publishedStoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Yayındaki Hikâyeler'),
        const SizedBox(height: 8),
        StreamBuilder<List<AstroStory>>(
          stream: _service.watchAllStories(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                'Firestore erişim hatası. Rules izinlerini kontrol edin.',
              );
            }

            final stories = snapshot.data ?? const <AstroStory>[];
            if (stories.isEmpty) {
              return const Text('Henüz hikâye yok.');
            }

            return Column(
              children: stories.map((story) {
                final isActive = story.isActive;
                return Card(
                  child: ListTile(
                    title: Text(story.title),
                    subtitle: Text('${story.segments.length} sayfa'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: isActive,
                          onChanged: (v) =>
                              _setStoryActive(id: story.id, isActive: v),
                        ),
                        IconButton(
                          onPressed: () => _deleteStory(story.id),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // Danışman sohbetleri için tam ekran iki-pane layout.
  // Scaffold body'sindeki Expanded içine doğrudan yerleştirilir —
  // SingleChildScrollView içine girmez, constraints bounded kalır.
  Widget _advisorChatsTwoPane() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Sol: sohbet listesi (340 px) ─────────────────────────
        Container(
          width: 340,
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF0D1B2A),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Danışman Mesajları'),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<List<AdvisorChatSummary>>(
                  stream: AdvisorChatService().allChatsStream(),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return Text(
                        'Yüklenemedi: ${snap.error}',
                        style: const TextStyle(color: Colors.orangeAccent),
                      );
                    }
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final chats = snap.data ?? [];
                    if (chats.isEmpty) {
                      return const Text(
                        'Henüz gelen mesaj yok.',
                        style: TextStyle(color: Colors.white70),
                      );
                    }
                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (_, i) {
                        final chat = chats[i];
                        final isSelected = _selectedAdvisorChat?.id == chat.id;
                        final timeStr = chat.updatedAt != null
                            ? _formatDateTime(chat.updatedAt)
                            : '-';
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          color: isSelected ? const Color(0xFF0F3460) : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: isSelected
                                ? const BorderSide(
                                    color: Color(0xFFFFD700),
                                    width: 1.5,
                                  )
                                : BorderSide.none,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: chat.unreadByAdmin
                                  ? const Color(0xFF5C3EFF)
                                  : Colors.grey.shade700,
                              child: Icon(
                                chat.unreadByAdmin
                                    ? Icons.mark_email_unread
                                    : Icons.chat_bubble_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            title: Text(
                              '${chat.userName.isNotEmpty ? chat.userName : 'Bilinmiyor'} → ${chat.advisorName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '${chat.consultationType}\n'
                              '${chat.lastMessage.isNotEmpty ? chat.lastMessage : '(henüz mesaj yok)'}\n'
                              '$timeStr',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            isThreeLine: true,
                            trailing: chat.unreadByAdmin
                                ? Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF5C3EFF),
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
                            onTap: () => _openAdvisorChatDetail(chat),
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
        const VerticalDivider(width: 1, color: Colors.white12),
        // ── Sağ: detay paneli ────────────────────────────────────
        Expanded(
          child: _selectedAdvisorChat == null
              ? const Center(
                  child: Text(
                    'Bir konuşma seçin',
                    style: TextStyle(color: Colors.white38, fontSize: 16),
                  ),
                )
              : _AdvisorChatDetailPanel(
                  key: ValueKey(_selectedAdvisorChat!.id),
                  chat: _selectedAdvisorChat!,
                  onClose: () => setState(() => _selectedAdvisorChat = null),
                ),
        ),
      ],
    );
  }

  // _panelContent içinden çağrıldığı için stub olarak bırakılır;
  // advisorChats sekmesi artık _advisorChatsTwoPane() üzerinden render edilir.
  Widget _advisorChatsSection() => const SizedBox.shrink();

  void _openAdvisorChatDetail(AdvisorChatSummary chat) {
    AdvisorChatService().markReadByAdmin(chat.id);
    setState(() => _selectedAdvisorChat = chat);
  }

  Widget _supportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Kullanıcılardan Gelen Mesajlar'),
        const SizedBox(height: 8),
        _supportMessagesSection(),
      ],
    );
  }

  Widget _statCard({required String label, required String value}) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
        color: Colors.white.withValues(alpha: 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _distributionCard({
    required String title,
    required Map<String, int> distribution,
    required Color accent,
    int maxItems = 6,
  }) {
    final entries = distribution.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final visible = entries.take(maxItems).toList(growable: false);
    final remaining = entries
        .skip(maxItems)
        .fold<int>(0, (acc, e) => acc + e.value);
    final normalized = <MapEntry<String, int>>[
      ...visible,
      if (remaining > 0) MapEntry<String, int>('Diğer', remaining),
    ];
    final total = normalized.fold<int>(0, (acc, e) => acc + e.value);
    final palette = _buildPiePalette(accent, normalized.length);
    final slices = List<_PieSlice>.generate(
      normalized.length,
      (i) => _PieSlice(
        label: normalized[i].key,
        value: normalized[i].value,
        color: palette[i],
      ),
      growable: false,
    );

    return Container(
      width: 380,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
        color: Colors.white.withValues(alpha: 0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 10),
          if (slices.isEmpty)
            const Text(
              'Yeterli veri yok.',
              style: TextStyle(color: Colors.white70),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 340;
                final pie = SizedBox(
                  width: 132,
                  height: 132,
                  child: CustomPaint(
                    painter: _PieChartPainter(slices: slices),
                    child: Center(
                      child: Text(
                        '$total',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );

                final legend = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: slices
                      .map((slice) {
                        final percent = total == 0
                            ? 0
                            : ((slice.value / total) * 100).round();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: slice.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${slice.label} (${slice.value} / %$percent)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                      .toList(growable: false),
                );

                if (compact) {
                  return Column(
                    children: [pie, const SizedBox(height: 12), legend],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pie,
                    const SizedBox(width: 12),
                    Expanded(child: legend),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  List<Color> _buildPiePalette(Color accent, int count) {
    if (count <= 0) {
      return const <Color>[];
    }
    final base = HSLColor.fromColor(accent);
    return List<Color>.generate(count, (index) {
      final hue = (base.hue + (index * 31)) % 360;
      final saturation = (base.saturation + 0.12 - ((index % 3) * 0.05))
          .clamp(0.45, 0.9)
          .toDouble();
      final lightness = (0.42 + ((index % 4) * 0.1))
          .clamp(0.38, 0.76)
          .toDouble();
      return HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
    }, growable: false);
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) {
      return '-';
    }
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_panelTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: _openMainApp,
              icon: const Icon(Icons.phone_android),
              label: const Text('Uygulamaya Git'),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          _buildSidebar(),
          if (_activeTab == _AdminPanelTab.advisorChats)
            Expanded(child: _advisorChatsTwoPane())
          else if (_activeTab == _AdminPanelTab.kozmikAiChats)
            Expanded(
              child: _KozmikAiChatsTwoPane(
                selectedUid: _selectedKozmikUid,
                selectedName: _selectedKozmikName,
                onUserSelected: (uid, name) => setState(() {
                  _selectedKozmikUid = uid;
                  _selectedKozmikName = name;
                }),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_panelContent()],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _supportMessagesSection() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('supportMessages')
          .limit(200)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final err = snapshot.error;
          final message = err is FirebaseException
              ? 'Mesajlar yüklenemedi (${err.code}). Firestore yetkilerini kontrol edin.'
              : 'Mesajlar yüklenemedi. Firestore erişimini kontrol edin.';
          return Text(
            message,
            style: const TextStyle(color: Colors.orangeAccent),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final docs =
            List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
              snapshot.data?.docs ?? const [],
            )..sort((a, b) {
              final aTs = _resolveSupportTimestamp(a.data());
              final bTs = _resolveSupportTimestamp(b.data());
              return bTs.compareTo(aTs);
            });
        if (docs.isEmpty) {
          return const Text('Henüz kullanıcı mesajı yok.');
        }

        return Column(
          children: docs.map((doc) {
            final data = doc.data();
            final userName = (data['userName'] as String?)?.trim();
            final userEmail = (data['userEmail'] as String?)?.trim();
            final subject = (data['subject'] as String?)?.trim();
            final message = (data['message'] as String?)?.trim();
            final isRead = (data['isRead'] as bool?) ?? false;
            final createdAt =
                (data['createdAt'] as Timestamp?) ??
                (data['createdAtClient'] as Timestamp?);

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isRead
                      ? Colors.grey.shade600
                      : const Color(0xFF5C3EFF),
                  child: Icon(
                    isRead ? Icons.drafts : Icons.mark_email_unread,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                title: Text(
                  (userName?.isNotEmpty ?? false)
                      ? userName!
                      : 'Bilinmeyen kullanıcı',
                ),
                subtitle: Text(
                  '${(subject?.isNotEmpty ?? false) ? subject : 'Konu yok'}\n${_formatSupportTime(createdAt)}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  onPressed: isRead
                      ? null
                      : () => _markSupportMessageAsRead(doc.id),
                  icon: const Icon(Icons.done_all),
                  tooltip: 'Okundu olarak işaretle',
                ),
                onTap: () => _openSupportMessageDetail(
                  userName: userName,
                  userEmail: userEmail,
                  subject: subject,
                  message: message,
                  question: (data['question'] as String?)?.trim(),
                  contactEmail: (data['contactEmail'] as String?)?.trim(),
                  createdAt: createdAt,
                  entryPoint: (data['entryPoint'] as String?)?.trim(),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  DateTime _resolveSupportTimestamp(Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    if (createdAt is Timestamp) {
      return createdAt.toDate();
    }

    final createdAtClient = data['createdAtClient'];
    if (createdAtClient is Timestamp) {
      return createdAtClient.toDate();
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  Future<void> _markSupportMessageAsRead(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('supportMessages')
          .doc(docId)
          .set({
            'isRead': true,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mesaj güncellenemedi.')));
    }
  }

  void _openSupportMessageDetail({
    required String? userName,
    required String? userEmail,
    required String? contactEmail,
    required String? subject,
    required String? question,
    required String? message,
    required Timestamp? createdAt,
    required String? entryPoint,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            (userName?.isNotEmpty ?? false) ? userName! : 'Kullanıcı Mesajı',
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailLine('Kullanıcı Email', userEmail),
                _detailLine('İletişim Email', contactEmail),
                _detailLine('Konu', subject),
                _detailLine('Soru', question),
                _detailLine('Tarih', _formatSupportTime(createdAt)),
                _detailLine('Kaynak', entryPoint),
                const SizedBox(height: 8),
                const Text(
                  'Mesaj',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text((message?.isNotEmpty ?? false) ? message! : '-'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailLine(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('$label: ${(value?.isNotEmpty ?? false) ? value : '-'}'),
    );
  }

  String _formatSupportTime(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Tarih yok';
    }
    final dt = timestamp.toDate().toLocal();
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildPreviewImage(
    String source, {
    required double height,
    required String errorText,
    bool storyFrame = false,
  }) {
    Widget errorBox() => Container(
      height: height,
      alignment: Alignment.center,
      color: Colors.white10,
      child: Text(errorText),
    );

    Widget inStoryFrame(Widget child) {
      if (!storyFrame) {
        return child;
      }
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    if (source.startsWith('data:image')) {
      try {
        final commaIndex = source.indexOf(',');
        if (commaIndex < 0) {
          return errorBox();
        }
        final bytes = base64Decode(source.substring(commaIndex + 1));
        return inStoryFrame(
          Image.memory(
            bytes,
            height: height,
            width: double.infinity,
            fit: storyFrame ? BoxFit.contain : BoxFit.cover,
            errorBuilder: (_, _, _) => errorBox(),
          ),
        );
      } catch (_) {
        return errorBox();
      }
    }

    if (source.startsWith('assets/')) {
      return inStoryFrame(
        Image.asset(
          source,
          height: height,
          width: double.infinity,
          fit: storyFrame ? BoxFit.contain : BoxFit.cover,
          errorBuilder: (_, _, _) => errorBox(),
        ),
      );
    }

    return inStoryFrame(
      Image.network(
        source,
        height: height,
        width: double.infinity,
        fit: storyFrame ? BoxFit.contain : BoxFit.cover,
        errorBuilder: (_, _, _) => errorBox(),
      ),
    );
  }

  Widget _presetSelector({
    required String title,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return _PresetSelectorWidget(
      title: title,
      selectedValue: selectedValue,
      images: _presetImages,
      onSelected: onSelected,
    );
  }
}

class _PieSlice {
  const _PieSlice({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;
}

// ─────────────────────────────────────────────────────────────────────────────
// Advisor Chat Detail Dialog
// ─────────────────────────────────────────────────────────────────────────────
class _AdvisorChatDetailPanel extends StatefulWidget {
  const _AdvisorChatDetailPanel({
    super.key,
    required this.chat,
    required this.onClose,
  });
  final AdvisorChatSummary chat;
  final VoidCallback onClose;

  @override
  State<_AdvisorChatDetailPanel> createState() =>
      _AdvisorChatDetailPanelState();
}

class _AdvisorChatDetailPanelState extends State<_AdvisorChatDetailPanel> {
  final _replyController = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await AdvisorChatService().sendMessage(
        chatId: widget.chat.id,
        text: text,
        senderType: 'admin',
      );
      _replyController.clear();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.chat.userProfile;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Sol: kullanıcı profili ──
          Container(
            width: 200,
            decoration: const BoxDecoration(
              color: Color(0xFF16213E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kullanıcı Profili',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _profileRow('Ad Soyad', widget.chat.userName),
                  _profileRow('E-posta', widget.chat.userEmail),
                  if (profile['birthDate'] != null)
                    _profileRow('Doğum Tarihi', () {
                      final bd = profile['birthDate'];
                      DateTime? dt;
                      if (bd is Timestamp) {
                        dt = bd.toDate();
                      } else if (bd is DateTime) {
                        dt = bd;
                      } else if (bd is int) {
                        dt = DateTime.fromMillisecondsSinceEpoch(bd);
                      }
                      if (dt == null) return '-';
                      final d = dt.day.toString().padLeft(2, '0');
                      final m = dt.month.toString().padLeft(2, '0');
                      return '$d.$m.${dt.year}';
                    }()),
                  if (profile['birthTime'] != null &&
                      profile['birthTime'].toString().isNotEmpty)
                    _profileRow(
                      'Doğum Saati',
                      profile['birthTimeUnknown'] == true
                          ? 'Bilinmiyor'
                          : profile['birthTime'].toString(),
                    ),
                  if (profile['zodiacSign'] != null)
                    _profileRow('Burç', profile['zodiacSign'].toString()),
                  if (profile['moonSign'] != null)
                    _profileRow('Ay Burcu', profile['moonSign'].toString()),
                  if (profile['risingSign'] != null)
                    _profileRow('Yükselen', profile['risingSign'].toString()),
                  if (profile['gender'] != null)
                    _profileRow('Cinsiyet', profile['gender'].toString()),
                  if (profile['job'] != null)
                    _profileRow('Meslek', profile['job'].toString()),
                  if (profile['relationshipStatus'] != null)
                    _profileRow(
                      'İlişki Durumu',
                      profile['relationshipStatus'].toString(),
                    ),
                  if (profile['birthPlace'] != null)
                    _profileRow('Doğum Yeri', profile['birthPlace'].toString()),
                  const Divider(color: Colors.white24, height: 20),
                  _profileRow('Danışman', widget.chat.advisorName),
                  _profileRow('Konu', widget.chat.consultationType),
                ],
              ),
            ),
          ),
          // ── Sağ: mesajlar + cevap ──
          Expanded(
            child: Column(
              children: [
                // Başlık
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F3460),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.chat.userName} — ${widget.chat.advisorName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 20,
                        ),
                        onPressed: widget.onClose,
                      ),
                    ],
                  ),
                ),
                // Mesajlar
                Expanded(
                  child: StreamBuilder<List<AdvisorChatMessage>>(
                    stream: AdvisorChatService().messagesStream(widget.chat.id),
                    builder: (ctx, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFFD700),
                          ),
                        );
                      }
                      if (snap.hasError) {
                        return Center(
                          child: Text(
                            'Hata: ${snap.error}',
                            style: const TextStyle(color: Colors.orangeAccent),
                          ),
                        );
                      }
                      final messages = snap.data ?? [];
                      if (messages.isEmpty) {
                        return const Center(
                          child: Text(
                            'Henüz mesaj yok.',
                            style: TextStyle(color: Colors.white54),
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
                        padding: const EdgeInsets.all(12),
                        itemCount: messages.length,
                        itemBuilder: (ctx, i) {
                          final msg = messages[i];
                          final isAdmin = msg.senderType == 'admin';
                          return Align(
                            alignment: isAdmin
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              constraints: const BoxConstraints(maxWidth: 360),
                              decoration: BoxDecoration(
                                color: isAdmin
                                    ? const Color(0xFF0F3460)
                                    : const Color(0xFF2A2A4A),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isAdmin ? 'Admin' : widget.chat.userName,
                                    style: TextStyle(
                                      color: isAdmin
                                          ? const Color(0xFFFFD700)
                                          : Colors.white70,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    msg.text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Cevap kutusu
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF16213E),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _replyController,
                          style: const TextStyle(color: Colors.white),
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Cevabınızı yazın...',
                            hintStyle: const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: const Color(0xFF1A1A2E),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onSubmitted: (_) => _sendReply(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _sending
                          ? const SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                color: Color(0xFFFFD700),
                                strokeWidth: 2,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Color(0xFFFFD700),
                              ),
                              onPressed: _sendReply,
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

  Widget _profileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value.isEmpty ? '—' : value,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Haftalık Genel Yorum Yönetim Bölümü
// ─────────────────────────────────────────────────────────────

class _WeeklyHoroscopeMgmtSection extends StatefulWidget {
  const _WeeklyHoroscopeMgmtSection();

  @override
  State<_WeeklyHoroscopeMgmtSection> createState() =>
      _WeeklyHoroscopeMgmtSectionState();
}

class _WeeklyHoroscopeMgmtSectionState
    extends State<_WeeklyHoroscopeMgmtSection> {
  static const List<String> _signs = [
    'Koç',
    'Boğa',
    'İkizler',
    'Yengeç',
    'Aslan',
    'Başak',
    'Terazi',
    'Akrep',
    'Yay',
    'Oğlak',
    'Kova',
    'Balık',
  ];

  String _selectedSign = 'Koç';
  bool _isLoading = false;
  bool _isSaving = false;

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSign(_selectedSign);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _loadSign(String sign) async {
    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('weekly_horoscopes_general')
          .doc(sign)
          .get();
      final data = doc.data();
      _titleController.text = (data?['title'] as String?) ?? '';
      _bodyController.text = (data?['body'] as String?) ?? '';
    } catch (_) {
      _titleController.clear();
      _bodyController.clear();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başlık ve yorum boş olamaz.')),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance
          .collection('weekly_horoscopes_general')
          .doc(_selectedSign)
          .set({
            'title': title,
            'body': body,
            'updatedAt': FieldValue.serverTimestamp(),
          });
      // Push bildirimi arka planda gönder (hata olsa kayıt etkilenmesin)
      unawaited(_sendHoroscopeNotification(_selectedSign, title, body));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_selectedSign haftalık yorumu kaydedildi.'),
            backgroundColor: const Color(0xFF3B1F8C),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Kayıt hatası: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _sendHoroscopeNotification(
    String sign,
    String title,
    String body,
  ) async {
    const baseUrl = String.fromEnvironment(
      'ASTRO_API_BASE_URL',
      defaultValue: 'https://zodiona-astro-api.onrender.com',
    );
    const apiKey = String.fromEnvironment('NOTIFY_API_KEY', defaultValue: '');
    if (apiKey.isEmpty) return;

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/notify-horoscope'),
            headers: {'Content-Type': 'application/json', 'X-API-Key': apiKey},
            body: jsonEncode({'sign': sign, 'title': title, 'body': body}),
          )
          .timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint(
          'FCM: ${result['sent']} gönderildi, ${result['failed']} başarısız',
        );
      } else {
        debugPrint('Bildirim servisi yanıtı: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bildirim gönderme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Haftalık Genel Yorum Yönetimi',
            style: TextStyle(
              color: Color(0xFFF2D28E),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Bir burç seçin, başlık ve yorumu yazın, kaydedin. '
            'Uygulama bu burca sahip kullanıcılara haftalık genel yorum olarak bu metni gösterir.',
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 20),
          // Burç seçim grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _signs.map((sign) {
              final isSelected = sign == _selectedSign;
              return ChoiceChip(
                label: Text(sign),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => _selectedSign = sign);
                  _loadSign(sign);
                },
                selectedColor: const Color(0xFFF2D28E),
                backgroundColor: const Color(0xFF2A1E5C),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF1F1344) : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: isSelected ? const Color(0xFFF2D28E) : Colors.white24,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            // Başlık alanı
            const Text(
              'Başlık',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              maxLength: 80,
              decoration: InputDecoration(
                hintText: 'Örn: Koç haftalık genel yorum',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1E1550),
                counterStyle: const TextStyle(color: Colors.white38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF2D28E)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Yorum alanı
            const Text(
              'Yorum',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _bodyController,
              style: const TextStyle(color: Colors.white, height: 1.4),
              maxLines: 8,
              maxLength: 5000,
              decoration: InputDecoration(
                hintText: 'Haftalık genel yorumu buraya yazın...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1E1550),
                counterStyle: const TextStyle(color: Colors.white38),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF2D28E)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2D28E),
                  foregroundColor: const Color(0xFF1F1344),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF1F1344)),
                        ),
                      )
                    : const Text(
                        'Kaydet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  const _PieChartPainter({required this.slices});

  final List<_PieSlice> slices;

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<int>(
      0,
      (accumulator, item) => accumulator + item.value,
    );
    if (total <= 0) {
      return;
    }

    final rect = Offset.zero & size;
    var start = -math.pi / 2;

    for (final slice in slices) {
      final sweep = (slice.value / total) * 2 * math.pi;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..isAntiAlias = true
        ..color = slice.color;
      canvas.drawArc(rect, start, sweep, true, paint);
      start += sweep;
    }

    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true
      ..color = Colors.white24;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.shortestSide / 2,
      border,
    );
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    if (oldDelegate.slices.length != slices.length) {
      return true;
    }
    for (var i = 0; i < slices.length; i++) {
      if (oldDelegate.slices[i].label != slices[i].label ||
          oldDelegate.slices[i].value != slices[i].value ||
          oldDelegate.slices[i].color != slices[i].color) {
        return true;
      }
    }
    return false;
  }
}

class _PresetStoryImage {
  const _PresetStoryImage(this.name, this.url);

  final String name;
  final String url;
}

class _PresetSelectorWidget extends StatefulWidget {
  const _PresetSelectorWidget({
    required this.title,
    required this.selectedValue,
    required this.images,
    required this.onSelected,
  });

  final String title;
  final String selectedValue;
  final List<_PresetStoryImage> images;
  final ValueChanged<String> onSelected;

  @override
  State<_PresetSelectorWidget> createState() => _PresetSelectorWidgetState();
}

class _PresetSelectorWidgetState extends State<_PresetSelectorWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollBy(double delta) async {
    if (!_scrollController.hasClients) {
      return;
    }
    final target = (_scrollController.offset + delta).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        Row(
          children: [
            IconButton(
              onPressed: () => _scrollBy(-280),
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Sola kaydır',
            ),
            Expanded(
              child: SizedBox(
                height: 96,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.images.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = widget.images[index];
                    final selected = widget.selectedValue == item.url;
                    return GestureDetector(
                      onTap: () => widget.onSelected(item.url),
                      child: Container(
                        width: 86,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFFF2D28E)
                                : Colors.white24,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item.url,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () => _scrollBy(280),
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Sağa kaydır',
            ),
          ],
        ),
      ],
    );
  }
}

class _SegmentDraft {
  _SegmentDraft() {
    durationController.text = '5000';
  }

  final textController = TextEditingController();
  final imageController = TextEditingController();
  final durationController = TextEditingController();
  bool isUploading = false;

  AstroStorySegment toSegment() {
    final durationMs = int.tryParse(durationController.text.trim()) ?? 5000;
    return AstroStorySegment(
      text: textController.text.trim(),
      imageUrl: imageController.text.trim(),
      duration: Duration(milliseconds: durationMs.clamp(1500, 15000)),
    );
  }

  void dispose() {
    textController.dispose();
    imageController.dispose();
    durationController.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Kozmik AI Sohbetleri — Admin Two-Pane
// ─────────────────────────────────────────────────────────────────────────────

class _KozmikAiChatsTwoPane extends StatefulWidget {
  const _KozmikAiChatsTwoPane({
    required this.selectedUid,
    required this.selectedName,
    required this.onUserSelected,
  });

  final String? selectedUid;
  final String? selectedName;
  final void Function(String uid, String name) onUserSelected;

  @override
  State<_KozmikAiChatsTwoPane> createState() => _KozmikAiChatsTwoPaneState();
}

class _KozmikAiChatsTwoPaneState extends State<_KozmikAiChatsTwoPane> {
  String? _selectedChatId;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(
        () => _searchQuery = _searchController.text.toLowerCase().trim(),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_KozmikAiChatsTwoPane old) {
    super.didUpdateWidget(old);
    if (old.selectedUid != widget.selectedUid) {
      _selectedChatId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Sol: kullanıcı listesi (280 px) ──────────────────────
        Container(
          width: 280,
          color: const Color(0xFF0D1B2A),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Kozmik AI Sohbetleri',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              // Arama kutusu
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Ad veya e-posta ara...',
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white38,
                      size: 18,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white38,
                              size: 16,
                            ),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.07),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('hasKozmikChats', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Arama filtresi + client-side sıralama
                    final allUsers = snap.data?.docs ?? []
                      ..sort((a, b) {
                        final na = (a.data()['name'] as String? ?? '')
                            .toLowerCase();
                        final nb = (b.data()['name'] as String? ?? '')
                            .toLowerCase();
                        return na.compareTo(nb);
                      });
                    final users = allUsers.where((doc) {
                      if (_searchQuery.isEmpty) return true;
                      final data = doc.data();
                      final name = (data['name'] as String? ?? '')
                          .toLowerCase();
                      final email = (data['email'] as String? ?? '')
                          .toLowerCase();
                      return name.contains(_searchQuery) ||
                          email.contains(_searchQuery);
                    }).toList();
                    if (users.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _searchQuery.isNotEmpty
                              ? 'Arama sonucu bulunamadı.'
                              : 'Henüz sohbet yapan kullanıcı yok.',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (_, i) {
                        final data = users[i].data();
                        final uid = users[i].id;
                        final name = (data['name'] as String? ?? 'İsimsiz')
                            .trim();
                        final email = data['email'] as String? ?? '';
                        final isSelected = widget.selectedUid == uid;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: const Color(0x22F2C98A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF3D1E7A),
                            radius: 18,
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            email,
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => widget.onUserSelected(uid, name),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1, color: Colors.white12),

        // ── Orta: seçili kullanıcının sohbet listesi (260 px) ────
        if (widget.selectedUid != null) ...[
          Container(
            width: 260,
            color: const Color(0xFF0E1420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                  child: Text(
                    widget.selectedName ?? '',
                    style: const TextStyle(
                      color: Color(0xFFF2D293),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Divider(height: 1, color: Colors.white12),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.selectedUid)
                        .collection('kozmikRehberChats')
                        .orderBy('updatedAt', descending: true)
                        .snapshots(),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final docs = snap.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Henüz AI sohbeti yok.',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: docs.length,
                        itemBuilder: (_, i) {
                          final data = docs[i].data();
                          final chatId = docs[i].id;
                          final type =
                              data['type'] as String? ?? 'dogumHaritasi';
                          final preview = data['previewText'] as String? ?? '';
                          final updatedAt = (data['updatedAt'] as Timestamp?)
                              ?.toDate();
                          final msgCount =
                              (data['messages'] as List<dynamic>?)?.length ?? 0;
                          final typeLabel = switch (type) {
                            'dogumHaritasi' => 'Doğum Haritası',
                            'burcYorumu' => 'Burç Yorumu',
                            'uyumAnalizi' => 'Uyum Analizi',
                            _ => type,
                          };
                          final dateStr = updatedAt != null
                              ? '${updatedAt.day.toString().padLeft(2, '0')}.'
                                    '${updatedAt.month.toString().padLeft(2, '0')}.'
                                    '${updatedAt.year}'
                              : '';
                          final isSelected = _selectedChatId == chatId;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            color: isSelected ? const Color(0xFF1A3A5C) : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: isSelected
                                  ? const BorderSide(
                                      color: Color(0xFFF2D293),
                                      width: 1.5,
                                    )
                                  : BorderSide.none,
                            ),
                            child: ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.auto_awesome,
                                color: Color(0xFFF2D293),
                                size: 18,
                              ),
                              title: Text(
                                typeLabel,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '$dateStr · $msgCount mesaj'
                                '${preview.isNotEmpty ? '\n$preview' : ''}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11),
                              ),
                              isThreeLine: preview.isNotEmpty,
                              onTap: () =>
                                  setState(() => _selectedChatId = chatId),
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
          const VerticalDivider(width: 1, color: Colors.white12),
        ],

        // ── Sağ: mesaj detayı ─────────────────────────────────────
        Expanded(
          child: widget.selectedUid == null
              ? const Center(
                  child: Text(
                    'Bir kullanıcı seçin',
                    style: TextStyle(color: Colors.white38, fontSize: 16),
                  ),
                )
              : _selectedChatId == null
              ? const Center(
                  child: Text(
                    'Bir sohbet seçin',
                    style: TextStyle(color: Colors.white38, fontSize: 16),
                  ),
                )
              : _KozmikChatMessagesPanel(
                  key: ValueKey(_selectedChatId),
                  uid: widget.selectedUid!,
                  chatId: _selectedChatId!,
                  userName: widget.selectedName ?? '',
                ),
        ),
      ],
    );
  }
}

// ── Mesaj detay paneli ───────────────────────────────────────
class _KozmikChatMessagesPanel extends StatelessWidget {
  const _KozmikChatMessagesPanel({
    super.key,
    required this.uid,
    required this.chatId,
    required this.userName,
  });

  final String uid;
  final String chatId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('kozmikRehberChats')
          .doc(chatId)
          .snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snap.data?.data();
        final msgs = (data?['messages'] as List<dynamic>? ?? []);
        final type = data?['type'] as String? ?? 'dogumHaritasi';
        final typeLabel = switch (type) {
          'dogumHaritasi' => 'Doğum Haritası',
          'burcYorumu' => 'Burç Yorumu',
          'uyumAnalizi' => 'Uyum Analizi',
          _ => type,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFF0D1422),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFF2D293),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$userName — $typeLabel',
                    style: const TextStyle(
                      color: Color(0xFFF2D293),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${msgs.length} mesaj',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white12),

            // Messages
            Expanded(
              child: msgs.isEmpty
                  ? const Center(
                      child: Text(
                        'Mesaj bulunamadı.',
                        style: TextStyle(color: Colors.white38),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: msgs.length,
                      itemBuilder: (_, i) {
                        final msg = msgs[i] as Map<String, dynamic>;
                        final role = msg['role'] as String? ?? 'user';
                        final content = msg['content'] as String? ?? '';
                        final isUser = role == 'user';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.only(
                                  right: 10,
                                  top: 2,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isUser
                                      ? const Color(0xFF3D1E7A)
                                      : const Color(0xFF1A3A2A),
                                ),
                                child: Icon(
                                  isUser ? Icons.person : Icons.auto_awesome,
                                  size: 15,
                                  color: isUser
                                      ? Colors.white70
                                      : const Color(0xFFF2D293),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isUser ? userName : 'Kozmik Rehber',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isUser
                                            ? Colors.white70
                                            : const Color(0xFFF2D293),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      content,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        height: 1.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
