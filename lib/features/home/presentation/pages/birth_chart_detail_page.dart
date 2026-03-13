import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../utils/zodiac.dart';

class BirthChartDetailPage extends StatefulWidget {
  const BirthChartDetailPage({super.key});

  @override
  State<BirthChartDetailPage> createState() => _BirthChartDetailPageState();
}

class _BirthChartDetailPageState extends State<BirthChartDetailPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF030B2A),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xAA04184A), Color(0xCC04133C)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
                  child: Row(
                    children: [
                      const SizedBox(width: 38),
                      Expanded(
                        child: Text(
                          'Doğum Haritan',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: const Color(0xFFF8E5BE),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white70),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ),
                if (uid == null)
                  Expanded(
                    child: Center(
                      child: Text(
                        'Kullanıcı bilgisi bulunamadı.',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.white70),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            final data =
                                snapshot.data?.data() ?? <String, dynamic>{};
                            final birthData = _BirthUserData.fromMap(data);
                            final chart = _NatalChartBuilder.build(birthData);

                            return SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _SignText(icon: '☉', sign: chart.sunSign),
                                      const SizedBox(width: 12),
                                      _SignText(
                                        icon: '☾',
                                        sign: chart.moonSign,
                                      ),
                                      const SizedBox(width: 12),
                                      _SignText(
                                        icon: '↑',
                                        sign: chart.risingSign,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Center(
                                    child: SizedBox(
                                      width: 330,
                                      height: 330,
                                      child: CustomPaint(
                                        painter: _NatalChartPainter(
                                          chart: chart,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _TabBarPills(
                                    selectedIndex: _selectedTabIndex,
                                    onChanged: (index) {
                                      setState(() => _selectedTabIndex = index);
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  ..._buildTabCards(context, chart),
                                ],
                              ),
                            );
                          },
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTabCards(BuildContext context, _NatalChart chart) {
    final items = switch (_selectedTabIndex) {
      0 => chart.planetCards,
      1 => chart.houseCards,
      2 => chart.aspectCards,
      _ => chart.personalityCards,
    };

    return items
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _BirthChartInfoCard(
              title: item.title,
              subtitle: item.subtitle,
              detail: item.detail,
              glyph: item.glyph,
              color: item.color,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        _BirthChartPlaceholderDetailPage(title: item.title),
                  ),
                );
              },
            ),
          ),
        )
        .toList(growable: false);
  }
}

class _SignText extends StatelessWidget {
  const _SignText({required this.icon, required this.sign});

  final String icon;
  final String sign;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$icon ${_displaySign(sign)}',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: const Color(0xFFECD6A8),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TabBarPills extends StatelessWidget {
  const _TabBarPills({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['Gezegenler', 'Evler', 'Açılar', 'Kişilik'];

    return Row(
      children: List.generate(labels.length, (index) {
        final active = selectedIndex == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 8),
            child: InkWell(
              onTap: () => onChanged(index),
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: active ? Colors.white : Colors.white70,
                    width: 1.2,
                  ),
                ),
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: active ? const Color(0xFF00174D) : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _BirthChartInfoCard extends StatelessWidget {
  const _BirthChartInfoCard({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.glyph,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String detail;
  final String glyph;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF131B5A).withValues(alpha: 0.92),
              const Color(0xFF07133F).withValues(alpha: 0.92),
            ],
          ),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            _GlyphAvatar(glyph: glyph, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.86),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.white54, size: 28),
          ],
        ),
      ),
    );
  }
}

class _GlyphAvatar extends StatelessWidget {
  const _GlyphAvatar({required this.glyph, required this.color});

  final String glyph;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.96),
            color.withValues(alpha: 0.22),
            const Color(0xFF060E3A),
          ],
          stops: const [0.0, 0.58, 1.0],
        ),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          glyph,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFFFFF2D2),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _BirthChartPlaceholderDetailPage extends StatelessWidget {
  const _BirthChartPlaceholderDetailPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06133E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Bu alanın detay içeriğini bir sonraki adımda ekleyeceğiz.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _NatalChartPainter extends CustomPainter {
  const _NatalChartPainter({required this.chart});

  final _NatalChart chart;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;

    final outerFill = Paint()..color = const Color(0xFF11284E);
    final innerFill = Paint()..color = const Color(0xFFF2F3F7);
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF6D798B);

    canvas.drawCircle(center, radius, outerFill);
    canvas.drawCircle(center, radius * 0.82, innerFill);
    canvas.drawCircle(center, radius, border);
    canvas.drawCircle(center, radius * 0.82, border);

    _drawSigns(canvas, center, radius);
    _drawHouses(canvas, center, radius);
    _drawAspects(canvas, center, radius * 0.52);
    _drawPlanets(canvas, center, radius);
  }

  void _drawSigns(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 12; i++) {
      final angle = _degToRad(-90 + i * 30);
      final start = Offset(
        center.dx + math.cos(angle) * radius * 0.82,
        center.dy + math.sin(angle) * radius * 0.82,
      );
      final end = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = const Color(0xFFADB9CA)
          ..strokeWidth = 1,
      );

      final signAngle = _degToRad(-90 + i * 30 + 15);
      final signOffset = Offset(
        center.dx + math.cos(signAngle) * radius * 0.9,
        center.dy + math.sin(signAngle) * radius * 0.9,
      );
      _paintGlyph(
        canvas,
        _zodiacGlyphs[i],
        signOffset,
        const TextStyle(
          color: Color(0xFFD9E4F1),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }

  void _drawHouses(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 12; i++) {
      final cusp = _normalizeDeg(chart.ascendantLongitude + i * 30);
      final angle = _degToRad(-90 + cusp);
      final end = Offset(
        center.dx + math.cos(angle) * radius * 0.82,
        center.dy + math.sin(angle) * radius * 0.82,
      );
      canvas.drawLine(
        center,
        end,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.17)
          ..strokeWidth = 0.9,
      );

      final houseMid = _normalizeDeg(chart.ascendantLongitude + i * 30 + 15);
      final houseAngle = _degToRad(-90 + houseMid);
      final labelOffset = Offset(
        center.dx + math.cos(houseAngle) * radius * 0.57,
        center.dy + math.sin(houseAngle) * radius * 0.57,
      );
      _paintGlyph(
        canvas,
        '${i + 1}',
        labelOffset,
        const TextStyle(
          color: Color(0xFF4B5361),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      );
    }
  }

  void _drawPlanets(Canvas canvas, Offset center, double radius) {
    for (final placement in chart.placements) {
      final angle = _degToRad(-90 + placement.longitude);
      final point = Offset(
        center.dx + math.cos(angle) * radius * 0.72,
        center.dy + math.sin(angle) * radius * 0.72,
      );

      canvas.drawCircle(
        point,
        7,
        Paint()
          ..color = placement.color.withValues(alpha: 0.95)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        point,
        7,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.7,
      );
      _paintGlyph(
        canvas,
        placement.glyph,
        point,
        const TextStyle(
          color: Color(0xFF031136),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      );
    }
  }

  void _drawAspects(Canvas canvas, Offset center, double radius) {
    for (final aspect in chart.aspects) {
      final angleA = _degToRad(-90 + aspect.from.longitude);
      final angleB = _degToRad(-90 + aspect.to.longitude);
      final pointA = Offset(
        center.dx + math.cos(angleA) * radius,
        center.dy + math.sin(angleA) * radius,
      );
      final pointB = Offset(
        center.dx + math.cos(angleB) * radius,
        center.dy + math.sin(angleB) * radius,
      );

      final color = switch (aspect.type) {
        _AspectType.square || _AspectType.opposition => const Color(0xFFCD5A77),
        _AspectType.trine => const Color(0xFF4E9EE8),
        _AspectType.sextile => const Color(0xFF67C8BC),
        _AspectType.conjunction => const Color(0xFFD7A451),
      };

      canvas.drawLine(
        pointA,
        pointB,
        Paint()
          ..color = color.withValues(alpha: 0.7)
          ..strokeWidth = 1,
      );
    }
  }

  void _paintGlyph(Canvas canvas, String text, Offset center, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(
      canvas,
      Offset(center.dx - painter.width / 2, center.dy - painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _NatalChartPainter oldDelegate) {
    return oldDelegate.chart.seed != chart.seed;
  }
}

class _BirthUserData {
  const _BirthUserData({
    required this.birthDate,
    required this.birthTime,
    required this.latitude,
    required this.longitude,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
  });

  final DateTime? birthDate;
  final String? birthTime;
  final double? latitude;
  final double? longitude;
  final String sunSign;
  final String moonSign;
  final String risingSign;

  factory _BirthUserData.fromMap(Map<String, dynamic> map) {
    final timestamp = map['birthDate'];
    final birthDate = timestamp is Timestamp ? timestamp.toDate() : null;

    final sunRaw = (map['zodiacSign'] as String?)?.trim();
    final moonRaw = (map['moonSign'] as String?)?.trim();
    final risingRaw = (map['risingSign'] as String?)?.trim();

    final fallbackSun = birthDate != null
        ? calculateZodiac(birthDate)
        : 'Bilinmiyor';

    return _BirthUserData(
      birthDate: birthDate,
      birthTime: (map['birthTime'] as String?)?.trim(),
      latitude: _asDouble(map['birthPlaceLat']),
      longitude: _asDouble(map['birthPlaceLon']),
      sunSign: _sanitizeSign(sunRaw, fallback: fallbackSun),
      moonSign: _sanitizeSign(moonRaw, fallback: 'Bilinmiyor'),
      risingSign: _sanitizeSign(risingRaw, fallback: 'Bilinmiyor'),
    );
  }
}

class _NatalChartBuilder {
  static _NatalChart build(_BirthUserData userData) {
    final localDateTime = _buildLocalBirthDateTime(
      birthDate: userData.birthDate,
      birthTime: userData.birthTime,
    );

    final baseDateTime = localDateTime ?? DateTime(2000, 1, 1, 12, 0);
    final utcLike = DateTime.utc(
      baseDateTime.year,
      baseDateTime.month,
      baseDateTime.day,
      baseDateTime.hour,
      baseDateTime.minute,
    );

    final latitude = userData.latitude ?? 39.9255;
    final longitude = userData.longitude ?? 32.8663;

    var sunLongitude = _sunLongitude(utcLike);
    var moonLongitude = _moonLongitude(utcLike);
    var ascLongitude = _ascendantLongitude(
      utcDateTime: utcLike,
      latitudeDeg: latitude,
      longitudeDeg: longitude,
    );

    sunLongitude = _coerceLongitudeToSign(sunLongitude, userData.sunSign);
    moonLongitude = _coerceLongitudeToSign(moonLongitude, userData.moonSign);
    ascLongitude = _coerceLongitudeToSign(ascLongitude, userData.risingSign);

    final d =
        utcLike.difference(DateTime.utc(2000, 1, 1, 12)).inMinutes / 1440.0;
    final seed = _normalizeDeg(
      (utcLike.millisecondsSinceEpoch / 60000) +
          latitude * 11.2 +
          longitude * 7.4,
    );

    double generic(String key, double l0, double speed) {
      final wobble = 1.8 * math.sin(_degToRad(seed + key.codeUnitAt(0) * 17.0));
      return _normalizeDeg(l0 + speed * d + wobble);
    }

    final rawLongitudes = <String, double>{
      'Sun': sunLongitude,
      'Moon': moonLongitude,
      'Asc': ascLongitude,
      'Mercury': generic('Mercury', 252.25, 4.09233445),
      'Venus': generic('Venus', 181.98, 1.60213034),
      'Mars': generic('Mars', 355.43, 0.52402068),
      'Jupiter': generic('Jupiter', 34.35, 0.08308529),
      'Saturn': generic('Saturn', 50.08, 0.03344414),
      'Uranus': generic('Uranus', 314.05, 0.01172834),
      'Neptune': generic('Neptune', 304.35, 0.00598103),
      'Pluto': generic('Pluto', 238.95, 0.00396400),
      'NorthNode': generic('NorthNode', 125.0, -0.0529538),
      'Chiron': generic('Chiron', 209.2, 0.02),
      'SouthNode': _normalizeDeg(generic('NorthNode', 125.0, -0.0529538) + 180),
      'Fortune': _normalizeDeg(ascLongitude + moonLongitude - sunLongitude),
      'Juno': generic('Juno', 169.2, 0.09),
      'MC': _normalizeDeg(ascLongitude + 90),
    };

    final placements = [
      _PlanetPlacement(
        key: 'Sun',
        label: 'Güneş',
        theme: 'Benlik',
        glyph: '☉',
        color: const Color(0xFFFFC361),
        longitude: rawLongitudes['Sun']!,
      ),
      _PlanetPlacement(
        key: 'Moon',
        label: 'Ay',
        theme: 'Hisler',
        glyph: '☾',
        color: const Color(0xFFBFD6FF),
        longitude: rawLongitudes['Moon']!,
      ),
      _PlanetPlacement(
        key: 'Asc',
        label: 'Yükselen',
        theme: 'Sosyal Kişiliğim',
        glyph: '↑',
        color: const Color(0xFFF1E3A6),
        longitude: rawLongitudes['Asc']!,
      ),
      _PlanetPlacement(
        key: 'Mercury',
        label: 'Merkür',
        theme: 'Düşünceler',
        glyph: '☿',
        color: const Color(0xFFAFD8FF),
        longitude: rawLongitudes['Mercury']!,
      ),
      _PlanetPlacement(
        key: 'Venus',
        label: 'Venüs',
        theme: 'Sevgi',
        glyph: '♀',
        color: const Color(0xFFFFA9C7),
        longitude: rawLongitudes['Venus']!,
      ),
      _PlanetPlacement(
        key: 'Mars',
        label: 'Mars',
        theme: 'Hareket',
        glyph: '♂',
        color: const Color(0xFFFF867C),
        longitude: rawLongitudes['Mars']!,
      ),
      _PlanetPlacement(
        key: 'Jupiter',
        label: 'Jüpiter',
        theme: 'Büyüme',
        glyph: '♃',
        color: const Color(0xFFEBC18A),
        longitude: rawLongitudes['Jupiter']!,
      ),
      _PlanetPlacement(
        key: 'Saturn',
        label: 'Satürn',
        theme: 'Yaratım',
        glyph: '♄',
        color: const Color(0xFFCFBC9A),
        longitude: rawLongitudes['Saturn']!,
      ),
      _PlanetPlacement(
        key: 'Uranus',
        label: 'Uranüs',
        theme: 'Yenilik',
        glyph: '♅',
        color: const Color(0xFF87CEFF),
        longitude: rawLongitudes['Uranus']!,
      ),
      _PlanetPlacement(
        key: 'Neptune',
        label: 'Neptün',
        theme: 'Hayaller',
        glyph: '♆',
        color: const Color(0xFF7BB5FF),
        longitude: rawLongitudes['Neptune']!,
      ),
      _PlanetPlacement(
        key: 'Pluto',
        label: 'Plüton',
        theme: 'Güç',
        glyph: '♇',
        color: const Color(0xFFC4E2FF),
        longitude: rawLongitudes['Pluto']!,
      ),
      _PlanetPlacement(
        key: 'NorthNode',
        label: 'Kuzey Ay Düğümü',
        theme: 'Evrim',
        glyph: '☊',
        color: const Color(0xFFF0DA97),
        longitude: rawLongitudes['NorthNode']!,
      ),
      _PlanetPlacement(
        key: 'Chiron',
        label: 'Kiron',
        theme: 'Şifa',
        glyph: '⚷',
        color: const Color(0xFFD3D3E8),
        longitude: rawLongitudes['Chiron']!,
      ),
      _PlanetPlacement(
        key: 'SouthNode',
        label: 'Güney Ay Düğümü',
        theme: 'Alışkanlık',
        glyph: '☋',
        color: const Color(0xFFEFD294),
        longitude: rawLongitudes['SouthNode']!,
      ),
      _PlanetPlacement(
        key: 'Fortune',
        label: 'Şans Noktası',
        theme: 'Refah',
        glyph: '⊗',
        color: const Color(0xFFF7E0A7),
        longitude: rawLongitudes['Fortune']!,
      ),
      _PlanetPlacement(
        key: 'Juno',
        label: 'Juno',
        theme: 'Bağlanma',
        glyph: '✶',
        color: const Color(0xFFE4D9B4),
        longitude: rawLongitudes['Juno']!,
      ),
      _PlanetPlacement(
        key: 'MC',
        label: 'MC Noktası',
        theme: 'Yön',
        glyph: 'MC',
        color: const Color(0xFFEAD7A0),
        longitude: rawLongitudes['MC']!,
      ),
    ];

    final placementsWithMeta = placements
        .map(
          (item) => item.copyWith(
            sign: _signFromLongitude(item.longitude),
            house: _houseFromLongitude(item.longitude, ascLongitude),
          ),
        )
        .toList(growable: false);

    final aspects = _buildAspects(placementsWithMeta);

    final houseCards = List.generate(12, (index) {
      final houseNumber = index + 1;
      final cuspSign = _signFromLongitude(
        _normalizeDeg(ascLongitude + index * 30),
      );
      final title = '$houseNumber. Ev: ${_houseTheme(houseNumber)}';
      return _InfoCardData(
        title: title,
        subtitle:
            '$houseNumber. ev ${_displaySign(cuspSign)} burcuyla başlıyor',
        detail: 'Yönetici tema: ${_houseDetail(houseNumber)}',
        glyph: '$houseNumber',
        color: const Color(0xFFA2C1FF),
      );
    });

    final aspectCards = aspects.isEmpty
        ? [
            const _InfoCardData(
              title: 'Açı Yorumu Hazırlanıyor',
              subtitle: 'Açı listesi doğum verilerine göre yenilenecek',
              detail: 'Kısa süre sonra burada görünecek',
              glyph: '△',
              color: Color(0xFF8BC2FF),
            ),
          ]
        : aspects
              .take(14)
              .map(
                (aspect) => _InfoCardData(
                  title: '${aspect.from.label} - ${aspect.to.label}',
                  subtitle: _aspectTitle(aspect.type),
                  detail:
                      '${aspect.from.label} ${aspect.from.house}. ev • ${aspect.to.label} ${aspect.to.house}. ev',
                  glyph: _aspectGlyph(aspect.type),
                  color: _aspectColor(aspect.type),
                ),
              )
              .toList(growable: false);

    final personalityCards = [
      _InfoCardData(
        title: 'Kimlik İmzası',
        subtitle:
            'Güneş ${_displaySign(userData.sunSign)}, Ay ${_displaySign(userData.moonSign)}, Yükselen ${_displaySign(userData.risingSign)}',
        detail:
            'Dışarıya verdiğin izlenim ile iç motivasyonun bu eksende şekillenir',
        glyph: '✦',
        color: const Color(0xFFEFC56E),
      ),
      _InfoCardData(
        title: 'Element Dengesi',
        subtitle: _elementBalanceText(placementsWithMeta),
        detail: 'Element dağılımı günlük karar ritmini etkiler',
        glyph: '◌',
        color: const Color(0xFF86D7F4),
      ),
      _InfoCardData(
        title: 'Öne Çıkan Evler',
        subtitle: _topHousesText(placementsWithMeta),
        detail: 'Bu evler hayat akışında daha görünür çalışır',
        glyph: '⌂',
        color: const Color(0xFFBDA9FF),
      ),
    ];

    final planetCards = placementsWithMeta
        .map(
          (item) => _InfoCardData(
            title: '${item.label}: ${item.theme}',
            subtitle: '${item.label} ${_displaySign(item.sign)} Burcunda',
            detail: '${item.house}. Ev',
            glyph: item.glyph,
            color: item.color,
          ),
        )
        .toList(growable: false);

    return _NatalChart(
      seed: seed,
      sunSign: userData.sunSign,
      moonSign: userData.moonSign,
      risingSign: userData.risingSign,
      ascendantLongitude: ascLongitude,
      placements: placementsWithMeta,
      aspects: aspects,
      planetCards: planetCards,
      houseCards: houseCards,
      aspectCards: aspectCards,
      personalityCards: personalityCards,
    );
  }
}

class _NatalChart {
  const _NatalChart({
    required this.seed,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
    required this.ascendantLongitude,
    required this.placements,
    required this.aspects,
    required this.planetCards,
    required this.houseCards,
    required this.aspectCards,
    required this.personalityCards,
  });

  final double seed;
  final String sunSign;
  final String moonSign;
  final String risingSign;
  final double ascendantLongitude;
  final List<_PlanetPlacement> placements;
  final List<_AspectConnection> aspects;
  final List<_InfoCardData> planetCards;
  final List<_InfoCardData> houseCards;
  final List<_InfoCardData> aspectCards;
  final List<_InfoCardData> personalityCards;
}

class _PlanetPlacement {
  const _PlanetPlacement({
    required this.key,
    required this.label,
    required this.theme,
    required this.glyph,
    required this.color,
    required this.longitude,
    this.sign = 'Bilinmiyor',
    this.house = 1,
  });

  final String key;
  final String label;
  final String theme;
  final String glyph;
  final Color color;
  final double longitude;
  final String sign;
  final int house;

  _PlanetPlacement copyWith({String? sign, int? house}) {
    return _PlanetPlacement(
      key: key,
      label: label,
      theme: theme,
      glyph: glyph,
      color: color,
      longitude: longitude,
      sign: sign ?? this.sign,
      house: house ?? this.house,
    );
  }
}

class _InfoCardData {
  const _InfoCardData({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.glyph,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String detail;
  final String glyph;
  final Color color;
}

enum _AspectType { conjunction, sextile, square, trine, opposition }

class _AspectConnection {
  const _AspectConnection({
    required this.from,
    required this.to,
    required this.type,
  });

  final _PlanetPlacement from;
  final _PlanetPlacement to;
  final _AspectType type;
}

List<_AspectConnection> _buildAspects(List<_PlanetPlacement> placements) {
  final result = <_AspectConnection>[];

  for (int i = 0; i < placements.length; i++) {
    for (int j = i + 1; j < placements.length; j++) {
      final first = placements[i];
      final second = placements[j];
      final diff = _angleDistance(first.longitude, second.longitude);

      _AspectType? type;
      if ((diff - 0).abs() <= 7) {
        type = _AspectType.conjunction;
      } else if ((diff - 60).abs() <= 4) {
        type = _AspectType.sextile;
      } else if ((diff - 90).abs() <= 5) {
        type = _AspectType.square;
      } else if ((diff - 120).abs() <= 5) {
        type = _AspectType.trine;
      } else if ((diff - 180).abs() <= 6) {
        type = _AspectType.opposition;
      }

      if (type != null) {
        result.add(_AspectConnection(from: first, to: second, type: type));
      }
    }
  }

  return result;
}

String _aspectTitle(_AspectType type) {
  return switch (type) {
    _AspectType.conjunction => 'Kavuşum Açısı',
    _AspectType.sextile => 'Altmışlık Açısı',
    _AspectType.square => 'Kare Açısı',
    _AspectType.trine => 'Üçgen Açısı',
    _AspectType.opposition => 'Karşıtlık Açısı',
  };
}

String _aspectGlyph(_AspectType type) {
  return switch (type) {
    _AspectType.conjunction => '☌',
    _AspectType.sextile => '✶',
    _AspectType.square => '□',
    _AspectType.trine => '△',
    _AspectType.opposition => '☍',
  };
}

Color _aspectColor(_AspectType type) {
  return switch (type) {
    _AspectType.conjunction => const Color(0xFFE7BD64),
    _AspectType.sextile => const Color(0xFF6DCFC3),
    _AspectType.square => const Color(0xFFD3718A),
    _AspectType.trine => const Color(0xFF70A6EA),
    _AspectType.opposition => const Color(0xFFCF607F),
  };
}

DateTime? _buildLocalBirthDateTime({
  required DateTime? birthDate,
  required String? birthTime,
}) {
  if (birthDate == null) {
    return null;
  }

  final raw = birthTime?.trim();
  if (raw == null || raw.isEmpty || raw == 'Bilinmiyor') {
    return DateTime(birthDate.year, birthDate.month, birthDate.day, 12, 0);
  }

  final parts = raw.split(':');
  if (parts.length != 2) {
    return DateTime(birthDate.year, birthDate.month, birthDate.day, 12, 0);
  }

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) {
    return DateTime(birthDate.year, birthDate.month, birthDate.day, 12, 0);
  }

  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    return DateTime(birthDate.year, birthDate.month, birthDate.day, 12, 0);
  }

  return DateTime(birthDate.year, birthDate.month, birthDate.day, hour, minute);
}

double? _asDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

String _sanitizeSign(String? value, {required String fallback}) {
  final trimmed = value?.trim();
  if (trimmed == null ||
      trimmed.isEmpty ||
      trimmed == 'Bilinmiyor' ||
      trimmed == 'Yukleniyor...') {
    return fallback;
  }
  return trimmed;
}

int _houseFromLongitude(double longitude, double ascendantLongitude) {
  final normalized = _normalizeDeg(longitude - ascendantLongitude);
  return (normalized / 30).floor() + 1;
}

String _signFromLongitude(double longitude) {
  final index = (_normalizeDeg(longitude) / 30).floor() % 12;
  return _zodiacOrder[index];
}

double _coerceLongitudeToSign(double longitude, String sign) {
  final signIndex = _zodiacOrder.indexOf(sign);
  if (signIndex == -1 || sign == 'Bilinmiyor') {
    return _normalizeDeg(longitude);
  }

  final degreeInSign = _normalizeDeg(longitude) % 30;
  return _normalizeDeg(signIndex * 30 + degreeInSign);
}

double _sunLongitude(DateTime utcDateTime) {
  final jd = _julianDay(utcDateTime);
  final n = jd - 2451545.0;
  final l = _normalizeDeg(280.460 + 0.9856474 * n);
  final g = _normalizeDeg(357.528 + 0.9856003 * n);
  return _normalizeDeg(l + 1.915 * _sinDeg(g) + 0.020 * _sinDeg(2 * g));
}

double _moonLongitude(DateTime utcDateTime) {
  final jd = _julianDay(utcDateTime);
  final d = jd - 2451543.5;

  final n = _normalizeDeg(125.1228 - 0.0529538083 * d);
  const i = 5.1454;
  final w = _normalizeDeg(318.0634 + 0.1643573223 * d);
  const a = 60.2666;
  const e = 0.054900;
  final m = _normalizeDeg(115.3654 + 13.0649929509 * d);

  final eAnomaly = m + (180 / math.pi) * e * _sinDeg(m) * (1 + e * _cosDeg(m));

  final xv = a * (_cosDeg(eAnomaly) - e);
  final yv = a * (math.sqrt(1 - e * e) * _sinDeg(eAnomaly));

  final v = _radToDeg(math.atan2(yv, xv));
  final r = math.sqrt(xv * xv + yv * yv);

  final xh =
      r *
      (_cosDeg(n) * _cosDeg(v + w) - _sinDeg(n) * _sinDeg(v + w) * _cosDeg(i));
  final yh =
      r *
      (_sinDeg(n) * _cosDeg(v + w) + _cosDeg(n) * _sinDeg(v + w) * _cosDeg(i));

  return _normalizeDeg(_radToDeg(math.atan2(yh, xh)));
}

double _ascendantLongitude({
  required DateTime utcDateTime,
  required double latitudeDeg,
  required double longitudeDeg,
}) {
  final jd = _julianDay(utcDateTime);
  final t = (jd - 2451545.0) / 36525.0;
  final gmst = _normalizeDeg(
    280.46061837 +
        360.98564736629 * (jd - 2451545.0) +
        0.000387933 * t * t -
        t * t * t / 38710000.0,
  );
  final lst = _normalizeDeg(gmst + longitudeDeg);

  final phi = _degToRad(latitudeDeg);
  const eps = 23.439291111;
  final epsilon = _degToRad(eps);

  double bestLongitude = 0;
  double bestAltitudeAbs = double.infinity;
  double? crossingStart;
  double? crossingEnd;
  double? prevAltitude;
  bool? prevIsRising;

  for (double lambdaDeg = 0; lambdaDeg <= 360; lambdaDeg += 0.5) {
    final state = _eclipticState(
      lambdaDeg: lambdaDeg,
      lstDeg: lst,
      phi: phi,
      epsilon: epsilon,
    );

    if (state.isRising) {
      final altitudeAbs = state.altitudeRad.abs();
      if (altitudeAbs < bestAltitudeAbs) {
        bestAltitudeAbs = altitudeAbs;
        bestLongitude = lambdaDeg;
      }
    }

    if (prevAltitude != null &&
        prevIsRising == true &&
        state.isRising &&
        ((prevAltitude <= 0 && state.altitudeRad >= 0) ||
            (prevAltitude >= 0 && state.altitudeRad <= 0))) {
      crossingStart = lambdaDeg - 0.5;
      crossingEnd = lambdaDeg;
      break;
    }

    prevAltitude = state.altitudeRad;
    prevIsRising = state.isRising;
  }

  if (crossingStart != null && crossingEnd != null) {
    var a = crossingStart;
    var b = crossingEnd;

    for (int i = 0; i < 20; i++) {
      final mid = (a + b) / 2;
      final aState = _eclipticState(
        lambdaDeg: a,
        lstDeg: lst,
        phi: phi,
        epsilon: epsilon,
      );
      final midState = _eclipticState(
        lambdaDeg: mid,
        lstDeg: lst,
        phi: phi,
        epsilon: epsilon,
      );

      final sameSign =
          (aState.altitudeRad >= 0 && midState.altitudeRad >= 0) ||
          (aState.altitudeRad <= 0 && midState.altitudeRad <= 0);

      if (sameSign) {
        a = mid;
      } else {
        b = mid;
      }
    }

    bestLongitude = (a + b) / 2;
  }

  return _normalizeDeg(bestLongitude);
}

_EclipticState _eclipticState({
  required double lambdaDeg,
  required double lstDeg,
  required double phi,
  required double epsilon,
}) {
  final lambda = _degToRad(_normalizeDeg(lambdaDeg));

  final alpha = math.atan2(
    math.sin(lambda) * math.cos(epsilon),
    math.cos(lambda),
  );
  final alphaDeg = _normalizeDeg(_radToDeg(alpha));

  final delta = math.asin(math.sin(epsilon) * math.sin(lambda));
  final hourAngleDeg = _normalizeHourAngle(lstDeg - alphaDeg);
  final hourAngle = _degToRad(hourAngleDeg);

  final sinAltitude =
      math.sin(phi) * math.sin(delta) +
      math.cos(phi) * math.cos(delta) * math.cos(hourAngle);
  final altitude = math.asin(sinAltitude.clamp(-1.0, 1.0));

  return _EclipticState(altitudeRad: altitude, isRising: hourAngleDeg < 0);
}

class _EclipticState {
  const _EclipticState({required this.altitudeRad, required this.isRising});

  final double altitudeRad;
  final bool isRising;
}

double _julianDay(DateTime utcDateTime) {
  final dt = utcDateTime.toUtc();
  var year = dt.year;
  var month = dt.month;
  final day =
      dt.day +
      (dt.hour + (dt.minute + (dt.second + dt.millisecond / 1000) / 60) / 60) /
          24;

  if (month <= 2) {
    year -= 1;
    month += 12;
  }

  final a = (year / 100).floor();
  final b = 2 - a + (a / 4).floor();

  return (365.25 * (year + 4716)).floorToDouble() +
      (30.6001 * (month + 1)).floorToDouble() +
      day +
      b -
      1524.5;
}

double _angleDistance(double a, double b) {
  final diff = (_normalizeDeg(a) - _normalizeDeg(b)).abs();
  return diff > 180 ? 360 - diff : diff;
}

double _normalizeDeg(double value) {
  final result = value % 360;
  return result < 0 ? result + 360 : result;
}

double _normalizeHourAngle(double value) {
  final normalized = _normalizeDeg(value);
  return normalized > 180 ? normalized - 360 : normalized;
}

double _sinDeg(double value) => math.sin(_degToRad(value));
double _cosDeg(double value) => math.cos(_degToRad(value));
double _degToRad(double value) => value * math.pi / 180.0;
double _radToDeg(double value) => value * 180.0 / math.pi;

String _houseTheme(int house) {
  const themes = [
    'Benlik',
    'Maddi Kaynaklar',
    'İletişim',
    'Aile',
    'Yaratıcılık',
    'Düzen',
    'İlişkiler',
    'Dönüşüm',
    'Ufuk',
    'Kariyer',
    'Sosyal Alan',
    'Ruhsal Alan',
  ];
  return themes[house - 1];
}

String _houseDetail(int house) {
  const details = [
    'Kişisel duruş ve yeni başlangıçlar',
    'Gelir, sahip oldukların ve güven duygusu',
    'Yakın çevre, öğrenme ve ifade biçimi',
    'Ev, kökler ve aidiyet duygusu',
    'Aşk, keyif ve üretim enerjisi',
    'Çalışma ritmi, sağlık ve alışkanlıklar',
    'İkili ilişkiler ve ortaklıklar',
    'Paylaşılan kaynaklar ve psikolojik dönüşüm',
    'Eğitim, seyahat ve inanç sistemleri',
    'Toplumsal görünürlük ve meslek hedefi',
    'Arkadaşlıklar, ekipler ve vizyon',
    'İçe dönüş, bilinçaltı ve kapanışlar',
  ];
  return details[house - 1];
}

String _elementBalanceText(List<_PlanetPlacement> placements) {
  int fire = 0;
  int earth = 0;
  int air = 0;
  int water = 0;

  for (final placement in placements.take(10)) {
    switch (_elementOfSign(placement.sign)) {
      case 'Ateş':
        fire++;
      case 'Toprak':
        earth++;
      case 'Hava':
        air++;
      case 'Su':
        water++;
    }
  }

  return 'Ateş $fire • Toprak $earth • Hava $air • Su $water';
}

String _topHousesText(List<_PlanetPlacement> placements) {
  final counts = <int, int>{};
  for (final placement in placements.take(11)) {
    counts[placement.house] = (counts[placement.house] ?? 0) + 1;
  }

  final sorted = counts.entries.toList(growable: false)
    ..sort((a, b) => b.value.compareTo(a.value));

  if (sorted.isEmpty) {
    return 'Belirgin yoğunluk bulunamadı';
  }

  final top = sorted.take(3).map((entry) => '${entry.key}. Ev').toList();
  return top.join(' • ');
}

String _elementOfSign(String sign) {
  switch (sign) {
    case 'Koc':
    case 'Aslan':
    case 'Yay':
      return 'Ateş';
    case 'Boga':
    case 'Basak':
    case 'Oglak':
      return 'Toprak';
    case 'Ikizler':
    case 'Terazi':
    case 'Kova':
      return 'Hava';
    case 'Yengec':
    case 'Akrep':
    case 'Balik':
      return 'Su';
    default:
      return 'Ateş';
  }
}

String _displaySign(String value) {
  switch (value) {
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
    case 'Balik':
      return 'Balık';
    case 'Bilinmiyor':
      return 'Bilinmiyor';
    default:
      return value;
  }
}

const List<String> _zodiacOrder = <String>[
  'Koc',
  'Boga',
  'Ikizler',
  'Yengec',
  'Aslan',
  'Basak',
  'Terazi',
  'Akrep',
  'Yay',
  'Oglak',
  'Kova',
  'Balik',
];

const List<String> _zodiacGlyphs = <String>[
  '♈',
  '♉',
  '♊',
  '♋',
  '♌',
  '♍',
  '♎',
  '♏',
  '♐',
  '♑',
  '♒',
  '♓',
];
