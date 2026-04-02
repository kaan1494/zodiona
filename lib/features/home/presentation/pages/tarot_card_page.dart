import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../services/tarot_selection_service.dart';
import 'previous_insights_page.dart';

class _TarotCardData {
  const _TarotCardData({
    required this.asset,
    required this.name,
    required this.description,
  });

  final String asset;
  final String name;
  final String description;
}

const _cards = <_TarotCardData>[
  _TarotCardData(
    asset: 'assets/tarot/1-yenibaşlangıç.png',
    name: 'Yeni Başlangıç',
    description:
        'Kapılar açılıyor, yeni bir sayfa dönüyor. Bu kart, cesurca atılacak ilk adımın işaretidir. Geçmişi geride bırak ve geleceğe umutla yönel.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/2-değişim_degişecek.png',
    name: 'Değişim',
    description:
        'Durağanlık bozuluyor, dönüşüm kapıda. Değişime direnme; o seni daha güçlü bir yere taşıyor. Akışa bırak kendini.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/3-sabır.png',
    name: 'Sabır',
    description:
        'Her şeyin bir zamanı var. Aceleden değil, doğru andan doğan kararlar kalıcı olur. Beklemek zayıflık değil, bilgeliktir.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/4-güç_değişecek.png',
    name: 'Güç',
    description:
        'Seni zorlayan her şey aslında içindeki gücü ortaya çıkarıyor. Bu kart, senin sandığından çok daha dayanıklı olduğunu söylüyor. Devam et.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/5-şans.png',
    name: 'Şans',
    description:
        'Evren bugün sana gülümsüyor. Fırsatlar beklenmedik yerlerden gelecek; uyanık ol. Şans hazırlıklı olanın yanında durur.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/6-aşk.png',
    name: 'Aşk',
    description:
        'Kalbin bir şeyi ya da birini özlüyor. Bu kart, bağlantı ve sevginin enerjisini taşıyor. Duygularına alan aç.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/7-fırsat.png',
    name: 'Fırsat',
    description:
        'Önüne bir kapı açılıyor; geçip geçmeyeceğine sen karar vereceksin. Şüphe değil, sezgi rehberin olsun. Zamanı iyi değerlendir.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/8-yolculuk.png',
    name: 'Yolculuk',
    description:
        'Bir yolculuk başlıyor; bu ister fiziksel ister ruhsal olsun. Yol, seni hedeften çok dönüştürecek. Yaşanan her anı hazine say.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/9-karar.png',
    name: 'Karar',
    description:
        'Bir kavşaktasın ve seçim yapmak zorundasın. İçindeki ses zaten cevabı biliyor. Korkudan değil, kalpten karar ver.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/10-dönüşüm.png',
    name: 'Dönüşüm',
    description:
        'Eski bir dönem kapanıyor ve sen farklı biri olarak uyanıyorsun. Bu dönüşüme direnmek anlamsız; kabul et ve büyü.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/11-umut.png',
    name: 'Umut',
    description:
        'Karanlık ne kadar yoğun olursa olsun, bir ışık her zaman var. Bu kart, umudu kaybetmemeni hatırlatıyor. Sabah her zaman gelir.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/12-risk.png',
    name: 'Risk',
    description:
        'Güvende kalmak seni büyütmez. Bu kart, büyük kazanımların cesur adımların ardından geldiğini söylüyor. Kontrollü bir risk al.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/13-başarı.png',
    name: 'Başarı',
    description:
        'Emeklerin boşa gitmedi; artık meyve verme zamanı. Başarı kapıda, sadece son adımı atmak kalıyor. Kendine güvenmeye devam et.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/14-denge.png',
    name: 'Denge',
    description:
        'Hayatının bir alanı ihmal ediliyor olabilir. Bu kart, iç ve dış dünyanda dengeyi yeniden kurmanı öneriyor. Hepsine eşit alan aç.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/15-içses.png',
    name: 'İç Ses',
    description:
        'Dışarıdaki gürültüyü kapat ve içine kulak ver. Sezgin bu aralar çok güçlü; yalnızca mantığa değil kalbe de danış. Cevap zaten içinde.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/16-koruma.png',
    name: 'Koruma',
    description:
        'Evrenin koruyucu enerjisi etrafında. Yalnız hissetsen de, görünmez bir güç seni destekliyor. Güvende olduğuna inan.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/17-yenilenme.png',
    name: 'Yenilenme',
    description:
        'Ruhu ve bedeni dinlenme zamanı. Bu kart, yeniden şarj olmanı ve tazelenmen gerektiğini söylüyor. Kendine iyi bak.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/18-bolluk.png',
    name: 'Bolluk',
    description:
        'Bereket ve refah sana doğru akıyor. Bu kart, nimetlere açık kalmayı ve minnetle karşılamayı temsil ediyor. Bol bol şükret.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/19-uyanış.png',
    name: 'Uyanış',
    description:
        'Bir gerçek sana görünür oluyor; uzun süre gizli kalan bir şey aydınlanıyor. Bu uyanışa direnmeden bak. Netlik yaklaşıyor.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/20-gizem.png',
    name: 'Gizem',
    description:
        'Her şey göründüğü gibi değil; yüzeyin altında daha derin bir anlam var. Sabırla bekle, sır zamanı gelince kendini açacak.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/21-sezgi.png',
    name: 'Sezgi',
    description:
        'Mantığın sınırlarına ulaşmışsın; artık sezgine güvenme zamanı. İçinden gelen ilk his genellikle doğrudur. Onu dinle.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/22-barış.png',
    name: 'Barış',
    description:
        'İçinde süren çatışma son buluyor. Hem kendinle hem de çevrenle barışma zamanı geldi. Huzur bir tercih.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/23-cesaret.png',
    name: 'Cesaret',
    description:
        'Korku seni durduruyor olabilir ama bu kart harekete geçme zamanı olduğunu söylüyor. Cesaret korku yokken değil, korkmana rağmen ilerlemektir.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/24-gerçek.png',
    name: 'Gerçek',
    description:
        'Görmek istemediğin bir gerçek artık görmezden gelinemez. Bu kart, hakikati kucaklamanın özgürleştirici gücünü taşıyor. Kendine dürüst ol.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/25-bağlantı.png',
    name: 'Bağlantı',
    description:
        'Anlamlı bir bağ kurma ya da mevcut bağları derinleştirme zamanı. Bu kart, ilişkilerde köprü inşa etmeyi simgeliyor. Ulaş ve bağlan.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/26-bekleyiş.png',
    name: 'Bekleyiş',
    description:
        'Aceleci adımlar bu dönemde sonuç vermez. Bu kart, doğru zamanı kollamanın ve sabırla beklemenin gücünü anlatıyor. Zamana güven.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/27-keşif.png',
    name: 'Keşif',
    description:
        'Bilinmeyene adım atma vakti geldi. Bu kart, merak ve macera enerjisiyle yüklü; yeni ufuklar seni bekliyor. Keşfetmekten çekinme.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/28-ilham.png',
    name: 'İlham',
    description:
        'Yaratıcı bir kıvılcım içinde parlıyor. Bu kart, seni eyleme geçirecek ilhamın tam da şu an geldiğini müjdeliyor. Hissi yakalamayı kaçırma.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/29-hedef.png',
    name: 'Hedef',
    description:
        'Gözünü diktiğin hedefe odaklan ve dağılma. Bu kart, neyin peşinde olduğunu netleştirme ve ona doğru kararlıca yürüme zamanıdır.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/30-şifa.png',
    name: 'Şifa',
    description:
        'Geçmişin yaraları iyileşiyor. Bu kart, hem bedensel hem de duygusal iyileşme enerjisi taşıyor. Kendine şefkat ve zaman ver.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/31-değer.png',
    name: 'Değer',
    description:
        'Kendi değerini başkalarının onayına bırakma. Bu kart, içindeki özü fark etmeni ve ona sahip çıkmanı söylüyor. Sen yeterlisin.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/32-kader.png',
    name: 'Kader',
    description:
        'Bazı şeyler tam da olması gerektiği gibi gelişiyor. Bu kart, evrene teslim olmanın ve akışa katılmanın zamanı olduğunu söylüyor.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/33-duygular.png',
    name: 'Duygular',
    description:
        'Bastırılan duygular artık yüzeye çıkmak istiyor. Bu kart, hissettiklerini tanımanı ve onlara alan açmanı öneriyor. Duymak iyileştirir.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/34-güven.png',
    name: 'Güven',
    description:
        'Kendine duyduğun güven sarsılmış olabilir ama bu kart, içindeki sağlam zemini hatırlatıyor. Bırak şüpheler geçsin; sen biliyorsun.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/35-açılım.png',
    name: 'Açılım',
    description:
        'Uzun süredir kapalı tutulan bir kapı aralanıyor. Bu kart, yeni bakış açılarına ve olasılıklara hazır olmanı söylüyor. Açık kal.',
  ),
  _TarotCardData(
    asset: 'assets/tarot/36-kozmikmesaj.png',
    name: 'Kozmik Mesaj',
    description:
        'Evren sana özel bir mesaj gönderiyor; yeterince sessiz olursan duyabilirsin. Bu kart, büyük resmi görme ve kozmik akışa katılma zamanıdır.',
  ),
];

const _kMaxSelection = 5;
const _kBackAsset = 'assets/tarot/tarotarka.png';
const _kCardsPerPage = 8;

class TarotCardPage extends StatefulWidget {
  const TarotCardPage({super.key});

  @override
  State<TarotCardPage> createState() => _TarotCardPageState();
}

class _TarotCardPageState extends State<TarotCardPage> {
  late final List<_TarotCardData> _shuffledCards;
  final List<int> _selectedIndices = [];
  bool _onCooldown = false;
  bool _hasPrevious = false;
  bool _loaded = false;
  // Continuous offset: 0.0 → (totalCards - cardsPerView), sürükleyince güncellenir
  double _fanOffset = 0.0;
  bool _isDragging = false;
  Timer? _countdownTimer;
  Duration _cooldownRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _shuffledCards = List<_TarotCardData>.from(_cards)..shuffle(math.Random());
    _init();
  }

  Future<void> _init() async {
    final cooldown = await TarotSelectionService.isOnCooldown();
    final prev = await TarotSelectionService.getPreviousSelection();
    Duration remaining = Duration.zero;
    if (cooldown) {
      remaining = await TarotSelectionService.cooldownRemaining();
    }
    if (mounted) {
      setState(() {
        _onCooldown = cooldown;
        _hasPrevious = prev.isNotEmpty;
        _cooldownRemaining = remaining;
        _loaded = true;
      });
      if (cooldown) _startCountdown();
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_cooldownRemaining.inSeconds <= 1) {
        _countdownTimer?.cancel();
        setState(() {
          _cooldownRemaining = Duration.zero;
          _onCooldown = false;
        });
      } else {
        setState(() {
          _cooldownRemaining -= const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _onCardTapped(int index) async {
    if (_onCooldown) {
      _showCooldownSnack();
      return;
    }
    if (_selectedIndices.contains(index)) return;
    if (_selectedIndices.length >= _kMaxSelection) return;

    setState(() => _selectedIndices.add(index));
    await _showCardDetail(_shuffledCards[index]);

    if (_selectedIndices.length == _kMaxSelection) {
      await _finalizeSelection();
    }
  }

  Future<void> _finalizeSelection() async {
    final selected = _selectedIndices
        .map(
          (i) => TarotSelectedCard(
            asset: _shuffledCards[i].asset,
            name: _shuffledCards[i].name,
            description: _shuffledCards[i].description,
          ),
        )
        .toList();
    await TarotSelectionService.saveSelection(selected);
    if (mounted) {
      final remaining = await TarotSelectionService.cooldownRemaining();
      setState(() {
        _onCooldown = true;
        _hasPrevious = true;
        _cooldownRemaining = remaining;
      });
      _startCountdown();
    }
  }

  void _showCooldownSnack() async {
    final remaining = await TarotSelectionService.cooldownRemaining();
    if (!mounted) return;
    final h = remaining.inHours;
    final m = remaining.inMinutes % 60;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1050),
        content: Text(
          '$h saat $m dakika sonra yeni yıldızlar seçebilirsin.',
          style: const TextStyle(color: Color(0xFFF2D9A6)),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showCardDetail(_TarotCardData cardData) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (ctx, _, _) => _CardDetailDialog(cardData: cardData),
      transitionBuilder: (ctx, anim, _, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }

  void _openPreviousInsights() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PreviousInsightsPage()));
  }

  void _onFanDragStart(DragStartDetails _) {
    setState(() => _isDragging = true);
  }

  void _onFanDrag(DragUpdateDetails d) {
    final maxOff = (_shuffledCards.length - _kCardsPerPage).toDouble();
    setState(() {
      _isDragging = true;
      _fanOffset = (_fanOffset - d.delta.dx / 28.0).clamp(0.0, maxOff);
    });
  }

  void _onFanDragEnd(DragEndDetails _) {
    setState(() => _isDragging = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0520),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xBB1A0848), Color(0xDD130535)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Yıldız Seç',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFF2D9A6),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (_onCooldown)
                  _CooldownBanner(remaining: _cooldownRemaining)
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Gözlerini kapat ve kalbindeki cevapsız soruyu ve niyetini düşün, sana en yakın gelen yıldızı seç.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.70),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // Counter
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFFF2D9A6).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    '${_selectedIndices.length} / $_kMaxSelection',
                    style: const TextStyle(
                      color: Color(0xFFF2D9A6),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Geçmiş butonu
                if (_hasPrevious)
                  GestureDetector(
                    onTap: _openPreviousInsights,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2D9A6).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(
                            0xFFF2D9A6,
                          ).withValues(alpha: 0.30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: const Color(
                              0xFFF2D9A6,
                            ).withValues(alpha: 0.80),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Yıldızların önceki mesajını oku',
                            style: TextStyle(
                              color: const Color(
                                0xFFF2D9A6,
                              ).withValues(alpha: 0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_hasPrevious) const SizedBox(height: 8),
                // Seçilen kartlar rafı
                if (_selectedIndices.isNotEmpty && !_onCooldown)
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _selectedIndices.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (_, idx) {
                        final card = _shuffledCards[_selectedIndices[idx]];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFF2D9A6,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(card.asset, fit: BoxFit.cover),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.85),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      card.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFFF2D9A6),
                                        fontSize: 6,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (_selectedIndices.isNotEmpty && !_onCooldown)
                  const SizedBox(height: 8),
                // Sürekli kaydırmalı fan – sürükleyince kartlar gerçek zamanlı kayar
                Expanded(
                  child: _loaded
                      ? GestureDetector(
                          onHorizontalDragStart: _onFanDragStart,
                          onHorizontalDragUpdate: _onFanDrag,
                          onHorizontalDragEnd: _onFanDragEnd,
                          onHorizontalDragCancel: () =>
                              setState(() => _isDragging = false),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Kart boyutu: ekran genişliğine göre hesapla
                              final cardW =
                                  constraints.maxWidth / _kCardsPerPage * 2.2;
                              final cardH = cardW / 0.62;
                              const totalDeg = 70.0;
                              final firstI = _fanOffset.floor();
                              final lastI = math.min(
                                firstI + _kCardsPerPage + 1,
                                _shuffledCards.length,
                              );
                              // Pivot noktası: kartların aşağı-merkezi, fan yayını oluşturur
                              final pivotY =
                                  constraints.maxHeight + cardH * 0.28;
                              // Kartları ortaya taşı (ekranın %50 üstünden)
                              final cardBottomOffset =
                                  constraints.maxHeight * 0.50 - cardH * 0.28;
                              return ClipRect(
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      for (int i = firstI; i < lastI; i++)
                                        () {
                                          final relPos =
                                              i.toDouble() - _fanOffset;
                                          final angleDeg =
                                              (relPos / (_kCardsPerPage - 1)) *
                                                  totalDeg -
                                              totalDeg / 2;
                                          final angleRad =
                                              angleDeg * math.pi / 180.0;
                                          final selected = _selectedIndices
                                              .contains(i);
                                          final blocked =
                                              _isDragging ||
                                              _onCooldown ||
                                              (_selectedIndices.length >=
                                                      _kMaxSelection &&
                                                  !selected);
                                          return Positioned(
                                            bottom: cardBottomOffset,
                                            left:
                                                (constraints.maxWidth - cardW) /
                                                2,
                                            child: Transform(
                                              alignment: FractionalOffset(
                                                0.5,
                                                pivotY / cardH,
                                              ),
                                              transform: Matrix4.rotationZ(
                                                angleRad,
                                              ),
                                              child: SizedBox(
                                                width: cardW,
                                                height: cardH,
                                                child: _TarotFlipCard(
                                                  key: ValueKey(i),
                                                  cardData: _shuffledCards[i],
                                                  selected: selected,
                                                  blocked: blocked,
                                                  onTap: () => _onCardTapped(i),
                                                ),
                                              ),
                                            ),
                                          );
                                        }(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF2D9A6),
                          ),
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TarotFlipCard extends StatefulWidget {
  const _TarotFlipCard({
    super.key,
    required this.cardData,
    required this.selected,
    required this.blocked,
    required this.onTap,
  });

  final _TarotCardData cardData;
  final bool selected;
  final bool blocked;
  final VoidCallback onTap;

  @override
  State<_TarotFlipCard> createState() => _TarotFlipCardState();
}

class _TarotFlipCardState extends State<_TarotFlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
    // Kart zaten seçiliyse (fan kaymasından sonra yeniden oluşturuldu) anında açık göster
    if (widget.selected) {
      _ctrl.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_TarotFlipCard old) {
    super.didUpdateWidget(old);
    if (widget.selected && !old.selected) {
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.blocked ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, _) {
          final angle = _anim.value * math.pi;
          final showFront = angle > math.pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _CardFace(
                      asset: widget.cardData.asset,
                      name: widget.cardData.name,
                      selected: true,
                    ),
                  )
                : _CardFace(asset: _kBackAsset, name: '', selected: false),
          );
        },
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    required this.asset,
    required this.name,
    required this.selected,
  });

  final String asset;
  final String name;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: selected
                ? const Color(0xFFF2D9A6).withValues(alpha: 0.45)
                : Colors.black.withValues(alpha: 0.45),
            blurRadius: selected ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(asset, fit: BoxFit.cover),
            if (selected && name.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFF2D9A6),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Cooldown banner
// ──────────────────────────────────────────────────────────────

class _CooldownBanner extends StatelessWidget {
  const _CooldownBanner({required this.remaining});

  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    final h = remaining.inHours.toString().padLeft(2, '0');
    final m = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return Column(
      children: [
        Text(
          '8 saat dolmadan yeni 5 kart seçemezsin.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.70),
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _HourglassWidget(),
            const SizedBox(width: 10),
            Text(
              '$h:$m:$s',
              style: const TextStyle(
                color: Color(0xFFF2D9A6),
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HourglassWidget extends StatefulWidget {
  const _HourglassWidget();

  @override
  State<_HourglassWidget> createState() => _HourglassWidgetState();
}

class _HourglassWidgetState extends State<_HourglassWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        final icon = _ctrl.value < 0.5
            ? Icons.hourglass_top
            : Icons.hourglass_bottom;
        return Icon(icon, color: const Color(0xFFF2D9A6), size: 30);
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Card detail dialog
// ──────────────────────────────────────────────────────────────

class _CardDetailDialog extends StatefulWidget {
  const _CardDetailDialog({required this.cardData});

  final _TarotCardData cardData;

  @override
  State<_CardDetailDialog> createState() => _CardDetailDialogState();
}

class _CardDetailDialogState extends State<_CardDetailDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A1050).withValues(alpha: 0.93),
                      const Color(0xFF0D0830).withValues(alpha: 0.93),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFF2D9A6).withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _glowAnim,
                      builder: (_, _) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFF2D9A6,
                                ).withValues(alpha: _glowAnim.value * 0.55),
                                blurRadius: 32,
                                spreadRadius: 4,
                              ),
                              BoxShadow(
                                color: const Color(
                                  0xFF9B59F5,
                                ).withValues(alpha: _glowAnim.value * 0.35),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              widget.cardData.asset,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      widget.cardData.name,
                      style: const TextStyle(
                        color: Color(0xFFF2D9A6),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.cardData.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
