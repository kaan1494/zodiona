import 'dart:math' as math;

import 'package:flutter/material.dart';

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

const _kBackAsset = 'assets/tarot/tarotarka.png';

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

class TarotCardPage extends StatefulWidget {
  const TarotCardPage({super.key});

  @override
  State<TarotCardPage> createState() => _TarotCardPageState();
}

class _TarotCardPageState extends State<TarotCardPage> {
  late final List<_TarotCardData> _shuffledCards;

  @override
  void initState() {
    super.initState();
    _shuffledCards = List<_TarotCardData>.from(_cards)..shuffle(math.Random());
  }

  @override
  Widget build(BuildContext context) {
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
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xBB04184A), Color(0xDD04133C)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
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
                          'Gökyüzünün Fısıltısı',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFF2D9A6),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Bir karta tıkla ve yıldızlardan mesajını al',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: _shuffledCards.length,
                    itemBuilder: (context, index) {
                      return _TarotFlipCard(
                        cardData: _shuffledCards[index],
                        cardNumber: index + 1,
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
}

class _TarotFlipCard extends StatefulWidget {
  const _TarotFlipCard({required this.cardData, required this.cardNumber});

  final _TarotCardData cardData;
  final int cardNumber;

  @override
  State<_TarotFlipCard> createState() => _TarotFlipCardState();
}

class _TarotFlipCardState extends State<_TarotFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 650),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_isFlipped) return;
    setState(() => _isFlipped = true);
    _controller.forward();
  }

  void _showCardDetail(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (ctx, _, _) => _CardDetailDialog(cardData: widget.cardData),
      transitionBuilder: (ctx, anim, _, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isFlipped) {
          _onTap();
        } else {
          _showCardDetail(context);
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
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
                      isFront: true,
                    ),
                  )
                : _CardFace(asset: _kBackAsset, name: '', isFront: false),
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
    required this.isFront,
  });

  final String asset;
  final String name;
  final bool isFront;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(asset, fit: BoxFit.cover)),
            if (isFront && name.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
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
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (isFront)
              Positioned(
                bottom: 4,
                right: 6,
                child: Icon(
                  Icons.info_outline,
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

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
