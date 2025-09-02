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
