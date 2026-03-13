enum HoroscopePeriod { weekly, monthly, yearly }

class PeriodicHoroscopeComment {
  const PeriodicHoroscopeComment({required this.title, required this.body});

  final String title;
  final String body;
}

class PeriodicHoroscopeGenerator {
  const PeriodicHoroscopeGenerator._();

  static PeriodicHoroscopeComment personalized({
    required String userKey,
    required String userName,
    required String sunSign,
    required HoroscopePeriod period,
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    final sign = _normalizeSign(sunSign);
    final name = _normalizeName(userName);
    final bucket = _periodBucket(period, date);
    final seed = _seedFrom('$userKey|$sign|${period.name}|$bucket|ozel-v1');

    final lexicon = _signLexicon[sign] ?? _defaultLexicon;
    final lead = _pickBySeed(_periodLeads[period]!, seed: seed, salt: 11);
    final trait = _pickBySeed(lexicon.traits, seed: seed, salt: 19);
    final gift = _pickBySeed(lexicon.gifts, seed: seed, salt: 23);
    final focus = _pickBySeed(lexicon.focusAreas, seed: seed, salt: 31);
    final action = _pickBySeed(_actions, seed: seed, salt: 41);
    final balance = _pickBySeed(lexicon.balanceTips, seed: seed, salt: 47);
    final closer = _pickBySeed(_personalClosers, seed: seed, salt: 59);
    final periodPulse = _pickBySeed(
      _personalPeriodPulseFrames[period]!,
      seed: seed,
      salt: 67,
    ).replaceAll('{sign}', sign).replaceAll('{focus}', focus);
    final innerTheme = _pickBySeed(
      _personalInnerThemeFrames,
      seed: seed,
      salt: 73,
    ).replaceAll('{trait}', trait).replaceAll('{gift}', gift);
    final workFlow = _pickBySeed(
      _personalWorkFlowFrames,
      seed: seed,
      salt: 79,
    ).replaceAll('{focus}', focus).replaceAll('{gift}', gift);
    final relationFlow = _pickBySeed(
      _personalRelationFlowFrames,
      seed: seed,
      salt: 83,
    ).replaceAll('{trait}', trait);
    final financeFlow = _pickBySeed(
      _personalFinanceFlowFrames,
      seed: seed,
      salt: 89,
    ).replaceAll('{gift}', gift);
    final timingAdvice = _pickBySeed(
      _personalTimingAdviceFrames[period]!,
      seed: seed,
      salt: 97,
    );
    final energyAdvice = _pickBySeed(
      _personalEnergyAdviceFrames,
      seed: seed,
      salt: 101,
    ).replaceAll('{balance}', balance);
    final longCloser = _pickBySeed(_personalLongClosers, seed: seed, salt: 109);

    final title = _buildPersonalizedTitle(
      period: period,
      name: name,
      sign: sign,
    );

    final sentence1 = lead
        .replaceAll('{name}', name)
        .replaceAll('{sign}', sign)
        .replaceAll('{trait}', trait)
        .replaceAll('{gift}', gift);

    final sentence2 = '$focus alanında $action; denge için $balance. $closer';
    final sentence3 = periodPulse;
    final sentence4 = innerTheme;
    final sentence5 = workFlow;
    final sentence6 = relationFlow;
    final sentence7 = financeFlow;
    final sentence8 = timingAdvice;
    final sentence9 = energyAdvice;
    final sentence10 = longCloser;

    return PeriodicHoroscopeComment(
      title: title,
      body: _capitalizeSentenceStarts(
        '$sentence1 $sentence2 $sentence3 $sentence4 $sentence5 $sentence6 $sentence7 $sentence8 $sentence9 $sentence10',
      ),
    );
  }

  static PeriodicHoroscopeComment general({
    required String sunSign,
    required HoroscopePeriod period,
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    final sign = _normalizeSign(sunSign);
    final bucket = _periodBucket(period, date);
    final seed = _seedFrom('$sign|${period.name}|$bucket|genel-v1');

    final lexicon = _signLexicon[sign] ?? _defaultLexicon;
    final lead = _pickBySeed(_generalLeads[period]!, seed: seed, salt: 13);
    final trend = _pickBySeed(lexicon.generalTrends, seed: seed, salt: 29);
    final opportunity = _pickBySeed(
      lexicon.opportunities,
      seed: seed,
      salt: 37,
    );
    final caution = _pickBySeed(lexicon.cautions, seed: seed, salt: 43);
    final closer = _pickBySeed(_generalClosers, seed: seed, salt: 61);
    final periodContext = _pickBySeed(
      _generalPeriodContextFrames[period]!,
      seed: seed,
      salt: 71,
    ).replaceAll('{sign}', sign);
    final generalOpportunity = _pickBySeed(
      _generalOpportunityFrames,
      seed: seed,
      salt: 79,
    ).replaceAll('{opportunity}', opportunity);
    final generalRisk = _pickBySeed(
      _generalRiskFrames,
      seed: seed,
      salt: 83,
    ).replaceAll('{caution}', caution);
    final generalStrategy = _pickBySeed(
      _generalStrategyFrames,
      seed: seed,
      salt: 89,
    ).replaceAll('{trend}', trend);
    final timingWindow = _pickBySeed(
      _generalTimingFrames[period]!,
      seed: seed,
      salt: 97,
    );
    final collectiveAdvice = _pickBySeed(
      _generalCollectiveAdviceFrames,
      seed: seed,
      salt: 103,
    );
    final longCloser = _pickBySeed(_generalLongClosers, seed: seed, salt: 107);

    final title = _buildGeneralTitle(period: period, sign: sign, date: date);
    final body =
        '$lead $trend etkisi öne çıkıyor ve burç genelinde karar alanlarını belirginleştiriyor. '
        '$periodContext '
        '$generalOpportunity '
        '$generalRisk '
        '$generalStrategy '
        '$timingWindow '
        '$collectiveAdvice '
        '$closer '
        '$longCloser';

    return PeriodicHoroscopeComment(
      title: title,
      body: _capitalizeSentenceStarts(body),
    );
  }

  static int _periodBucket(HoroscopePeriod period, DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    switch (period) {
      case HoroscopePeriod.weekly:
        final weekStart = normalized.subtract(
          Duration(days: normalized.weekday - DateTime.monday),
        );
        return weekStart.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
      case HoroscopePeriod.monthly:
        return (normalized.year * 12) + normalized.month;
      case HoroscopePeriod.yearly:
        return normalized.year;
    }
  }

  static String _buildPersonalizedTitle({
    required HoroscopePeriod period,
    required String name,
    required String sign,
  }) {
    switch (period) {
      case HoroscopePeriod.weekly:
        return '$name için haftalık gökyüzü';
      case HoroscopePeriod.monthly:
        return '$name için aylık gökyüzü';
      case HoroscopePeriod.yearly:
        return '$sign - Senin yıllık gökyüzün';
    }
  }

  static String _buildGeneralTitle({
    required HoroscopePeriod period,
    required String sign,
    required DateTime date,
  }) {
    switch (period) {
      case HoroscopePeriod.weekly:
        return '$sign haftalık genel yorum';
      case HoroscopePeriod.monthly:
        return '$sign aylık genel yorum';
      case HoroscopePeriod.yearly:
        return '$sign - ${date.year} yılı genel yorum';
    }
  }

  static T _pickBySeed<T>(
    List<T> list, {
    required int seed,
    required int salt,
  }) {
    if (list.isEmpty) {
      throw StateError('Seçim listesi boş olamaz.');
    }
    final index = (seed + (salt * 9973)) % list.length;
    return list[index];
  }

  static String _normalizeSign(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      return 'Koç';
    }
    return _signAliases[value] ?? value;
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
    return _toTurkishUpper(first[0]) + first.substring(1);
  }

  static int _seedFrom(String input) {
    var hash = 2166136261;
    for (final codeUnit in input.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 16777619) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }

  static String _capitalizeSentenceStarts(String text) {
    if (text.isEmpty) {
      return text;
    }

    final chars = text.split('');
    final output = <String>[];
    var shouldCapitalize = true;

    for (final char in chars) {
      if (shouldCapitalize && _isLetter(char)) {
        output.add(_toTurkishUpper(char));
        shouldCapitalize = false;
        continue;
      }

      output.add(char);
      if (char == '.') {
        shouldCapitalize = true;
      } else if (_isLetter(char)) {
        shouldCapitalize = false;
      }
    }

    return output.join();
  }

  static bool _isLetter(String char) {
    return RegExp(r'[A-Za-zÇĞİIÖŞÜçğıiöşü]').hasMatch(char);
  }

  static String _toTurkishUpper(String char) {
    switch (char) {
      case 'i':
        return 'İ';
      case 'ı':
        return 'I';
      case 'ç':
        return 'Ç';
      case 'ğ':
        return 'Ğ';
      case 'ö':
        return 'Ö';
      case 'ş':
        return 'Ş';
      case 'ü':
        return 'Ü';
      default:
        return char.toUpperCase();
    }
  }
}

class _SignLexicon {
  const _SignLexicon({
    required this.traits,
    required this.gifts,
    required this.focusAreas,
    required this.balanceTips,
    required this.generalTrends,
    required this.opportunities,
    required this.cautions,
  });

  final List<String> traits;
  final List<String> gifts;
  final List<String> focusAreas;
  final List<String> balanceTips;
  final List<String> generalTrends;
  final List<String> opportunities;
  final List<String> cautions;
}

const _periodLeads = <HoroscopePeriod, List<String>>{
  HoroscopePeriod.weekly: [
    '{name}, bu hafta {sign} tarafında {trait} etkisi yükselirken {gift} kapısı açılıyor.',
    'Bu hafta {name}, {sign} enerjinde {trait} tonu belirgin; {gift} alanı hız kazanıyor.',
    '{name}, haftanın gökyüzü {sign} için {trait} bir akış sunuyor ve {gift} şansını artırıyor.',
  ],
  HoroscopePeriod.monthly: [
    '{name}, bu ay {sign} frekansında {trait} bir yükseliş var; {gift} alanın güçleniyor.',
    'Aylık döngüde {name}, {sign} enerjinde {trait} yaklaşımın {gift} fırsatını büyütüyor.',
    '{name}, bu ay {sign} tarafında {trait} kalmak {gift} sonuçları getiriyor.',
  ],
  HoroscopePeriod.yearly: [
    '{name}, bu yıl {sign} etkisinde {trait} duruşun {gift} yolculuğunu genişletiyor.',
    'Yıllık akışta {name}, {sign} enerjinde {trait} tavrınla {gift} alanı destekleniyor.',
    '{name}, bu yıl {sign} hattında {trait} bir ilerleme seni {gift} noktasına taşıyor.',
  ],
};

const _generalLeads = <HoroscopePeriod, List<String>>{
  HoroscopePeriod.weekly: [
    'Bu haftanın genel gökyüzünde',
    'Haftalık genel etkilerde',
    'Bu hafta burç genelinde',
  ],
  HoroscopePeriod.monthly: [
    'Bu ayın genel gökyüzünde',
    'Aylık genel etkilerde',
    'Bu ay burç genelinde',
  ],
  HoroscopePeriod.yearly: [
    'Bu yılın genel gökyüzünde',
    'Yıllık genel etkilerde',
    'Bu yıl burç genelinde',
  ],
};

const _actions = [
  'önceliklerini üç başlıkta netleştir',
  'tek bir hedefe odaklanıp adımlarını sadeleştir',
  'iletişimde açık ve kısa cümlelerle ilerle',
  'yarım kalan bir işi tamamlayarak ivme kazan',
  'duygusal yükünü not alıp zihnini hafiflet',
  'kararlarını acele etmeden ama kararlılıkla uygula',
  'üretim ritmini küçük ama istikrarlı adımlarla koru',
  'kişisel sınırlarını nazik ama net biçimde ifade et',
];

const _personalClosers = [
  'Ritmini korudukça akış senden yana hızlanır.',
  'Sakin güçle ilerlediğinde sonuçlar daha görünür olur.',
  'Kendine sadık kaldığında doğru kapılar zamanında açılır.',
  'Dengeyi koruduğunda haftanın enerjisi seni destekler.',
  'Netlik ve istikrar bu dönemde en büyük avantajın olur.',
  'Küçük ama tamamlanan adımlar büyük fark yaratır.',
];

const _personalPeriodPulseFrames = <HoroscopePeriod, List<String>>{
  HoroscopePeriod.weekly: [
    'Bu haftalık akışta {sign} vurgusu, özellikle {focus} başlığında hızlı başlayan ama dikkatli sürdürülmesi gereken bir ivme taşıyor.',
    'Haftanın kozmik ritmi {sign} tarafında dalga dalga çalışıyor; bu nedenle {focus} alanında sabit bir planla ilerlemek daha güçlü sonuç verir.',
    'Bu hafta {sign} enerjisi dışarıdan yoğun görünse de asıl kazanç, {focus} alanında stratejik ve ölçülü kalabilenlerde toplanıyor.',
    'Haftalık döngü {sign} için görünür kararlar getiriyor; {focus} tarafında acele yerine ardışık adımlar bu etkinin kalıcılığını artırır.',
    'Bu hafta {sign} hattında gündem hızlanırken, {focus} alanında seçici davrananlar için net bir toparlanma potansiyeli oluşuyor.',
  ],
  HoroscopePeriod.monthly: [
    'Aylık düzlemde {sign} etkisi, {focus} alanında birikimli ilerleme fırsatı veriyor; ayın başındaki niyet, ay sonu sonuçlarını doğrudan belirliyor.',
    'Bu ay {sign} frekansı daha derin ve uzun soluklu çalıştığı için {focus} başlığında kurulan düzen, sonraki döneme güçlü bir zemin bırakıyor.',
    'Aylık enerjide {sign} tonu, {focus} tarafında hem sadeleşme hem de güçlenme çağrısı yapıyor; öncelik sırası doğru kurulduğunda ivme artıyor.',
    'Bu ayın kozmik temposu {sign} için iniş-çıkışlı değil, katmanlı bir büyüme sunuyor; {focus} alanında devamlılık en kritik anahtar oluyor.',
    'Aylık döngü boyunca {sign} etkisi, {focus} hattında dağınık işleri toparlama ve daha verimli bir sistem kurma imkanı sağlıyor.',
  ],
  HoroscopePeriod.yearly: [
    'Yıllık akışta {sign} vurgusu, {focus} alanında sadece kısa vadeli değil, uzun vadeli bir yön inşasını da gündeme getiriyor.',
    'Bu yıl {sign} frekansı dönemsel dalgalanmalara rağmen {focus} başlığında kalıcı kararlar alma potansiyelini yükseltiyor.',
    'Yıllık gökyüzü {sign} için köklü bir güncelleme etkisi taşıyor; {focus} tarafında atılan bilinçli adımlar yılın ikinci yarısında daha görünür hale geliyor.',
    'Bu yıl {sign} enerjisi, {focus} hattında eski alışkanlıkları geride bırakıp daha olgun bir stratejiyle ilerleme fırsatı veriyor.',
    'Yıllık düzlemde {sign} etkisi güçlü; {focus} alanında kurulan yapı, yalnızca bugünü değil gelecek dönemleri de destekleyecek nitelik kazanıyor.',
  ],
};

const _personalInnerThemeFrames = [
  'İç dünyanda {trait} yaklaşımın güçlendikçe, {gift} kapasitenin daha görünür bir biçimde açıldığını fark edebilirsin.',
  'Bu dönemde duygusal ve zihinsel merkezini koruman, {trait} tavrını sağlamlaştırır ve {gift} potansiyelini somutlaştırır.',
  'Kendi iç sesinle kurduğun temas derinleştikçe, {trait} yönün doğal biçimde güçlenir; bunun sonucu olarak {gift} alanında net bir ilerleme oluşur.',
  'İçsel dengeyi koruduğunda {trait} tarafın daha dengeli çalışır ve {gift} başlığında dağınık görünen parçalar anlamlı bir bütüne dönüşür.',
  '{trait} kalabilmek bu dönemin en değerli kası; bu kas güçlendikçe {gift} alanındaki fırsatları daha erken fark etmeye başlarsın.',
  'Duygularını bastırmadan yönetmek, {trait} yaklaşımını olgunlaştırır ve {gift} yönünde daha güvenli adımlar atmanı kolaylaştırır.',
  '{trait} duruşun bugünlerde yalnızca bir karakter özelliği değil, {gift} yolculuğunu besleyen gerçek bir strateji haline geliyor.',
];

const _personalWorkFlowFrames = [
  'İş ve üretim tarafında {focus} gündemini parçalara bölerek ilerlersen, {gift} etkisi daha ölçülebilir ve sürdürülebilir hale gelir.',
  '{focus} alanında atacağın küçük ama düzenli adımlar, {gift} başlığında kısa sürede fark edilen bir düzenlenme yaratır.',
  'Günlük planını sade tutup {focus} tarafında net sınırlar oluşturduğunda, {gift} kapasiten gürültüden arınmış şekilde çalışır.',
  'Özellikle üretim ritminde {focus} noktasına dönen bir disiplin, {gift} etkisini hızdan çok kalite üzerinden büyütür.',
  '{focus} alanında önceliklerini yazılı hale getirmen, {gift} enerjisini dağılmadan tek bir hatta toplamana yardım eder.',
  'Çalışma düzeninde {focus} başlığını merkezde tutmak, {gift} konusunda dış koşullardan bağımsız bir istikrar sağlar.',
  'Verim açısından bu dönemde {focus} alanında tamamlanan her küçük parça, {gift} tarafında birikimli bir güç yaratır.',
];

const _personalRelationFlowFrames = [
  'İlişkilerde {trait} bir dil kullanman, yanlış anlaşılmaları azaltırken duygusal güveni belirgin biçimde artırır.',
  'Yakın çevreyle kurduğun iletişimde {trait} kalabildiğinde, karşılıklı beklentiler daha net bir zeminde buluşur.',
  'Bu süreçte ilişki dinamiklerinde {trait} yaklaşım, gerilimleri yumuşatır ve ortak karar almayı kolaylaştırır.',
  'Duygusal bağlarda {trait} bir tavır, hem sınırlarını korumana hem de sıcaklığı kaybetmeden ilerlemene imkan verir.',
  'İletişimde {trait} bir duruş sergilediğinde, hem kendini daha doğru ifade eder hem de karşı tarafın ihtiyacını daha net duyarsın.',
  '{trait} yaklaşımın sosyal çevrende güven alanı oluşturur; bu da destek istemeyi ve destek vermeyi daha doğal hale getirir.',
  'Özellikle hassas konularda {trait} bir ton seçmek, tartışmayı uzatmak yerine çözüm kanalını açar.',
];

const _personalFinanceFlowFrames = [
  'Kaynak yönetiminde sade ve planlı kaldığında, {gift} etkisi harcama-karar dengesinde daha sağlıklı bir tabloya dönüşür.',
  'Maddi alanda acele karar yerine kontrollü adımlar seçmek, {gift} potansiyelini daha güvenli bir zeminde büyütür.',
  'Gelir-gider dengesini haftalık kontrol etmek, {gift} tarafındaki fırsatları daha erken görmene yardımcı olur.',
  'Finansal konularda net sınırlar koyduğunda, {gift} enerjisi yalnızca kazanımda değil, korumada da güçlü çalışır.',
  'Bu dönemde bütçeyi şeffaf takip etmek, {gift} başlığında zihinsel rahatlık ve daha az belirsizlik sağlar.',
  'Kaynaklarını öncelik sırasına göre kullanman, {gift} etkisini geçici değil kalıcı bir avantaja çevirir.',
  'Maddi düzeni yazılı planla desteklemek, {gift} sürecinde duygusal dalgalanmaların kararlarını etkilemesini azaltır.',
];

const _personalTimingAdviceFrames = <HoroscopePeriod, List<String>>{
  HoroscopePeriod.weekly: [
    'Haftanın ilk yarısında temel kararlarını netleştirip ikinci yarıda uygulamaya geçmek, ritmini daha verimli kullanmanı sağlar.',
    'Bu hafta özellikle gün ortası saatlerinde odak gerektiren işleri toplamak, zihinsel dağılmayı belirgin biçimde azaltır.',
    'Haftalık planda ilk iki gün hazırlık, sonraki günler uygulama dengesi kurmak sonuçlarını hızlandırır.',
    'Hafta boyunca tek seferde büyük sıçrama aramak yerine günlük ilerleme mantığıyla gitmek daha güçlü bir akış yaratır.',
    'Bu haftanın zamanlamasında kısa kontrol araları eklemek, hata birikimini önleyerek seni daha rahat bir ritimde tutar.',
  ],
  HoroscopePeriod.monthly: [
    'Ayın ilk bölümünde strateji kurup ikinci bölümünde çıktı almaya odaklanman, aylık döngünün gücünü en verimli biçimde kullanır.',
    'Bu ay zaman yönetiminde haftalık mini hedefler belirlemek, uzun vadeli niyetini günlük hayata daha kolay indirir.',
    'Aylık tempoda gereksiz iş yüklerini erken elemek, ay ortasında oluşabilecek zihinsel yorgunluğu belirgin biçimde azaltır.',
    'Bu ayın zamanlamasında düzenli gözden geçirme noktaları oluşturmak, karar kalitesini ay sonuna kadar yüksek tutar.',
    'Ay boyunca ritmini korumak için üretim ve dinlenme bloklarını baştan planlamak, sürdürülebilir verim sağlar.',
  ],
  HoroscopePeriod.yearly: [
    'Yıllık ölçekte çeyrek dönem hedefleri kurmak, büyük resmi kaybetmeden uygulanabilir bir rota oluşturmanı kolaylaştırır.',
    'Bu yılın zamanlamasında dönem başlarında plan güncellemesi yapmak, değişen koşullara uyumu güçlendirir.',
    'Yıllık akışta her ayın sonunda kısa değerlendirme yapmak, rotayı erken düzeltmene ve gereksiz yıpranmayı azaltmana yardım eder.',
    'Bu yıl uzun hedefleri aylık parçalara ayırmak, motivasyonu canlı tutarken performansı da ölçülebilir hale getirir.',
    'Yıllık ritimde stratejik sabırla ilerlemek, geç gelen ama daha kalıcı sonuçların temelini oluşturur.',
  ],
};

const _personalEnergyAdviceFrames = [
  'Enerji yönetiminde {balance} yaklaşımını sürdürdüğünde hem duygusal hem zihinsel kapasiten daha dengeli çalışır.',
  'Ritmini korumak için {balance} tarafını günlük rutine bağlaman, dönem boyunca istikrarını güçlendirir.',
  'Yüksek performans için yalnızca hız değil, {balance} prensibini korumak da en az eylem kadar kritiktir.',
  'Bu dönemde sürdürülebilir ilerleme için {balance} alışkanlığını küçük ama düzenli adımlarla beslemek önemlidir.',
  'Kendi merkezinde kalabilmek adına {balance} yaklaşımını özellikle yoğun günlerde daha görünür şekilde uygulaman faydalı olur.',
  'Duygusal taşmaları azaltmanın en pratik yolu, {balance} çizgisini gün içinde birkaç kısa kontrolle canlı tutmaktır.',
];

const _personalLongClosers = [
  'Sonuç olarak bu dönem, hız ile bilinci birlikte taşıdığında seni yalnızca kısa vadeli kazanıma değil, daha olgun ve kalıcı bir dönüşüme götürebilir.',
  'Özetle bu gökyüzü akışı, kendini doğru yerde konumlandırdığında iç huzur, verim ve ilişki kalitesini aynı anda büyütebilecek güçlü bir potansiyel taşıyor.',
  'Bu nedenle adımlarını sade tutup niyetini netleştirdiğinde, dönem sonunda geriye dönüp baktığında belirgin bir olgunlaşma ve güçlenme hissi yaşayabilirsin.',
  'Uzun vadede bu yaklaşım, yalnızca bugünün dengesini değil, gelecekteki karar kaliteni de yükselterek sana daha sağlam bir kişisel rota kazandırır.',
  'Bütün bu etkiler bir araya geldiğinde, kendi ritmine sadık kaldığın ölçüde hem içsel hem somut alanda daha güçlü bir yapı kurman mümkün görünüyor.',
];

const _generalClosers = [
  'Planlı ilerlemek bu dönemde verimi artırır.',
  'Dengeyi koruyanlar için fırsatlar daha görünür olur.',
  'Acele yerine netlik seçmek bu periyotta daha kazançlıdır.',
  'Öncelik sırasını korumak burç enerjisini daha verimli kullanmanızı sağlar.',
];

const _generalPeriodContextFrames = <HoroscopePeriod, List<String>>{
  HoroscopePeriod.weekly: [
    'Haftalık düzlemde {sign} tarafında hızlı değişen gündemler görülebilir; bu nedenle karar alırken veri ve sezgiyi birlikte çalıştırmak önemli olur.',
    'Bu haftanın genel etkileri {sign} burcunda özellikle iletişim, tempo ve öncelik yönetimi başlıklarını daha görünür hale getiriyor.',
    'Haftalık akışta {sign} için dış koşullar hızlanırken, iç dengede kalabilenlerin daha istikrarlı sonuç aldığı bir tablo oluşuyor.',
    'Bu hafta {sign} genelinde aynı anda birden fazla alanda hareketlilik var; sade plan yapanlar bu yoğunluğu daha rahat yönetebilir.',
    'Haftalık gökyüzünde {sign} etkisi kısa vadeli kararları öne taşıyor; ancak kalıcılık için adımların sıralı ilerlemesi gerekiyor.',
  ],
  HoroscopePeriod.monthly: [
    'Aylık görünümde {sign} burcu için ana tema, dağınık başlıkları toparlayıp daha net bir yön haritası kurmak olarak öne çıkıyor.',
    'Bu ay {sign} genelinde birikimli ilerleme etkisi var; sabit ve tutarlı ritim, ay sonuna doğru somut sonuçları artırabilir.',
    'Aylık döngüde {sign} tarafında iç-dış denge başlığı kritikleşiyor; sorumluluk dağılımını net yapmak verimi yükseltir.',
    'Bu ayın genel akışında {sign} için strateji güncellemesi ihtiyacı belirgin; eski yöntemleri sadeleştirmek kazanç sağlayabilir.',
    'Aylık etkiler {sign} burcunda özellikle plan disiplini isteyen bir zemin oluşturuyor; ölçülü ilerleme uzun vadeli rahatlık sunar.',
  ],
  HoroscopePeriod.yearly: [
    'Yıllık gökyüzünde {sign} burcunun ana ekseni, dönemsel iniş çıkışları yönetirken uzun vadeli hedef yapısını güçlendirmek olarak beliriyor.',
    'Bu yıl {sign} genelinde temel konu, eski alışkanlıklarla yeni hedefler arasında daha bilinçli bir denge kurmak olarak öne çıkıyor.',
    'Yıllık ölçekte {sign} için plan, sabır ve uygulama dengesini koruyanlar daha kalıcı bir ilerleme deneyimi yaşayabilir.',
    'Bu yılın genel enerjisi {sign} burcunda özellikle yön netliği isteyen bir atmosfer yaratıyor; dağılmadan ilerleyenler daha güçlü sonuç alır.',
    'Yıllık akışta {sign} tarafında yapılandırma ve sadeleşme birlikte çalışıyor; bu kombinasyon uzun soluklu verimi destekliyor.',
  ],
};

const _generalOpportunityFrames = [
  '{opportunity} tarafında atılan bilinçli adımlar, genel akışın destekleyici yönünü görünür hale getirebilir.',
  '{opportunity} alanında sade ama istikrarlı hamleler, dönem boyunca birikimli bir güç oluşturabilir.',
  '{opportunity} başlığında kurulan net plan, dağınık görünen süreci daha ölçülebilir bir ilerlemeye çevirebilir.',
  '{opportunity} odağında iletişimi açık tutmak, fırsatların doğru zamanda fark edilmesini kolaylaştırabilir.',
  '{opportunity} hattında gereksiz yükleri azaltmak, enerjinin daha verimli kullanılmasına katkı sağlayabilir.',
  '{opportunity} alanında kısa vadeli hamleleri uzun vadeli hedefle eşleştirmek daha sağlam sonuçlar getirebilir.',
  '{opportunity} tarafında karar kalitesini artırmak için veri ve sezgiyi birlikte değerlendirmek faydalı olur.',
];

const _generalRiskFrames = [
  'Öte yandan {caution}; bu başlıkta erken farkındalık geliştirmek dönem sonu baskıyı belirgin biçimde azaltır.',
  'Bu tabloda dikkat edilmesi gereken nokta {caution}; küçük düzeltmelerin etkisi düşündüğünüzden daha büyük olabilir.',
  'Genel akışta risk tarafında {caution}; bu nedenle tempo kadar dengeyi de korumak gerekir.',
  'Bu dönemde {caution}; karar süreçlerinde kısa bir kontrol molası, olası hataları azaltmada oldukça etkilidir.',
  'Kritik hassasiyet alanı {caution}; özellikle yoğun günlerde bu uyarıyı görünür tutmak fayda sağlar.',
  'Genel uyarı hattında {caution}; plansız hız yerine kademeli ilerleme daha güvenli bir sonuç üretir.',
];

const _generalStrategyFrames = [
  '{trend} etkisini doğru kullanmak için öncelik listesi oluşturup adımları sırayla tamamlamak en işlevsel yaklaşım olur.',
  '{trend} döneminde kararları tek merkezde toplamak ve dağılmayı azaltmak, performansı belirgin şekilde iyileştirir.',
  '{trend} akışında iletişim netliği ve görev paylaşımı, özellikle ekipli süreçlerde hata oranını düşürür.',
  '{trend} vurgusunda günlük ritmi sabit tutmak, ani dalgalanmaların etkisini yumuşatır.',
  '{trend} döneminde önce sadeleşme sonra hız prensibi, sürdürülebilir sonuç almak için güçlü bir çerçeve sunar.',
  '{trend} etkisinde kısa değerlendirme döngüleri kurmak, stratejiyi zamanında güncellemenizi kolaylaştırır.',
];

const _generalTimingFrames = <HoroscopePeriod, List<String>>{
  HoroscopePeriod.weekly: [
    'Haftalık zamanlamada ilk günlerde niyeti netleştirip sonraki günlerde uygulamaya geçmek daha dengeli bir sonuç verir.',
    'Bu haftada kısa aralıklarla yapılan plan kontrolü, hızlanan gündemde yön kaybını azaltır.',
    'Haftalık döngüde sabah bloklarını öncelikli işlere ayırmak, günün kalanında daha rahat bir akış sağlayabilir.',
    'Hafta ortasında yapılacak küçük bir plan güncellemesi, son günlerde biriken baskıyı azaltabilir.',
    'Bu hafta zaman yönetiminde tek hedef odaklı bloklar oluşturmak, verim kalitesini yukarı taşır.',
  ],
  HoroscopePeriod.monthly: [
    'Aylık zamanlamada haftalık alt hedefler belirlemek, büyük planın uygulanabilirliğini artırır.',
    'Ayın başında kurulan düzenin ay ortasında gözden geçirilmesi, yönü korumak için önemli bir avantaj yaratır.',
    'Bu ay periyodik değerlendirme noktaları eklemek, yanlış giden başlıkları erken düzeltmeye imkan tanır.',
    'Aylık döngüde ilk yarıda hazırlık, ikinci yarıda çıktı odaklı ilerlemek daha dengeli bir sonuç üretebilir.',
    'Bu ayın ritminde plan ve dinlenme bloklarını baştan tasarlamak, sürdürülebilir performansı destekler.',
  ],
  HoroscopePeriod.yearly: [
    'Yıllık perspektifte hedefleri çeyrek dönemlere bölmek, büyük resmi kaybetmeden ilerlemeyi kolaylaştırır.',
    'Yıl içinde düzenli kontrol noktaları tanımlamak, değişen koşullara karşı stratejik esnekliği artırır.',
    'Yıllık akışta aylık mini değerlendirmeler yapmak, hem motivasyonu hem karar kalitesini yüksek tutar.',
    'Bu yıl uzun vadeli planları kısa uygulama adımlarına çevirmek, süreç yönetimini daha gerçekçi hale getirir.',
    'Yıllık zamanlamada dönem başı ve dönem sonu karşılaştırmaları, öğrenme hızını ve rota netliğini güçlendirir.',
  ],
};

const _generalCollectiveAdviceFrames = [
  'Kolektif düzlemde sadeleşme, net iletişim ve dengeli tempo ilkeleri bu dönemin en güvenli üç dayanağı olarak öne çıkıyor.',
  'Genel atmosferde kalıcı sonuç almak isteyenler için acele yerine plan, dağınıklık yerine odak ve tepki yerine bilinçli seçimler daha avantajlı görünüyor.',
  'Bu süreçte hem bireysel hem ortak çalışmalarda ritim disiplini korunursa, ortaya çıkan verim yalnızca kısa vadeli olmayacaktır.',
  'Kolektif enerji, küçük ama tamamlanan adımları büyük niyetlerden daha fazla ödüllendiriyor; bu yaklaşım dönemi daha verimli kılabilir.',
  'Genel akış, dengeli kalanları destekleyen bir yapı taşıyor; bu nedenle zihinsel hijyen ve görev netliği kritik önem taşıyor.',
  'Bu dönemde tutarlılık ve şeffaflık ilkesi güçlendikçe, hem ilişkilerde hem iş akışında gereksiz sürtünmeler azalabilir.',
];

const _generalLongClosers = [
  'Sonuç olarak bu periyot, doğru planlandığında yalnızca geçici bir rahatlama değil, gelecek döneme taşınabilecek daha olgun bir denge üretme potansiyeli taşıyor.',
  'Özetle burç genelinde ortaya çıkan tablo, disiplinli ama esnek bir yaklaşım benimseyenler için hem iç huzuru hem somut ilerlemeyi birlikte destekliyor.',
  'Genel çerçevede bakıldığında bu etkiler, kısa vadeli kararların uzun vadeli sonuçlarını daha görünür hale getirerek bilinçli adım atmayı ödüllendiriyor.',
  'Bu dönemin ana mesajı, hız ile netliği dengede tutabilenlerin daha kalıcı ve daha güvenli bir gelişim hattı kurabileceği yönünde güçleniyor.',
  'Bütün bu göstergeler bir araya geldiğinde, ölçülü ilerleme ve düzenli değerlendirme alışkanlığının dönem sonunda belirgin bir kalite artışı sağlayacağı görülüyor.',
];

const _defaultLexicon = _SignLexicon(
  traits: ['dengeli', 'kararlı', 'esnek', 'bilinçli'],
  gifts: ['netleşme', 'ilerleme', 'uyum', 'güçlenme'],
  focusAreas: ['iş ve üretim', 'iletişim', 'ilişkiler', 'kişisel düzen'],
  balanceTips: [
    'mola ve üretim dengesini korumak',
    'tek hedefte kalmak',
    'duyguyu bastırmadan ifade etmek',
    'gereksiz yükleri sadeleştirmek',
  ],
  generalTrends: ['denge', 'odak', 'sadeleşme', 'kararlılık'],
  opportunities: ['iş', 'iletişim', 'ilişkiler', 'planlama'],
  cautions: [
    'gereksiz dağılmayı azaltmak önemli',
    'aşırı hız yerine istikrar tercih edilmeli',
    'duygusal tepkilerde ölçü korumak faydalı',
    'detaylarda kaybolmadan büyük resmi görmek gerekli',
  ],
);

const _signAliases = {
  'Koc': 'Koç',
  'Boga': 'Boğa',
  'Ikizler': 'İkizler',
  'Yengec': 'Yengeç',
  'Basak': 'Başak',
  'Oglak': 'Oğlak',
  'Balik': 'Balık',
};

const _signLexicon = <String, _SignLexicon>{
  'Koç': _SignLexicon(
    traits: ['atak', 'öncü', 'cesur', 'hızlı'],
    gifts: ['başlatma', 'liderlik', 'karar netliği', 'girişim'],
    focusAreas: [
      'kariyer adımları',
      'kişisel hedefler',
      'spor ve enerji yönetimi',
      'rekabet içeren işler',
    ],
    balanceTips: [
      'hızını stratejiyle dengelemek',
      'ani çıkışlarda nefes arası vermek',
      'tek hedefte odaklanmak',
      'sabır kasını bilinçli kullanmak',
    ],
    generalTrends: ['hareket', 'başlangıç', 'cesaret', 'ataklık'],
    opportunities: [
      'yeni projeler',
      'hızlı karar gerektiren işler',
      'liderlik alanları',
      'kişisel görünürlük',
    ],
    cautions: [
      'aceleci çıkışları yumuşatmak gerekli',
      'çatışma dilinden kaçınmak faydalı',
      'enerjiyi tek hedefte toplamak önemli',
      'sabırsızlığa karşı plan disiplini korunmalı',
    ],
  ),
  'Boğa': _SignLexicon(
    traits: ['istikrarlı', 'sabırlı', 'dayanıklı', 'topraklı'],
    gifts: [
      'kalıcı sonuç',
      'maddi düzen',
      'güven inşası',
      'sürdürülebilir verim',
    ],
    focusAreas: [
      'para yönetimi',
      'ev ve yaşam düzeni',
      'uzun vadeli projeler',
      'bedensel bakım',
    ],
    balanceTips: [
      'esnekliğe alan açmak',
      'konforda fazla kalmamak',
      'değişime küçük adımlarla uyumlanmak',
      'değer odaklı seçimleri netleştirmek',
    ],
    generalTrends: ['istikrar', 'güven', 'somutlaşma', 'sabır'],
    opportunities: [
      'finans planı',
      'kalıcı iş düzeni',
      'kaynak biriktirme',
      'ev odaklı gelişmeler',
    ],
    cautions: [
      'inat yerine esneklik kazanç sağlar',
      'değişimi ertelememek önemli',
      'aşırı konfor alanından çıkmak faydalı',
      'duygusal yeme veya harcamada ölçü korunmalı',
    ],
  ),
  'İkizler': _SignLexicon(
    traits: ['meraklı', 'hızlı düşünen', 'iletişimci', 'çevik'],
    gifts: ['bağlantı kurma', 'öğrenme', 'ifade gücü', 'fikir üretimi'],
    focusAreas: [
      'iletişim projeleri',
      'eğitim',
      'sosyal çevre',
      'yazılı işler',
    ],
    balanceTips: [
      'dağılmayı azaltıp öncelik belirlemek',
      'tek işi tamamlayıp diğerine geçmek',
      'zihinsel molalarla netliği korumak',
      'dedikodu yerine net iletişim seçmek',
    ],
    generalTrends: ['iletişim', 'öğrenme', 'hareketlilik', 'ağ kurma'],
    opportunities: [
      'sunum ve görüşmeler',
      'yeni bağlantılar',
      'kısa eğitimler',
      'fikir paylaşımı',
    ],
    cautions: [
      'dikkat dağınıklığını yönetmek gerekli',
      'çoklu işe dağılmamak önemli',
      'kararsızlığı azaltmak için net hedef şart',
      'iletişimde yüzeysellikten kaçınılmalı',
    ],
  ),
  'Yengeç': _SignLexicon(
    traits: ['şefkatli', 'koruyucu', 'duygusal zekası yüksek', 'sezgisel'],
    gifts: ['aidiyet kurma', 'duygusal derinlik', 'içgörü', 'ilişki şifası'],
    focusAreas: [
      'aile temaları',
      'ev yaşamı',
      'duygusal ilişkiler',
      'içsel denge',
    ],
    balanceTips: [
      'sınırları sevgiyle netleştirmek',
      'geçmişe takılmadan bugüne dönmek',
      'duyguyu yazarak boşaltmak',
      'aşırı hassasiyeti nefesle dengelemek',
    ],
    generalTrends: ['duygu', 'aidiyet', 'koruma', 'içe dönüş'],
    opportunities: [
      'aile bağlarını güçlendirme',
      'ev düzeni',
      'duygusal onarım',
      'yakın ilişkiler',
    ],
    cautions: [
      'alınganlık dozunu yönetmek önemli',
      'duygusal dalgaları bastırmadan ifade etmek gerekli',
      'aşırı geri çekilmeden iletişimde kalınmalı',
      'sınır ihlallerine karşı net duruş faydalı',
    ],
  ),
  'Aslan': _SignLexicon(
    traits: ['yaratıcı', 'görünür', 'özgüvenli', 'coşkulu'],
    gifts: [
      'sahne enerjisi',
      'motivasyon',
      'liderlik sıcaklığı',
      'ilham verme',
    ],
    focusAreas: [
      'yaratıcı üretim',
      'sosyal görünürlük',
      'liderlik rolleri',
      'öz ifade',
    ],
    balanceTips: [
      'takdir beklentisini dengelemek',
      'dinleme payını artırmak',
      'abartıdan kaçınıp ölçüyü korumak',
      'enerjiyi üretime yöneltmek',
    ],
    generalTrends: ['yaratıcılık', 'sahne', 'özgüven', 'ifade'],
    opportunities: [
      'sunumlar',
      'görünür projeler',
      'yaratıcı işler',
      'topluluk yönetimi',
    ],
    cautions: [
      'ego çatışmalarından uzak durmak faydalı',
      'dramayı azaltıp netlikte kalmak önemli',
      'öz güveni kibre dönüştürmemek gerekli',
      'geri bildirimlere açık olmak kazandırır',
    ],
  ),
  'Başak': _SignLexicon(
    traits: ['analitik', 'titiz', 'düzenli', 'işlevsel'],
    gifts: ['iyileştirme', 'sistem kurma', 'kalite artışı', 'detay yönetimi'],
    focusAreas: [
      'iş akışı',
      'rutin düzeni',
      'sağlık alışkanlıkları',
      'planlama',
    ],
    balanceTips: [
      'mükemmeliyet baskısını azaltmak',
      'dinlenme araları eklemek',
      'eleştiriyi çözüm diline çevirmek',
      'büyük resmi gözden kaçırmamak',
    ],
    generalTrends: ['düzen', 'detay', 'analiz', 'iyileştirme'],
    opportunities: [
      'sistem kurma',
      'verim artışı',
      'iş planı',
      'sağlık rutini',
    ],
    cautions: [
      'aşırı eleştiriden kaçınmak önemli',
      'detaylarda kaybolmamak gerekli',
      'esnekliği korumak fayda sağlar',
      'kendine karşı yumuşak dil kullanmak destekleyici olur',
    ],
  ),
  'Terazi': _SignLexicon(
    traits: ['diplomatik', 'uyumlu', 'estetik', 'adil'],
    gifts: ['denge kurma', 'ilişki onarımı', 'ortak akıl', 'zarif iletişim'],
    focusAreas: [
      'ilişkiler',
      'ortaklıklar',
      'estetik projeler',
      'sosyal denge',
    ],
    balanceTips: [
      'kararsızlığı azaltıp net seçim yapmak',
      'kendi ihtiyacını açık ifade etmek',
      'uzlaşırken sınırları korumak',
      'ertelemeyi bırakıp somut adım atmak',
    ],
    generalTrends: ['uyum', 'ilişki', 'estetik', 'denge'],
    opportunities: [
      'ortak projeler',
      'müzakere süreçleri',
      'sosyal bağlar',
      'yaratıcı iş birlikleri',
    ],
    cautions: [
      'herkesi memnun etme çabasını sınırlamak önemli',
      'kararsızlık yerine netlik seçilmeli',
      'ilişkilerde sınırları korumak gerekli',
      'sürekli erteleme verimi düşürebilir',
    ],
  ),
  'Akrep': _SignLexicon(
    traits: ['derin', 'dönüştürücü', 'sezgisel', 'kararlı'],
    gifts: [
      'kriz yönetimi',
      'duygusal güç',
      'stratejik bakış',
      'içsel dönüşüm',
    ],
    focusAreas: [
      'derin ilişkiler',
      'finansal paylaşım',
      'psikolojik dönüşüm',
      'gizli kalan konular',
    ],
    balanceTips: [
      'kontrol ihtiyacını yumuşatmak',
      'güveni adım adım inşa etmek',
      'duyguyu bastırmadan ifade etmek',
      'kin tutmak yerine bırakmayı seçmek',
    ],
    generalTrends: ['dönüşüm', 'derinlik', 'sezgi', 'güç'],
    opportunities: [
      'içsel şifa',
      'finansal plan güncellemesi',
      'stratejik hamleler',
      'derin bağ kurma',
    ],
    cautions: [
      'aşırı kontrol eğilimini azaltmak gerekli',
      'şüpheyi kanıta dayalı yönetmek önemli',
      'duygusal sertlik yerine açıklık faydalı',
      'intikam dili yerine çözüm dili seçilmeli',
    ],
  ),
  'Yay': _SignLexicon(
    traits: ['vizyoner', 'iyimser', 'keşif odaklı', 'özgür ruhlu'],
    gifts: ['büyük resim', 'ilham', 'öğreticilik', 'ufuk genişletme'],
    focusAreas: [
      'eğitim',
      'seyahat planları',
      'uzun vadeli hedefler',
      'inanç sistemi',
    ],
    balanceTips: [
      'abartıyı somut veriyle dengelemek',
      'vizyonu günlük plana indirmek',
      'dağılmadan tek hedefte kalmak',
      'acele kararları gözden geçirmek',
    ],
    generalTrends: ['genişleme', 'vizyon', 'öğrenme', 'hareket'],
    opportunities: [
      'yeni eğitimler',
      'network genişletme',
      'uzun vadeli planlar',
      'ilham verici projeler',
    ],
    cautions: [
      'detayları atlamamak önemli',
      'fazla riskten kaçınmak gerekli',
      'veri olmadan büyük söz vermemek faydalı',
      'tutarlılığı korumak bu dönemde kritik',
    ],
  ),
  'Oğlak': _SignLexicon(
    traits: ['disiplinli', 'sorumlu', 'hedef odaklı', 'dayanıklı'],
    gifts: [
      'yapı kurma',
      'kariyer ilerlemesi',
      'stratejik sabır',
      'somut başarı',
    ],
    focusAreas: [
      'kariyer',
      'uzun vadeli planlar',
      'otorite ilişkileri',
      'sorumluluk yönetimi',
    ],
    balanceTips: [
      'katılığı esneklikle dengelemek',
      'mola vermeyi ihmal etmemek',
      'duyguyu bastırmadan paylaşmak',
      'yükü parçalara bölerek taşımak',
    ],
    generalTrends: ['disiplin', 'sorumluluk', 'hedef', 'inşa'],
    opportunities: [
      'kariyer adımı',
      'yapısal düzenlemeler',
      'uzun vadeli yatırım',
      'otorite ile uyum',
    ],
    cautions: [
      'aşırı yük almamak gerekli',
      'katı tavrı yumuşatmak faydalı',
      'duygusal izolasyondan kaçınmak önemli',
      'mükemmel sonuç beklentisini dengelemek gerekir',
    ],
  ),
  'Kova': _SignLexicon(
    traits: ['yenilikçi', 'özgün', 'bağımsız', 'vizyoner'],
    gifts: [
      'farklı çözüm',
      'topluluk etkisi',
      'gelecek odaklı bakış',
      'teknik zekâ',
    ],
    focusAreas: [
      'ekip projeleri',
      'teknoloji',
      'sosyal ağlar',
      'yenilik geliştirme',
    ],
    balanceTips: [
      'duygusal bağı ihmal etmemek',
      'teoriyi pratiğe bağlamak',
      'isyan enerjisini üretime çevirmek',
      'iletişimde sıcaklığı artırmak',
    ],
    generalTrends: ['yenilik', 'ağ', 'topluluk', 'farklı bakış'],
    opportunities: [
      'teknik projeler',
      'grup çalışmaları',
      'yaratıcı fikir testleri',
      'sosyal etki alanları',
    ],
    cautions: [
      'aşırı mesafeli dilden kaçınmak önemli',
      'teorik kalıp uygulamayı ihmal etmemek gerekli',
      'sabit fikir yerine geri bildirime açık olmak faydalı',
      'duygusal kopukluğu azaltmak ilişkileri güçlendirir',
    ],
  ),
  'Balık': _SignLexicon(
    traits: ['sezgisel', 'empatik', 'yaratıcı', 'akışkan'],
    gifts: ['ilham', 'şefkat', 'sanatsal üretim', 'ruhsal farkındalık'],
    focusAreas: [
      'yaratıcı işler',
      'duygusal iyilik hali',
      'ruhsal pratikler',
      'ilişki şefkati',
    ],
    balanceTips: [
      'sınırları netleştirip enerjiyi korumak',
      'hayali somut plana bağlamak',
      'duygusal yükü yazıyla boşaltmak',
      'gerçeklik kontrolünü düzenli yapmak',
    ],
    generalTrends: ['sezgi', 'ilham', 'duyarlılık', 'akış'],
    opportunities: [
      'sanatsal üretim',
      'duygusal şifa',
      'ruhsal denge',
      'empatik iletişim',
    ],
    cautions: [
      'dağılmayı azaltmak önemli',
      'sınır ihlallerine karşı net durmak gerekli',
      'kaçış eğilimi yerine gerçeklikle temas faydalı',
      'aşırı fedakârlığı dengelemek gerekir',
    ],
  ),
};
