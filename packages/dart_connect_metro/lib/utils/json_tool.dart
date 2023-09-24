import 'dart:convert';

/// Parses a JSON string into a Map object.
///
/// May throw a `FormatException` if the input string is not valid JSON.
Map<String, dynamic> readJson(String json) {
  if (json.isEmpty) return {};

  dynamic jsonObj = jsonDecode(json);

  if (jsonObj is Map<String, dynamic>) {
    return jsonObj;
  }

  // If the parsed JSON is not a map, return an empty map.
  return {};
}

/// Parses a Map object into a JSON string.
String writeJson(Map<String, dynamic> json) {
  return jsonEncode(json);
}
