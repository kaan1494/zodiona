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

    final queryVariants = <String>{
      normalized,
      _toAscii(normalized),
    }..removeWhere((value) => value.isEmpty);

    final merged = <String, LocationModel>{};
    for (final item in queryVariants) {
      final result = await _searchPhoton(
        item,
        limit: limit,
        language: language,
      );
      for (final location in result) {
        merged[location.stableId] = location;
      }
      if (merged.length >= limit) {
        break;
      }
    }

    return merged.values.take(limit).toList();
  }

  Future<List<LocationModel>> _searchPhoton(
    String query, {
    required int limit,
    required String language,
  }) async {
    final attempts = <Future<http.Response>>[
      _requestPhoton(host: 'photon.komoot.io', query: query, limit: limit, language: language),
      _requestPhoton(host: 'photon.komoot.io', query: query, limit: limit),
      _requestPhoton(host: 'photon.komoot.de', query: query, limit: limit, language: language),
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

        final results = features
            .whereType<Map<String, dynamic>>()
            .map(LocationModel.fromFeature)
            .where((location) => location.name.isNotEmpty)
            .toList();

        if (results.isNotEmpty) {
          return results;
        }
      } catch (_) {
        continue;
      }
    }

    return const <LocationModel>[];
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
    return http.get(
      uri,
      headers: const {
        'Accept': 'application/json',
        'User-Agent': 'Zodiona/1.0 (Flutter)'
      },
    ).timeout(const Duration(seconds: 10));
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
