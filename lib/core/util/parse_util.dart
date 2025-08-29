List<T> parseList<T>({required dynamic json, required T Function(Map<String, dynamic>) fromJson}) {
  if (json is List) {
    return json
        .whereType<Map<String, dynamic>>()
        .map<T>((e) => fromJson(e))
        .toList();
  }

  return <T>[];
}
