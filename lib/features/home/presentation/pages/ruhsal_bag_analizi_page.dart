import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/ruhsal_bag_engine.dart';
import '../../../../utils/zodiac.dart';

// ─── Sayfa ────────────────────────────────────────────────────────────────────

class RuhsalBagAnaliziPage extends StatefulWidget {
  const RuhsalBagAnaliziPage({super.key});

  @override
  State<RuhsalBagAnaliziPage> createState() => _RuhsalBagAnaliziPageState();
}

class _RuhsalBagAnaliziPageState extends State<RuhsalBagAnaliziPage> {
  // ── Seçili / yeni kişi verileri ────────────────────────────────────────

  String? _secilenIsim;
  DateTime? _secilenTarih;
  String? _secilenGunes;
  String? _secilenAy;
  String? _secilenVenus;
  String? _secilenYukselen;

  // ── Yeni kişi formu ────────────────────────────────────────────────────

  final _isimCtrl = TextEditingController();
  DateTime? _yeniTarih;
  bool _formGosteriliyor = false;

  // ── Sonuç ──────────────────────────────────────────────────────────────

  RuhsalBagResult? _sonuc;
  bool _hesaplaniyor = false;

  @override
  void dispose() {
    _isimCtrl.dispose();
    super.dispose();
  }

  // ── Hesapla ────────────────────────────────────────────────────────────

  void _hesapla(Map<String, dynamic> kullaniciVerisi) {
    final kullaniciIsim = _kullaniciIsmiAl(kullaniciVerisi);
    final kullaniciTarih = _kullaniciTarihiAl(kullaniciVerisi);
    if (kullaniciTarih == null ||
        _secilenTarih == null ||
        _secilenIsim == null ||
        _secilenIsim!.trim().isEmpty) {
      return;
    }
    setState(() => _hesaplaniyor = true);

    final gunes1 =
        _normalizeSign((kullaniciVerisi['zodiacSign'] as String?)?.trim()) ??
        calculateZodiac(kullaniciTarih);
    final ay1 = _normalizeSign(
      (kullaniciVerisi['moonSign'] as String?)?.trim(),
    );
    final venus1 = _normalizeSign(
      (kullaniciVerisi['venusSign'] as String?)?.trim(),
    );
    final yukselen1 = _normalizeSign(
      (kullaniciVerisi['risingSign'] as String?)?.trim(),
    );

    final gunes2 = _secilenGunes ?? calculateZodiac(_secilenTarih!);

    final sonuc = RuhsalBagEngine.hesapla(
      isim1: kullaniciIsim,
      dogumTarihi1: kullaniciTarih,
      gunes1: gunes1,
      ay1: ay1,
      venus1: venus1,
      yukselen1: yukselen1,
      isim2: _secilenIsim!.trim(),
      dogumTarihi2: _secilenTarih!,
      gunes2: gunes2,
      ay2: _secilenAy,
      venus2: _secilenVenus,
      yukselen2: _secilenYukselen,
    );

    setState(() {
      _sonuc = sonuc;
      _hesaplaniyor = false;
    });
  }

  // ── Arkadaş seç ────────────────────────────────────────────────────────

  void _arkadasSec(Map<String, dynamic> arkadas) {
    final isim = (arkadas['name'] as String?)?.trim() ?? '';
    final tarihRaw = arkadas['birthDate'];
    final tarih = tarihRaw is Timestamp ? tarihRaw.toDate() : null;
    if (isim.isEmpty || tarih == null) return;

    setState(() {
      _secilenIsim = isim;
      _secilenTarih = tarih;
      _secilenGunes = _normalizeSign(
        (arkadas['zodiacSign'] as String?)?.trim(),
      );
      _secilenAy = _normalizeSign((arkadas['moonSign'] as String?)?.trim());
      _secilenVenus = _normalizeSign((arkadas['venusSign'] as String?)?.trim());
      _secilenYukselen = _normalizeSign(
        (arkadas['risingSign'] as String?)?.trim(),
      );
      _formGosteriliyor = false;
      _sonuc = null;
    });
  }

  // ── Yardımcılar ────────────────────────────────────────────────────────

  String _kullaniciIsmiAl(Map<String, dynamic> data) {
    final rawName = (data['name'] as String?)?.trim();
    if (rawName != null && rawName.isNotEmpty) return rawName;
    return FirebaseAuth.instance.currentUser?.displayName?.trim() ?? 'Sen';
  }

  DateTime? _kullaniciTarihiAl(Map<String, dynamic> data) {
    final raw = data['birthDate'];
    if (raw is Timestamp) return raw.toDate();
    return null;
  }

  String? _normalizeSign(String? s) {
    if (s == null || s.isEmpty || s == 'Bilinmiyor' || s == 'Yukleniyor...') {
      return null;
    }
    const harita = <String, String>{
      'Koç': 'Koc',
      'Boğa': 'Boga',
      'İkizler': 'Ikizler',
      'Yengeç': 'Yengec',
      'Başak': 'Basak',
      'Oğlak': 'Oglak',
      'Balık': 'Balik',
    };
    return harita[s] ?? s;
  }

  List<MapEntry<String, Map<String, dynamic>>> _arkadaslariAl(dynamic raw) {
    final result = <MapEntry<String, Map<String, dynamic>>>[];
    if (raw is Map<String, dynamic>) {
      for (final e in raw.entries) {
        if (e.value is Map<String, dynamic>) {
          result.add(MapEntry(e.key, e.value as Map<String, dynamic>));
        }
      }
    }
    return result;
  }

  // ── Tarih Seçici ───────────────────────────────────────────────────────

  Future<void> _tariSec() async {
    DateTime temp = _yeniTarih ?? DateTime(DateTime.now().year - 25, 6, 15);
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 280,
        color: const Color(0xFF1B1F3B),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: const Text(
                    'Tamam',
                    style: TextStyle(color: Color(0xFFF2C98A)),
                  ),
                  onPressed: () {
                    setState(() => _yeniTarih = temp);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: temp,
                minimumDate: DateTime(1900),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (v) => temp = v,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final stream = uid == null
        ? null
        : FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

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
                    Color(0xCC1B1F3B),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: stream,
              builder: (context, snap) {
                final kullanici = snap.data?.data() ?? <String, dynamic>{};
                final arkadaslar = _arkadaslariAl(
                  kullanici['compatibilityFriends'],
                );
                return Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: _sonuc != null
                          ? _buildSonuc(kullanici)
                          : SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildKullaniciBilgisi(kullanici),
                                  const SizedBox(height: 20),
                                  _buildKisiSecimi(
                                    context,
                                    kullanici,
                                    arkadaslar,
                                  ),
                                  if (_formGosteriliyor) ...[
                                    const SizedBox(height: 16),
                                    _buildYeniKisiFormu(context),
                                  ],
                                  if (_secilenIsim != null &&
                                      _secilenTarih != null) ...[
                                    const SizedBox(height: 24),
                                    _buildAnalizButonu(kullanici),
                                  ],
                                ],
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              '🔮 Ruhsal Bağ Analizi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFF2D293),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Kullanıcı bilgi kartı ───────────────────────────────────────────────

  Widget _buildKullaniciBilgisi(Map<String, dynamic> data) {
    final isim = _kullaniciIsmiAl(data);
    final tarih = _kullaniciTarihiAl(data);
    final burc =
        (data['zodiacSign'] as String?)?.trim() ??
        (tarih != null ? calculateZodiac(tarih) : '—');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.07),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          _BurcAvatar(burcAdi: burc, boyut: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isim,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (tarih != null)
                  Text(
                    '${tarih.day}.${tarih.month}.${tarih.year}  •  $burc',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white60),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4A2880).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Sen',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFFF2D293),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Kişi seçim bölümü ──────────────────────────────────────────────────

  Widget _buildKisiSecimi(
    BuildContext context,
    Map<String, dynamic> kullanici,
    List<MapEntry<String, Map<String, dynamic>>> arkadaslar,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analiz edilecek kişiyi seç',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFFF2D293),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),

        // Mevcut uyum arkadaşları
        if (arkadaslar.isNotEmpty) ...[
          Text(
            'Uyum listenden seç',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white54),
          ),
          const SizedBox(height: 8),
          ...arkadaslar.map((e) => _buildArkadasKarti(e.value)),
          const SizedBox(height: 12),
        ],

        // Yeni kişi ekle
        GestureDetector(
          onTap: () {
            setState(() {
              _formGosteriliyor = !_formGosteriliyor;
              if (_formGosteriliyor) {
                // Önceki arkadaş seçimini temizle
                _secilenIsim = null;
                _secilenTarih = null;
                _secilenGunes = null;
                _secilenAy = null;
                _secilenVenus = null;
                _secilenYukselen = null;
                _sonuc = null;
              }
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _formGosteriliyor
                    ? const Color(0xFFF2D293)
                    : Colors.white30,
                width: _formGosteriliyor ? 1.5 : 1,
              ),
              color: _formGosteriliyor
                  ? const Color(0xFF4A2880).withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.05),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_add_alt_1_rounded,
                  color: _formGosteriliyor
                      ? const Color(0xFFF2D293)
                      : Colors.white60,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  'Yeni kişi ekle',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _formGosteriliyor
                        ? const Color(0xFFF2D293)
                        : Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArkadasKarti(Map<String, dynamic> arkadas) {
    final isim = (arkadas['name'] as String?)?.trim() ?? '?';
    final tarihRaw = arkadas['birthDate'];
    final tarih = tarihRaw is Timestamp ? tarihRaw.toDate() : null;
    final iliski = (arkadas['relationship'] as String?)?.trim();
    final burc =
        (arkadas['zodiacSign'] as String?)?.trim() ??
        (tarih != null ? calculateZodiac(tarih) : '');

    final secili = _secilenIsim == isim && !_formGosteriliyor;

    return GestureDetector(
      onTap: () => _arkadasSec(arkadas),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: secili
              ? const Color(0xFF4A2880).withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.06),
          border: Border.all(
            color: secili ? const Color(0xFFF2D293) : Colors.white24,
            width: secili ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            _BurcAvatar(burcAdi: burc, boyut: 32),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isim,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      if (burc.isNotEmpty)
                        Text(
                          burc,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white54),
                        ),
                      if (iliski != null && iliski.isNotEmpty) ...[
                        Text(
                          '  •  ',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white30),
                        ),
                        Text(
                          iliski,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white54),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (secili)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFFF2D293),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  // ── Yeni kişi formu ────────────────────────────────────────────────────

  Widget _buildYeniKisiFormu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kişi bilgileri',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // İsim
          TextField(
            controller: _isimCtrl,
            style: const TextStyle(color: Colors.white),
            textCapitalization: TextCapitalization.words,
            decoration: _inputDeko('İsim (ilk isim yeterli)'),
            onChanged: (_) {
              setState(() {
                _secilenIsim = _isimCtrl.text.trim().isEmpty
                    ? null
                    : _isimCtrl.text.trim();
                _secilenTarih = _yeniTarih;
                _sonuc = null;
              });
            },
          ),
          const SizedBox(height: 12),

          // Doğum tarihi
          GestureDetector(
            onTap: () async {
              await _tariSec();
              setState(() {
                _secilenTarih = _yeniTarih;
                _secilenIsim = _isimCtrl.text.trim().isEmpty
                    ? null
                    : _isimCtrl.text.trim();
                _secilenGunes = null;
                _secilenAy = null;
                _secilenVenus = null;
                _secilenYukselen = null;
                _sonuc = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white30),
                color: Colors.white.withValues(alpha: 0.05),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.cake_rounded,
                    color: Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _yeniTarih != null
                          ? '${_yeniTarih!.day}.${_yeniTarih!.month}.${_yeniTarih!.year}'
                          : 'Doğum tarihi seç',
                      style: TextStyle(
                        color: _yeniTarih != null
                            ? Colors.white
                            : Colors.white54,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white30,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
          Text(
            'Doğum yeri bilgisi olmasa da analiz yapılabilir. Ay, Venüs ve Yükselen burçları uyum sayfasından eklenmiş kişilerde otomatik kullanılır.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white38, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ── Analiz butonu ──────────────────────────────────────────────────────

  Widget _buildAnalizButonu(Map<String, dynamic> kullanici) {
    final hazir =
        !_hesaplaniyor &&
        _secilenIsim != null &&
        _secilenTarih != null &&
        _kullaniciTarihiAl(kullanici) != null;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: hazir ? () => _hesapla(kullanici) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B3EC6),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.white12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
            side: const BorderSide(color: Color(0xFFF2C98A)),
          ),
        ),
        child: _hesaplaniyor
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFF2C98A),
                ),
              )
            : const Text(
                '🔮  Analiz Et',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
      ),
    );
  }

  // ── Sonuç ekranı ───────────────────────────────────────────────────────

  Widget _buildSonuc(Map<String, dynamic> kullanici) {
    final s = _sonuc!;
    final kullaniciIsim = _kullaniciIsmiAl(kullanici);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      child: Column(
        children: [
          // Skor Çemberi
          _SkorCemberi(skor: s.score, emoji: s.categoryEmoji),
          const SizedBox(height: 16),

          // Kategori etiketi
          Text(
            '${s.categoryEmoji}  ${s.categoryLabel}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFFF2D293),
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '$kullaniciIsim  &  ${_secilenIsim ?? '?'}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white54),
          ),

          const SizedBox(height: 20),

          // Açıklama
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xCC3D1E7A), Color(0xB32E1568)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              '"${s.description}"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                height: 1.55,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Güçlü / Zayıf Yönler
          _buildGucluZayif(s),
          const SizedBox(height: 14),

          // Tavsiyeler
          _buildTavsiyeler(s),
          const SizedBox(height: 14),

          // Enerji Barları
          _buildEnerjiBarlar(s),

          const SizedBox(height: 28),

          // Yeniden Analiz Et
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _sonuc = null;
                  _secilenIsim = null;
                  _secilenTarih = null;
                  _secilenGunes = null;
                  _secilenAy = null;
                  _secilenVenus = null;
                  _secilenYukselen = null;
                  _formGosteriliyor = false;
                  _isimCtrl.clear();
                  _yeniTarih = null;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFF2D293),
                side: const BorderSide(color: Color(0xFFF2D293)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Yeniden Analiz Et',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGucluZayif(RuhsalBagResult s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚖️  Güçlü & Zayıf Yönler',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFF2D293),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.add_circle_outline_rounded,
                          color: Color(0xFF6EE7B7),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Artılar',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFF6EE7B7),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ...s.gucluYonler.map(
                      (y) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• $y',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70, height: 1.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.remove_circle_outline_rounded,
                          color: Color(0xFFFCA5A5),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Eksiler',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFFFCA5A5),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ...s.zayifYonler.map(
                      (y) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• $y',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70, height: 1.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTavsiyeler(RuhsalBagResult s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨  Tavsiyeler',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFF2D293),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...s.tavsiyeler.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF6B3EC6).withValues(alpha: 0.6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${e.key + 1}',
                      style: const TextStyle(
                        color: Color(0xFFF2D293),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e.value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.80),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnerjiBarlar(RuhsalBagResult s) {
    const renkler = <String, Color>{
      'Duygusal': Color(0xFFFF8FAB),
      'Zihinsel': Color(0xFF93C5FD),
      'Karmik': Color(0xFFC4B5FD),
      'Ruhsal': Color(0xFF6EE7B7),
      'Fiziksel': Color(0xFFFCD34D),
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🌀  Ruhsal Enerji Boyutları',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFF2D293),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ...s.enerjiBarlari.entries.map((e) {
            final renk = renkler[e.key] ?? const Color(0xFFF2D293);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.key,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                      Text(
                        '%${e.value}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: renk,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: e.value / 100,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(renk),
                      minHeight: 7,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Yardımcı ─────────────────────────────────────────────────────────

  InputDecoration _inputDeko(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFF2C98A)),
      ),
    );
  }
}

// ─── Skor Çemberi ─────────────────────────────────────────────────────────────

class _SkorCemberi extends StatefulWidget {
  const _SkorCemberi({required this.skor, required this.emoji});

  final int skor;
  final String emoji;

  @override
  State<_SkorCemberi> createState() => _SkorCemberiState();
}

class _SkorCemberiState extends State<_SkorCemberi>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final display = (widget.skor * _anim.value).round();
        return SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: display / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _skorRengi(widget.skor),
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.emoji, style: const TextStyle(fontSize: 32)),
                  Text(
                    '%$display',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _skorRengi(int skor) {
    if (skor >= 90) return const Color(0xFFFF6B35);
    if (skor >= 80) return const Color(0xFFFFD700);
    if (skor >= 70) return const Color(0xFFFF69B4);
    if (skor >= 60) return const Color(0xFFB08AFF);
    if (skor >= 50) return const Color(0xFF5CE0D8);
    if (skor >= 40) return const Color(0xFF4FC3F7);
    if (skor >= 30) return const Color(0xFFA78BF7);
    if (skor >= 20) return const Color(0xFF9E9E9E);
    return const Color(0xFF607D8B);
  }
}

// ─── Burç Avatar ──────────────────────────────────────────────────────────────

class _BurcAvatar extends StatelessWidget {
  const _BurcAvatar({required this.burcAdi, this.boyut = 42});

  final String burcAdi;
  final double boyut;

  static const _resimler = <String, String>{
    'koc': 'assets/burclar/koc.png',
    'koç': 'assets/burclar/koc.png',
    'boga': 'assets/burclar/boga.png',
    'boğa': 'assets/burclar/boga.png',
    'ikizler': 'assets/burclar/ikizler.png',
    'yengec': 'assets/burclar/yengec.png',
    'yengeç': 'assets/burclar/yengec.png',
    'aslan': 'assets/burclar/aslan.png',
    'basak': 'assets/burclar/basak.png',
    'başak': 'assets/burclar/basak.png',
    'terazi': 'assets/burclar/terazi.png',
    'akrep': 'assets/burclar/akrep.png',
    'yay': 'assets/burclar/yay.png',
    'oglak': 'assets/burclar/oglak.png',
    'oğlak': 'assets/burclar/oglak.png',
    'kova': 'assets/burclar/kova.png',
    'balik': 'assets/burclar/balık.png',
    'balık': 'assets/burclar/balık.png',
  };

  @override
  Widget build(BuildContext context) {
    final key = burcAdi.trim().toLowerCase();
    final resim = _resimler[key];

    return Container(
      width: boyut,
      height: boyut,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF3D1E7A).withValues(alpha: 0.7),
      ),
      clipBehavior: Clip.antiAlias,
      child: resim != null
          ? Image.asset(resim, fit: BoxFit.cover)
          : Center(
              child: Text(
                burcAdi.isNotEmpty ? burcAdi[0].toUpperCase() : '?',
                style: TextStyle(
                  color: const Color(0xFFF2D293),
                  fontWeight: FontWeight.w700,
                  fontSize: boyut * 0.42,
                ),
              ),
            ),
    );
  }
}
