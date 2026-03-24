import 'dart:convert';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/astro_story.dart';
import '../../../services/astro_story_service.dart';
import '../../../utils/city_normalizer.dart';
import '../../../utils/web_image_picker.dart';
import '../../auth/presentation/auth_screen.dart';

enum _AdminPanelTab { dashboard, users, stories, support, premium }

class AdminStoryAdminScreen extends StatefulWidget {
  const AdminStoryAdminScreen({super.key});

  @override
  State<AdminStoryAdminScreen> createState() => _AdminStoryAdminScreenState();
}

class _AdminStoryAdminScreenState extends State<AdminStoryAdminScreen> {
  static const List<_PresetStoryImage> _presetImages = [
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
