/// İki burç arasındaki haftalık ilişki yorumu üretici.
/// Pazartesi–Pazartesi döngüsünde aynı iki burç için tutarlı, sonraki haftada
/// farklı bir yorum gösterir. Varyant sayısı çok yüksek tutulmuştur.
class RelationshipWeeklyComment {
  const RelationshipWeeklyComment({
    required this.title,
    required this.body,
    required this.tip,
  });

  final String title;
  final String body;
  final String tip;
}

class RelationshipWeeklyCommentGenerator {
  const RelationshipWeeklyCommentGenerator._();

  // ---------------------------------------------------------------------------
  // Genel haftalık transit bağlamları
  // ---------------------------------------------------------------------------
  static const _transitContexts = <String>[
    'Bu hafta Venüs geçişleri duyguların yüzeyini ısıtıyor; o ince anlaşmazlıklar yumuşamaya hazır.',
    'Merkür\'ün hızlı dansı bu hafta sözlerin ağırlığını artırıyor; doğru an, doğru kelime her şeyi değiştirebilir.',
    'Ay\'ın bu haftalık döngüsü duygusal dalgalanmaları beraberinde getiriyor; sabır bir kalkan gibi her şeyi koruyacak.',
    'Mars\'ın aktif etkisi bu hafta ilişkiye ekstra enerji katıyor; bu gücü birlikte büyümek için kullanın.',
    'Jüpiter\'in genişletici ışığı bu hafta ilişkiye iyimserlik ve ferahlık serpiyor.',
    'Satürn\'ün olgunlaştırıcı varlığı bu hafta ilişkinin sınırlarını ve taahhütlerini netleştiriyor.',
    'Güneş\'in bu haftaki konumu ilişkideki merkezi dengeyi öne çıkarıyor; kim ne istiyor, şimdi görünür.',
    'Neptün\'ün sisli etkisi bu hafta hayal ile gerçeği birbirine karıştırabilir; net iletişim çıpanız olsun.',
    'Uranüs\'ün ani dalgalanmaları bu hafta ilişkiye beklenmedik bir heyecan ya da sürpriz getirebilir.',
    'Plüton\'un derin dönüşüm enerjisi bu hafta ilişkideki köklü örüntüleri yüzeye taşıyor.',
    'Kiron\'un şifacı transit etkisi bu hafta geçmiş yaraları nazikçe anımsatıyor; birlikte iyileşmek mümkün.',
    'Bu haftaki tam dolunay atmosferi duygusal yoğunluğu zirveye taşıyabilir; tepkiden önce bir nefes alın.',
    'Haftanın yeni ay enerjisi, ilişkide taze bir başlangıç ve yeni bir niyet koymak için eşsiz bir zemin sunuyor.',
    'Bu hafta Venüs–Mars kavuşumu ilişkiye güçlü bir çekim ve tutku dalgası getiriyor.',
    'Merkür retrosu yaklaşırken bu hafta yanlış anlaşılmalara karşı ekstra dikkatli olun; tekrar sorun, varsaymayın.',
  ];

  // ---------------------------------------------------------------------------
  // Burç özellikleri — ilişki bağlamında kısa tanımlayıcılar
  // ---------------------------------------------------------------------------
  static const _signTraits = <String, List<String>>{
    'Koç': [
      'tutkulu ve önce davranan',
      'cesur ve hızlı karar veren',
      'ateşli ve spontane',
      'lider ruhlu ve kararlı',
      'heyecan dolu ve bağımsız',
    ],
    'Boğa': [
      'sadık ve güvenilir',
      'sabırlı ve istikrarlı',
      'duygusal derinliğe sahip',
      'konfor odaklı ve besleyici',
      'sezgisel ve sabırlı',
    ],
    'İkizler': [
      'meraklı ve iletişim dolu',
      'zeki ve esprili',
      'çok yönlü ve uyum sağlayan',
      'hareketli ve sosyal',
      'yaratıcı ve fikir üreten',
    ],
    'Yengeç': [
      'şefkatli ve koruyucu',
      'duygusal bağa önem veren',
      'sezgisel ve empatik',
      'aile odaklı ve içten',
      'besleyici ve bağlı',
    ],
    'Aslan': [
      'cömert ve karizmatik',
      'sadık ve gurur sahibi',
      'yaratıcı ve ilham veren',
      'sıcak kalpli ve koruyucu',
      'lider ve tutku dolu',
    ],
    'Başak': [
      'özenli ve analitik',
      'güvenilir ve pratik',
      'ayrıntılara dikkat eden',
      'şefkatli ve çözüm odaklı',
      'sadık ve yardımsever',
    ],
    'Terazi': [
      'dengeli ve uyum arayan',
      'romantik ve nazik',
      'adalet duygusu güçlü',
      'estetik ve incelikli',
      'ilişkiye özen gösteren',
    ],
    'Akrep': [
      'derin ve yoğun duygular taşıyan',
      'sadık ve dönüştürücü',
      'sezgisel ve gizem dolu',
      'tutkulu ve kararlı',
      'koruyucu ve bağlı',
    ],
    'Yay': [
      'özgür ruhlu ve maceraperest',
      'iyimser ve ilham veren',
      'felsefi ve vizyoner',
      'dürüst ve heyecan dolu',
      'keşifçi ve canlı',
    ],
    'Oğlak': [
      'sorumlu ve kararlı',
      'pratik ve güvenilir',
      'disiplinli ve sabırlı',
      'uzun vadeli düşünen',
      'olgun ve istikrarlı',
    ],
    'Kova': [
      'yenilikçi ve özgün',
      'özgürlük sever ve insancıl',
      'vizyoner ve bağımsız',
      'yaratıcı ve ilginç',
      'dürüst ve farklı düşünen',
    ],
    'Balık': [
      'hayalperest ve empati dolu',
      'sezgisel ve şefkatli',
      'spiritüel ve bağlı',
      'romantik ve idealist',
      'nazik ve besleyici',
    ],
  };

  // ---------------------------------------------------------------------------
  // Uyum temaları — iki burç arasındaki dinamiği tanımlar
  // ---------------------------------------------------------------------------
  static const _compatibilityThemes = <String>[
    'Bu hafta ikinizin farklı hızları, birbirini tamamlayan bir ritme dönüşebilir.',
    'Bu hafta duygusal katmanlar yüzey alıyor; özten konuşmak bağı güçlendirecek.',
    'Bu hafta küçük jest ve sürprizler büyük fark yaratıyor; basit ama anlamlı adımlar atın.',
    'Bu hafta paylaşılan bir hedef ya da plan, ikinizi daha güçlü bir zeminde buluşturur.',
    'Bu hafta dinlemek konuşmaktan daha değerli; partnerinizin sesine yer açın.',
    'Bu hafta özgür alan tanımak ilişkiye nefes aldırır; bireysel zaman kaliteyi artırır.',
    'Bu hafta şükran ifadesi ilişkiye yeni bir ışık yakıyor; minnetinizi söyleyin.',
    'Bu hafta rutini kırmak ilişkiye taze enerji katabilir; beklenmedik bir şey planlayın.',
    'Bu hafta eski bir anlaşmazlığı nazikçe çözmek, ileriye daha hafif yürümenizi sağlar.',
    'Bu hafta güven ve dürüstlük her zamankinden daha yüksek sesle konuşuyor.',
    'Bu hafta ortak bir deneyim yaşamak — küçük olsa bile — bağı derinleştiriyor.',
    'Bu hafta sınırlarınızı sevgiyle ifade etmek ilişkiye saygı ve güvenlik katar.',
    'Bu hafta eğlence ve hafiflik önceliğiniz olsun; gülüşmek her yarayı sarar.',
    'Bu hafta geleceğe dair küçük bir hayal kurmak ikinizi heyecanla birleştirir.',
    'Bu hafta beden diliniz sözcüklerinizden daha çok konuşuyor; dokunuş ve yakınlık önemli.',
    'Bu hafta sabır göstermek, uzun vadede en güçlü sevgi dilidir.',
    'Bu hafta birlikte çözülen bir sorun, ikinize birbirinden daha çok güvenmek için alan açar.',
    'Bu hafta önce anlamaya çalışmak, sonra anlaşılmayı beklemek ilişkiyi ileri taşır.',
    'Bu hafta ortak değerlerinizi hatırlatmak, günlük trafiğin üstüne çıkmanıza yardımcı olur.',
    'Bu hafta yaratıcı bir proje ya da aktivite birlikte vakit geçirmenin en güzel yolu.',
  ];

  // ---------------------------------------------------------------------------
  // Haftalık öneri cümleleri
  // ---------------------------------------------------------------------------
  static const _weeklyTips = <String>[
    'İpucu: Haftada bir "nasılsın" sorusunu gerçekten yanıt bekleyerek sorun.',
    'İpucu: Birlikte yapılan küçük bir ritüel — sabah kahvesi, akşam yürüyüşü — bağı pekiştirir.',
    'İpucu: Eleştirmeden önce bir övgü paylaşmak tartışmaların tonunu yumuşatır.',
    'İpucu: Partnerinizin sevgi dilini bu hafta bilinçli olarak konuşun.',
    'İpucu: "Seni duyuyorum" demek çözümden çok daha güçlü bir bağ kurar.',
    'İpucu: Hatalarınızı hızla kabul etmek güveni inşa eden en kısa yoldur.',
    'İpucu: Bu hafta birlikte yeni bir şey deneyin; ortak anılar birlikte büyür.',
    'İpucu: Söylenmemiş bir teşekkürü bu hafta yüksek sesle ifade edin.',
    'İpucu: Tartışmayı kazanmak mı, ilişkiyi kazanmak mı? Seçim her zaman sizin.',
    'İpucu: Partnerinizin en iyi tarafını bu hafta birine anlatın — ve ona da söyleyin.',
    'İpucu: Geçmişi gündeme taşımak yerine bugüne ve yarına odaklanın.',
    'İpucu: En zor anlarda dahi nazik bir ses tonu ilişkiyi korur.',
    'İpucu: İki dakkkalık sessiz bir sarılma, yüz kelimeden daha fazlasını ifade eder.',
    'İpucu: Partnerinizin bir rüyasını ya da hedefini bu hafta aktif olarak destekleyin.',
    'İpucu: "Ben" yerine "biz" diliyle konuşmak çatışmayı işbirliğine dönüştürür.',
    'İpucu: Sizi birbirinize bağlayan şeyleri listelemek, zor günlerde güçlendirici bir hatırlatma olur.',
    'İpucu: Dijital ekranları bir akşam kapatıp sadece birbirinize zaman ayırın.',
    'İpucu: Partnerinizin duygularını küçümsemeden, büyütmeden, olduğu gibi kabul edin.',
    'İpucu: Özür dilemek zayıflık değil, ilişkiye verilen değerin en güçlü göstergesidir.',
    'İpucu: Bu hafta birlikte güldüğünüz bir an yaratın; neşe bağı yeniler.',
  ];

  // ---------------------------------------------------------------------------
  // Title çerçeveleri
  // ---------------------------------------------------------------------------
  static const _titleFrames = <String>[
    '{a} & {b} — Bu Haftanın Kozmik Tablosu',
    '{a} ile {b} Arasında: Haftalık Enerji Akışı',
    'Bu Hafta {a}–{b} Bağına Yıldızlar Ne Söylüyor?',
    '{a} & {b}: Gökyüzünün Haftalık İlişki Haritası',
    'Haftalık Transit: {a} ile {b} Enerjisi',
    '{a}–{b} Dinamiği: Bu Haftanın Kozmik Mesajı',
    'Yıldızların {a} & {b} İçin Bu Haftaki Sözü',
    '{a} ile {b}: Bu Hafta Birlikte Nereye?',
  ];

  // ---------------------------------------------------------------------------
  // Türkçe hâl ekleri — ünsüz yumuşaması ve ünlü uyumu kurallarına göre
  // Tek heceli ç (Koç, Yay) yumuşamaz.
  // Çok heceli: ç→c (Yengeç), k→ğ (Başak, Oğlak, Balık), p→b (Akrep)
  // Ünlüyle biten kelimeler kaynaştırma ünsüzü 'y'/'n' alır.
  // ---------------------------------------------------------------------------
  static const _genitiveMap = <String, String>{
    'Koç': 'Koçun',        // tek heceli, ç yumuşamaz
    'Boğa': 'Boğanın',    // ünlüyle biter, n kaynaştırma
    'İkizler': 'İkizlerin',
    'Yengeç': 'Yengecin',  // ç→c
    'Aslan': 'Aslanın',
    'Başak': 'Başağın',    // k→ğ
    'Terazi': 'Terazinin', // ünlüyle biter, n kaynaştırma
    'Akrep': 'Akrebin',    // p→b
    'Yay': 'Yayın',        // tek heceli, y yumuşamaz
    'Oğlak': 'Oğlağın',   // k→ğ
    'Kova': 'Kovanın',     // ünlüyle biter, n kaynaştırma
    'Balık': 'Balığın',    // k→ğ
  };

  static const _accusativeMap = <String, String>{
    'Koç': 'Koçu',         // tek heceli, ç yumuşamaz
    'Boğa': 'Boğayı',     // ünlüyle biter, y kaynaştırma
    'İkizler': 'İkizleri',
    'Yengeç': 'Yengeci',   // ç→c
    'Aslan': 'Aslanı',
    'Başak': 'Başağı',     // k→ğ
    'Terazi': 'Teraziyi',  // ünlüyle biter, y kaynaştırma
    'Akrep': 'Akrebi',     // p→b
    'Yay': 'Yayı',         // tek heceli, y yumuşamaz
    'Oğlak': 'Oğlağı',    // k→ğ
    'Kova': 'Kovayı',      // ünlüyle biter, y kaynaştırma
    'Balık': 'Balığı',     // k→ğ
  };

  static const _dativeMap = <String, String>{
    'Koç': 'Koça',         // tek heceli, ç yumuşamaz
    'Boğa': 'Boğaya',     // ünlüyle biter, y kaynaştırma
    'İkizler': 'İkizlere',
    'Yengeç': 'Yengece',   // ç→c
    'Aslan': 'Aslana',
    'Başak': 'Başağa',     // k→ğ
    'Terazi': 'Teraziye',  // ünlüyle biter, y kaynaştırma
    'Akrep': 'Akrebe',     // p→b
    'Yay': 'Yaya',         // tek heceli, y yumuşamaz
    'Oğlak': 'Oğlağa',    // k→ğ
    'Kova': 'Kovaya',      // ünlüyle biter, y kaynaştırma
    'Balık': 'Balığa',     // k→ğ
  };

  // ---------------------------------------------------------------------------
  // Body giriş cümleleri
  //   {a}/{b}      → yalın hâl   (Koç, Yengeç)
  //   {aGen}/{bGen} → tamlayan   (Koç'un, Yengeç'in)
  //   {aAcc}/{bAcc} → belirtme   (Koç'u, Yengeç'i)
  //   {aDat}/{bDat} → yönelme    (Koç'a, Yengeç'e)
  //   {aAdj}/{bAdj} → sıfat      (tutkulu ve önce davranan)
  // ---------------------------------------------------------------------------
  static const _bodyLeadFrames = <String>[
    '{aAdj} bir {a} ile {bAdj} bir {bGen} bu buluşması, bu hafta güzel dalgalar yaratacak potansiyele sahip.',
    '{aAdj} {a} enerjisi ve {bAdj} {b} doğası bu hafta ilginç bir kimya oluşturuyor.',
    'Bir tarafta {aAdj} {a}, diğer tarafta {bAdj} {b}; bu hafta bu iki güç birbirini nasıl besliyor?',
    '{aGen} {aAdj} yanı ile {bGen} {bAdj} dünyası bu hafta ortak bir harmoni arıyor.',
    'Bu hafta {aAdj} {a} enerjisi {bAdj} {bAcc} derinlemesine etkiliyor.',
    '{a} ile {b} arasındaki enerji dengesi bu hafta yeni bir boyut kazanıyor.',
    '{bAdj} {b} doğasına {aAdj} {a} enerjisi bu hafta farklı bir renk katıyor.',
    'Bu hafta {aGen} {aAdj} özü ile {bGen} {bAdj} dünyası beklenmedik bir noktada kesişiyor.',
    '{a} ve {b} enerjileri bu hafta birbirini tamamlamak için doğru fırsatı yakalamış görünüyor.',
    '{aAdj} {a} ile {bAdj} {b} bu hafta ortak bir ritim yakalamaya çok yakın.',
    'Bu hafta {a} enerjisinin {bAcc} nasıl etkilediğine dikkat edin; güzel sürprizler kapıda bekliyor.',
    '{bAdj} {b} ile {aAdj} {a} bu hafta ortak bir zemin üzerinde yeniden buluşuyor.',
    '{aGen} {aAdj} doğası ve {bGen} {bAdj} dünyası bu hafta birbirini sessizce dönüştürüyor.',
    'Bu hafta {aDat} has {aAdj} enerji, {bAdj} {bAcc} beklenmedik biçimde cezbediyor.',
    '{aAdj} {a} ruhunun {bAcc} ne denli etkileyebileceği bu hafta net biçimde görünüyor.',
  ];

  // ---------------------------------------------------------------------------
  // Yardımcılar
  // ---------------------------------------------------------------------------
  static int _weekBucket(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final weekday = normalized.weekday; // 1=Pzt, 7=Paz
    final monday = normalized.subtract(Duration(days: weekday - 1));
    return (monday.millisecondsSinceEpoch ~/ 1000).toInt();
  }

  static int _seedFrom(String key) {
    int h = 2166136261;
    for (final c in key.codeUnits) {
      h = ((h ^ c) * 16777619) & 0xFFFFFFFF;
    }
    return h;
  }

  static T _pick<T>(List<T> list, {required int seed, required int salt}) {
    return list[(seed ^ salt) % list.length];
  }

  static String _normalize(String sign) {
    final s = sign.trim();
    switch (s) {
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
        return s;
    }
  }

  // ---------------------------------------------------------------------------
  // Umumi API
  // ---------------------------------------------------------------------------
  static RelationshipWeeklyComment generate({
    required String signA,
    required String signB,
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    final a = _normalize(signA);
    final b = _normalize(signB);

    final bucket = _weekBucket(date);
    // her hafta farklı seed; a–b ve b–a aynı sonucu üretsin
    final pairKey = a.compareTo(b) <= 0 ? '$a|$b' : '$b|$a';
    final seed = _seedFrom('$pairKey|$bucket|iliski-v1');

    final traitsA = _signTraits[a] ?? ['özgün'];
    final traitsB = _signTraits[b] ?? ['özgün'];
    final aAdj = _pick(traitsA, seed: seed, salt: 3);
    final bAdj = _pick(traitsB, seed: seed, salt: 7);

    final aGen = _genitiveMap[a] ?? "$a'ın";
    final bGen = _genitiveMap[b] ?? "$b'ın";
    final aAcc = _accusativeMap[a] ?? "$a'ı";
    final bAcc = _accusativeMap[b] ?? "$b'ı";
    final aDat = _dativeMap[a] ?? "$a'a";
    final bDat = _dativeMap[b] ?? "$b'a";

    final titleFrame = _pick(_titleFrames, seed: seed, salt: 11);
    final title = titleFrame.replaceAll('{a}', a).replaceAll('{b}', b);

    final leadFrame = _pick(_bodyLeadFrames, seed: seed, salt: 13);
    final lead = leadFrame
        .replaceAll('{aGen}', aGen)
        .replaceAll('{bGen}', bGen)
        .replaceAll('{aAcc}', aAcc)
        .replaceAll('{bAcc}', bAcc)
        .replaceAll('{aDat}', aDat)
        .replaceAll('{bDat}', bDat)
        .replaceAll('{a}', a)
        .replaceAll('{b}', b)
        .replaceAll('{aAdj}', aAdj)
        .replaceAll('{bAdj}', bAdj);

    final context = _pick(_transitContexts, seed: seed, salt: 17);
    final theme = _pick(_compatibilityThemes, seed: seed, salt: 23);

    // ikinci tema varyantı — farklı salt ile farklı cümle seç
    final theme2 = _pick(_compatibilityThemes, seed: seed, salt: 29);
    final extraTheme = theme2 == theme
        ? _compatibilityThemes[((_compatibilityThemes.indexOf(theme2) + 1) %
              _compatibilityThemes.length)]
        : theme2;

    final tip = _pick(_weeklyTips, seed: seed, salt: 37);

    final rawBody = '$lead $context $theme $extraTheme';
    final body = rawBody.isEmpty
        ? rawBody
        : rawBody[0].toUpperCase() + rawBody.substring(1);

    return RelationshipWeeklyComment(title: title, body: body, tip: tip);
  }
}
