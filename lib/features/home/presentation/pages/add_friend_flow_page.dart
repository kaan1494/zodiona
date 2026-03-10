import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/location_model.dart';
import '../../../../services/astro_api_service.dart';
import '../../../../services/location_service.dart';
import '../../../../utils/zodiac.dart';

class AddCompatibilityFriendPage extends StatefulWidget {
  const AddCompatibilityFriendPage({super.key, required this.uid});

  final String uid;

  @override
  State<AddCompatibilityFriendPage> createState() => _AddCompatibilityFriendPageState();
}

class _AddCompatibilityFriendPageState extends State<AddCompatibilityFriendPage> {
  static const _savingMinDuration = Duration(seconds: 3);

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
    'Anne',
    'Baba',
    'Kardes',
    'Es',
    'Sevgili',
    'Flort',
    'Platonik',
    'Arkadas',
    'Eski Es',
    'Eski Sevgili',
    'Is Arkadasi',
    'Cocuk',
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
                        onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Arkadas Ekle',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFFF2C98A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
          'Iliskinizi analiz etmek icin onu daha yakindan taniyalim.',
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
          decoration: _inputDecoration('Isim'),
        ),
      ],
    );
  }

  Widget _buildBirthDateStep(ThemeData theme) {
    final displayName = _nameController.text.trim().isEmpty
        ? 'Arkadasin'
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
          'Ekledigin kisinin dogum tarihi, gunes burcu ve astrolojik kimliginin temelidir.',
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
            initialDateTime: _birthDate ?? DateTime(DateTime.now().year - 25, 1, 1),
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
          'Dogum Saati',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFFF2C98A),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Dogum saati, gezegenlerin tam konumlarini daha dogru hesaplamamizi saglar.',
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
          'Dogum saati bilinmiyorsa 12:00 olarak kabul edilir.',
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
          'Dogum Yeri',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFFF2C98A),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Dogum yerini secerek daha dogru yildiz haritasi cikarmamizi saglayabilirsin.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _placeController,
          onChanged: _onPlaceChanged,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Sehir veya ulke ara'),
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
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
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
              'Sonuc bulunamadi. Farkli yazimla tekrar dene.',
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
          'Bu bilgi, iliski yorumlarini daha kisisel hale getirmemize yardimci olur.',
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
              label: 'Kadin',
              icon: Icons.female,
              isSelected: _gender == 'Kadin',
              onTap: () => setState(() => _gender = 'Kadin'),
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
          'Isi',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFFF2C98A),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Ekledigin kisinin meslegi daha detayli iliski analizi yapmamizi saglar.',
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
                  child: Text(item, style: const TextStyle(color: Colors.white)),
                ),
              )
              .toList(),
          decoration: _inputDecoration('Meslek sec'),
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
          'Iliskiniz',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFFF2C98A),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Bu kisiyle olan iliski tipini sec.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: _pickRelationship,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF2C98A)),
              color: Colors.white.withValues(alpha: 0.05),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _relationship ?? 'Iliski sec',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onNext() {
    if (!_validateCurrentStep()) {
      _showSnack('Lutfen bu adimi tamamla.');
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
        ? null
        : _birthTime != null
        ? _formatTime(_birthTime!)
        : null;

    String sunSign = _birthDate != null ? calculateZodiac(_birthDate!) : 'Bilinmiyor';
    String moonSign = 'Bilinmiyor';
    String risingSign = 'Bilinmiyor';
    String? timezone;

    final canCalculateFromApi =
        _birthDate != null &&
        _birthTime != null &&
        !_birthTimeUnknown &&
        _selectedBirthLocation != null;

    if (canCalculateFromApi) {
      try {
        final localDateTime = DateTime(
          _birthDate!.year,
          _birthDate!.month,
          _birthDate!.day,
          _birthTime!.hour,
          _birthTime!.minute,
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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .set({
            'compatibilityFriends': {friendId: payload},
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      await minLoadingFuture;

      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Iliskiniz'),
            content: const Text(
              'Profil bilgileri basariyla eklendi, yildizlarda yazili uyumunuzu gormeye hazir ol!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tamam'),
              ),
            ],
          );
        },
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
        _showSnack('Kayit sirasinda bir hata olustu.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _pickRelationship() async {
    final currentIndex = _relationshipOptions.indexOf(_relationship ?? '');
    int selectedIndex = currentIndex >= 0 ? currentIndex : 0;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Container(
            height: 290,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6B6792),
                  Color(0xFF5D5A86),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
                  child: Row(
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Iptal',
                          style: TextStyle(
                            color: Color(0xFFE9DFEF),
                            fontSize: 26 / 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Iliskiniz',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFFE9DFEF),
                            fontSize: 30 / 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onPressed: () {
                          setState(() => _relationship = _relationshipOptions[selectedIndex]);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Bitti',
                          style: TextStyle(
                            color: Color(0xFFF2C98A),
                            fontSize: 26 / 2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    backgroundColor: Colors.transparent,
                    scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                    itemExtent: 34,
                    selectionOverlay: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSelectedItemChanged: (value) => selectedIndex = value,
                    children: _relationshipOptions
                        .map(
                          (item) => Center(
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: Color(0xFFECE8F7),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
      final results = await _locationService.searchLocations(normalized, limit: 10, language: 'tr');
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
                color: isSelected ? const Color(0xFFF2C98A) : const Color(0xB47858D4),
                width: 1.6,
              ),
              color: isSelected ? const Color(0x335A4F9C) : Colors.white.withValues(alpha: 0.02),
            ),
            child: Icon(
              icon,
              size: 42,
              color: const Color(0xFFA475F5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class CompatibilityFriendDetailPage extends StatefulWidget {
  const CompatibilityFriendDetailPage({
    super.key,
    required this.currentUserName,
    required this.currentUserSigns,
    required this.friendData,
  });

  final String currentUserName;
  final Map<String, String> currentUserSigns;
  final Map<String, dynamic> friendData;

  @override
  State<CompatibilityFriendDetailPage> createState() => _CompatibilityFriendDetailPageState();
}

class _CompatibilityFriendDetailPageState extends State<CompatibilityFriendDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
    final resolvedFriendName =
        (friendName?.isNotEmpty ?? false) ? friendName! : 'Arkadas';

    final friendSun = _displaySign((widget.friendData['zodiacSign'] as String?) ?? 'Bilinmiyor');
    final friendMoon = _displaySign((widget.friendData['moonSign'] as String?) ?? 'Bilinmiyor');
    final friendRising = _displaySign((widget.friendData['risingSign'] as String?) ?? 'Bilinmiyor');

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
                  colors: [Color(0x330B1026), Color(0x990B1026), Color(0xE61B1F3B)],
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
                          const Tab(text: 'Ikiniz Arasinda'),
                          Tab(text: '$resolvedFriendName icin'),
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
                        friendName: resolvedFriendName,
                        friendSun: friendSun,
                      ),
                      _buildFriendTab(
                        context,
                        friendName: resolvedFriendName,
                        friendSun: friendSun,
                        friendMoon: friendMoon,
                        friendRising: friendRising,
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

  Widget _buildBetweenTab(
    BuildContext context, {
    required String friendName,
    required String friendSun,
  }) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: [
        _CardSurface(
          child: Column(
            children: [
              Text(
                '${widget.currentUserName} - $friendName',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CircleSign(label: widget.currentUserName, sign: widget.currentUserSigns['sun'] ?? ''),
                  _CircleSign(label: friendName, sign: friendSun),
                ],
              ),
              const SizedBox(height: 16),
              const _MetricRow(label: 'Duygusal Bag', value: 88),
              const _MetricRow(label: 'Fiziksel Cekim', value: 100),
              const _MetricRow(label: 'Iletisim', value: 84),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _CardSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Iliskinizi Etkileyen Transitler',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              Text(
                'Bu kisim, secili kisi icin ortak gezegen etkilerini ve donemsel iliski yorumlarini gosterir.',
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
            ],
          ),
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
  }) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        Text(
          friendName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '☉ $friendSun   ☾ $friendMoon   ↑ $friendRising',
          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _FilterChip(label: 'Bugun', selected: true),
            _FilterChip(label: 'Bu Hafta'),
            _FilterChip(label: 'Transitler'),
            _FilterChip(label: 'Dogum Haritasi'),
          ],
        ),
        const SizedBox(height: 14),
        const _CardSurface(
          child: Text(
            'Bugun, yakin iliskilerde daha dengeli bir enerji var. Kucuk ama anlamli adimlarla baginizi guclendirebilirsiniz.',
            style: TextStyle(color: Colors.white, height: 1.5),
          ),
        ),
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
                    'Yildizlar hizalaniyor',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Uyum profili hazirlaniyor, lutfen bekle...',
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label  %$value',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            minHeight: 4,
            value: value / 100,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(Color(0xFFF2C98A)),
          ),
        ],
      ),
    );
  }
}

class _CircleSign extends StatelessWidget {
  const _CircleSign({required this.label, required this.sign});

  final String label;
  final String sign;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.12),
            border: Border.all(color: const Color(0xFFF2C98A), width: 1.6),
          ),
          alignment: Alignment.center,
          child: Text(
            sign.isEmpty ? '?' : sign.characters.first,
            style: const TextStyle(color: Colors.white, fontSize: 26),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
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
