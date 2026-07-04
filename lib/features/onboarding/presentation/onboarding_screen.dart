import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/location_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/location_service.dart';
import '../../../utils/city_normalizer.dart';
import '../../../utils/zodiac.dart';
import '../../home/presentation/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.userId});

  final String userId;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
    'Bekar',
    'İlişkim var',
    'Nişanlı',
    'Evli',
    'Boşanmış',
    'Karmaşık',
    'Dul',
    'Açık ilişki',
  ];

  static const _stepImages = <String>[
    'assets/onboarding/name.png',
    'assets/onboarding/birth_date.png',
    'assets/onboarding/birth_time.png',
    'assets/onboarding/job.png',
    'assets/onboarding/relationship.png',
    'assets/onboarding/birth_place.png',
    'assets/onboarding/gender.png',
  ];

  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _authService = AuthService();
  final _locationService = LocationService();

  int _stepIndex = 0;
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  bool _birthTimeUnknown = false;
  String? _job;
  String? _relationshipStatus;
  String? _birthPlace;
  LocationModel? _selectedBirthLocation;
  String? _gender;
  bool _isSaving = false;
  bool _isSearchingPlaces = false;
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
    final stepImage = _stepImages[_stepIndex.clamp(0, _stepImages.length - 1)];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              stepImage,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Color(0x220B1026),
                    Color(0x880B1026),
                    Color(0xFF1B1F3B),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      if (_stepIndex > 0)
                        IconButton(
                          onPressed: _isSaving ? null : _previousStep,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        )
                      else
                        const SizedBox(width: 48),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'ZODIONA',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                letterSpacing: 4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: (_stepIndex + 1) / _totalSteps,
                                minHeight: 6,
                                backgroundColor: Colors.white12,
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFFF2C98A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Padding(
                      key: ValueKey(_stepIndex),
                      padding: _stepIndex == 0
                          ? EdgeInsets.zero
                          : const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                      child: _buildStepContent(theme),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF2C98A),
                        foregroundColor: const Color(0xFF1B1F3B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _stepIndex == _totalSteps - 1
                                  ? 'Tamamla'
                                  : 'Devam Et',
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

  Widget _buildStepContent(ThemeData theme) {
    switch (_stepIndex) {
      case 0:
        return _buildNameStep(theme);
      case 1:
        return _buildBirthDateStep(theme);
      case 2:
        return _buildBirthTimeStep(theme);
      case 3:
        return _buildJobStep(theme);
      case 4:
        return _buildRelationshipStep(theme);
      case 5:
        return _buildBirthPlaceStep(theme);
      case 6:
        return _buildGenderStep(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNameStep(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final topSpacing = (constraints.maxHeight * 0.22).clamp(120.0, 220.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: topSpacing),
              Text(
                'Adın',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Yolculuğa başlamadan önce seni biraz tanımak istiyorum.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Adın'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBirthDateStep(ThemeData theme) {
    final displayName = _nameController.text.trim().isEmpty
        ? 'Merhaba'
        : _nameController.text.trim();
    final initialDate = _birthDate ?? DateTime(DateTime.now().year - 25, 1, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          displayName,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Doğduğun gün, hikayenin ilk sayfası. Bu bilgiyi paylaşırsan, gökyüzündeki izini daha net okuyabilirim.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        _buildCupertinoPickerContainer(
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: initialDate,
            maximumDate: DateTime.now(),
            minimumDate: DateTime(1900),
            onDateTimeChanged: (value) {
              setState(() => _birthDate = value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBirthTimeStep(ThemeData theme) {
    final initialTime = _birthTime ?? const TimeOfDay(hour: 12, minute: 0);
    final initialDateTime = DateTime(
      2000,
      1,
      1,
      initialTime.hour,
      initialTime.minute,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Doğum Saatin',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Doğum saatin, gezegenlerin konumunu netleştirmemize yardımcı olur.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Opacity(
          opacity: _birthTimeUnknown ? 0.4 : 1,
          child: IgnorePointer(
            ignoring: _birthTimeUnknown,
            child: _buildCupertinoPickerContainer(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: initialDateTime,
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
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Bilmiyorum (12:00 olarak kabul edilsin)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: const Color(0xFFF2C98A),
        ),
      ],
    );
  }

  Widget _buildJobStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'İş',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Günlük hayatında seni en iyi anlatan rol hangisi?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        _buildChoiceList(theme, _jobOptions, _job, (value) {
          setState(() => _job = value);
        }),
      ],
    );
  }

  Widget _buildRelationshipStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'İlişki Durumun',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Kalbinin ritmi nasıl? Bağlarını birlikte okuyalım.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        _buildChoiceList(theme, _relationshipOptions, _relationshipStatus, (
          value,
        ) {
          setState(() => _relationshipStatus = value);
        }),
      ],
    );
  }

  Widget _buildBirthPlaceStep(ThemeData theme) {
    final suggestions = _placeSuggestions;
    final query = _placeController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Doğum Yerin',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Doğum yerin, yıldız yolculuğunun başlangıç noktası.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        const Spacer(),
        TextField(
          controller: _placeController,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Doğum yeri ara'),
          onChanged: _onPlaceChanged,
        ),
        const SizedBox(height: 16),
        if (_isSearchingPlaces)
          const LinearProgressIndicator(
            minHeight: 2,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(Color(0xFFF2C98A)),
          ),
        if (_isSearchingPlaces) const SizedBox(height: 12),
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
              'Sonuç bulunamadı. Farklı bir yazımla tekrar dene.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          )
        else
          const Spacer(),
      ],
    );
  }

  Widget _buildGenderStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          'Cinsiyetin',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Ruhunun kimliğini bilmek, sana daha özel rehberlik ve\n'
          'wellbeing önerileri sunmama yardımcı olacak.\n'
          'Cinsiyet bilgisini benimle paylaşmak ister misin?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        Text(
          'Cinsiyetin',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFFF2C98A),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGenderCard(
              theme,
              label: 'Erkek',
              icon: Icons.male,
              isSelected: _gender == 'Erkek',
              onTap: () => setState(() => _gender = 'Erkek'),
            ),
            const SizedBox(width: 16),
            _buildGenderCard(
              theme,
              label: 'Kadın',
              icon: Icons.female,
              isSelected: _gender == 'Kadın',
              onTap: () => setState(() => _gender = 'Kadın'),
            ),
            const SizedBox(width: 16),
            _buildGenderCard(
              theme,
              label: 'Belirtmek istemiyorum',
              icon: Icons.transgender,
              isSelected: _gender == 'Belirtmek istemiyorum',
              onTap: () => setState(() => _gender = 'Belirtmek istemiyorum'),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildGenderCard(
    ThemeData theme, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final borderColor = isSelected
        ? const Color(0xFFF2C98A)
        : Colors.white.withValues(alpha: 0.35);
    final fillColor = isSelected
        ? const Color(0xFF5A4F9C)
        : Colors.white.withValues(alpha: 0.08);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
              boxShadow: isSelected
                  ? const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceList(
    ThemeData theme,
    List<String> options,
    String? selected,
    ValueChanged<String> onSelect,
  ) {
    return Expanded(
      child: ListView.separated(
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selected;
          return InkWell(
            onTap: () => onSelect(option),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF5A4F9C)
                    : Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFFF2C98A) : Colors.white24,
                ),
              ),
              child: Text(
                option,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _previousStep() {
    if (_stepIndex > 0) {
      setState(() => _stepIndex--);
    }
  }

  Future<void> _nextStep() async {
    if (!_validateCurrentStep()) {
      _showSnack('Lütfen bu adımı tamamla.');
      return;
    }

    if (_stepIndex < _totalSteps - 1) {
      setState(() => _stepIndex++);
      return;
    }

    await _completeOnboarding();
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
        return _job != null;
      case 4:
        return _relationshipStatus != null;
      case 5:
        return _selectedBirthLocation != null;
      case 6:
        return _gender != null;
      default:
        return false;
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isSaving = true);

    final birthTimeValue = _birthTimeUnknown
        ? '12:00'
        : _birthTime != null
        ? _formatTime(_birthTime!)
        : null;

    String sunSign = _birthDate != null ? calculateZodiac(_birthDate!) : '';
    String moonSign = 'Bilinmiyor';
    String risingSign = 'Bilinmiyor';
    String venusSign = 'Bilinmiyor';
    String? timezone = 'pending';

    final canCalculateFromApi =
        _birthDate != null &&
        birthTimeValue != null &&
        _selectedBirthLocation != null;

    if (!canCalculateFromApi) {
      timezone = null;
    }

    final normalizedCity = normalizeCityName(
      _selectedBirthLocation?.name ?? _birthPlace,
    );

    final data = <String, dynamic>{
      'name': _nameController.text.trim(),
      'birthDate': _birthDate != null ? Timestamp.fromDate(_birthDate!) : null,
      'birthTime': birthTimeValue,
      'birthTimeUnknown': _birthTimeUnknown,
      'job': _job,
      'relationshipStatus': _relationshipStatus,
      'birthPlace': _birthPlace,
      'birthPlaceName': normalizedCity.isEmpty
          ? _selectedBirthLocation?.name
          : normalizedCity,
      'birthPlaceCountry': _selectedBirthLocation?.country,
      'birthPlaceLat': _selectedBirthLocation?.lat,
      'birthPlaceLon': _selectedBirthLocation?.lon,
      'cityNormalized': normalizedCity.isEmpty ? null : normalizedCity,
      'birthTimezone': timezone,
      'gender': _gender,
      'zodiacSign': sunSign,
      'moonSign': moonSign,
      'risingSign': risingSign,
      'venusSign': venusSign,
      'onboardingCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      await _authService.saveOnboardingData(uid: widget.userId, data: data);
      if (!mounted) {
        return;
      }
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (_) {
      if (mounted) {
        _showSnack('Kayıt tamamlanamadı. Tekrar dene.');
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
      final results = await _fetchWorldPlaceSuggestions(normalized);
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

  Future<List<LocationModel>> _fetchWorldPlaceSuggestions(String query) {
    return _locationService.searchLocations(query, limit: 10, language: 'tr');
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFF2C98A)),
      ),
    );
  }

  Widget _buildCupertinoPickerContainer({required Widget child}) {
    return Container(
      height: 190,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: child,
    );
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
}
