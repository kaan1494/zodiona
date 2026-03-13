class LocationModel {
  const LocationModel({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    this.city,
    this.state,
    this.district,
  });

  final String name;
  final String country;
  final double lat;
  final double lon;
  final String? city;
  final String? state;
  final String? district;

  factory LocationModel.fromFeature(Map<String, dynamic> feature) {
    final properties =
        (feature['properties'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final geometry =
        (feature['geometry'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final coordinates = (geometry['coordinates'] as List?) ?? const [];

    double parseCoordinate(dynamic value) {
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    final lon = coordinates.isNotEmpty ? parseCoordinate(coordinates[0]) : 0.0;
    final lat = coordinates.length > 1 ? parseCoordinate(coordinates[1]) : 0.0;

    return LocationModel(
      name: (properties['name'] as String?)?.trim() ?? '',
      country: (properties['country'] as String?)?.trim() ?? '',
      city: (properties['city'] as String?)?.trim(),
      state: (properties['state'] as String?)?.trim(),
      district: (properties['district'] as String?)?.trim(),
      lat: lat,
      lon: lon,
    );
  }

  String get displayLabel {
    final parts = <String>{
      if (name.isNotEmpty) name,
      if (district != null && district!.isNotEmpty) district!,
      if (city != null && city!.isNotEmpty) city!,
      if (state != null && state!.isNotEmpty) state!,
      if (country.isNotEmpty) country,
    };
    return parts.join(', ');
  }

  String get stableId =>
      '${lat.toStringAsFixed(5)}|${lon.toStringAsFixed(5)}|$name';
}
