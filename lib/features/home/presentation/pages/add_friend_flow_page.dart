import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/location_model.dart';
import '../../../../services/astro_api_service.dart';
import '../../../../services/location_service.dart';
import '../../../../utils/zodiac.dart';
import '../../domain/periodic_horoscope_generator.dart';
import '../../domain/relationship_weekly_comment_generator.dart';
import '../../domain/zodiona_daily_comment_generator.dart';
import 'birth_chart_detail_page.dart';

class AddCompatibilityFriendPage extends StatefulWidget {
  const AddCompatibilityFriendPage({super.key, required this.uid});

  final String uid;

  @override
  State<AddCompatibilityFriendPage> createState() =>
      _AddCompatibilityFriendPageState();
}

class _AddCompatibilityFriendPageState
    extends State<AddCompatibilityFriendPage> {
  static const _savingMinDuration = Duration(seconds: 3);

  static const _jobOptions = <String>[
    'Teknik ve Mühendislik',
    'Sağlık Hizmetleri',
    'Eğitim',
    'Sanat, Tasarım ve Medya',
    'Sivil Toplum ve Kamu Sektörü',
    'Spor ve Fitness',
    'Serbest ve Bağımsız Çalışma',
    'Öğrenci',
    'Emekli',
    'Diğer',
  ];

  static const _relationshipOptions = <String>[
    'Anne',
    'Baba',
    'Kardeş',
    'Eş',
    'Sevgili',
    'Flört',
    'Platonik',
    'Arkadaş',
    'Eski Eş',
    'Eski Sevgili',
    'İş Arkadaşı',
    'Çocuk',
  ];

  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _locationService = LocationService();
  final _astroApiService = const AstroApiService();

  int _stepIndex = 0;
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  bool _birthTimeUnknown = false;
  String? _birthPlace;
  LocationModel? _selectedBirthLocation;
  String? _gender;
  String? _job;
  String? _relationship;

  bool _isSearchingPlaces = false;
  bool _isSaving = false;
  List<LocationModel> _placeSuggestions = const <LocationModel>[];
  Timer? _placeDebounce;
  int _placeSearchRequestId = 0;

  @override
  void dispose() {
    _placeDebounce?.cancel();
    _nameController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  int get _totalSteps => 7;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x220B1026),
                    Color(0x760B1026),
                    Color(0xC51B1F3B),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.58, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _isSaving
                            ? null
                            : () {
                                if (_stepIndex == 0) {
                                  Navigator.of(context).pop(false);
                                } else {
                                  setState(() => _stepIndex--);
                                }
                              },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            minHeight: 5,
                            value: (_stepIndex + 1) / _totalSteps,
                            backgroundColor: Colors.white12,
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFF2C98A),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Arkadaş Ekle',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFFF2C98A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _buildStep(theme),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 22),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                          side: const BorderSide(color: Color(0xFFF2C98A)),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Devam Et',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isSaving) const _SavingFriendOverlay(),
        ],
      ),
    );
  }

  Widget _buildStep(ThemeData theme) {
    switch (_stepIndex) {
      case 0:
        return _buildNameStep(theme);
      case 1:
        return _buildBirthDateStep(theme);
      case 2:
        return _buildBirthTimeStep(theme);
      case 3:
        return _buildBirthPlaceStep(theme);
      case 4:
        return _buildGenderStep(theme);
      case 5:
        return _buildJobStep(theme);
      case 6:
        return _buildRelationshipStep(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNameStep(ThemeData theme) {
    return Column(
      key: const ValueKey('name'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 56),
        Text(
          'İlişkinizi analiz etmek için onu daha yakından tanıyalım.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('İsim'),
        ),
      ],
    );
  }

  Widget _buildBirthDateStep(ThemeData theme) {
    final displayName = _nameController.text.trim().isEmpty
        ? 'Arkadaşın'
        : _nameController.text.trim();

    return Column(
      key: const ValueKey('birth_date'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 36),
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Eklediğin kişinin doğum tarihi, güneş burcu ve astrolojik kimliğinin temelidir.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        _buildPickerContainer(
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime:
                _birthDate ?? DateTime(DateTime.now().year - 25, 1, 1),
            minimumDate: DateTime(1900),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (value) => setState(() => _birthDate = value),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildBirthTimeStep(ThemeData theme) {
    final initialTime = _birthTime ?? const TimeOfDay(hour: 12, minute: 0);

    return Column(
      key: const ValueKey('birth_time'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 44),
        Text(
          'Doğum Saati',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFFF2C98A),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Doğum saati, gezegenlerin tam konumlarını daha doğru hesaplamamızı sağlar.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const Spacer(),
        Opacity(
          opacity: _birthTimeUnknown ? 0.45 : 1,
          child: IgnorePointer(
            ignoring: _birthTimeUnknown,
            child: _buildPickerContainer(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: DateTime(
                  2000,
                  1,
                  1,
                  initialTime.hour,
                  initialTime.minute,
                ),
                onDateTimeChanged: (value) {
                  setState(() {
                    _birthTime = TimeOfDay.fromDateTime(value);
                    _birthTimeUnknown = false;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _birthTimeUnknown = true;
                  _birthTime = null;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.12),
                foregroundColor: Colors.white,
              ),
              child: const Text('Bilmiyorum'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Doğum saati bilinmiyorsa 12:00 olarak kabul edilir.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildBirthPlaceStep(ThemeData theme) {
    final suggestions = _placeSuggestions;
    final query = _placeController.text.trim();

    return Column(
      key: const ValueKey('birth_place'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 36),
        Text(
          'Doğum Yeri',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFFF2C98A),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Doğum yerini seçerek daha doğru yıldız haritası çıkarmamızı sağlayabilirsin.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _placeController,
          onChanged: _onPlaceChanged,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Şehir veya ülke ara'),
        ),
        const SizedBox(height: 10),
        if (_isSearchingPlaces)
          const LinearProgressIndicator(
            minHeight: 2,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(Color(0xFFF2C98A)),
          ),
        if (_isSearchingPlaces) const SizedBox(height: 10),
        if (suggestions.isNotEmpty)
          Expanded(
            child: ListView.separated(
              itemCount: suggestions.length,
              separatorBuilder: (_, _) => const Divider(color: Colors.white12),
              itemBuilder: (context, index) {
                final item = suggestions[index];
                return ListTile(
                  title: Text(
                    item.displayLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _placeController.text = item.displayLabel;
                      _birthPlace = item.displayLabel;
                      _selectedBirthLocation = item;
                      _placeSuggestions = const <LocationModel>[];
                    });
                  },
                );
              },
            ),
          )
        else if (!_isSearchingPlaces && query.length >= 2)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Sonuç bulunamadı. Farklı yazımla tekrar dene.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          )
        else
          const Spacer(),
      ],
    );
  }

  Widget _buildGenderStep(ThemeData theme) {
    return Column(
      key: const ValueKey('gender'),
      children: [
        const SizedBox(height: 56),
        Text(
          'Cinsiyeti',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFFF2C98A),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Bu bilgi, ilişki yorumlarını daha kişisel hale getirmemize yardımcı olur.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _GenderCard(
              label: 'Erkek',
              icon: Icons.male,
              isSelected: _gender == 'Erkek',
              onTap: () => setState(() => _gender = 'Erkek'),
            ),
            const SizedBox(width: 10),
            _GenderCard(
              label: 'Kadın',
              icon: Icons.female,
              isSelected: _gender == 'Kadın',
              onTap: () => setState(() => _gender = 'Kadın'),
            ),
            const SizedBox(width: 10),
            _GenderCard(
              label: 'Non Binary',
              icon: Icons.transgender,
              isSelected: _gender == 'Non Binary',
              onTap: () => setState(() => _gender = 'Non Binary'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJobStep(ThemeData theme) {
    return Column(
      key: const ValueKey('job'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 56),
        Text(
          'İşi',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFFF2C98A),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Eklediğin kişinin mesleği daha detaylı ilişki analizi yapmamızı sağlar.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 22),
        DropdownButtonFormField<String>(
          dropdownColor: const Color(0xFF1A214B),
          initialValue: _job,
          items: _jobOptions
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
          decoration: _inputDecoration('Meslek seç'),
          onChanged: (value) => setState(() => _job = value),
        ),
      ],
    );
  }

  Widget _buildRelationshipStep(ThemeData theme) {
    return Column(
      key: const ValueKey('relationship'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 56),
        Text(
          'İlişkiniz',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFFF2C98A),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Bu kişiyle olan ilişki tipini seç.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 22),
        DropdownButtonFormField<String>(
          dropdownColor: const Color(0xFF1A214B),
          initialValue: _relationship,
          items: _relationshipOptions
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
          decoration: _inputDecoration('İlişki seç'),
          onChanged: (value) => setState(() => _relationship = value),
        ),
      ],
    );
  }

  void _onNext() {
    if (!_validateCurrentStep()) {
      _showSnack('Lütfen bu adımı tamamla.');
      return;
    }

    if (_stepIndex < _totalSteps - 1) {
      setState(() => _stepIndex++);
      return;
    }

    _saveFriend();
  }

  bool _validateCurrentStep() {
    switch (_stepIndex) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        return _birthDate != null;
      case 2:
        return _birthTimeUnknown || _birthTime != null;
      case 3:
        return _selectedBirthLocation != null;
      case 4:
        return _gender != null;
      case 5:
        return _job != null;
      case 6:
        return _relationship != null;
      default:
        return false;
    }
  }

  Future<void> _saveFriend() async {
    setState(() => _isSaving = true);
    final minLoadingFuture = Future<void>.delayed(_savingMinDuration);

    final birthTimeValue = _birthTimeUnknown
        ? '12:00'
        : _birthTime != null
        ? _formatTime(_birthTime!)
        : null;

    String sunSign = _birthDate != null
        ? calculateZodiac(_birthDate!)
        : 'Bilinmiyor';
    String moonSign = 'Bilinmiyor';
    String risingSign = 'Bilinmiyor';
    String? timezone;

    final canCalculateFromApi =
        _birthDate != null &&
        birthTimeValue != null &&
        _selectedBirthLocation != null;

    if (canCalculateFromApi) {
      try {
        final resolvedBirthTime = birthTimeValue.split(':');
        final localDateTime = DateTime(
          _birthDate!.year,
          _birthDate!.month,
          _birthDate!.day,
          int.parse(resolvedBirthTime[0]),
          int.parse(resolvedBirthTime[1]),
        );

        final astro = await _astroApiService.calculate(
          localBirthDateTime: localDateTime,
          latitude: _selectedBirthLocation!.lat,
          longitude: _selectedBirthLocation!.lon,
        );

        sunSign = astro.sunSign;
        moonSign = astro.moonSign;
        risingSign = astro.ascendant;
        timezone = astro.timezone;
      } catch (_) {
        timezone = null;
      }
    }

    final payload = <String, dynamic>{
      'name': _nameController.text.trim(),
      'birthDate': _birthDate != null ? Timestamp.fromDate(_birthDate!) : null,
      'birthTime': birthTimeValue,
      'birthTimeUnknown': _birthTimeUnknown,
      'birthPlace': _birthPlace,
      'birthPlaceName': _selectedBirthLocation?.name,
      'birthPlaceCountry': _selectedBirthLocation?.country,
      'birthPlaceLat': _selectedBirthLocation?.lat,
      'birthPlaceLon': _selectedBirthLocation?.lon,
      'birthTimezone': timezone,
      'gender': _gender,
      'job': _job,
      'relationshipType': _relationship,
      'zodiacSign': sunSign,
      'moonSign': moonSign,
      'risingSign': risingSign,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      final friendId = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('compatibilityFriends')
          .doc()
          .id;

      payload['id'] = friendId;

      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'compatibilityFriends': {friendId: payload},
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await minLoadingFuture;

      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.65),
        builder: (context) => const _FriendAddedSuccessDialog(),
      );

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } on FirebaseException catch (e) {
      if (mounted) {
        _showSnack('Kayit hatasi: ${e.code}');
      }
    } catch (_) {
      if (mounted) {
        _showSnack('Kayıt sırasında bir hata oluştu.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _onPlaceChanged(String value) {
    final trimmed = value.trim();
    setState(() {
      _birthPlace = trimmed.isEmpty ? null : trimmed;
      _selectedBirthLocation = null;
    });

    _placeDebounce?.cancel();
    _placeDebounce = Timer(const Duration(milliseconds: 350), () {
      _searchPlaces(trimmed);
    });
  }

  Future<void> _searchPlaces(String query) async {
    final normalized = query.trim();
    if (normalized.length < 2) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSearchingPlaces = false;
        _placeSuggestions = const <LocationModel>[];
      });
      return;
    }

    final requestId = ++_placeSearchRequestId;
    if (mounted) {
      setState(() => _isSearchingPlaces = true);
    }

    try {
      final results = await _locationService.searchLocations(
        normalized,
        limit: 10,
        language: 'tr',
      );
      if (!mounted || requestId != _placeSearchRequestId) {
        return;
      }
      setState(() {
        _isSearchingPlaces = false;
        _placeSuggestions = results;
      });
    } catch (_) {
      if (!mounted || requestId != _placeSearchRequestId) {
        return;
      }
      setState(() {
        _isSearchingPlaces = false;
        _placeSuggestions = const <LocationModel>[];
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildPickerContainer({required Widget child}) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFF2C98A)),
      ),
    );
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFF2C98A)
                    : const Color(0xB47858D4),
                width: 1.6,
              ),
              color: isSelected
                  ? const Color(0x335A4F9C)
                  : Colors.white.withValues(alpha: 0.02),
            ),
            child: Icon(icon, size: 42, color: const Color(0xFFA475F5)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class CompatibilityFriendDetailPage extends StatefulWidget {
  const CompatibilityFriendDetailPage({
    super.key,
    this.currentUserName = 'Kullanici',
    this.currentUserAvatarId = 'terazi',
    this.friendAvatarId = 'terazi',
    this.currentUserSigns = const <String, String>{},
    this.friendData = const <String, dynamic>{},
  });

  final String currentUserName;
  final String currentUserAvatarId;
  final String friendAvatarId;
  final Map<String, String> currentUserSigns;
  final Map<String, dynamic> friendData;

  @override
  State<CompatibilityFriendDetailPage> createState() =>
      _CompatibilityFriendDetailPageState();
}

class _CompatibilityFriendDetailPageState
    extends State<CompatibilityFriendDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _selectedFriendFilter = 'Bugün';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendName = (widget.friendData['name'] as String?)?.trim();
    final resolvedFriendName = _capitalizeNameInitial(
      (friendName?.isNotEmpty ?? false) ? friendName! : 'Arkadas',
    );
    final resolvedCurrentUserName = _capitalizeNameInitial(
      widget.currentUserName,
    );

    final friendSun = _displaySign(
      (widget.friendData['zodiacSign'] as String?) ?? 'Bilinmiyor',
    );
    final friendMoon = _displaySign(
      (widget.friendData['moonSign'] as String?) ?? 'Bilinmiyor',
    );
    final friendRising = _displaySign(
      (widget.friendData['risingSign'] as String?) ?? 'Bilinmiyor',
    );
    final friendVenus = _displaySign(
      (widget.friendData['venusSign'] as String?) ?? 'Bilinmiyor',
    );
    final currentUserAvatarId = _isValidAvatarId(widget.currentUserAvatarId)
        ? widget.currentUserAvatarId
        : _defaultAvatarIdForSign(widget.currentUserSigns['sun'] ?? '');
    final friendAvatarId = _isValidAvatarId(widget.friendAvatarId)
        ? widget.friendAvatarId
        : _defaultAvatarIdForSign(friendSun);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x330B1026),
                    Color(0x990B1026),
                    Color(0xE61B1F3B),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: const Color(0xFFF2C98A),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        tabs: [
                          const Tab(text: 'İkiniz Arasında'),
                          Tab(text: '$resolvedFriendName için'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBetweenTab(
                        context,
                        currentUserName: resolvedCurrentUserName,
                        friendName: resolvedFriendName,
                        currentUserAvatarId: currentUserAvatarId,
                        friendAvatarId: friendAvatarId,
                        currentUserSun: widget.currentUserSigns['sun'] ?? '',
                        friendSun: friendSun,
                      ),
                      _buildFriendTab(
                        context,
                        friendName: resolvedFriendName,
                        friendSun: friendSun,
                        friendMoon: friendMoon,
                        friendRising: friendRising,
                        friendVenus: friendVenus,
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

  void _showFriendInfoSheet(BuildContext context, String friendName) {
    final data = widget.friendData;

    // Doğum tarihi
    final birthDateRaw = data['birthDate'];
    String birthDateStr = 'Bilinmiyor';
    if (birthDateRaw is Timestamp) {
      final dt = birthDateRaw.toDate();
      const months = [
        '',
        'Ocak',
        'Şubat',
        'Mart',
        'Nisan',
        'Mayıs',
        'Haziran',
        'Temmuz',
        'Ağustos',
        'Eylül',
        'Ekim',
        'Kasım',
        'Aralık',
      ];
      birthDateStr = '${dt.day} ${months[dt.month]} ${dt.year}';
    }

    final birthTime = (data['birthTime'] as String?)?.trim();
    final birthTimeUnknown = data['birthTimeUnknown'] as bool? ?? false;
    final birthTimeStr = (birthTime != null && birthTime.isNotEmpty)
        ? birthTime
        : (birthTimeUnknown ? '12:00' : 'Bilinmiyor');

    final birthPlace =
        (data['birthPlaceName'] as String?)?.trim().isNotEmpty == true
        ? (data['birthPlaceName'] as String).trim()
        : (data['birthPlace'] as String?)?.trim() ?? 'Bilinmiyor';

    final gender = (data['gender'] as String?)?.trim() ?? 'Belirtilmemiş';
    final job = (data['job'] as String?)?.trim() ?? 'Belirtilmemiş';
    final relationship =
        (data['relationshipType'] as String?)?.trim() ?? 'Belirtilmemiş';

    final sun = _displaySign((data['zodiacSign'] as String?) ?? 'Bilinmiyor');
    final moon = _displaySign((data['moonSign'] as String?) ?? 'Bilinmiyor');
    final rising = _displaySign(
      (data['risingSign'] as String?) ?? 'Bilinmiyor',
    );
    final venus = _displaySign((data['venusSign'] as String?) ?? 'Bilinmiyor');

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF130535),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: Colors.white24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFFF2D293),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  friendName,
                  style: const TextStyle(
                    color: Color(0xFFF2D293),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Doğum Tarihi',
              value: birthDateStr,
            ),
            _InfoRow(
              icon: Icons.access_time_rounded,
              label: 'Doğum Saati',
              value: birthTimeStr,
            ),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Doğum Yeri',
              value: birthPlace,
            ),
            _InfoRow(icon: Icons.wc_rounded, label: 'Cinsiyet', value: gender),
            _InfoRow(
              icon: Icons.work_outline_rounded,
              label: 'Meslek',
              value: job,
            ),
            _InfoRow(
              icon: Icons.favorite_border_rounded,
              label: 'İlişki',
              value: relationship,
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SignChip(label: '☉ $sun'),
                _SignChip(label: '☾ $moon'),
                _SignChip(label: '↑ $rising'),
                _SignChip(label: '♀ $venus'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBetweenTab(
    BuildContext context, {
    required String currentUserName,
    required String friendName,
    required String currentUserAvatarId,
    required String friendAvatarId,
    required String currentUserSun,
    required String friendSun,
  }) {
    final weeklyComment = RelationshipWeeklyCommentGenerator.generate(
      signA: currentUserSun,
      signB: friendSun,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xBF2E2A67), Color(0xBF1B1A49)],
            ),
            border: Border.all(color: const Color(0x88D8B87B), width: 1.05),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.26),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                '$currentUserName - $friendName',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double buttonLeft = constraints.maxWidth * 0.68;
                  return Stack(
                    children: [
                      Positioned.fill(
                        top: 8,
                        left: 36,
                        right: 36,
                        child: IgnorePointer(child: _ConstellationConnector()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _CircleAvatarSign(
                            label: currentUserName,
                            avatarId: currentUserAvatarId,
                            sign: widget.currentUserSigns['sun'] ?? '',
                          ),
                          _CircleAvatarSign(
                            label: friendName,
                            avatarId: friendAvatarId,
                            sign: _displaySign(
                              (widget.friendData['zodiacSign'] as String?) ??
                                  'Bilinmiyor',
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: buttonLeft,
                        top: 24,
                        child: GestureDetector(
                          onTap: () =>
                              _showFriendInfoSheet(context, friendName),
                          child: Container(
                            padding: const EdgeInsets.all(1.2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF2D3D73), Color(0xFF5F8FC6)],
                              ),
                              border: Border.all(
                                color: const Color(0xFFE8D4A1),
                                width: 1.1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF9EE6FF,
                                  ).withValues(alpha: 0.42),
                                  blurRadius: 16,
                                  spreadRadius: 0.7,
                                ),
                                BoxShadow(
                                  color: const Color(
                                    0xFFF5DAA0,
                                  ).withValues(alpha: 0.22),
                                  blurRadius: 8,
                                  spreadRadius: 0.2,
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 4.8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF5A6D90),
                                    Color(0xFF3D4D6B),
                                  ],
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: Color(0xFFF2D293),
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Profil',
                                    style: TextStyle(
                                      color: Color(0xFFF8E2AD),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 14),
              const _MetricRow(label: 'Duygusal Bağ', value: 88),
              const _MetricRow(label: 'Fiziksel Çekim', value: 100),
              const _MetricRow(label: 'İletişim', value: 84),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _TransitFrameCard(
          title: weeklyComment.title,
          body: weeklyComment.body,
          tip: weeklyComment.tip,
        ),
      ],
    );
  }

  Widget _buildFriendTab(
    BuildContext context, {
    required String friendName,
    required String friendSun,
    required String friendMoon,
    required String friendRising,
    required String friendVenus,
  }) {
    final filters = ['Bugün', 'Bu Hafta', 'Doğum Haritası'];

    Widget contentCard;
    if (_selectedFriendFilter == 'Bugün') {
      final comment = ZodionaDailyCommentGenerator.generate(
        userName: friendName,
        sunSign: friendSun,
        moonSign: friendMoon,
        risingSign: friendRising,
      );
      contentCard = _CardSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${comment.focusTypeLabel} odağı: ${comment.focusSign}',
              style: const TextStyle(
                color: Color(0xFFF7D57A),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              comment.body,
              style: const TextStyle(color: Colors.white, height: 1.5),
            ),
          ],
        ),
      );
    } else if (_selectedFriendFilter == 'Bu Hafta') {
      final weekly = PeriodicHoroscopeGenerator.general(
        sunSign: friendSun,
        period: HoroscopePeriod.weekly,
      );
      contentCard = _CardSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weekly.title,
              style: const TextStyle(
                color: Color(0xFFF7D57A),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weekly.body,
              style: const TextStyle(color: Colors.white, height: 1.5),
            ),
          ],
        ),
      );
    } else {
      contentCard = const _CardSurface(
        child: Text(
          'Doğum haritası yorumu için karta dokun.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filters
              .map(
                (f) => _FilterChip(
                  label: f,
                  selected: _selectedFriendFilter == f,
                  onTap: () {
                    if (f == 'Doğum Haritası') {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BirthChartDetailPage(
                            externalData: widget.friendData,
                            ownerName: friendName,
                          ),
                        ),
                      );
                    } else {
                      setState(() => _selectedFriendFilter = f);
                    }
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 14),
        contentCard,
      ],
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 17),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignChip extends StatelessWidget {
  const _SignChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFF2D293),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SavingFriendOverlay extends StatelessWidget {
  const _SavingFriendOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Center(
            child: Container(
              width: 280,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              decoration: BoxDecoration(
                color: const Color(0xE61D2446),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0x80F2C98A)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 28,
                    width: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      valueColor: AlwaysStoppedAnimation(Color(0xFFF2C98A)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Yıldızlar hizalanıyor',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Uyum profili hazırlanıyor, lütfen bekle...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final progress = (value.clamp(0, 100)) / 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label  %$value',
            style: const TextStyle(
              color: Color(0xFFE6D3A0),
              fontWeight: FontWeight.w400,
              fontSize: 13.6,
            ),
          ),
          const SizedBox(height: 4.5),
          _CrystalMeterBar(progress: progress),
        ],
      ),
    );
  }
}

class _CrystalMeterBar extends StatelessWidget {
  const _CrystalMeterBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final safe = progress.clamp(0.0, 1.0);
    final knobOffset = (safe * 100).clamp(2, 98) / 100;

    return SizedBox(
      height: 12,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 12,
            right: 12,
            top: 2,
            child: Container(
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Color(0x8A69708F), Color(0x66545A73)],
                ),
                border: Border.all(color: const Color(0x88D0BB8A), width: 0.6),
              ),
            ),
          ),
          Positioned(left: 0, top: 1, child: _barCap(false)),
          Positioned(right: 0, top: 1, child: _barCap(true)),
          Positioned(
            left: 12,
            right: 12,
            top: 3,
            child: FractionallySizedBox(
              widthFactor: safe,
              alignment: Alignment.centerLeft,
              child: Row(
                children: List.generate(5, (i) {
                  final isBlue = i == 0;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: i == 4 ? 0 : 1),
                      height: 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: isBlue
                            ? const LinearGradient(
                                colors: [Color(0xFFCFE8FF), Color(0xFF87B3D6)],
                              )
                            : const LinearGradient(
                                colors: [Color(0xFFFCEFC6), Color(0xFFE2BE6D)],
                              ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isBlue
                                        ? const Color(0xFFBEE7FF)
                                        : const Color(0xFFFFE39F))
                                    .withValues(alpha: 0.28),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: 2,
            child: FractionallySizedBox(
              widthFactor: knobOffset,
              alignment: Alignment.centerLeft,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 5.5,
                  height: 5.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2CB),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFF2CB).withValues(alpha: 0.95),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _barCap(bool right) {
    return Transform.rotate(
      angle: right ? 3.14159 : 0,
      child: SizedBox(
        width: 10,
        height: 11,
        child: CustomPaint(painter: _BarCapPainter()),
      ),
    );
  }
}

class _BarCapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width - 1, 0)
      ..lineTo(size.width - 1, size.height)
      ..close();

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE8D5A6), Color(0xFFBE9850)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConstellationConnector extends StatelessWidget {
  const _ConstellationConnector();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ConstellationPainter());
  }
}

class _ConstellationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xCCDAE6FF)
      ..strokeWidth = 1.25
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = const Color(0x66DAE6FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.2);

    final points = <Offset>[
      Offset(size.width * 0.04, size.height * 0.50),
      Offset(size.width * 0.11, size.height * 0.33),
      Offset(size.width * 0.19, size.height * 0.42),
      Offset(size.width * 0.35, size.height * 0.51),
      Offset(size.width * 0.46, size.height * 0.53),
      Offset(size.width * 0.54, size.height * 0.53),
      Offset(size.width * 0.68, size.height * 0.45),
      Offset(size.width * 0.77, size.height * 0.29),
      Offset(size.width * 0.88, size.height * 0.14),
      Offset(size.width * 0.93, size.height * 0.29),
    ];

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    for (final p in points) {
      canvas.drawCircle(p, 2.7, glowPaint);
      canvas.drawCircle(p, 1.85, Paint()..color = const Color(0xFFF5F7FF));
    }

    final center = Offset(size.width * 0.52, size.height * 0.54);
    final starPath = Path()
      ..moveTo(center.dx, center.dy - 5)
      ..lineTo(center.dx + 1.6, center.dy - 1.2)
      ..lineTo(center.dx + 5, center.dy)
      ..lineTo(center.dx + 1.6, center.dy + 1.2)
      ..lineTo(center.dx, center.dy + 5)
      ..lineTo(center.dx - 1.6, center.dy + 1.2)
      ..lineTo(center.dx - 5, center.dy)
      ..lineTo(center.dx - 1.6, center.dy - 1.2)
      ..close();
    canvas.drawPath(starPath, Paint()..color = const Color(0xFFF4DEAA));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TransitFrameCard extends StatelessWidget {
  const _TransitFrameCard({
    required this.title,
    required this.body,
    required this.tip,
  });

  final String title;
  final String body;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xC056556D), Color(0xC03A415B)],
        ),
        border: Border.all(color: const Color(0x88D2BE90), width: 1.05),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 210,
                      height: 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(left: -4, top: -9, child: _MoonBadge()),
          const Positioned(right: -7, top: -10, child: _SaturnBadge()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'İlişkinizi Etkileyen Transitler',
                style: TextStyle(
                  color: Color(0xFFF2C98A),
                  fontWeight: FontWeight.w700,
                  fontSize: 13.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                style: const TextStyle(
                  color: Colors.white,
                  height: 1.52,
                  fontSize: 12.8,
                ),
              ),
              const SizedBox(height: 12),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0x2AF2C98A), Color(0x1B7F6A45)],
                      ),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: const Color(0xA6D5BD88)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFF7D57A),
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            tip,
                            style: const TextStyle(
                              color: Color(0xFFF7D57A),
                              height: 1.42,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(left: -10, top: -1, child: _TipPillar()),
                  const Positioned(right: -10, top: -1, child: _TipPillar()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoonBadge extends StatelessWidget {
  const _MoonBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Color(0xFFF4E0BE), Color(0xFFBA9760)],
            ),
          ),
        ),
        const SizedBox(width: 2),
        Container(
          width: 25,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              colors: [Color(0xFFE6D09F), Color(0xFF9D7D40)],
            ),
          ),
        ),
      ],
    );
  }
}

class _SaturnBadge extends StatelessWidget {
  const _SaturnBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.45,
            child: Container(
              width: 24,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD7BF90), width: 1),
              ),
            ),
          ),
          Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFF1DFC0), Color(0xFFB08E56)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipPillar extends StatelessWidget {
  const _TipPillar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 23,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE5D6B8), Color(0xFF9C8250)],
        ),
      ),
      child: Center(
        child: Container(
          width: 3,
          height: 3,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF73CDEB),
          ),
        ),
      ),
    );
  }
}

class _CircleAvatarSign extends StatelessWidget {
  const _CircleAvatarSign({
    required this.label,
    required this.avatarId,
    this.sign = '',
  });

  final String label;
  final String avatarId;
  final String sign;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0x2268A7FF), Color(0x111B2149)],
                ),
                border: Border.all(color: const Color(0xFFF2C98A), width: 1.8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB1DFFF).withValues(alpha: 0.22),
                    blurRadius: 10,
                    spreadRadius: 0.3,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  _avatarAssetPathForId(avatarId),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF0E2152),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white70,
                        size: 36,
                      ),
                    );
                  },
                ),
              ),
            ),
            if (sign.isNotEmpty)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6D49B6), Color(0xFF4B2591)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border.all(
                      color: const Color(0xFFF2D293),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFF2CC).withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    sign.isNotEmpty ? sign.substring(0, 1) : '',
                    style: const TextStyle(
                      color: Color(0xFFF2D293),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFD8D2C5),
            fontSize: 30 / 2,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF2C98A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF2C98A)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF1B1F3B) : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

String _displaySign(String value) {
  switch (value.trim()) {
    case 'Koc':
      return 'Koç';
    case 'Boga':
      return 'Boğa';
    case 'Ikizler':
      return 'İkizler';
    case 'Yengec':
      return 'Yengeç';
    case 'Basak':
      return 'Başak';
    case 'Oglak':
      return 'Oğlak';
    default:
      return value.trim().isEmpty ? 'Bilinmiyor' : value.trim();
  }
}

String _capitalizeNameInitial(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return trimmed;
  }
  const trUpperMap = {
    'i': 'İ',
    'ı': 'I',
    'ş': 'Ş',
    'ğ': 'Ğ',
    'ü': 'Ü',
    'ö': 'Ö',
    'ç': 'Ç',
  };
  final first = trimmed[0];
  final upperFirst = trUpperMap[first] ?? first.toUpperCase();
  return '$upperFirst${trimmed.substring(1)}';
}

bool _isValidAvatarId(String? id) {
  if (id == null || id.trim().isEmpty) {
    return false;
  }
  return _avatarAssetById.containsKey(id.trim());
}

String _defaultAvatarIdForSign(String sign) {
  const signToAvatar = <String, String>{
    'Koç': 'koc',
    'Boğa': 'boga',
    'İkizler': 'ikizler',
    'Yengeç': 'yengec',
    'Aslan': 'aslan',
    'Başak': 'basak',
    'Terazi': 'terazi',
    'Akrep': 'akrep',
    'Yay': 'yay',
    'Oğlak': 'oglak',
    'Kova': 'kova',
    'Balık': 'balik',
  };
  return signToAvatar[sign] ?? 'terazi';
}

String _avatarAssetPathForId(String id) {
  final normalized = id.trim();
  return _avatarAssetById[normalized] ?? _avatarAssetById['terazi']!;
}

const Map<String, String> _avatarAssetById = <String, String>{
  'kova': 'assets/burclar/kova.png',
  'balik': 'assets/burclar/balık.png',
  'terazi': 'assets/burclar/terazi.png',
  'aslan': 'assets/burclar/aslan.png',
  'ikizler': 'assets/burclar/ikizler.png',
  'oglak': 'assets/burclar/oglak.png',
  'yengec': 'assets/burclar/yengec.png',
  'koc': 'assets/burclar/koc.png',
  'yay': 'assets/burclar/yay.png',
  'akrep': 'assets/burclar/akrep.png',
  'boga': 'assets/burclar/boga.png',
  'basak': 'assets/burclar/basak.png',
};

class _FriendAddedSuccessDialog extends StatelessWidget {
  const _FriendAddedSuccessDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1D2446), Color(0xFF0D1230)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFFF2C98A).withValues(alpha: 0.55),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF2C98A).withValues(alpha: 0.18),
              blurRadius: 36,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: const Color(0xFF7B5FF5).withValues(alpha: 0.25),
              blurRadius: 48,
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Dağılmış yıldız süslemeleri
              Positioned(top: 14, right: 22, child: _Star(size: 9)),
              Positioned(top: 32, left: 18, child: _Star(size: 5)),
              Positioned(top: 58, right: 48, child: _Star(size: 4)),
              Positioned(bottom: 72, right: 26, child: _Star(size: 6)),
              Positioned(bottom: 50, left: 14, child: _Star(size: 5)),
              Positioned(top: 18, left: 52, child: _Star(size: 4)),
              // İçerik
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gezegen + parlama ikonu
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Dış halkalar (gezegen halkası efekti)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(
                                0xFFF2C98A,
                              ).withValues(alpha: 0.18),
                              width: 14,
                            ),
                          ),
                        ),
                        // Orta parlayan gezegen
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [Color(0xFF7B5FF5), Color(0xFF3A2680)],
                              center: Alignment(-0.3, -0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFA475F5,
                                ).withValues(alpha: 0.5),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFF2C98A),
                            size: 36,
                          ),
                        ),
                        // Sağ üst küçük yıldız rozeti
                        Positioned(
                          top: -2,
                          right: 2,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1D2446),
                              border: Border.all(
                                color: const Color(
                                  0xFFF2C98A,
                                ).withValues(alpha: 0.7),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Color(0xFFF2C98A),
                              size: 15,
                            ),
                          ),
                        ),
                        // Sol alt küçük hilal rozeti
                        Positioned(
                          bottom: -2,
                          left: 4,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1D2446),
                              border: Border.all(
                                color: const Color(
                                  0xFFA475F5,
                                ).withValues(alpha: 0.7),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.brightness_3,
                              color: Color(0xFFA475F5),
                              size: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Başlık
                    const Text(
                      'Yıldızlar Hizalandı! ✨',
                      style: TextStyle(
                        color: Color(0xFFF2C98A),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    // Dekoratif ayırıcı
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 1,
                          color: const Color(
                            0xFFF2C98A,
                          ).withValues(alpha: 0.45),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.brightness_3,
                            color: Color(0xFFF2C98A),
                            size: 11,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.star,
                            color: Color(0xFFF2C98A),
                            size: 9,
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 1,
                          color: const Color(
                            0xFFF2C98A,
                          ).withValues(alpha: 0.45),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Açıklama metni
                    Text(
                      'Profil bilgileri başarıyla eklendi.\nYıldızlarda yazılı uyumunuzu görmeye hazır ol!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 14.5,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Buton
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFF2C98A,
                          ).withValues(alpha: 0.12),
                          foregroundColor: const Color(0xFFF2C98A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: const BorderSide(
                              color: Color(0xFFF2C98A),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.auto_awesome, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Harika, Göreyim!',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star,
      size: size,
      color: const Color(0xFFF2C98A).withValues(alpha: 0.30),
    );
  }
}
