class ZodionaDailyComment {
  const ZodionaDailyComment({
    required this.title,
    required this.body,
    required this.focusTypeLabel,
    required this.focusSign,
  });

  final String title;
  final String body;
  final String focusTypeLabel;
  final String focusSign;
}

class ZodionaDailyCommentGenerator {
  const ZodionaDailyCommentGenerator._();

  static int get estimatedVariantsPerSign =>
      _mentionModeWeights.length *
      _dailyRhythmFrames.length *
      _defaultSignSignatureLines.length *
      (_openersWithSign.length + _openersPlain.length) *
      _intentFrames.length *
      _actionFrames.length *
      _balanceFrames.length *
      (_closersWithSign.length + _closersPlain.length);

  static ZodionaDailyComment generate({
    required String userName,
    required String sunSign,
    required String moonSign,
    required String risingSign,
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    final daySerial = _daySerial(date);

    final normalizedName = _normalizeName(userName);
    final sun = _normalizeSign(sunSign);
    final moon = _normalizeSign(moonSign);
    final rising = _normalizeSign(risingSign);

    final seed = _seedFrom('$normalizedName|$sun|$moon|$rising');
    final mentionMode = _pickMentionMode(
      daySerial: daySerial,
      seed: seed,
      moon: moon,
      rising: rising,
    );
    final focus = _pickFocusSign(
      daySerial: daySerial,
      seed: seed,
      mentionMode: mentionMode,
      sun: sun,
      moon: moon,
      rising: rising,
    );

    final lexicon = _lexiconBySign[focus.sign] ?? _defaultLexicon;
    final signSignaturePool =
        _signSignatureLines[focus.sign] ?? _defaultSignSignatureLines;

    final title = _pickByDay(
      _titleFrames,
      daySerial: daySerial,
      seed: seed,
      salt: 11,
    ).replaceAll('{name}', normalizedName);

    final lead = _buildSignLead(
      mentionMode: mentionMode,
      daySerial: daySerial,
      seed: seed,
      sun: sun,
      moon: moon,
      rising: rising,
      focus: focus,
    );

    final dailyRhythm = _pickByDay(
      _dailyRhythmFrames,
      daySerial: daySerial,
      seed: seed,
      salt: 29,
    );

    final signSignature = _pickByDay(
      signSignaturePool,
      daySerial: daySerial,
      seed: seed,
      salt: 37,
    ).replaceAll('{focusSign}', focus.sign);

    final openerPool = mentionMode == _MentionMode.none
        ? _openersPlain
        : _openersWithSign;
    final opener =
        _pickByDay(openerPool, daySerial: daySerial, seed: seed, salt: 41)
            .replaceAll('{focusType}', focus.type)
            .replaceAll('{focusSign}', focus.sign)
            .replaceAll(
              '{signImage}',
              _pickByDay(
                lexicon.imagery,
                daySerial: daySerial,
                seed: seed,
                salt: 43,
              ),
            );

    final intent =
        _pickByDay(_intentFrames, daySerial: daySerial, seed: seed, salt: 47)
            .replaceAll(
              '{quality}',
              _pickByDay(
                lexicon.qualities,
                daySerial: daySerial,
                seed: seed,
                salt: 53,
              ),
            )
            .replaceAll(
              '{gift}',
              _pickByDay(
                lexicon.gifts,
                daySerial: daySerial,
                seed: seed,
                salt: 59,
              ),
            );

    final action =
        _pickByDay(_actionFrames, daySerial: daySerial, seed: seed, salt: 61)
            .replaceAll(
              '{action}',
              _pickByDay(
                lexicon.actions,
                daySerial: daySerial,
                seed: seed,
                salt: 67,
              ),
            )
            .replaceAll(
              '{area}',
              _pickByDay(_areas, daySerial: daySerial, seed: seed, salt: 71),
            );

    final balance =
        _pickByDay(
          _balanceFrames,
          daySerial: daySerial,
          seed: seed,
          salt: 73,
        ).replaceAll(
          '{balance}',
          _pickByDay(
            lexicon.balanceTips,
            daySerial: daySerial,
            seed: seed,
            salt: 79,
          ),
        );

    final closerPool = mentionMode == _MentionMode.none
        ? _closersPlain
        : _closersWithSign;
    final closer =
        _pickByDay(closerPool, daySerial: daySerial, seed: seed, salt: 83)
            .replaceAll('{name}', normalizedName)
            .replaceAll('{focusSign}', focus.sign);

    final segments = [
      if (lead.isNotEmpty) lead,
      dailyRhythm,
      signSignature,
      opener,
      intent,
      action,
      balance,
      closer,
    ];

    final body = segments.join(' ');

    return ZodionaDailyComment(
      title: title,
      body: body,
      focusTypeLabel: focus.type,
      focusSign: focus.sign,
    );
  }

  static String _normalizeName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Sen';
    }
    final first = trimmed.split(RegExp(r'\s+')).first;
    if (first.isEmpty) {
      return 'Sen';
    }
    return first[0].toUpperCase() + first.substring(1);
  }

  static String _normalizeSign(String value) {
    final raw = value.trim();
    if (raw.isEmpty) {
      return 'Bilinmiyor';
    }
    return _signAliases[raw] ?? raw;
  }

  static int _seedFrom(String input) {
    var hash = 2166136261;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 16777619) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }

  static int _daySerial(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  }

  static T _pickByDay<T>(
    List<T> list, {
    required int daySerial,
    required int seed,
    required int salt,
  }) {
    if (list.isEmpty) {
      throw StateError('Secim yapilacak liste bos olamaz.');
    }
    if (list.length == 1) {
      return list.first;
    }

    final localSeed = (seed + (salt * 9973)) & 0x7fffffff;
    final offset = localSeed % list.length;
    final step = _coprimeStep(list.length, localSeed);
    final index = (offset + (daySerial * step)) % list.length;
    return list[index];
  }

  static int _coprimeStep(int length, int seed) {
    if (length <= 1) {
      return 1;
    }
    var step = seed % length;
    if (step <= 0) {
      step = 1;
    }
    while (_gcd(step, length) != 1) {
      step++;
      if (step >= length) {
        step = 1;
      }
    }
    return step;
  }

  static int _gcd(int a, int b) {
    var x = a.abs();
    var y = b.abs();
    while (y != 0) {
      final t = x % y;
      x = y;
      y = t;
    }
    return x;
  }

  static _MentionMode _pickMentionMode({
    required int daySerial,
    required int seed,
    required String moon,
    required String rising,
  }) {
    final raw = _pickByDay(
      _mentionModeWeights,
      daySerial: daySerial,
      seed: seed,
      salt: 7,
    );
    if (raw == _MentionMode.moonOnly && moon == 'Bilinmiyor') {
      return _MentionMode.focusOnly;
    }
    if (raw == _MentionMode.risingOnly && rising == 'Bilinmiyor') {
      return _MentionMode.focusOnly;
    }
    return raw;
  }

  static _FocusSign _pickFocusSign({
    required int daySerial,
    required int seed,
    required _MentionMode mentionMode,
    required String sun,
    required String moon,
    required String rising,
  }) {
    final moonKnown = moon != 'Bilinmiyor';
    final risingKnown = rising != 'Bilinmiyor';

    if (mentionMode == _MentionMode.sunOnly) {
      return _FocusSign(type: 'Güneş', sign: sun);
    }
    if (mentionMode == _MentionMode.moonOnly && moonKnown) {
      return _FocusSign(type: 'Ay', sign: moon);
    }
    if (mentionMode == _MentionMode.risingOnly && risingKnown) {
      return _FocusSign(type: 'Yükselen', sign: rising);
    }

    final focusPool = <_FocusSign>[
      _FocusSign(type: 'Güneş', sign: sun),
      if (moonKnown) _FocusSign(type: 'Ay', sign: moon),
      if (risingKnown) _FocusSign(type: 'Yükselen', sign: rising),
    ];

    return _pickByDay(focusPool, daySerial: daySerial, seed: seed, salt: 17);
  }

  static String _buildSignLead({
    required _MentionMode mentionMode,
    required int daySerial,
    required int seed,
    required String sun,
    required String moon,
    required String rising,
    required _FocusSign focus,
  }) {
    switch (mentionMode) {
      case _MentionMode.full:
        return _pickByDay(
              _fullLeadFrames,
              daySerial: daySerial,
              seed: seed,
              salt: 19,
            )
            .replaceAll('{sun}', sun)
            .replaceAll('{moon}', moon)
            .replaceAll('{rising}', rising);
      case _MentionMode.sunOnly:
        return _pickByDay(
          _sunLeadFrames,
          daySerial: daySerial,
          seed: seed,
          salt: 23,
        ).replaceAll('{sun}', sun);
      case _MentionMode.moonOnly:
        return moon == 'Bilinmiyor'
            ? ''
            : _pickByDay(
                _moonLeadFrames,
                daySerial: daySerial,
                seed: seed,
                salt: 31,
              ).replaceAll('{moon}', moon);
      case _MentionMode.risingOnly:
        return rising == 'Bilinmiyor'
            ? ''
            : _pickByDay(
                _risingLeadFrames,
                daySerial: daySerial,
                seed: seed,
                salt: 43,
              ).replaceAll('{rising}', rising);
      case _MentionMode.focusOnly:
        return _pickByDay(
              _focusLeadFrames,
              daySerial: daySerial,
              seed: seed,
              salt: 47,
            )
            .replaceAll('{focusType}', focus.type)
            .replaceAll('{focusSign}', focus.sign);
      case _MentionMode.none:
        return '';
    }
  }
}

class _FocusSign {
  const _FocusSign({required this.type, required this.sign});

  final String type;
  final String sign;
}

enum _MentionMode { full, sunOnly, moonOnly, risingOnly, focusOnly, none }

class _SignLexicon {
  const _SignLexicon({
    required this.imagery,
    required this.qualities,
    required this.gifts,
    required this.actions,
    required this.balanceTips,
  });

  final List<String> imagery;
  final List<String> qualities;
  final List<String> gifts;
  final List<String> actions;
  final List<String> balanceTips;
}

const _titleFrames = [
  '{name} senin için Zodiona önerisi',
  '{name} senin için bugünün Zodiona yorumu',
  '{name} senin için yıldızlardan mesaj',
  '{name} senin için günlük gökyüzü notu',
  '{name} senin için bugün zihin & kalp dengesi',
  '{name} senin için kozmik yönlendirme',
];

const _mentionModeWeights = [
  _MentionMode.full,
  _MentionMode.sunOnly,
  _MentionMode.moonOnly,
  _MentionMode.risingOnly,
  _MentionMode.focusOnly,
  _MentionMode.none,
  _MentionMode.full,
  _MentionMode.focusOnly,
  _MentionMode.none,
  _MentionMode.sunOnly,
  _MentionMode.none,
];

const _dailyRhythmFrames = [
  'Bugünün kozmik ritmi sade ama etkili adımları ödüllendiriyor.',
  'Gökyüzü bugün önce netlik, sonra hız diyor.',
  'Günün enerjisi, doğru anda küçük hamlelerle büyüyor.',
  'Bugün acele yerine bilinçli seçimler kazandırır.',
  'Kozmik akış bugün denge kuranları destekliyor.',
  'Bugün odak daraldıkça sonuçların görünürlüğü artar.',
  'Günün atmosferi, sakin kalıp doğru yere dokunmayı kolaylaştırıyor.',
  'Bugün niyetini sadeleştirmek güçlü bir ivme yaratır.',
  'Bugün iç ses ve gerçek veri birlikte çalıştığında yol açılır.',
  'Gökyüzü bugün yük azaltıp netleşenleri bir adım öne taşıyor.',
  'Bugün ritmini koruyup istikrarlı kalanlar için verimli bir gün.',
];

const _fullLeadFrames = [
  'Güneş burcun {sun}, ay burcun {moon}, yükselenin {rising}; bugün bu üçlü birlikte çalışıyor.',
  'Bugün haritanda {sun} - {moon} - {rising} hattı günün tonunu belirliyor.',
  '{sun}, {moon} ve {rising} enerjileri bugün ortak bir mesaj veriyor.',
  'Günün ana sahnesinde Güneş {sun}, Ay {moon}, yükselen {rising} dengesi var.',
  'Bugün iç motivasyonunda {sun}, duyguda {moon}, dış tavırda {rising} etkisi öne çıkıyor.',
  '{sun} merkezdeyken, {moon} duygunu, {rising} yaklaşımını şekillendiriyor.',
  'Bugün Güneş {sun}, Ay {moon}, yükselen {rising} birleşimi kararlarını etkiliyor.',
  '{sun} - {moon} - {rising} kombinasyonu bugün net ama esnek kalmanı istiyor.',
];

const _sunLeadFrames = [
  'Bugün yönü daha çok Güneş burcun {sun} belirliyor.',
  'Günün ana motivasyonunda {sun} etkisi baskın.',
  '{sun} tarafın bugün karar mekanizmasını güçlendiriyor.',
  'Bugün Güneş burcun {sun}, ana rotanı netleştiriyor.',
  '{sun} enerjisi bugün sahnede; niyetini görünür tut.',
  'Bugün {sun} odağın, önceliklerini keskinleştiriyor.',
  '{sun} frekansı bugün iç pusulanı daha net çalıştırıyor.',
  'Bugün {sun} etkisiyle hedef bilincin yükseliyor.',
];

const _moonLeadFrames = [
  'Bugün duygusal pusulada Ay burcun {moon} öne çıkıyor.',
  '{moon} etkisi bugün hislerini daha görünür hale getiriyor.',
  'Ay burcun {moon}, bugünkü duygusal tepkilerine yön veriyor.',
  'Bugün kalp dilinde {moon} tonu belirgin.',
  '{moon} frekansı bugün sezgini güçlendiriyor.',
  'Bugün Ay burcun {moon}, iç dengeni yönetmeyi hatırlatıyor.',
  '{moon} etkisiyle bugün duygusal netlik daha önemli.',
  'Bugün {moon} enerjisi, iç dünyanda ince ayar istiyor.',
];

const _risingLeadFrames = [
  'Bugün dış dünyaya yansımanda yükselenin {rising} etkisi güçlü.',
  'Yükselen burcun {rising}, gün içi tavrını belirginleştiriyor.',
  'Bugün yaklaşım biçiminde {rising} etkisi öne çıkıyor.',
  'Yükselenin {rising}, bugün çevreyle kurduğun teması şekillendiriyor.',
  'Bugün {rising} enerjisiyle ilk adım tarzın netleşiyor.',
  '{rising} etkisi bugün sosyal alandaki duruşunu güçlendiriyor.',
  'Bugün yükselen burcun {rising}, görünür davranışlarını yönlendiriyor.',
  '{rising} vurgusu bugün iletişim tarzında hissediliyor.',
];

const _focusLeadFrames = [
  'Bugün odak {focusType} hattında {focusSign} tarafına kayıyor.',
  '{focusType} alanında {focusSign} enerjisi bugün daha görünür.',
  'Bugün {focusType} ekseninde {focusSign} tonu baskın.',
  '{focusSign} etkisi, bugün {focusType} katmanında belirleyici.',
  'Bugün {focusType} yorumunda {focusSign} merkezde.',
  '{focusType} haritanda {focusSign} bugün net bir yön gösteriyor.',
  'Bugün {focusType} pencerende {focusSign} vurgusu var.',
  '{focusSign}, bugün {focusType} alanında öncelik işareti veriyor.',
];

const _openersWithSign = [
  'Bugün odak {focusType} yerleşimin olan {focusSign}; {signImage} teması güçlü.',
  '{focusType} burcundaki {focusSign}, günün atmosferine {signImage} dokusu katıyor.',
  '{focusSign} etkisiyle {focusType} alanın bugün öne çıkıyor; {signImage} vurgusu var.',
  'Kozmik ritim, {focusType} katmanında {focusSign} üzerinden akıyor; {signImage} hissediliyor.',
  '{focusType} yönünde {focusSign} aktif; {signImage} enerjisini yapıcı kullan.',
  '{focusSign} frekansı bugün {focusType} merkezinde çalışıyor; {signImage} etkisi belirgin.',
  '{focusType} haritanda {focusSign} parlıyor; {signImage} alanında sezgilerin açık.',
  '{focusSign} tonu bugün {focusType} merkezini canlı tutuyor; {signImage} akışına güven.',
  'Gökyüzü, {focusType} boyutunda {focusSign} ile konuşuyor; {signImage} sahnede.',
  '{focusSign} bugün {focusType} pencerenden bakmanı istiyor; {signImage} ön planda.',
  '{focusType} alanında {focusSign} etkisiyle {signImage} dinamiği hızlanıyor.',
  '{focusSign} sinyali bugün {focusType} tarafında güçlü; {signImage} dikkat çekiyor.',
];

const _openersPlain = [
  'Bugün kozmik atmosferde {signImage} dokusu güçlü; bunu yapıcı kullan.',
  'Günün enerjisi {signImage} tonunda; netlik tarafını canlı tut.',
  'Bugünkü gökyüzü, {signImage} temasını daha görünür kılıyor.',
  'Bugün iç ritimde {signImage} etkisi artıyor; dengeni koru.',
  'Enerji akışında {signImage} tonu var; sade adımlar daha çok sonuç verir.',
  'Bugünün kozmik sinyalinde {signImage} vurgusu öne çıkıyor.',
  'Bugün {signImage} frekansı, kararlarında daha seçici olmanı destekliyor.',
  'Atmosferde {signImage} etkisi var; acele etmeden ilerlemek kazandırır.',
  'Bugünün titreşimi {signImage} alanında çalışıyor; odağını dağıtma.',
  'Gökyüzü bugün {signImage} tonuyla daha rafine seçimler istiyor.',
  'Bugün {signImage} hattı aktif; iç dengeyi koruyarak hareket et.',
  'Günün ritmi {signImage} merkezinde; küçük ama istikrarlı kal.',
];

const _intentFrames = [
  'Bu enerji, {quality} yanını güçlendirirken {gift} kapısını aralar.',
  '{quality} tavrın sayesinde {gift} potansiyelin görünür olur.',
  'Bugünün ana niyeti: {quality} kalıp {gift} alanını büyütmek.',
  '{gift} için gereken anahtar, {quality} yaklaşımında saklı.',
  'Yıldızların daveti: {quality} kal ve {gift} fırsatını yakala.',
  '{quality} frekansın, {gift} konusunda seni bir adım öne taşır.',
  '{gift} akışını açmak için {quality} tarafını bilinçli kullan.',
  'İç dengende {quality} arttıkça {gift} daha net görünür.',
  '{quality} odağın, {gift} hedeflerini daha gerçekçi kılar.',
  'Ruhsal ritim, {quality} sayesinde {gift} alanında genişler.',
  'Bugün {quality} tavrınla {gift} konusunda güçlü bir ivme yakalarsın.',
  '{gift} için en doğru yaklaşım, {quality} enerjini sadeleştirmek.',
];

const _actionFrames = [
  '{area} tarafında küçük ama net bir adım at ve {action}.',
  '{area} konularında odağını sadeleştir, ardından {action}.',
  '{area} alanında önceliğini belirleyip {action}.',
  '{area} gündeminde acele etmeden {action}.',
  '{area} planında bugün tek bir konu seç ve {action}.',
  '{area} adına kısa bir not al, sonra {action}.',
  '{area} ile ilgili gereksiz yükleri bırakıp {action}.',
  '{area} konusunda iletişimi açık tut ve {action}.',
  '{area} akışında sakin kal; doğru anda {action}.',
  '{area} tarafında dengeyi korurken {action}.',
  '{area} üzerinde çalışırken sezgine kulak ver ve {action}.',
  '{area} sorumluluklarını bölümlere ayır, ardından {action}.',
];

const _balanceFrames = [
  'Denge noktası: {balance}.',
  'Bugünkü hatırlatma: {balance}.',
  'Günün kilidi: {balance}.',
  'Enerjiyi korumak için {balance}.',
  'İç huzur için {balance}.',
  'Akışı sürdürebilmek için {balance}.',
  'Kritik ipucu: {balance}.',
  'Ritmini bozmamak adına {balance}.',
  'Netlik için {balance}.',
  'Verim için {balance}.',
];

const _closersWithSign = [
  'Bugün ritim sende, {name}.',
  '{focusSign} frekansını sakin ve bilinçli kullan.',
  'Yolun açık; küçük istikrar büyük fark yaratır.',
  'Akışa güven, netlik adım adım gelir.',
  'Bugün kendine alan açtığında şansın artar.',
  'Kalp-zihin dengesini koruduğunda sonuçlar hızlanır.',
  'Nazik ama kararlı ilerlediğinde gün sana çalışır.',
  'Odak sende kaldıkça gökyüzü desteği büyür.',
  'Bugün kendi ritmini bozmadan ilerlemen yeterli.',
  'Sakin güç, bugün en büyük avantajın.',
];

const _closersPlain = [
  'Bugün ritim sende, {name}.',
  'Yolun açık; küçük istikrar büyük fark yaratır.',
  'Akışa güven, netlik adım adım gelir.',
  'Bugün kendine alan açtığında şansın artar.',
  'Kalp-zihin dengesini koruduğunda sonuçlar hızlanır.',
  'Nazik ama kararlı ilerlediğinde gün sana çalışır.',
  'Odak sende kaldıkça gökyüzü desteği büyür.',
  'Bugün kendi ritmini bozmadan ilerlemen yeterli.',
  'Sakin güç, bugün en büyük avantajın.',
  'Netlik ve istikrar bugün en büyük destekçin.',
];

const _areas = [
  'ilişkiler',
  'iş ve üretim',
  'eğitim ve öğrenme',
  'para ve kaynak yönetimi',
  'aile düzeni',
  'kişisel bakım',
  'iletişim',
  'yaratıcılık',
  'uzun vadeli planlar',
  'günlük rutin',
  'duygusal denge',
  'sosyal çevre',
];

const _defaultSignSignatureLines = [
  'Bugün iç ritmini koruduğunda kararların daha temiz sonuç verir.',
  'Küçük ama net seçimler bugün uzun vadede fark yaratır.',
  'Bugün dengeni korumak, hızdan daha stratejik bir hamledir.',
  'Günün ana kazancı: sadeleştiğinde güçlenmen.',
  'Bugün odak daraldıkça sezgin ve verin daha iyi buluşur.',
  'Bugün duygunu ve mantığını aynı masada tuttuğunda açılım gelir.',
  'Enerjini doğru yere verdiğinde gün senden yana akmaya başlar.',
  'Bugün bir adımı tamamlamak, on fikirden daha değerlidir.',
];

const _signSignatureLines = <String, List<String>>{
  'Koç': [
    'Koç burçları için bugün en doğru hamle, cesareti plansızlığa çevirmemek.',
    'Bugün Koç enerjinde ilk adım güçlü; ikinci adımda strateji kazandırır.',
    'Koç tarafın bugün hızla açılıyor; odağını tek hedefte tuttuğunda fark yaratırsın.',
    'Bugün Koç vurgusu, beklediğin işi başlatmak için net bir destek veriyor.',
    'Koç frekansında bugün gereksiz çatışma yerine net yön seçmek kazandırır.',
    'Bugün Koç enerjisiyle liderlik gücün yükseliyor; tonda yumuşaklık dengeyi korur.',
    'Koç burcu etkisinde bugün kısa karar zincirleri daha verimli çalışır.',
    'Bugün Koç doğanla cesaretin yüksek; sabır eklendiğinde sonuç kalıcı olur.',
  ],
  'Boğa': [
    'Boğa burçları için bugün istikrar, en güçlü avantajın olarak çalışıyor.',
    'Bugün Boğa etkisinde yavaş ama sağlam ilerlemek hızdan daha kazançlı.',
    'Boğa frekansında bugün değerini net koyduğunda denge kendiliğinden gelir.',
    'Bugün Boğa doğanda güven ihtiyacını planla desteklemek seni rahatlatır.',
    'Boğa vurgusu bugün kaynak yönetiminde sezgini ve veriyi birlikte çalıştırır.',
    'Bugün Boğa enerjisiyle kalıcı bir düzen kurmak için doğru zaman.',
    'Boğa burcu etkisinde bugün konforu korurken esnemek büyümeni hızlandırır.',
    'Bugün Boğa tarafında sadelik, zihinsel yükünü azaltıp alan açar.',
  ],
  'İkizler': [
    'İkizler burçları için bugün iletişim trafiğini sadeleştirmek büyük fark yaratır.',
    'Bugün İkizler enerjisinde doğru soruyu sormak yarı çözüm demek.',
    'İkizler vurgusunda bugün bilgiyi hızla değil, netlikle taşımak kazandırır.',
    'Bugün İkizler frekansı merakını canlı tutuyor; dağılmamak için öncelik şart.',
    'İkizler burcu etkisinde bugün tek bir konuşmayı derinleştirmek çok şey açar.',
    'Bugün İkizler tarafında kısa notlar, büyük zihinsel dağınıklığı toparlar.',
    'İkizler enerjin bugün bağlantı kurdurur; seçici olmak kaliteyi yükseltir.',
    'Bugün İkizler doğanda fikir bolluğunu eylem sırasına koymak önemli.',
  ],
  'Yengeç': [
    'Yengeç burçları için bugün duygunu bastırmadan sınır koymak şifalı olur.',
    'Bugün Yengeç etkisinde aidiyet ihtiyacını net ifade etmek ilişkileri güçlendirir.',
    'Yengeç frekansında bugün kalbini korurken açıklıkta kalmak dengeni artırır.',
    'Bugün Yengeç enerjisinde yumuşak dil, zor konuları daha kolay çözer.',
    'Yengeç burcu etkisinde bugün geçmişi değil bugünü yönetmek sana iyi gelir.',
    'Bugün Yengeç tarafında duygusal hijyen, verimini doğrudan yükseltir.',
    'Yengeç doğanda bugün şefkati önce kendine verdiğinde akış kolaylaşır.',
    'Bugün Yengeç vurgusu, iç güveni büyüterek dış ilişkileri düzenler.',
  ],
  'Aslan': [
    'Aslan burçları için bugün görünürlük doğru niyetle birleştiğinde parlatır.',
    'Bugün Aslan etkisinde yaratıcı tarafını saklamadan paylaşmak kazandırır.',
    'Aslan frekansında bugün sıcak liderlik, ekip enerjisini yükseltir.',
    'Bugün Aslan vurgusu özgüven veriyor; ölçü dengesi sonucu kalıcı yapar.',
    'Aslan burcu etkisinde bugün takdir aramak yerine değer üretmek fark yaratır.',
    'Bugün Aslan enerjisiyle sahne senin; dinlemek de gücünü artırır.',
    'Aslan doğanda bugün kalpten iletişim, zor kapıları yumuşatır.',
    'Bugün Aslan tarafında yaratıcı risk, planla birleştiğinde sonuç verir.',
  ],
  'Başak': [
    'Başak burçları için bugün küçük iyileştirmeler büyük verim getirir.',
    'Bugün Başak etkisinde düzen kurmak, zihnindeki gürültüyü azaltır.',
    'Başak frekansında bugün eleştiriyi çözüm cümlesine çevirmek önemli.',
    'Bugün Başak vurgusu, kaliteyi artırırken mükemmeliyet baskısını bırakmanı ister.',
    'Başak burcu etkisinde bugün öncelik sırası netleştiğinde hız artar.',
    'Bugün Başak enerjisinde detaylar güçlü; bütünü de gözden kaçırma.',
    'Başak doğanda bugün sade bir sistem kurmak gününü rahatlatır.',
    'Bugün Başak tarafında plan + mola dengesi performansı korur.',
  ],
  'Terazi': [
    'Terazi burçları için bugün denge, net karar vermeyle anlam kazanır.',
    'Bugün Terazi etkisinde uyum ararken kendi ihtiyacını da masaya koy.',
    'Terazi frekansında bugün diplomasi, açık sınırlarla daha güçlü çalışır.',
    'Bugün Terazi vurgusu ilişkilerde ince ayar yapmak için ideal.',
    'Terazi burcu etkisinde bugün estetik dokunuşlar motivasyonunu yükseltir.',
    'Bugün Terazi enerjisiyle uzlaşma kolay; erteleme yerine karar seç.',
    'Terazi doğanda bugün nazik netlik, uzun tartışmaları kısaltır.',
    'Bugün Terazi tarafında adalet duygun güçlü; kendine de adil ol.',
  ],
  'Akrep': [
    'Akrep burçları için bugün derinlikten güç alıp net hamle yapmak mümkün.',
    'Bugün Akrep etkisinde iç sezgin yüksek; bunu sakin stratejiyle birleştir.',
    'Akrep frekansında bugün gereksiz yükü bırakmak dönüşümü hızlandırır.',
    'Bugün Akrep vurgusu, gizli kalan konularda gerçeği görmene yardım eder.',
    'Akrep burcu etkisinde bugün kontrolü biraz gevşetmek akışı açar.',
    'Bugün Akrep enerjisinde bağ kurarken sınırlarını net tutmak önemli.',
    'Akrep doğanda bugün duygusal yoğunluğu eyleme çevirmek rahatlatır.',
    'Bugün Akrep tarafında az ve öz konuşmak daha etkili olur.',
  ],
  'Yay': [
    'Yay burçları için bugün büyük resmi koruyup adımı somutlaştırmak kritik.',
    'Bugün Yay etkisinde coşkun yüksek; odağı tek hedefte tutmak kazandırır.',
    'Yay frekansında bugün öğrenme isteğin güçlü; uygulamaya çevirmeyi unutma.',
    'Bugün Yay vurgusu yeni fikir getiriyor; planla birleşince değer üretir.',
    'Yay burcu etkisinde bugün özgürlük ihtiyacını sorumlulukla dengelemek önemli.',
    'Bugün Yay enerjisiyle moralin yükseliyor; abartıyı sade veriyle dengele.',
    'Yay doğanda bugün keşif arzusu güçlü; bir konuyu derinleştirerek ilerle.',
    'Bugün Yay tarafında vizyonunu günlük plana indirmek başarıyı hızlandırır.',
  ],
  'Oğlak': [
    'Oğlak burçları için bugün disiplinin en büyük güven alanın oluyor.',
    'Bugün Oğlak etkisinde uzun vadeli düşünmek kısa vadeyi de toparlar.',
    'Oğlak frekansında bugün sağlam temel kurmak tüm günü rahatlatır.',
    'Bugün Oğlak vurgusu sorumluluk bilincini yükseltiyor; paylaşım yapmayı unutma.',
    'Oğlak burcu etkisinde bugün ölçülebilir hedefler hızını artırır.',
    'Bugün Oğlak enerjisinde emek görünür sonuç üretmeye başlar.',
    'Oğlak doğanda bugün sabır + düzen kombinasyonu kritik bir avantaj.',
    'Bugün Oğlak tarafında kendine yumuşak davranmak performansı düşürmez, korur.',
  ],
  'Kova': [
    'Kova burçları için bugün özgün fikirlerini pratiğe çevirmek günü açar.',
    'Bugün Kova etkisinde yenilikçi bakışın problem çözmede öne çıkıyor.',
    'Kova frekansında bugün farklı düşünmek güçlü; uygulanabilirlik de şart.',
    'Bugün Kova vurgusu ekip içinde yeni bir düzen önermeni destekliyor.',
    'Kova burcu etkisinde bugün teoriyi küçük testlere bölmek kazandırır.',
    'Bugün Kova enerjisinde bağımsızlık ihtiyacı yüksek; iletişimi açık tut.',
    'Kova doğanda bugün vizyonun güçlü; duygusal bağ kurmayı da ihmal etme.',
    'Bugün Kova tarafında yenilik cesareti, sadelikle birleştiğinde sonuç verir.',
  ],
  'Balık': [
    'Balık burçları için bugün sezgiyi somut adımla birleştirmek çok değerli.',
    'Bugün Balık etkisinde empatin yüksek; sınır çizmek dengeyi korur.',
    'Balık frekansında bugün yaratıcı akış güçlü; dağılmamak için sade plan yap.',
    'Bugün Balık vurgusu iç sesini artırıyor; gerçeklikle bağını canlı tut.',
    'Balık burcu etkisinde bugün şefkatli ama net iletişim daha etkili olur.',
    'Bugün Balık enerjisinde ilhamın yüksek; tek bir üretime odaklan.',
    'Balık doğanda bugün duygusal yoğunluğu ritimle topraklamak iyi gelir.',
    'Bugün Balık tarafında hayal gücünü uygulanabilir bir çerçeveye al.',
  ],
};

const _defaultLexicon = _SignLexicon(
  imagery: ['netlik', 'denge', 'odak', 'içgörü', 'sadelik', 'uyum'],
  qualities: [
    'sakin',
    'dengeli',
    'kararlı',
    'esnek',
    'bilinçli',
    'açık fikirli',
  ],
  gifts: [
    'fırsatları görme',
    'doğru karar',
    'duygusal netlik',
    'ilişkide uyum',
    'üretkenlik',
    'iç huzur',
  ],
  actions: [
    'kararını somutlaştır',
    'fikrini net ifade et',
    'yükünü hafiflet',
    'adımını tamamla',
    'önceliğini sabitle',
    'enerjini koru',
  ],
  balanceTips: [
    'tek işe odaklan',
    'acele yerine ritim seç',
    'dinlenme aralığı koy',
    'sınırlarını koru',
    'önce netlik sonra hız',
    'gereksiz tartışmayı bırak',
  ],
);

const _lexiconBySign = <String, _SignLexicon>{
  'Koç': _SignLexicon(
    imagery: ['başlangıç', 'cesaret', 'ataklık', 'hız', 'liderlik', 'mücadele'],
    qualities: ['cesur', 'atak', 'doğrudan', 'öncü', 'dinamik', 'kararlı'],
    gifts: [
      'ilk adımı atma',
      'hızlı toparlanma',
      'net karar alma',
      'ekibi ateşleme',
      'fırsatı yakalama',
      'engeli aşma',
    ],
    actions: [
      'ilk adımı ertelemeden at',
      'önceliğini yüksek sesle duyur',
      'yarım kalan işi tamamla',
      'hedefini netleştir',
      'enerjini tek hedefte topla',
      'kararsızlığı kes',
    ],
    balanceTips: [
      'hızını nefesle dengele',
      'ani tepkiden önce 10 saniye bekle',
      'tek savaş seç',
      'sabırsızlığı planla yumuşat',
      'rekabeti iş birliğine çevir',
      'bedeni kısa yürüyüşle boşalt',
    ],
  ),
  'Boğa': _SignLexicon(
    imagery: [
      'istikrar',
      'bereket',
      'sabır',
      'köklenme',
      'güven',
      'süreklilik',
    ],
    qualities: [
      'sabırlı',
      'sağlam',
      'istikrarlı',
      'topraklı',
      'güven veren',
      'ölçülü',
    ],
    gifts: [
      'kalıcı sonuç',
      'maddi denge',
      'güvenli adım',
      'uzun vadeli başarı',
      'dingin üretkenlik',
      'sağlam ilişki',
    ],
    actions: [
      'planını yavaş ama sağlam ilerlet',
      'kaynaklarını koruyarak büyüt',
      'değerini net şekilde savun',
      'rutinini istikrarlı tut',
      'önce temelini güçlendir',
      'konforu bilinçli yönet',
    ],
    balanceTips: [
      'inat yerine esneklik dene',
      'değişime küçük dozlarda açıl',
      'fazla yükü sadeleştir',
      'bedeni hareketle canlandır',
      'maddi kaygıyı plana dök',
      'konfor alanını biraz genişlet',
    ],
  ),
  'İkizler': _SignLexicon(
    imagery: [
      'merak',
      'iletişim',
      'zihin akışı',
      'bağlantı',
      'öğrenme',
      'hareket',
    ],
    qualities: [
      'meraklı',
      'çevik',
      'sosyal',
      'esnek',
      'zeki',
      'ifade gücü yüksek',
    ],
    gifts: [
      'hızlı öğrenme',
      'doğru bağlantı',
      'yaratıcı fikir',
      'iletişim başarısı',
      'çok yönlü çözüm',
      'fırsatları birleştirme',
    ],
    actions: [
      'fikrini kısa ve net anlat',
      'öncelik listeni sadeleştir',
      'tek konuşmada net sonuç al',
      'notlarını eyleme çevir',
      'iletişim trafiğini planla',
      'bilgiyi pratiğe indir',
    ],
    balanceTips: [
      'zihni dinlendirmek için ekran molası ver',
      'çok seçenek yerine 2 seçenek tut',
      'dağınıklığı listelerle toparla',
      'yarım işleri kapat',
      'dedikodu yerine net bilgi seç',
      'nefesle odağı toparla',
    ],
  ),
  'Yengeç': _SignLexicon(
    imagery: ['şefkat', 'aidiyet', 'koruma', 'duygusal zeka', 'yuva', 'sezgi'],
    qualities: [
      'şefkatli',
      'duyarlı',
      'koruyucu',
      'sezgisel',
      'bağlı',
      'yumuşak güç sahibi',
    ],
    gifts: [
      'duygusal derinlik',
      'güvenli bağ kurma',
      'iyileştirici iletişim',
      'ailede uyum',
      'iç sesle doğru karar',
      'hassas güç',
    ],
    actions: [
      'duygunu bastırmadan ifade et',
      'ev düzeninde küçük iyileştirme yap',
      'yakınlarınla net sınır kur',
      'kalbini yoran konuyu sadeleştir',
      'şefkati önce kendine ver',
      'sezgini eyleme dönüştür',
    ],
    balanceTips: [
      'geçmişte takılı kalma',
      'alınganlığı gerçek veriyle dengele',
      'kendi ihtiyaçlarını da öncelikle',
      'aşırı korumayı azalt',
      'duygunu yazıya dök',
      'enerjini emen sohbetleri sınırla',
    ],
  ),
  'Aslan': _SignLexicon(
    imagery: [
      'parlama',
      'özgüven',
      'yaratıcılık',
      'sahne',
      'cömertlik',
      'kalpten liderlik',
    ],
    qualities: [
      'özgüvenli',
      'yaratıcı',
      'sıcakkanlı',
      'cömert',
      'karizmatik',
      'ilham veren',
    ],
    gifts: [
      'görünür başarı',
      'liderlik etkisi',
      'yaratıcı üretim',
      'sosyal çekim',
      'takdir toplama',
      'motive etme',
    ],
    actions: [
      'üretimini görünür kıl',
      'yaratıcı fikrini paylaş',
      'ekibini cesaretlendir',
      'sahne almaktan çekinme',
      'hedefini tutkuyla savun',
      'parlayan yönünü işle',
    ],
    balanceTips: [
      'ego yerine katkı odağı seç',
      'takdir beklemeden değer üret',
      'dinlemeyi de liderlik say',
      'abartıyı sadelikle dengele',
      'enerjini dağıtma',
      'kalpten ama ölçülü ilerle',
    ],
  ),
  'Başak': _SignLexicon(
    imagery: ['düzen', 'analiz', 'arındırma', 'hizmet', 'detay', 'verim'],
    qualities: [
      'titiz',
      'analitik',
      'düzenli',
      'çözüm odaklı',
      'fayda üreten',
      'pratik',
    ],
    gifts: [
      'hata ayıklama',
      'sistem kurma',
      'verim artışı',
      'net plan',
      'kalite yükseltme',
      'disiplinli ilerleme',
    ],
    actions: [
      'iş akışını sadeleştir',
      'kritik detayı düzelt',
      'planını saatlere böl',
      'küçük iyileştirme uygula',
      'önce önem sırasını çıkar',
      'yarım dosyayı bitir',
    ],
    balanceTips: [
      'mükemmeliyet yerine yeterince iyi seç',
      'kendine karşı yumuşak ol',
      'eleştiriyi çözümle dengele',
      'dinlenmeyi plana yaz',
      'detayda kaybolma',
      'kontrol ihtiyacını azalt',
    ],
  ),
  'Terazi': _SignLexicon(
    imagery: ['denge', 'uyum', 'estetik', 'diplomasi', 'adalet', 'iş birliği'],
    qualities: [
      'uyumlu',
      'adil',
      'zarif',
      'diplomatik',
      'barıştırıcı',
      'sosyal zekası güçlü',
    ],
    gifts: [
      'ilişkide denge',
      'uzlaşma üretme',
      'estetik dokunuş',
      'doğru ortaklık',
      'ikna gücü',
      'sakin çözüm',
    ],
    actions: [
      'ilişkide net beklenti konuş',
      'kararını geciktirmeden ver',
      'ortak hedefi yazılı hale getir',
      'estetik düzenleme yap',
      'iletişimde tonu yumuşat',
      'dengeyi tek cümleyle kur',
    ],
    balanceTips: [
      'herkesi memnun etme çabasını bırak',
      'kararsızlığı son tarihle sınırla',
      'kendi ihtiyacını da masaya koy',
      'hayır demeyi pratik et',
      'görünüş kadar özü de tart',
      'denge için net sınır çiz',
    ],
  ),
  'Akrep': _SignLexicon(
    imagery: ['dönüşüm', 'derinlik', 'sezgi', 'güç', 'sadakat', 'yenilenme'],
    qualities: [
      'derin',
      'sezgisel',
      'kararlı',
      'güçlü',
      'odaklı',
      'dönüştürücü',
    ],
    gifts: [
      'krizde güçlenme',
      'gerçeği görme',
      'duygusal dayanıklılık',
      'derin bağ kurma',
      'stratejik hamle',
      'köklü yenilenme',
    ],
    actions: [
      'gizli kalan konuyu netleştir',
      'duygunu yapıcı kanala aktar',
      'stratejini iki adım ileri kur',
      'enerji sızıntısını kes',
      'önemli konuşmayı erteleme',
      'dönüştürücü karar al',
    ],
    balanceTips: [
      'kontrolü gevşetmeyi dene',
      'şüpheyi kanıtla dengele',
      'kini bırakıp alan aç',
      'güç savaşına girme',
      'gizlilikte dozunu koru',
      'yüksek duyguda mola ver',
    ],
  ),
  'Yay': _SignLexicon(
    imagery: ['ufuk', 'özgürlük', 'keşif', 'iyimserlik', 'inanç', 'genişleme'],
    qualities: [
      'iyimser',
      'vizyoner',
      'özgür',
      'öğrenmeye açık',
      'coşkulu',
      'dürüst',
    ],
    gifts: [
      'büyük resmi görme',
      'hızlı motivasyon',
      'öğretici etki',
      'fırsatları büyütme',
      'yol açıcı fikir',
      'moral yükseltme',
    ],
    actions: [
      'hedefini büyük resimle hizala',
      'öğrendiğini paylaş',
      'yeni bir beceriye başla',
      'vizyonunu takvime indir',
      'fazla dağılımı azalt',
      'coşkunu plana bağla',
    ],
    balanceTips: [
      'abartıyı somut adımla dengele',
      'fazla söz yerine net teslim koy',
      'özgürlüğü sorumlulukla eşleştir',
      'acele karardan önce veri topla',
      'enerjini bir ana hedefte tut',
      'dağılmayı günlük plana indir',
    ],
  ),
  'Oğlak': _SignLexicon(
    imagery: [
      'disiplin',
      'hedef',
      'dayanıklılık',
      'sorumluluk',
      'zirve',
      'yapı',
    ],
    qualities: [
      'disiplinli',
      'stratejik',
      'sabırlı',
      'sorumlu',
      'gerçekçi',
      'dayanıklı',
    ],
    gifts: [
      'uzun vadeli başarı',
      'sistemli ilerleme',
      'kararlı sonuç',
      'itibar inşası',
      'hedefe sadakat',
      'krizde soğukkanlılık',
    ],
    actions: [
      'hedefini ölçülebilir hale getir',
      'öncelik matrisini netleştir',
      'kritik görevi tamamla',
      'takvimini disiplinle uygula',
      'sorumluluğu delege et',
      'güçlü bir temel kur',
    ],
    balanceTips: [
      'kendine gereğinden sert olma',
      'mola vermeyi zayıflık sayma',
      'yük paylaşımını artır',
      'sonucu değil süreci de kutla',
      'duyguları bastırma',
      'esnemeyi plana ekle',
    ],
  ),
  'Kova': _SignLexicon(
    imagery: [
      'yenilik',
      'özgünlük',
      'vizyon',
      'topluluk',
      'farklı bakış',
      'gelecek',
    ],
    qualities: [
      'özgün',
      'yenilikçi',
      'bağımsız',
      'vizyoner',
      'insancıl',
      'analitik',
    ],
    gifts: [
      'orijinal çözüm',
      'sistem dışı bakış',
      'toplumsal katkı',
      'teknik netlik',
      'hızlı model kurma',
      'gelecek öngörüsü',
    ],
    actions: [
      'farklı fikrini prototipe çevir',
      'ekiple açık beyin fırtınası yap',
      'sistemi daha akıllı hale getir',
      'uzun vadeli vizyonu yaz',
      'yenilik için küçük test yap',
      'sınırları yapıcı zorla',
    ],
    balanceTips: [
      'duygusal mesafeyi azalt',
      'teoride kalma uygulamaya geç',
      'inatçı fikri veriye aç',
      'kopukluğu iletişimle onar',
      'fazla zihinselliği bedenle dengele',
      'yardım istemeyi erteleme',
    ],
  ),
  'Balık': _SignLexicon(
    imagery: ['sezgi', 'şifa', 'hayal gücü', 'akış', 'empati', 'ilham'],
    qualities: [
      'sezgisel',
      'şefkatli',
      'yaratıcı',
      'akışta',
      'duyarlı',
      'ilham verici',
    ],
    gifts: [
      'derin empati',
      'yaratıcı ifade',
      'ruhsal netlik',
      'şifalı etki',
      'esnek çözüm',
      'sanatsal üretim',
    ],
    actions: [
      'sezgini somut bir adıma indir',
      'yaratıcı fikrini kayda al',
      'duygusal sınırlarını belirle',
      'iyileştirici rutine dön',
      'hayalini planla buluştur',
      'iç sesini yazıya dök',
    ],
    balanceTips: [
      'kaçış yerine gerçeklikle bağ kur',
      'aşırı fedakarlığı sınırla',
      'duyguyu bedenle toprakla',
      'belirsizliği küçük plana böl',
      'enerji hijyenini koru',
      'sınır çizmekten çekinme',
    ],
  ),
};

const _signAliases = {
  'Koc': 'Koç',
  'Koç': 'Koç',
  'Boga': 'Boğa',
  'Boğa': 'Boğa',
  'Ikizler': 'İkizler',
  'İkizler': 'İkizler',
  'Yengec': 'Yengeç',
  'Yengeç': 'Yengeç',
  'Aslan': 'Aslan',
  'Basak': 'Başak',
  'Başak': 'Başak',
  'Terazi': 'Terazi',
  'Akrep': 'Akrep',
  'Yay': 'Yay',
  'Oglak': 'Oğlak',
  'Oğlak': 'Oğlak',
  'Kova': 'Kova',
  'Balik': 'Balık',
  'Balık': 'Balık',
  'Bilinmiyor': 'Bilinmiyor',
  'Yukleniyor...': 'Bilinmiyor',
};
