// List<T> parseList<T>({required dynamic json, required T Function(Map<String, dynamic>) fromJson}) {
//   if(json == null) return <T>[];
//   if (json is List) {
//     return json
//         .whereType<Map<String, dynamic>>()
//         .map<T>((e) => fromJson(e))
//         .toList();
//   }
//
//   return <T>[];
// }

List<T> parseList<T>({required dynamic json, required T Function(Map<String, dynamic>) fromJson}) {
  if (json is! List) return <T>[];

  return json
      .where((e) => e != null && e is Map) // drop nulls & non-Maps
      .map((e) => fromJson(Map<String, dynamic>.from(e as Map))) // safe on web
      .toList(growable: false);
}

String _sanitizeFlavor(String s) => s
    .replaceAll('\n', ' ')
    .replaceAll('\f', ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

String? latestEnglishDescription(Map<String, dynamic> species) {
  final entries = (species['flavor_text_entries'] as List?) ?? const [];
  for (final e in entries.reversed.whereType<Map>()) {
    final m = e.cast<String, dynamic>();
    if (m['language']?['name'] == 'en') {
      final raw = m['flavor_text'] as String?;
      if (raw != null && raw.isNotEmpty) return _sanitizeFlavor(raw);
    }
  }
  return null;
}

String? latestEnglishGenera(Map<String, dynamic> species) {
  final entries = (species['genera'] as List?) ?? const [];
  for (final e in entries.reversed.whereType<Map>()) {
    final m = e.cast<String, dynamic>();
    if (m['language']?['name'] == 'en') {
      final raw = m['genus'] as String?;
      if (raw != null && raw.isNotEmpty) return raw;
    }
  }
  return null;
}

Map<String, double>? genderSplit({required int? genderRate}) {
  if (genderRate == -1 || genderRate == null) return null; // genderless
  final female = genderRate * 12.5;
  final male = 100.0 - female;
  return {'male': male, 'female': female};
}


int stepsToHatch({required int? hatchCounter}) => (hatchCounter ?? 0)  * 255;

String friendshipLabel({required int baseHappiness}) {
  if (baseHappiness >= 200) return 'Very friendly';
  if (baseHappiness >= 100) return 'Friendly';
  if (baseHappiness >= 70)  return 'Neutral';
  return 'Low';
}

String catchDifficultyLabel({required int captureRate}) {
  if (captureRate <= 3)   return 'Legendary-tier (very hard)';
  if (captureRate <= 45)  return 'Hard';
  if (captureRate <= 90)  return 'Moderate';
  if (captureRate <= 190) return 'Easy';
  return 'Very easy';
}
