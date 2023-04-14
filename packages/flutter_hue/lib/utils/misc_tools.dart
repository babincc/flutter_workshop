import 'dart:math';

import 'package:flutter_hue/constants/api_fields.dart';

/// Miscellanies tools that are used throughout the app.
class MiscTools {
  /// Used to extract the desired data from a raw JSON data map response.
  ///
  /// Example
  ///
  /// ```dart
  /// /// Raw response
  /// {
  ///   "errors": [],
  ///   "data":
  ///   [
  ///     {
  ///       "id": ...
  ///       ...
  ///     }
  ///   ]
  /// }
  ///
  /// /// Desired JSON data
  /// {
  ///   "id": ...
  ///   ...
  /// }
  /// ```
  static Map<String, dynamic> extractData(Map<String, dynamic> dataMap) {
    Map<String, dynamic> data;

    if (dataMap[ApiFields.data] != null && dataMap[ApiFields.id] == null) {
      try {
        data = Map<String, dynamic>.from(dataMap[ApiFields.data]);
      } catch (_) {
        List<Map<String, dynamic>> resourceList =
            List<Map<String, dynamic>>.from(dataMap[ApiFields.data]);

        try {
          data = resourceList.first;
        } catch (__) {
          data = {};
        }
      }
    } else {
      data = dataMap;
    }

    return data;
  }

  /// Used to extract the desired data from a raw JSON data map response.
  ///
  /// Returns `null` if the desired list can not be extracted.
  ///
  /// Example
  ///
  /// ```dart
  /// /// Raw response
  /// {
  ///   "errors": [],
  ///   "data":
  ///   [
  ///     {
  ///       "id": ...
  ///       ...
  ///     },
  ///     {
  ///       "id2": ...
  ///       ...
  ///     }
  ///   ]
  /// }
  ///
  /// /// Desired JSON data
  /// [
  ///   {
  ///     "id": ...
  ///     ...
  ///   },
  ///   {
  ///     "id2": ...
  ///     ...
  ///   }
  /// ]
  /// ```
  static List<Map<String, dynamic>>? extractDataList(
      Map<String, dynamic> dataMap) {
    if (dataMap[ApiFields.data] != null && dataMap[ApiFields.id] == null) {
      try {
        return List<Map<String, dynamic>>.from(dataMap[ApiFields.data]);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  /// This method hashes a map in such a way that two different maps that look
  /// the same, will have the same hash.
  ///
  /// ```dart
  /// Map map1 = {"item1": 1, "item2": 2, "item3": 3};
  /// Map map2 = {"item1": 1, "item2": 2, "item3": 3};
  /// Map map3 = {"item6": 6, "item7": 7, "item8": 8};
  ///
  /// hashAllUnorderedMap(map1) == hashAllUnorderedMap(map2) // true
  /// hashAllUnorderedMap(map1) == hashAllUnorderedMap(map3) // false
  /// ```
  ///
  /// Unlike [hashAllUnorderedMap], this method does care about the order of the
  /// key-value pairs.
  ///
  /// ```dart
  /// Map map1 = {"item1": 1, "item2": 2, "item3": 3};
  /// Map map2 = {"item2": 2, "item3": 3, "item1": 1};
  /// Map map3 = {"item1": 2, "item2": 1, "item3": 3};
  ///
  /// hashAllUnorderedMap(map1) == hashAllUnorderedMap(map2) // false
  /// hashAllUnorderedMap(map1) == hashAllUnorderedMap(map3) // false
  /// ```
  static int hashAllMap(Map map) {
    List<int> hashes = [];

    map.forEach((key, value) => hashes.add(Object.hash(key, value)));

    return Object.hashAll(hashes);
  }

  /// This method hashes a map in such a way that two different maps that have
  /// the same key-value pairs, will have the same hash.
  ///
  /// ```dart
  /// Map map1 = {"item1": 1, "item2": 2, "item3": 3};
  /// Map map2 = {"item1": 1, "item2": 2, "item3": 3};
  /// Map map3 = {"item6": 6, "item7": 7, "item8": 8};
  ///
  /// hashAllUnorderedMap(map1) == hashAllUnorderedMap(map2) // true
  /// hashAllUnorderedMap(map1) == hashAllUnorderedMap(map3) // false
  /// ```
  ///
  /// Unlike [hashAllMap], this method does not care about the order of the
  /// key-value pairs.
  ///
  /// ```dart
  /// Map map1 = {"item1": 1, "item2": 2, "item3": 3};
  /// Map map2 = {"item2": 2, "item3": 3, "item1": 1};
  /// Map map3 = {"item1": 2, "item2": 1, "item3": 3};
  ///
  /// hashAllUnorderedMap(map1) == hashAllUnorderedMap(map2) // true
  /// hashAllUnorderedMap(map1) == hashAllUnorderedMap(map3) // false
  /// ```
  static int hashAllUnorderedMap(Map map) {
    List<int> hashes = [];

    map.forEach((key, value) => hashes.add(Object.hash(key, value)));

    return Object.hashAllUnordered(hashes);
  }

  /// This method generates and returns a random integer from `min` to `max`
  /// (inclusive).
  static int randInt(int min, int max) {
    // If `min` and `max` are the same number, just return that number.
    if (min == max) {
      return min;
    }

    // If `min` is greater than `max`, swap their values.
    if (min > max) {
      int temp = min;
      min = max;
      max = temp;
    }

    // Find the random number in the range, and return it.
    return Random().nextInt((max + 1) - min) + min;
  }
}
