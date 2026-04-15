import 'dart:convert';
import 'package:http/http.dart' as http;

/// Kullanıcının doğum harita bilgilerini taşır.
/// ChatPage, bu modeli Firestore'dan doldurup servise geçirir.
class KozmikRehberUserProfile {
  const KozmikRehberUserProfile({
    required this.name,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
    required this.venusSign,
    required this.birthDate,
    required this.birthTime,
    required this.birthPlace,
  });

  final String name;
  final String sunSign;
  final String moonSign;
  final String risingSign;
  final String venusSign;
  final String birthDate; // "14 Nisan 1994" gibi okunabilir format
  final String birthTime; // "04:50" veya "Bilinmiyor"
  final String birthPlace; // "İstanbul, Türkiye" gibi

  // Firestore map'inden oluştur
  factory KozmikRehberUserProfile.fromFirestore(Map<String, dynamic> data) {
    final name = (data['name'] as String? ?? 'Kullanıcı').trim();
    final sun = _sanitize(data['zodiacSign'], 'Bilinmiyor');
    final moon = _sanitize(data['moonSign'], 'Bilinmiyor');
    final rising = _sanitize(data['risingSign'], 'Bilinmiyor');
    final venus = _sanitize(data['venusSign'], 'Bilinmiyor');

    String birthDateStr = 'Bilinmiyor';
    final raw = data['birthDate'];
    if (raw != null) {
      try {
        final dt = raw.toDate() as DateTime;
        birthDateStr = '${dt.day} ${_monthName(dt.month)} ${dt.year}';
      } catch (_) {}
    }

    final birthTime = _sanitize(data['birthTime'], 'Bilinmiyor');
    final city = _sanitize(data['birthCity'], '');
    final country = _sanitize(data['birthCountry'], '');
    final place = [city, country].where((s) => s.isNotEmpty).join(', ');

    return KozmikRehberUserProfile(
      name: name,
      sunSign: _displaySign(sun),
      moonSign: _displaySign(moon),
      risingSign: _displaySign(rising),
      venusSign: _displaySign(venus),
      birthDate: birthDateStr,
      birthTime: birthTime,
      birthPlace: place.isEmpty ? 'Bilinmiyor' : place,
    );
  }
}

/// Uyum analizinde arkadaşın bilgilerini taşır.
class KozmikRehberFriendProfile {
  const KozmikRehberFriendProfile({
    required this.name,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
    required this.venusSign,
    required this.birthDate,
    required this.birthTime,
    required this.birthPlace,
    required this.gender,
    required this.job,
    required this.relationshipType,
    this.age,
  });

  final String name;
  final String sunSign;
  final String moonSign;
  final String risingSign;
  final String venusSign;
  final String birthDate;
  final String birthTime;
  final String birthPlace;
  final String gender;
  final String job;
  final String relationshipType;
  final int? age;

  factory KozmikRehberFriendProfile.fromData(Map<String, dynamic> data) {
    String birthDateStr = 'Bilinmiyor';
    int? age;
    final raw = data['birthDate'];
    if (raw != null) {
      try {
        final dt = (raw as dynamic).toDate() as DateTime;
        birthDateStr = '${dt.day} ${_monthName(dt.month)} ${dt.year}';
        age = DateTime.now().year - dt.year;
      } catch (_) {}
    }
    final city = _sanitize(data['birthCity'], '');
    final country = _sanitize(data['birthCountry'], '');
    final place = [city, country].where((s) => s.isNotEmpty).join(', ');

    return KozmikRehberFriendProfile(
      name: _sanitize(data['name'], 'Arkadaş'),
      sunSign: _displaySign(_sanitize(data['zodiacSign'], 'Bilinmiyor')),
      moonSign: _displaySign(_sanitize(data['moonSign'], 'Bilinmiyor')),
      risingSign: _displaySign(_sanitize(data['risingSign'], 'Bilinmiyor')),
      venusSign: _displaySign(_sanitize(data['venusSign'], 'Bilinmiyor')),
      birthDate: birthDateStr,
      birthTime: _sanitize(data['birthTime'], 'Bilinmiyor'),
      birthPlace: place.isEmpty ? 'Bilinmiyor' : place,
      gender: _sanitize(data['gender'], 'Bilinmiyor'),
      job: _sanitize(data['job'], 'Bilinmiyor'),
      relationshipType: _sanitize(data['relationshipType'], 'Bilinmiyor'),
      age: age,
    );
  }
}

class ChatMessage {
  const ChatMessage({required this.role, required this.content});

  /// 'user' veya 'assistant'
  final String role;
  final String content;
}

/// GPT ile iletişimi sağlayan servis.
/// Model ve prompt burada merkezi olarak yönetilir.
class KozmikRehberService {
  KozmikRehberService._();

  // -----------------------------------------------------------------------
  // ★ MODEL SEÇİMİ — buradan değiştir
  //   'gpt-4o-mini'  → ucuz, hızlı, yeterince akıllı  (önerilen)
  //   'gpt-4o'       → daha güçlü, daha pahalı
  //   'gpt-3.5-turbo'→ en ucuz, basit sorular için yeterli
  // -----------------------------------------------------------------------
  static const String _model = 'gpt-4o-mini';

  // ★ API key — tasks.json'daki --dart-define ile enjekte edilir
  static const String _apiKey = String.fromEnvironment('OPENAI_API_KEY');

  // -----------------------------------------------------------------------
  // ★ SİSTEM PROMPTU — GPT'ye kim olduğunu ve nasıl davranması
  //   gerektiğini burada tarif ediyoruz.
  //   {name}, {sun}, {moon}, {rising}, {birthDate}, {birthTime},
  //   {birthPlace} yer tutucuları kullanıcı verileriyle doldurulur.
  // -----------------------------------------------------------------------
  static String _buildSystemPrompt(KozmikRehberUserProfile profile) {
    return '''
Sen Zodiona uygulamasının "Kozmik Rehber" astroloji asistanısın.
Kullanıcının adı: ${profile.name}
Doğum tarihi: ${profile.birthDate}
Doğum saati: ${profile.birthTime}
Doğum yeri: ${profile.birthPlace}

Natal harita:
- Güneş burcu: ${profile.sunSign}  → kimlik, benlik, enerji kaynağı
- Ay burcu: ${profile.moonSign}     → duygular, sezgi, iç dünya
- Yükselen burcu: ${profile.risingSign} → dışa yansıma, sosyal kişilik- Venüs burcu: ${profile.venusSign} → aşk, çekim, ilişki stili
Görevlerin:
1. Kullanıcının sorduğu astrolojik soruları bu haritayı referans alarak yanıtla.
2. Cevapların Türkçe, sıcak, samimi ve pratik olsun.
3. Her cevap 3-6 cümle ile sınırlı olsun — uzun değil, öz ve etkili.
4. Harita bilgisi yetersizse bunu nazikçe belirt; asla uydurma.
5. Astroloji dilini kullan ama teknik jargonu aşırıya kaçma.
''';
  }

  static String _buildUyumSystemPrompt(
    KozmikRehberUserProfile user,
    KozmikRehberFriendProfile friend,
  ) {
    return '''
Sen Zodiona uygulamasının "Kozmik Rehber" astroloji asistanısın.
Kullanıcı iki kişi arasındaki uyumu ve ilişkiyi sormak istiyor.

— KULLANICI —
Ad: ${user.name}
Doğum: ${user.birthDate} | Saat: ${user.birthTime} | Yer: ${user.birthPlace}
Güneş: ${user.sunSign} | Ay: ${user.moonSign} | Yükselen: ${user.risingSign} | Venüs: ${user.venusSign}

— ${friend.name.toUpperCase()} (Arkadaş / Partner) —
Ad: ${friend.name}
Doğum: ${friend.birthDate} | Saat: ${friend.birthTime} | Yer: ${friend.birthPlace}
Güneş: ${friend.sunSign} | Ay: ${friend.moonSign} | Yükselen: ${friend.risingSign} | Venüs: ${friend.venusSign}
Cinsiyet: ${friend.gender} | Meslek: ${friend.job}
İlişki türü: ${friend.relationshipType}${friend.age != null ? ' | Yaş: ${friend.age}' : ''}

Görevlerin:
1. İki kişi arasındaki astrolojik uyumu bu bilgileri kullanarak değerlendir.
2. Cevapların Türkçe, sıcak, samimi ve kişiselleştirilmiş olsun.
3. Her cevap 3-7 cümle ile sınırlı olsun — öz ve etkili.
4. Venüs, Mars, Ay uyumlarına dikkat et, ilişki dinamiklerini vurgula.
5. Olumlu ve yapıcı bir ton kullan; zayıf noktaları nazikçe belirt.
''';
  }

  static String _buildTarotSystemPrompt(
    KozmikRehberUserProfile profile,
    List<Map<String, String>> cards,
  ) {
    final cardList = cards
        .asMap()
        .entries
        .map(
          (e) => '${e.key + 1}. ${e.value['name']}: ${e.value['description']}',
        )
        .join('\n');
    return '''
Sen Zodiona uygulamasının "Kozmik Rehber" tarot ve astroloji asistanısın.
Kullanıcının adı: ${profile.name}
Güneş: ${profile.sunSign} | Ay: ${profile.moonSign} | Yükselen: ${profile.risingSign}

Kullanıcının seçtiği tarot kartları:
$cardList

Görevlerin:
1. Kullanıcının tarot kartları hakkındaki sorularını bu kart isimleri ve açıklamalarını referans alarak yanıtla.
2. Her kartın sembolizmini, mesajını ve kullanıcının hayatına yansımasını yorumla.
3. Varsa kartlar arasındaki ilişkiyi ve genel mesajı da belirt.
4. Cevapların Türkçe, mistik, sıcak ve ilham verici olsun.
5. Her cevap 3-7 cümle ile sınırlı olsun — öz ve etkili.
6. Astroloji ve tarot dilini kullan ama aşırı teknik olmaktan kaçın.
''';
  }

  /// Uyum analizi chat
  static Future<String> sendUyumMessage({
    required List<ChatMessage> messages,
    required KozmikRehberUserProfile userProfile,
    required KozmikRehberFriendProfile friendProfile,
    List<ChatMessage> memoryMessages = const [],
  }) async {
    final systemPrompt = _buildUyumSystemPrompt(userProfile, friendProfile);
    return _callGpt(
      messages: messages,
      systemPrompt: systemPrompt,
      memoryMessages: memoryMessages,
    );
  }

  /// Tarot yorumu chat
  static Future<String> sendTarotMessage({
    required List<ChatMessage> messages,
    required KozmikRehberUserProfile profile,
    required List<Map<String, String>> cards,
    List<ChatMessage> memoryMessages = const [],
  }) async {
    final systemPrompt = _buildTarotSystemPrompt(profile, cards);
    return _callGpt(
      messages: messages,
      systemPrompt: systemPrompt,
      memoryMessages: memoryMessages,
    );
  }

  static Future<String> _callGpt({
    required List<ChatMessage> messages,
    required String systemPrompt,
    List<ChatMessage> memoryMessages = const [],
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'OPENAI_API_KEY tanımlı değil. launch.json dosyasını kontrol et.',
      );
    }
    const int maxContext = 50;
    final List<ChatMessage> contextMessages;
    if (messages.length >= maxContext) {
      contextMessages = messages.sublist(messages.length - maxContext);
    } else {
      final memSlots = maxContext - messages.length;
      final memStart = memoryMessages.length > memSlots
          ? memoryMessages.length - memSlots
          : 0;
      contextMessages = [...memoryMessages.sublist(memStart), ...messages];
    }

    final body = jsonEncode({
      'model': _model,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ...contextMessages.map((m) => {'role': m.role, 'content': m.content}),
      ],
      'max_tokens': 512,
      'temperature': 0.75,
    });

    final response = await http
        .post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'Authorization': 'Bearer $_apiKey',
          },
          body: body,
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return (json['choices'] as List).first['message']['content'] as String;
    } else {
      throw Exception('OpenAI hatası ${response.statusCode}: ${response.body}');
    }
  }

  static Future<String> sendMessage({
    required List<ChatMessage> messages,
    required KozmikRehberUserProfile profile,
    List<ChatMessage> memoryMessages = const [],
  }) async {
    final systemPrompt = _buildSystemPrompt(profile);
    return _callGpt(
      messages: messages,
      systemPrompt: systemPrompt,
      memoryMessages: memoryMessages,
    );
  }

  /// Rüya tabiri chat
  static Future<String> sendRuyaMessage({
    required List<ChatMessage> messages,
    required KozmikRehberUserProfile profile,
    List<ChatMessage> memoryMessages = const [],
  }) async {
    final systemPrompt = _buildRuyaSystemPrompt(profile);
    return _callGpt(
      messages: messages,
      systemPrompt: systemPrompt,
      memoryMessages: memoryMessages,
    );
  }

  static String _buildRuyaSystemPrompt(KozmikRehberUserProfile profile) {
    final now = DateTime.now();
    final age = (() {
      try {
        final parts = profile.birthDate.split(' ');
        if (parts.length == 3) {
          final year = int.parse(parts[2]);
          return (now.year - year).toString();
        }
      } catch (_) {}
      return 'Bilinmiyor';
    })();

    return '''
Sen Zodiona uygulamasının "Kozmik Rehber" rüya tabiri asistanısın.
Kullanıcının kişisel bilgileri:
- Ad: ${profile.name}
- Yaş: $age
- Doğum tarihi: ${profile.birthDate}
- Doğum saati: ${profile.birthTime}
- Doğum yeri: ${profile.birthPlace}

Natal harita:
- Güneş burcu: ${profile.sunSign}  → kimlik, benlik, bilinç
- Ay burcu: ${profile.moonSign}     → bilinçaltı, duygular, rüya alemi
- Yükselen burcu: ${profile.risingSign} → dış dünyaya yansıma

Görevlerin:
1. Kullanıcının anlattığı rüyaları sembolik, psikolojik ve astrolojik perspektiften yorumla.
2. Ay burcunu ve doğum haritasını rüyanın yorumuna mümkün olduğunca dahil et.
3. Rüyadaki semboller, karakterler ve duygulara dikkat et.
4. Cevapların Türkçe, sıcak, mistik ve kişiselleştirilmiş olsun.
5. Her yorum 4-7 cümle ile sınırlı olsun — öz, anlam yüklü ve etkili.
6. Kullanıcının adını ara sıra kullan, sohbet samimi hissettirsin.
7. Gerekirse rüyanın mesajını ve kullanıcıya önerisini de ekle.
''';
  }
}

// ---------------------------------------------------------------------------
// Yardımcı fonksiyonlar
// ---------------------------------------------------------------------------

String _sanitize(dynamic v, String fallback) {
  final t = (v as String?)?.trim();
  if (t == null || t.isEmpty || t == 'Bilinmiyor') return fallback;
  return t;
}

String _displaySign(String v) {
  return switch (v) {
    'Koc' => 'Koç',
    'Boga' => 'Boğa',
    'Ikizler' => 'İkizler',
    'Yengec' => 'Yengeç',
    'Basak' => 'Başak',
    'Oglak' => 'Oğlak',
    'Balik' => 'Balık',
    _ => v,
  };
}

String _monthName(int month) {
  const names = [
    '',
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];
  return names[month];
}
