class BiorhythmDailyComment {
  const BiorhythmDailyComment({required this.title, required this.body});

  final String title;
  final String body;
}

class BiorhythmDailyCommentGenerator {
  const BiorhythmDailyCommentGenerator._();

  static int get estimatedVariants =>
      _openers.length *
      _todayTone.length *
      _overallLines.length *
      _physicalLines.length *
      _emotionalLines.length *
      _mentalLines.length *
      _actions.length *
      _closers.length;

  static BiorhythmDailyComment generate({
    required String userKey,
    required DateTime date,
    required int physical,
    required int emotional,
    required int intellectual,
  }) {
    final daySerial =
        DateTime(date.year, date.month, date.day).millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
    final seed = _seedFrom(
      '$userKey|$daySerial|$physical|$emotional|$intellectual',
    );

    final dominant = _dominantCycle(
      physical: physical,
      emotional: emotional,
      intellectual: intellectual,
    );
    final overall = ((physical + emotional + intellectual) / 3).round();

    final title = _pick(_titles, daySerial: daySerial, seed: seed, salt: 3);

    final opener = _pick(_openers, daySerial: daySerial, seed: seed, salt: 5);

    final tone = _pick(
      _todayTone,
      daySerial: daySerial,
      seed: seed,
      salt: 7,
    ).replaceAll('{dominant}', dominant.labelLower);

    final overallLine = _pick(
      _overallLines,
      daySerial: daySerial,
      seed: seed + _stateSalt(overall),
      salt: 9,
    ).replaceAll('{overall}', _signed(overall));

    final physicalLine = _pick(
      _physicalLines,
      daySerial: daySerial,
      seed: seed + _stateSalt(physical),
      salt: 11,
    ).replaceAll('{physical}', _signed(physical));

    final emotionalLine = _pick(
      _emotionalLines,
      daySerial: daySerial,
      seed: seed + _stateSalt(emotional),
      salt: 13,
    ).replaceAll('{emotional}', _signed(emotional));

    final mentalLine = _pick(
      _mentalLines,
      daySerial: daySerial,
      seed: seed + _stateSalt(intellectual),
      salt: 17,
    ).replaceAll('{intellectual}', _signed(intellectual));

    final action = _pick(_actions, daySerial: daySerial, seed: seed, salt: 19);

    final closer = _pick(_closers, daySerial: daySerial, seed: seed, salt: 23);

    final body =
        '$opener $tone $overallLine $physicalLine $emotionalLine $mentalLine $action $closer';

    return BiorhythmDailyComment(title: title, body: body);
  }

  static int _seedFrom(String input) {
    var hash = 2166136261;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 16777619) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }

  static String _pick(
    List<String> list, {
    required int daySerial,
    required int seed,
    required int salt,
  }) {
    final localSeed = (seed + (salt * 7919)) & 0x7fffffff;
    final offset = localSeed % list.length;
    final step = _coprimeStep(list.length, localSeed);
    final index = (offset + (daySerial * step)) % list.length;
    return list[index];
  }

  static int _coprimeStep(int length, int seed) {
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

  static int _stateSalt(int value) {
    if (value >= 35) {
      return 101;
    }
    if (value <= -35) {
      return 197;
    }
    return 151;
  }

  static _Dominant _dominantCycle({
    required int physical,
    required int emotional,
    required int intellectual,
  }) {
    final absPhysical = physical.abs();
    final absEmotional = emotional.abs();
    final absIntellectual = intellectual.abs();

    if (absPhysical >= absEmotional && absPhysical >= absIntellectual) {
      return const _Dominant('Fiziksel', 'fiziksel');
    }
    if (absEmotional >= absPhysical && absEmotional >= absIntellectual) {
      return const _Dominant('Duygusal', 'duygusal');
    }
    return const _Dominant('Zihinsel', 'zihinsel');
  }

  static String _signed(int value) => value >= 0 ? '+$value' : '$value';
}

class _Dominant {
  const _Dominant(this.label, this.labelLower);

  final String label;
  final String labelLower;
}

const _titles = [
  'Biyoritim',
  'Bugünün Biyoritim Notu',
  'Enerji Dengen',
  'Günlük Biyoritim Yorumu',
  'Ritim Analizi',
  'Döngü Özeti',
  'Enerji Haritası',
  'Biyoritim Rehberi',
];

const _openers = [
  'Bugün beden-zihin-duygu hattında hassas ama yönetilebilir bir akış var.',
  'Günün biyoritmi, küçük ayarlarla daha verimli ilerleyebileceğini gösteriyor.',
  'Bugün ritimlerin birbirini dengelediği bir gün; tempo yönetimi önemli.',
  'Enerji eğrilerin bugün net sinyaller veriyor.',
  'Bugün iç ritmini doğru okuduğunda günün kalitesi yükselir.',
  'Biyoritim akışın, güne planlı başlarsan daha iyi sonuç veriyor.',
  'Gün içinde iniş-çıkışlar doğal; doğru zamanlamayla avantaja dönebilir.',
  'Bugün enerji dağılımın farkındalıkla yönetildiğinde güçlü çalışır.',
  'Biyoritim eğrileri bugün sade bir tempo öneriyor.',
  'Bugün kararları, enerjinin en yüksek olduğu saatlere yayman faydalı olur.',
  'Ritimlerin bugünkü dağılımı, acele yerine dengeyi ödüllendiriyor.',
  'Bugün üç döngünün birlikte verdiği mesaj: düzenli ve yumuşak ilerle.',
];

const _todayTone = [
  'Ana vurgu {dominant} alanda görünüyor.',
  'Bugünün ağırlık merkezi {dominant} tarafta.',
  'Günün yönlendirici çizgisi {dominant} ritimde.',
  'Bugün en güçlü sinyal {dominant} döngünden geliyor.',
  '{dominant} eksende aldığın kararlar günün kalitesini belirleyebilir.',
  '{dominant} çizgideki hareketler, diğer iki döngüyü de etkiliyor.',
  'Günün tempo kodu {dominant} kanalda daha belirgin.',
  'Bugün özellikle {dominant} ritmini iyi yönetmek önemli.',
  '{dominant} tarafta kuracağın denge, genel akışı iyileştirir.',
  'Bugün odak noktanı {dominant} alana göre belirlemek iyi olur.',
  '{dominant} eğrideki yön, günlük planına netlik verir.',
  'Bugün {dominant} döngü, zamanlama konusunda ana rehber olabilir.',
];
const _overallLines = [
  'Genel biyoritim ortalaman {overall}; gününü bu ortalamaya göre ölçeklemek verimi artırır.',
  'Toplam enerji ortalaman {overall}; temponu orta-istikrarlı seviyede tutmak iyi olur.',
  'Bugünkü üçlü döngü ortalaman {overall}; dengeli plan en iyi sonucu verir.',
  'Ortalama ritim değerin {overall}; kritik işleri en net hissettiğin saatlere al.',
  'Genel denge puanın {overall}; küçük ama tamamlanan adımlar bugünü güçlendirir.',
  'Bugün ortalama döngü seviyen {overall}; sürdürülebilir tempo seçmek doğru olur.',
  'Enerji ortalaman {overall}; hızdan çok düzen bugünü kazandırır.',
  'Bütünsel ritim ortalaman {overall}; odak dağılımını sadeleştirmen faydalı olur.',
  'Ortalama biyoritim çizgin {overall}; planını üç öncelikle sınırla.',
  'Günlük ortalama enerji değerinde {overall} seviyesindesin; esnek ama net kal.',
  'Genel ritim göstergen {overall}; denge ve süreklilik bugün ana avantajın.',
  'Ortalama akışın {overall}; yüksek beklenti yerine net hedef seçmek iyi gelir.',
];

const _physicalLines = [
  'Fiziksel döngün {physical}; bedensel gücünü kısa ve etkili işlerde kullanman iyi gelebilir.',
  'Fiziksel oran {physical}; temponu gün içine yaymak performansı korur.',
  'Fiziksel çizgide {physical} seviyesindesin; ritmik hareket ve su tüketimi destek olur.',
  'Fiziksel enerji {physical}; ağır yükler yerine planlı adımlar daha verimli olur.',
  'Fiziksel alan {physical}; kısa yürüyüşler ve nefes araları iyi çalışır.',
  'Fiziksel döngü {physical}; bedeni zorlamak yerine ısınma-gevşeme dengesi kur.',
  'Fiziksel eğri {physical}; küçük toparlanma molaları günün kalitesini artırır.',
  'Fiziksel ritim {physical}; bugün beden sinyallerini erken fark etmek avantaj sağlar.',
  'Fiziksel akış {physical}; düzenli tempo, ani dalgalanmaları yumuşatır.',
  'Fiziksel ölçekte {physical}; gücü doğru işe ayırmak daha çok sonuç üretir.',
  'Fiziksel çizgin {physical}; toparlanma ve üretim dengesini koruman önemli.',
  'Fiziksel düzey {physical}; fazla yüklenmeden sürdürülebilir tempo seç.',
];

const _emotionalLines = [
  'Duygusal döngün {emotional}; ilişkilerde sakin ve açık iletişim bugünü kolaylaştırır.',
  'Duygusal oran {emotional}; hassasiyetini net sınırlarla dengelemek rahatlatır.',
  'Duygusal çizgi {emotional}; kendine karşı yumuşak olman günün tonunu iyileştirir.',
  'Duygusal akış {emotional}; kısa içe dönüş molaları iyi gelir.',
  'Duygusal eğri {emotional}; acele tepki yerine nefes aralığı bırakman faydalı olur.',
  'Duygusal ritim {emotional}; paylaşım dozunu doğru ayarlamak denge sağlar.',
  'Duygusal alanda {emotional}; kalp-zihin uyumu için kısa bir sakinleşme iyi çalışır.',
  'Duygusal seviyen {emotional}; beklentileri sadeleştirmek huzur verir.',
  'Duygusal hat {emotional}; kendini ifade ederken net ama nazik kal.',
  'Duygusal ölçekte {emotional}; iç dengen için ekran ve gürültü molası yararlı olur.',
  'Duygusal yönde {emotional}; güven veren temaslar enerjini toparlar.',
  'Duygusal tarafta {emotional}; bugünü küçük memnuniyetlerle güçlendirebilirsin.',
];

const _mentalLines = [
  'Zihinsel döngün {intellectual}; odak blokları kurmak üretkenliği artırır.',
  'Zihinsel oran {intellectual}; tek işi bitirip diğerine geçmek daha verimli olur.',
  'Zihinsel çizgi {intellectual}; bilgi yoğunluğunu sadeleştirmen netlik sağlar.',
  'Zihinsel akış {intellectual}; not alma ve öncelikleme bugün güçlü çalışır.',
  'Zihinsel eğri {intellectual}; kısa düşünme molaları zihni tazeler.',
  'Zihinsel ritim {intellectual}; kritik kararları sakin bir zaman aralığına al.',
  'Zihinsel alanda {intellectual}; analizi somut adımla eşleştirmen önemli.',
  'Zihinsel seviyen {intellectual}; dağınıklığı azaltırsan hızın artar.',
  'Zihinsel hatta {intellectual}; dikkatini tek hedefte tutmak kazandırır.',
  'Zihinsel ölçekte {intellectual}; önce çerçeve, sonra detay yaklaşımı iyi olur.',
  'Zihinsel yönde {intellectual}; gün planını saat bloklarına bölmek yardımcı olur.',
  'Zihinsel tarafta {intellectual}; ekran molası ve kısa yürüyüş denge kurar.',
];

const _actions = [
  'Bugün yapılacaklar listesini üç önceliğe indirmen enerjini korur.',
  'En önemli işi günün ilk yüksek odağında tamamlamaya çalış.',
  'Kısa nefes araları eklemek ritmini dengeler.',
  'Su, hareket ve mola üçlüsünü ihmal etmezsen günün daha akıcı geçer.',
  'Planına küçük bir esneklik payı koymak stresi azaltır.',
  'İletişimde net cümleler kullanmak duygusal yükü hafifletir.',
  'Bugün tek bir tamamlanmış iş, birçok yarım işe göre daha değerlidir.',
  'Zamanı bloklara ayırıp her blok sonunda kısa değerlendirme yap.',
  'Düşük hissettiğin saatlerde rutin işleri, yüksek saatlerde kritik işleri seç.',
  'Kendine karşı daha nazik bir dil kullanmak enerjiyi hızlı toparlar.',
  'Bugün hızlı tepki yerine kısa düşünme aralığı bırakman fayda sağlar.',
  'Aşırı yükü azaltıp temel hedefe dönmek ritmi güçlendirir.',
];

const _closers = [
  'Bugünün anahtarı: dengeyi koruyup istikrarla ilerlemek.',
  'Ritmini izledikçe günün kontrolü sende kalır.',
  'Küçük doğru seçimler, günün sonunda büyük rahatlık getirir.',
  'Enerjini doğru zamanda doğru işe verdiğinde sonuçlar hızlanır.',
  'Bugün sadeleşmek, yarınki performansını da güçlendirir.',
  'Döngünü dinlemek bugün en büyük avantajın olabilir.',
  'İç ritmine uyumlandığında kararların daha net olur.',
  'Bugün tempoyu doğru ayarlamak tüm alanlarda denge yaratır.',
  'Sakin ve kararlı adımlar bugün seni öne taşır.',
  'Ritmini koruduğunda gün daha az yorucu, daha üretken geçer.',
  'Bugün denge kurduğunda zihnin, duygun ve bedenin birlikte çalışır.',
  'Günü kazanmak için hızdan çok doğru zamanlama yeterli olur.',
];
