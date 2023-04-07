import 'dart:convert';

/// Tools for handling JSON objects throughout the app.
class JsonTool {
  /// Parses a JSON string into a Map object.
  ///
  /// May throw a FormatException if the input string is not valid JSON.
  static Map<String, dynamic> readJson(String json) {
    dynamic jsonObj = jsonDecode(json);

    if (jsonObj is Map<String, dynamic>) {
      return jsonObj;
    }

    // If the parsed JSON is not a map, return an empty map.
    return {};
  }

  /// Parses a JSON string into a Map object.
  ///
  /// If the input string contains a JSON object, it returns that object as a
  /// single map in a list.
  ///
  /// If the input string contains a JSON array with at least one object, it
  /// returns all of the objects as maps in a list.
  ///
  /// Otherwise, it returns null.
  ///
  /// May throw a [FormatException] if the input string is not valid JSON.
  static List<Map<String, dynamic>>? readJsonOr(String json) {
    dynamic jsonObj = jsonDecode(json);

    if (jsonObj is Map<String, dynamic>) {
      return [jsonObj];
    } else if (jsonObj is List<dynamic>) {
      List<Map<String, dynamic>> toReturn = [];

      for (dynamic object in jsonObj) {
        if (object is Map<String, dynamic>) {
          toReturn.add(object);
        }
      }

      if (toReturn.isNotEmpty) return toReturn;
    }

    return null;
  }

  /// Parses a JSON string into a list of Map objects.
  ///
  /// May throw a FormatException if the input string is not valid JSON.
  static List<Map<String, dynamic>> readJsonList(String json) {
    dynamic jsonObj = jsonDecode(json);

    if (jsonObj is List<dynamic>) {
      return List<Map<String, dynamic>>.from(
        jsonObj.map(
          (result) => Map<String, dynamic>.from(result),
        ),
      );
    }

    return [];
  }

  /// Parses a Map object into a JSON string.
  static String writeJson(Map<String, dynamic> json) {
    return jsonEncode(json);
  }
}

/// Determines what information will be placed in the json.
enum OptimizeFor {
  /// Creates a json with only what is needed for a PUT request.
  put,

  /// Creates a json with only what is needed for a PUT request.
  ///
  /// This is different from [put] because it adds all of the data that is
  /// relevant to a PUT request since a parent of this object has changed. This
  /// requires all of the children of that object to be sent in full with the
  /// PUT request.
  putFull,

  /// Creates a json with only what is needed for a POST request.
  post,

  /// Creates a json with no data excluded.
  dontOptimize,
}
