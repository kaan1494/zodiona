class DailyAffirmationGenerator {
  const DailyAffirmationGenerator._();

  static int get estimatedVariants =>
      _openings.length *
      _intentionLines.length *
      _powerLines.length *
      _actionLines.length *
      _anchorLines.length *
      _closingLines.length *
      _firstSentenceFrames.length *
      _secondSentenceFrames.length *
      _includeSecondSentenceWeights.length;

  static String generate({required String userKey, DateTime? now}) {
    final date = now ?? DateTime.now();
    final daySerial = _daySerial(date);
    final seed = _hash('$userKey|günlük-olumlama-v2');

    final opening = _pickByDay(
      _openings,
      daySerial: daySerial,
      seed: seed,
      salt: 11,
    );
    final intention = _pickByDay(
      _intentionLines,
      daySerial: daySerial,
      seed: seed,
      salt: 23,
    );
    final power = _pickByDay(
      _powerLines,
      daySerial: daySerial,
      seed: seed,
      salt: 37,
    );
    final action = _pickByDay(
      _actionLines,
      daySerial: daySerial,
      seed: seed,
      salt: 53,
    );
    final anchor = _pickByDay(
      _anchorLines,
      daySerial: daySerial,
      seed: seed,
      salt: 71,
    );
    final closing = _pickByDay(
      _closingLines,
      daySerial: daySerial,
      seed: seed,
      salt: 97,
    );
    final includeSecondSentence = _pickByDay(
      _includeSecondSentenceWeights,
      daySerial: daySerial,
      seed: seed,
      salt: 101,
    );
    final firstFrame = _pickByDay(
      _firstSentenceFrames,
      daySerial: daySerial,
      seed: seed,
      salt: 107,
    );
    final secondFrame = _pickByDay(
      _secondSentenceFrames,
      daySerial: daySerial,
      seed: seed,
      salt: 113,
    );

    final firstSentence = firstFrame
        .replaceAll('{opening}', opening)
        .replaceAll('{intention}', intention)
        .replaceAll('{power}', power);

    if (!includeSecondSentence) {
      return _capitalizeSentenceStarts(firstSentence);
    }

    final secondSentence = secondFrame
        .replaceAll('{action}', action)
        .replaceAll('{anchor}', anchor)
        .replaceAll('{closing}', closing);

    final text = '$firstSentence $secondSentence';
    return _capitalizeSentenceStarts(text);
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
      throw StateError('Seçim yapılacak liste boş olamaz.');
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

  static int _hash(String input) {
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

const _openings = [
  'Bugün ışığın sakin ve güçlü',
  'İçindeki denge bugün daha görünür',
  'Kalbinin sesi bugün sana net konuşuyor',
  'Kendine verdiğin değer bugün daha parlak',
  'Bugün adımların güvenle büyüyor',
  'Ruhunun ritmi bugün sana destek oluyor',
  'Bugün kendinle kurduğun bağ şifalı',
  'Hayat bugün sana nazik bir kapı açıyor',
  'Bugün iç sesin ve aklın aynı yönde ilerliyor',
  'Günün enerjisi senden yana akmayı seçiyor',
  'Bugün kalbinin cesareti daha da belirgin',
  'Kendi yoluna duyduğun güven bugün artıyor',
  'Bugün ruhunun dinginliği sana güç veriyor',
  'Hayatın ritmi bugün sana yumuşak bir alan açıyor',
  'Bugün kendi özüne yaklaşman kolaylaşıyor',
  'Zihninin berraklığı bugün daha yüksek',
  'Bugün içindeki umut tazeleniyor',
  'Kendinle kurduğun dostluk bugün derinleşiyor',
  'Bugün niyetlerinin sesi daha net duyuluyor',
  'Yüreğindeki sıcaklık bugün çevrene yayılıyor',
  'Bugün sakinliğin en güçlü tarafın oluyor',
  'Kendi merkezinde kaldıkça günün güzelleşiyor',
  'Bugün içindeki ışık adımlarını aydınlatıyor',
  'Kalbindeki huzur bugün sana yön veriyor',
];

const _intentionLines = [
  'niyetin netleştiğinde fırsatlar sırasıyla görünür',
  'içinde büyüttüğün iyilik hayatına bereket taşır',
  'kalpten seçtiğin her yön sana doğru insanları getirir',
  'sabırla kurduğun her plan sağlam bir temel oluşturur',
  'dengede kaldığında kararların daha kolay olgunlaşır',
  'kendini onayladığında dış dünyanın sesi hafifler',
  'sezgilerinle iş birliği yaptığında yolun açılır',
  'kendine şefkat sunduğunda enerjin yenilenir',
  'sadeleştiğinde gerçek önceliklerin görünür olur',
  'öz değerini hatırladığında sınırların güç kazanır',
  'iç huzurunu korudukça günün ritmi dengelenir',
  'umutla baktığında yeni ihtimaller çoğalır',
  'hayatına kabul ettiğin her güzellik seni büyütür',
  'güvenle ilerlediğinde doğru kapılar zamanında açılır',
  'duygularını duyduğunda zihnin de yumuşar',
  'kendinle barışık kaldığında üretimin artar',
  'kararlılık ve zarafet birlikte hareket ettiğinde akış hızlanır',
  'her adımda kendini seçtiğinde iç gücün köklenir',
  'dengeli bir tempo seni kalıcı başarıya taşır',
  'kendine verdiğin sözleri tuttukça özgüvenin büyür',
  'bugünü bilinçle yaşadığında yarınların sağlamlaşır',
  'şimdiki ana yerleştikçe zihinsel yüklerin azalır',
  'küçük bir iyileşme bile büyük dönüşümün başlangıcıdır',
  'kalbinden geçen doğru niyet seni doğru sonuca götürür',
];

const _powerLines = [
  'şefkatin ve cesaretin aynı anda güçleniyor',
  'sabırla attığın her adım bereket taşıyor',
  'özgüvenin kalpten gelen bir netlik üretiyor',
  'sezgilerin doğru zamanı sakinlikle gösteriyor',
  'iç huzurun kararlarına berraklık katıyor',
  'yaratıcı yanın bugün ilhamı kolayca topluyor',
  'öz saygın sınırlarını sevgiyle netleştiriyor',
  'kararlılığın yolunu dingin bir güçle açıyor',
  'duruşundaki zarafet ilişkilerine güven katıyor',
  'odaklandığın her konu daha hızlı toparlanıyor',
  'içindeki üretkenlik dengeli biçimde artıyor',
  'duygusal olgunluğun doğru cümleleri seçtiriyor',
  'net iletişimin çevrende açıklık yaratıyor',
  'kendine inancın bugün daha sağlam hissediliyor',
  'aklın ve sezgin birlikte çalışarak kolaylık sağlıyor',
  'sakinliğin en zor anı bile yönetilebilir kılıyor',
  'iç disiplinin gününü daha verimli yapılandırıyor',
  'esnekliğin değişen koşullarda seni dengede tutuyor',
  'nazik kararlılığın hedeflerini görünür kılıyor',
  'kendini ifade gücün bugün belirgin biçimde yükseliyor',
  'yumuşak ama net tavrın güven duygusu oluşturuyor',
  'öz farkındalığın doğru seçimleri hızlandırıyor',
  'ruhsal dayanıklılığın seni merkezde tutuyor',
  'topraklı kalman zihnindeki dağınıklığı azaltıyor',
  'içindeki dingin güç adımlarına kalite katıyor',
  'kendine verdiğin alan yaratıcılığını besliyor',
  'bilinçli nefesin bedenine ve zihnine ferahlık veriyor',
  'bugün varlığın bulunduğun ortama huzur yayıyor',
  'kendi ritminde kaldıkça işler kolaylaşıyor',
  'doğru öncelik seçimin zamanını bereketlendiriyor',
  'şimdiye odaklanman kaygıyı azaltıp netliği artırıyor',
  'kalpten gelen motivasyonun sürdürülebilir güç üretiyor',
];

const _actionLines = [
  'kıyas yerine kendi gelişimine odaklan',
  'küçük bir adımı bitir ve emeğini kutla',
  'gereksiz yükleri bırakıp nefesine alan aç',
  'niyetini tek cümleyle yaz ve ona sadık kal',
  'kalbini yoran düşünceyi sevgiyle dönüştür',
  'günün içinde kendine sessiz bir mola ver',
  'bugün bir kişiye içten bir teşekkür gönder',
  'hedefini sadeleştir ve adımını netleştir',
  'günün ilk saatinde en önemli işine kısa bir başlangıç yap',
  'kendine nazik bir cümle kur ve onu gün boyu hatırla',
  'bir konuyu ertelemek yerine beş dakikalık ilerleme yarat',
  'bedenini dinle ve ihtiyaç duyduğun tempoyu seç',
  'aklını meşgul eden konuyu not alıp zihnini hafiflet',
  'önemli bir görüşme öncesi üç derin nefesle merkezlen',
  'bugün bir sınırını sevgiyle ifade et',
  'kendine ait sessiz bir an yaratıp düşüncelerini sadeleştir',
  'tamamladığın küçük işleri görünür kılarak motivasyonunu artır',
  'günün ortasında kısa bir esneme molası ver',
  'enerjini düşüren bir alışkanlığı bugün azalt',
  'içini açan bir müzikle ritmini tazele',
  'yakın çevrenden birine takdirini açıkça paylaş',
  'bir bardak suyla birlikte yeni bir niyet belirle',
  'yapılacaklarını üç maddeye indirip sırayla ilerle',
  'gün sonu için kendine minik bir ödül planla',
  'dijital gürültüyü azaltıp kendine odak süresi tanı',
  'tek bir görevi tamamlama niyetiyle dikkatini toparla',
  'kalbini yumuşatan bir anıyı hatırlayıp şükran duy',
  'kendini eleştirmek yerine gelişimini fark ederek ilerle',
  'yarım kalan işlerinden birine bugün net bir kapanış ver',
  'içinde tuttuğun duyguyu güvenli bir dille paylaş',
  'günün sonunda başardıklarını yazıp kendini onurlandır',
  'bir sonraki adımını tek cümleyle netleştirip harekete geç',
];

const _anchorLines = [
  'Sen yeterli, değerli ve gelişime açık bir insansın',
  'Her yeni gün içindeki gücü yeniden hatırlatır',
  'Sakinlik içinde attığın adımlar en kalıcı sonuçları doğurur',
  'Kendine sadık kaldığında hayat seninle uyumlanır',
  'İçindeki bilgelik doğru anda doğru sözü söyler',
  'Dengen, başarılarının en güvenilir temelidir',
  'Kalpten gelen seçimlerin sana ait yolu görünür kılar',
  'Küçük ilerlemeler büyük dönüşümlerin habercisidir',
  'Nefesin, bedenin ve zihnin için güvenli bir limandır',
  'Yumuşaklık ile kararlılık birlikte büyük güç oluşturur',
  'Işığını saklamadan ilerlemek sana yeni kapılar açar',
  'Bugün kendine verdiğin değer yarının yönünü belirler',
  'Olduğun halinle değerlisin, gelişimin ise sınırsız',
  'Kendi merkezinde kaldığında dış sesler etkisini kaybeder',
  'Şimdiye döndükçe zihnin netleşir ve kalbin genişler',
  'Kendinle dost kaldıkça yaşamınla bağın güçlenir',
];

const _closingLines = [
  'evren seninle uyum içinde akıyor',
  'bugün kendine inandıkça yolun aydınlanıyor',
  'şimdi seçtiğin iyi niyet tüm güne yayılıyor',
  'attığın her bilinçli adım seni hedeflerine yaklaştırıyor',
  'kalbinden geçen iyilik hayatına bereket olarak dönüyor',
  'içindeki ışık sana doğru zamanı göstermeye devam ediyor',
  'sakinliğini korudukça şansın daha görünür oluyor',
  'kendine güvendikçe yeni imkanlar beliriyor',
  'bugünün emeği yarının huzurunu büyütüyor',
  'özgün yolun sana ait başarıları çağırıyor',
  'iç dengeni korudukça dış dünya da düzenleniyor',
  'sen merkezde kaldıkça günün ritmi güzelleşiyor',
];

const _includeSecondSentenceWeights = [true, true, true, false];

const _firstSentenceFrames = ['{opening}, {power}.', '{opening}, {intention}.'];

const _secondSentenceFrames = ['{action}.', '{closing}.', '{anchor}.'];
