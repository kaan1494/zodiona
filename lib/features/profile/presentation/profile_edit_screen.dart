import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/location_model.dart';
import '../../../services/location_service.dart';
import '../../../utils/zodiac.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  static const _jobOptions = <String>[
    'Teknik ve Muhendislik',
    'Saglik Hizmetleri',
    'Egitim',
    'Sanat, Tasarim ve Medya',
    'Sivil Toplum ve Kamu Sektoru',
    'Spor ve Fitness',
    'Serbest ve Bagimsiz Calisma',
    'Ogrenci',
    'Emekli',
    'Diger',
  ];

  static const _relationshipOptions = <String>[
    'Bekar',
    'İlişkim var',
    'Nişanlı',
    'Evli',
    'Boşanmış',
    'Karmaşık',
    'Dul',
    'Açık ilişki',
  ];

  static const _genderOptions = <String>['Erkek', 'Kadın', 'Non Binary'];

  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _locationService = LocationService();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSearchingPlaces = false;

  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  bool _birthTimeUnknown = false;
  String? _job;
  String? _relationshipStatus;
  String? _gender;

  String? _initialPlaceText;
  double? _existingPlaceLat;
  double? _existingPlaceLon;
  String? _existingPlaceCountry;

  String? _existingMoonSign;
  String? _existingRisingSign;
  String? _existingBirthTimezone;

  DateTime? _initialBirthDate;
  String? _initialBirthTime;
  bool _initialBirthTimeUnknown = false;

  List<LocationModel> _placeSuggestions = const <LocationModel>[];
  LocationModel? _selectedBirthLocation;
  Timer? _placeDebounce;
  int _placeSearchRequestId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _placeDebounce?.cancel();
    _nameController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
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
          .doc(uid)
          .get();
      final data = snapshot.data() ?? <String, dynamic>{};

      final name = (data['name'] as String?)?.trim() ?? '';
      final birthDateTs = data['birthDate'];
      final birthDate = birthDateTs is Timestamp ? birthDateTs.toDate() : null;
      final birthTimeText = (data['birthTime'] as String?)?.trim();
      final birthTimeUnknown = data['birthTimeUnknown'] as bool? ?? false;
      final job = (data['job'] as String?)?.trim();
      final relationship = (data['relationshipStatus'] as String?)?.trim();
      final gender = (data['gender'] as String?)?.trim();

      final placeName = (data['birthPlaceName'] as String?)?.trim();
      final placeFallback = (data['birthPlace'] as String?)?.trim();
      final placeText = (placeName?.isNotEmpty ?? false)
          ? placeName!
          : (placeFallback ?? '');

      _nameController.text = name;
      _placeController.text = placeText;

      _birthDate = birthDate;
      _birthTime = _parseTimeOfDay(birthTimeText);
      _birthTimeUnknown = birthTimeUnknown;
      _job = (job?.isNotEmpty ?? false) ? job : null;
      _relationshipStatus = (relationship?.isNotEmpty ?? false)
          ? relationship
          : null;
      _gender = (gender?.isNotEmpty ?? false) ? gender : null;

      _initialPlaceText = placeText;
      _existingPlaceLat = _asDouble(data['birthPlaceLat']);
      _existingPlaceLon = _asDouble(data['birthPlaceLon']);
      _existingPlaceCountry = (data['birthPlaceCountry'] as String?)?.trim();

      _existingMoonSign = (data['moonSign'] as String?)?.trim();
      _existingRisingSign = (data['risingSign'] as String?)?.trim();
      _existingBirthTimezone = (data['birthTimezone'] as String?)?.trim();

      _initialBirthDate = birthDate;
      _initialBirthTime = (birthTimeText?.isNotEmpty ?? false)
          ? birthTimeText
          : null;
      _initialBirthTimeUnknown = birthTimeUnknown;
    } catch (_) {
      _showSnack('Profil bilgileri yuklenemedi.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
                        child: Row(
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
                                'Profilim',
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
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          children: [
                            _buildTextInputTile(
                              label: 'Isim',
                              controller: _nameController,
                              hint: 'Adini yaz',
                            ),
                            const SizedBox(height: 14),
                            _buildDateTile(),
                            const SizedBox(height: 14),
                            _buildTimeTile(),
                            const SizedBox(height: 8),
                            CheckboxListTile(
                              value: _birthTimeUnknown,
                              onChanged: (value) {
                                setState(() {
                                  _birthTimeUnknown = value ?? false;
                                  if (_birthTimeUnknown) {
                                    _birthTime = null;
                                  }
                                });
                              },
                              title: const Text(
                                'Bilmiyorum (12:00 kabul edilsin)',
                                style: TextStyle(color: Colors.white70),
                              ),
                              side: const BorderSide(color: Colors.white38),
                              activeColor: const Color(0xFFF2C98A),
                              checkColor: const Color(0xFF151E45),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            const SizedBox(height: 8),
                            _buildPlaceInputSection(),
                            const SizedBox(height: 14),
                            _buildPickerTile(
                              label: 'Meslek',
                              value: _job,
                              hint: 'Meslek seç',
                              onTap: () async {
                                final selected = await _pickOption(
                                  title: 'Meslek',
                                  options: _jobOptions,
                                  current: _job,
                                );
                                if (selected != null) {
                                  setState(() => _job = selected);
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            _buildPickerTile(
                              label: 'Cinsiyet',
                              value: _gender,
                              hint: 'Cinsiyet seç',
                              onTap: () async {
                                final selected = await _pickOption(
                                  title: 'Cinsiyet',
                                  options: _genderOptions,
                                  current: _gender,
                                );
                                if (selected != null) {
                                  setState(() => _gender = selected);
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            _buildPickerTile(
                              label: 'İlişki Durumu',
                              value: _relationshipStatus,
                              hint: 'İlişki durumu seç',
                              onTap: () async {
                                final selected = await _pickOption(
                                  title: 'İlişki Durumu',
                                  options: _relationshipOptions,
                                  current: _relationshipStatus,
                                );
                                if (selected != null) {
                                  setState(
                                    () => _relationshipStatus = selected,
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isSaving ? null : _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF2D9A6),
                                  foregroundColor: const Color(0xFF131A3F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Kaydet',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
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

  Widget _buildTextInputTile({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
      decoration: _lineDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white, fontSize: 28 / 2),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white38),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTile() {
    final text = _birthDate == null
        ? '-'
        : '${_birthDate!.day.toString().padLeft(2, '0')} '
              '${_monthName(_birthDate!.month)} ${_birthDate!.year}';

    return _buildPickerTile(
      label: 'Doğum Tarihi',
      value: text,
      trailingIcon: Icons.calendar_month_outlined,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _birthDate ?? DateTime(DateTime.now().year - 25, 1, 1),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => _birthDate = picked);
        }
      },
    );
  }

  Widget _buildTimeTile() {
    final text = _birthTimeUnknown
        ? 'Bilinmiyor'
        : (_birthTime != null ? _formatTime(_birthTime!) : '-');

    return _buildPickerTile(
      label: 'Doğum Saati',
      value: text,
      trailingIcon: Icons.expand_more,
      onTap: () async {
        if (_birthTimeUnknown) {
          setState(() => _birthTimeUnknown = false);
        }
        final picked = await showTimePicker(
          context: context,
          initialTime: _birthTime ?? const TimeOfDay(hour: 12, minute: 0),
        );
        if (picked != null) {
          setState(() {
            _birthTime = picked;
            _birthTimeUnknown = false;
          });
        }
      },
    );
  }

  Widget _buildPlaceInputSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
      decoration: _lineDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doğduğun Şehir',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _placeController,
            onChanged: _onPlaceChanged,
            style: const TextStyle(color: Colors.white, fontSize: 28 / 2),
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'Doğum şehri ara',
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
            ),
          ),
          if (_isSearchingPlaces)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation(Color(0xFFF2C98A)),
              ),
            ),
          if (_placeSuggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _placeSuggestions.length,
                separatorBuilder: (_, _) =>
                    const Divider(color: Colors.white12, height: 1),
                itemBuilder: (context, index) {
                  final item = _placeSuggestions[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      item.displayLabel,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedBirthLocation = item;
                        _placeController.text = item.displayLabel;
                        _placeSuggestions = const <LocationModel>[];
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPickerTile({
    required String label,
    required VoidCallback onTap,
    String? value,
    String? hint,
    IconData trailingIcon = Icons.expand_more,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        decoration: _lineDecoration,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    (value?.trim().isNotEmpty ?? false)
                        ? value!.trim()
                        : (hint ?? '-'),
                    style: TextStyle(
                      color: (value?.trim().isNotEmpty ?? false)
                          ? Colors.white
                          : Colors.white38,
                      fontSize: 28 / 2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(trailingIcon, color: const Color(0xFFF2D28E)),
          ],
        ),
      ),
    );
  }

  Future<String?> _pickOption({
    required String title,
    required List<String> options,
    required String? current,
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
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFF2D28E),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
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

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) {
      _showSnack('İsim alanı boş bırakılamaz.');
      return;
    }
    if (_birthDate == null) {
      _showSnack('Doğum tarihi seçmelisin.');
      return;
    }
    if (!_birthTimeUnknown && _birthTime == null) {
      _showSnack(
        'Doğum saati seçmelisin ya da bilmiyorum seçeneğini işaretlemelisin.',
      );
      return;
    }
    if (_job == null) {
      _showSnack('Meslek seçmelisin.');
      return;
    }
    if (_relationshipStatus == null) {
      _showSnack('İlişki durumunu seçmelisin.');
      return;
    }
    if (_gender == null) {
      _showSnack('Cinsiyet seçmelisin.');
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      _showSnack('Kullanıcı oturumu bulunamadı.');
      return;
    }

    final placeText = _placeController.text.trim();
    final isPlaceChanged = placeText != (_initialPlaceText ?? '');

    String? birthPlaceName;
    String? birthPlaceCountry;
    double? birthPlaceLat;
    double? birthPlaceLon;

    if (_selectedBirthLocation != null) {
      birthPlaceName = _selectedBirthLocation!.name;
      birthPlaceCountry = _selectedBirthLocation!.country;
      birthPlaceLat = _selectedBirthLocation!.lat;
      birthPlaceLon = _selectedBirthLocation!.lon;
    } else if (placeText.isEmpty) {
      birthPlaceName = null;
      birthPlaceCountry = null;
      birthPlaceLat = null;
      birthPlaceLon = null;
    } else if (!isPlaceChanged) {
      birthPlaceName = placeText;
      birthPlaceCountry = _existingPlaceCountry;
      birthPlaceLat = _existingPlaceLat;
      birthPlaceLon = _existingPlaceLon;
    } else {
      birthPlaceName = placeText;
      birthPlaceCountry = null;
      birthPlaceLat = null;
      birthPlaceLon = null;
    }

    final birthTimeValue = _birthTimeUnknown
        ? null
        : (_birthTime != null ? _formatTime(_birthTime!) : null);

    final hasBirthDateChanged = !_sameDate(_initialBirthDate, _birthDate);
    final hasBirthTimeChanged =
        (_initialBirthTime ?? '') != (birthTimeValue ?? '');
    final hasBirthTimeUnknownChanged =
        _initialBirthTimeUnknown != _birthTimeUnknown;
    final hasPlaceGeoChanged =
        (_existingPlaceLat != birthPlaceLat) ||
        (_existingPlaceLon != birthPlaceLon);

    final shouldResetAstro =
        hasBirthDateChanged ||
        hasBirthTimeChanged ||
        hasBirthTimeUnknownChanged ||
        isPlaceChanged ||
        hasPlaceGeoChanged;

    final canCalculateFromApi =
        _birthDate != null &&
        !_birthTimeUnknown &&
        birthTimeValue != null &&
        birthPlaceLat != null &&
        birthPlaceLon != null;

    final timezone = shouldResetAstro
        ? (canCalculateFromApi ? 'pending' : null)
        : _existingBirthTimezone;

    final data = <String, dynamic>{
      'name': _nameController.text.trim(),
      'birthDate': Timestamp.fromDate(_birthDate!),
      'birthTime': birthTimeValue,
      'birthTimeUnknown': _birthTimeUnknown,
      'job': _job,
      'relationshipStatus': _relationshipStatus,
      'birthPlace': placeText.isEmpty ? null : placeText,
      'birthPlaceName': birthPlaceName,
      'birthPlaceCountry': birthPlaceCountry,
      'birthPlaceLat': birthPlaceLat,
      'birthPlaceLon': birthPlaceLon,
      'birthTimezone': timezone,
      'gender': _gender,
      'zodiacSign': calculateZodiac(_birthDate!),
      'moonSign': shouldResetAstro
          ? 'Bilinmiyor'
          : (_existingMoonSign?.isNotEmpty == true
                ? _existingMoonSign
                : 'Bilinmiyor'),
      'risingSign': shouldResetAstro
          ? 'Bilinmiyor'
          : (_existingRisingSign?.isNotEmpty == true
                ? _existingRisingSign
                : 'Bilinmiyor'),
      'onboardingCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(data, SetOptions(merge: true));
      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        _nameController.text.trim(),
      );

      _initialPlaceText = placeText;
      _existingPlaceLat = birthPlaceLat;
      _existingPlaceLon = birthPlaceLon;
      _existingPlaceCountry = birthPlaceCountry;
      _initialBirthDate = _birthDate;
      _initialBirthTime = birthTimeValue;
      _initialBirthTimeUnknown = _birthTimeUnknown;
      _existingBirthTimezone = timezone;
      _existingMoonSign = data['moonSign'] as String?;
      _existingRisingSign = data['risingSign'] as String?;

      if (!mounted) {
        return;
      }
      _showSnack('Profil bilgileri güncellendi.');
      Navigator.of(context).pop(true);
    } catch (_) {
      _showSnack('Kaydetme sırasında bir hata oluştu.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _onPlaceChanged(String value) {
    final trimmed = value.trim();
    _selectedBirthLocation = null;

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

  TimeOfDay? _parseTimeOfDay(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) {
      return null;
    }
    final parts = raw.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool _sameDate(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return a == b;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _monthName(int month) {
    const months = <int, String>{
      1: 'Ocak',
      2: 'Şubat',
      3: 'Mart',
      4: 'Nisan',
      5: 'Mayıs',
      6: 'Haziran',
      7: 'Temmuz',
      8: 'Ağustos',
      9: 'Eylül',
      10: 'Ekim',
      11: 'Kasım',
      12: 'Aralık',
    };
    return months[month] ?? '-';
  }

  double? _asDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
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
