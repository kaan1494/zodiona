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
    required this.birthDate,
    required this.birthTime,
    required this.birthPlace,
  });

  final String name;
  final String sunSign;
  final String moonSign;
  final String risingSign;
  final String birthDate; // "14 Nisan 1994" gibi okunabilir format
  final String birthTime; // "04:50" veya "Bilinmiyor"
  final String birthPlace; // "İstanbul, Türkiye" gibi

  // Firestore map'inden oluştur
  factory KozmikRehberUserProfile.fromFirestore(Map<String, dynamic> data) {
    final name = (data['name'] as String? ?? 'Kullanıcı').trim();
    final sun = _sanitize(data['zodiacSign'], 'Bilinmiyor');
    final moon = _sanitize(data['moonSign'], 'Bilinmiyor');
    final rising = _sanitize(data['risingSign'], 'Bilinmiyor');

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
      birthDate: birthDateStr,
      birthTime: birthTime,
      birthPlace: place.isEmpty ? 'Bilinmiyor' : place,
    );
  }
}

/// Tek bir sohbet mesajını temsil eder.
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
- Yükselen burcu: ${profile.risingSign} → dışa yansıma, sosyal kişilik

Görevlerin:
1. Kullanıcının sorduğu astrolojik soruları bu haritayı referans alarak yanıtla.
2. Cevapların Türkçe, sıcak, samimi ve pratik olsun.
3. Her cevap 3-6 cümle ile sınırlı olsun — uzun değil, öz ve etkili.
4. Harita bilgisi yetersizse bunu nazikçe belirt; asla uydurma.
5. Astroloji dilini kullan ama teknik jargonu aşırıya kaçma.
''';
  }

  /// [messages]: Şimdiye kadarki sohbet geçmişi (kullanıcı + asistan)
  /// [profile]:  Kullanıcının doğum haritası bilgileri
  /// Döndürür: GPT'nin cevap metni
  static Future<String> sendMessage({
    required List<ChatMessage> messages,
    required KozmikRehberUserProfile profile,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'OPENAI_API_KEY tanımlı değil. tasks.json dosyasını kontrol et.',
      );
    }

    final systemPrompt = _buildSystemPrompt(profile);

    final body = jsonEncode({
      'model': _model,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ...messages.map((m) => {'role': m.role, 'content': m.content}),
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
