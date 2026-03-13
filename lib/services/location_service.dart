import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/location_model.dart';

class LocationService {
  Future<List<LocationModel>> searchLocations(
    String query, {
    int limit = 10,
    String language = 'tr',
  }) async {
    final normalized = query.trim();
    if (normalized.length < 2) {
      return const <LocationModel>[];
    }

    final queryVariants = <String>{normalized, _toAscii(normalized)}
      ..removeWhere((value) => value.isEmpty);

    final merged = <String, LocationModel>{};
    for (final item in queryVariants) {
      final openMeteoResult = await _searchOpenMeteo(
        item,
        limit: limit,
        language: language,
      );
      for (final location in openMeteoResult) {
        merged[location.stableId] = location;
      }

      if (merged.length < limit) {
        final photonResult = await _searchPhoton(
          item,
          limit: limit,
          language: language,
        );
        for (final location in photonResult) {
          merged[location.stableId] = location;
        }
      }

      if (merged.length < limit) {
        final nominatimResult = await _searchNominatim(
          item,
          limit: limit,
          language: language,
        );
        for (final location in nominatimResult) {
          merged[location.stableId] = location;
        }
      }

      if (merged.length >= limit) {
        break;
      }
    }

    return merged.values.take(limit).toList();
  }

  Future<List<LocationModel>> _searchOpenMeteo(
    String query, {
    required int limit,
    required String language,
  }) async {
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': query,
      'count': '$limit',
      'language': language,
      'format': 'json',
    });

    try {
      final response = await http
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
              'User-Agent': 'Zodiona/1.0 (Flutter)',
            },
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode != 200) {
        return const <LocationModel>[];
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final results = (decoded['results'] as List?) ?? const [];

      return results
          .whereType<Map<String, dynamic>>()
          .map((item) {
            final lat = _asDouble(item['latitude']) ?? 0.0;
            final lon = _asDouble(item['longitude']) ?? 0.0;
            final name = (item['name'] as String?)?.trim() ?? '';
            final admin1 = (item['admin1'] as String?)?.trim();
            final admin2 = (item['admin2'] as String?)?.trim();
            final country = (item['country'] as String?)?.trim();
            final countryCode = (item['country_code'] as String?)?.trim();

            return LocationModel(
              name: name,
              country: (country?.isNotEmpty ?? false)
                  ? country!
                  : (countryCode ?? ''),
              city: name,
              state: admin1,
              district: admin2,
              lat: lat,
              lon: lon,
            );
          })
          .where((location) => location.name.isNotEmpty)
          .toList(growable: false);
    } catch (_) {
      return const <LocationModel>[];
    }
  }

  Future<List<LocationModel>> _searchPhoton(
    String query, {
    required int limit,
    required String language,
  }) async {
    final attempts = <Future<http.Response>>[
      _requestPhoton(
        host: 'photon.komoot.io',
        query: query,
        limit: limit,
        language: language,
      ),
      _requestPhoton(host: 'photon.komoot.io', query: query, limit: limit),
      _requestPhoton(
        host: 'photon.komoot.de',
        query: query,
        limit: limit,
        language: language,
      ),
      _requestPhoton(host: 'photon.komoot.de', query: query, limit: limit),
    ];

    for (final attempt in attempts) {
      try {
        final response = await attempt;
        if (response.statusCode != 200) {
          continue;
        }

        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final features = (decoded['features'] as List?) ?? const [];

        final results = <LocationModel>[];
        for (final raw in features.whereType<Map<String, dynamic>>()) {
          try {
            final location = LocationModel.fromFeature(raw);
            if (location.name.isNotEmpty) {
              results.add(location);
            }
          } catch (_) {
            continue;
          }
        }

        if (results.isNotEmpty) {
          return results;
        }
      } catch (_) {
        continue;
      }
    }

    return const <LocationModel>[];
  }

  Future<List<LocationModel>> _searchNominatim(
    String query, {
    required int limit,
    required String language,
  }) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'jsonv2',
      'addressdetails': '1',
      'limit': '$limit',
      'accept-language': language,
    });

    try {
      final response = await http
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
              'User-Agent': 'Zodiona/1.0 (Flutter)',
            },
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return const <LocationModel>[];
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        return const <LocationModel>[];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((item) {
            final address =
                (item['address'] as Map?)?.cast<String, dynamic>() ??
                <String, dynamic>{};
            final lat = _asDouble(item['lat']) ?? 0.0;
            final lon = _asDouble(item['lon']) ?? 0.0;
            final city =
                ((address['city'] as String?) ??
                        (address['town'] as String?) ??
                        (address['village'] as String?) ??
                        (address['municipality'] as String?))
                    ?.trim();

            return LocationModel(
              name: ((item['name'] as String?)?.trim().isNotEmpty ?? false)
                  ? (item['name'] as String).trim()
                  : (city ?? ''),
              country: (address['country'] as String?)?.trim() ?? '',
              city: city,
              state: (address['state'] as String?)?.trim(),
              district: (address['county'] as String?)?.trim(),
              lat: lat,
              lon: lon,
            );
          })
          .where((location) => location.name.isNotEmpty)
          .toList(growable: false);
    } catch (_) {
      return const <LocationModel>[];
    }
  }

  Future<http.Response> _requestPhoton({
    required String host,
    required String query,
    required int limit,
    String? language,
  }) {
    final params = <String, String>{
      'q': query,
      'limit': '$limit',
      if (language != null && language.isNotEmpty) 'lang': language,
    };

    final uri = Uri.https(host, '/api/', params);
    return http
        .get(
          uri,
          headers: const {
            'Accept': 'application/json',
            'User-Agent': 'Zodiona/1.0 (Flutter)',
          },
        )
        .timeout(const Duration(seconds: 3));
  }

  double? _asDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  String _toAscii(String input) {
    const map = {
      'ç': 'c',
      'Ç': 'C',
      'ğ': 'g',
      'Ğ': 'G',
      'ı': 'i',
      'İ': 'I',
      'ö': 'o',
      'Ö': 'O',
      'ş': 's',
      'Ş': 'S',
      'ü': 'u',
      'Ü': 'U',
    };

    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(map[char] ?? char);
    }
    return buffer.toString();
  }
}
