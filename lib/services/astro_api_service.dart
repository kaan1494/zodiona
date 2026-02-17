import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

class AstroCalculationResult {
  const AstroCalculationResult({
    required this.sunSign,
    required this.moonSign,
    required this.ascendant,
    required this.timezone,
    required this.utcDateTime,
  });

  final String sunSign;
  final String moonSign;
  final String ascendant;
  final String timezone;
  final String utcDateTime;

  factory AstroCalculationResult.fromJson(Map<String, dynamic> json) {
    return AstroCalculationResult(
      sunSign: (json['sunSign'] as String?)?.trim() ?? 'Bilinmiyor',
      moonSign: (json['moonSign'] as String?)?.trim() ?? 'Bilinmiyor',
      ascendant: (json['ascendant'] as String?)?.trim() ?? 'Bilinmiyor',
      timezone: (json['timezone'] as String?)?.trim() ?? '',
      utcDateTime: (json['utcDateTime'] as String?)?.trim() ?? '',
    );
  }
}

class AstroApiService {
  const AstroApiService({
    this.baseUrl = _defaultBaseUrl,
    this.apiKey = _defaultApiKey,
    this.requestTimeout = const Duration(seconds: 45),
  });

  static const _defaultBaseUrl = String.fromEnvironment(
    'ASTRO_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const _defaultApiKey = String.fromEnvironment(
    'ASTRO_API_KEY',
    defaultValue: '',
  );

  final String baseUrl;
  final String apiKey;
  final Duration requestTimeout;

  Future<AstroCalculationResult> calculate({
    required DateTime localBirthDateTime,
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse('$baseUrl/astro').replace(
      queryParameters: {
        'date': _toIsoLocal(localBirthDateTime),
        'lat': latitude.toString(),
        'lon': longitude.toString(),
      },
    );

    final headers = <String, String>{'Accept': 'application/json'};
    if (apiKey.trim().isNotEmpty) {
      headers['x-api-key'] = apiKey.trim();
    }

    final response = await http
      .get(uri, headers: headers)
      .timeout(requestTimeout);

    if (response.statusCode != 200) {
      throw Exception('Astro API error: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return AstroCalculationResult.fromJson(body);
  }

  String _toIsoLocal(DateTime value) {
    final y = value.year.toString().padLeft(4, '0');
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    final h = value.hour.toString().padLeft(2, '0');
    final min = value.minute.toString().padLeft(2, '0');
    return '$y-$m-$d' 'T$h:$min';
  }
}
