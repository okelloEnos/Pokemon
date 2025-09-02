import 'package:flutter/material.dart';
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

// import 'package:flutter/material.dart';

/// Deterministically map any string (e.g., "red", "green", "whatever")
/// to a nice-looking, stable color — no default tables required.
class ColorHash {
  /// Get a Flutter [Color] from a name.
  /// Tweak [vibrancy] (0..1) and [lightness] (0..1) to match your UI.
  static Color colorFromName(
      String name, {
        double vibrancy = 0.75, // saturation bias (0.0..1.0)
        double lightness = 0.52, // lightness baseline (0.0..1.0)
        double opacity = 1.0,
      }) {
    final h = _hash32(name) % 360; // hue 0..359
    // Derive slight variation for S & L from the hash to avoid identical tones.
    final sJitter = ((_hash32('${name}::s') >> 3) & 0xFF) / 255.0; // 0..1
    final lJitter = ((_hash32('${name}::l') >> 5) & 0xFF) / 255.0; // 0..1

    final s = (0.55 + (vibrancy * 0.4))              // 0.55..0.95 depending on vibrancy
        .clamp(0.0, 1.0);
    final l = (lightness + (lJitter * 0.10) - 0.05)   // ±5% jitter around baseline
        .clamp(0.0, 1.0);

    final c = _hslToColor(h.toDouble(), s, l);
    return c.withOpacity(opacity);
  }

  /// Get a HEX like "#RRGGBB" from a name.
  static String hexFromName(String name, {double vibrancy = 0.75, double lightness = 0.52}) {
    final c = colorFromName(name, vibrancy: vibrancy, lightness: lightness);
    final rgb = (c.value & 0x00FFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();
    return '#$rgb';
  }

  // ---------- internals ----------

  // Fast, stable 32-bit hash (FNV-1a).
  static int _hash32(String s) {
    const prime = 0x01000193;
    int hash = 0x811C9DC5;
    for (var i = 0; i < s.length; i++) {
      hash ^= s.codeUnitAt(i);
      hash = (hash * prime) & 0xFFFFFFFF;
    }
    return hash;
  }

  static Color _hslToColor(double h, double s, double l) {
    final c = (1 - (2 * l - 1).abs()) * s;
    final x = c * (1 - ((h / 60) % 2 - 1).abs());
    final m = l - c / 2;
    double r = 0, g = 0, b = 0;

    if (h < 60) { r = c; g = x; b = 0; }
    else if (h < 120) { r = x; g = c; b = 0; }
    else if (h < 180) { r = 0; g = c; b = x; }
    else if (h < 240) { r = 0; g = x; b = c; }
    else if (h < 300) { r = x; g = 0; b = c; }
    else { r = c; g = 0; b = x; }

    int ri = ((r + m) * 255).round().clamp(0, 255);
    int gi = ((g + m) * 255).round().clamp(0, 255);
    int bi = ((b + m) * 255).round().clamp(0, 255);
    return Color.fromARGB(0xFF, ri, gi, bi);
  }
}
