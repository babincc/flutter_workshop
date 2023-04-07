import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// An entertainment configuration's position.
class EntertainmentConfigurationPosition {
  /// Creates a [EntertainmentConfigurationPosition] object.
  EntertainmentConfigurationPosition({
    required this.x,
    required this.y,
    required this.z,
  })  : assert(x >= -1 && x <= 1, "`x` must be between -1 and 1 (inclusive)"),
        assert(y >= -1 && y <= 1, "`y` must be between -1 and 1 (inclusive)"),
        assert(z >= -1 && z <= 1, "`z` must be between -1 and 1 (inclusive)");

  /// Creates a [EntertainmentConfigurationPosition] object from the JSON
  /// response to a GET request.
  factory EntertainmentConfigurationPosition.fromJson(
      Map<String, dynamic> dataMap) {
    return EntertainmentConfigurationPosition(
      x: dataMap[ApiFields.x] ?? 0.0,
      y: dataMap[ApiFields.y] ?? 0.0,
      z: dataMap[ApiFields.z] ?? 0.0,
    );
  }

  /// Creates an empty [EntertainmentConfigurationPosition] object.
  EntertainmentConfigurationPosition.empty()
      : x = 0.0,
        y = 0.0,
        z = 0.0;

  /// Coordinate of a single axis.
  final double x;

  /// Coordinate of a single axis.
  final double y;

  /// Coordinate of a single axis.
  final double z;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  EntertainmentConfigurationPosition copyWith({
    double? x,
    double? y,
    double? z,
    bool copyOriginalValues = true,
  }) {
    return EntertainmentConfigurationPosition(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
    );
  }

  /// Converts this object into JSON format.
  ///
  /// `optimizeFor` lets the program know what information to include in the
  /// JSON data map.
  /// * [OptimizeFor.put] (the default value) is used when making a data map
  /// that is being placed in a PUT request. This only includes data that has
  /// changed.
  /// * [OptimizeFor.putFull] is used when a parent object updates; so, all of
  /// the children are required to be present for the PUT request.
  /// * [OptimizeFor.post] is used when making a data map for a POST request.
  /// * [OptimizeFor.dontOptimize] is used to get all of the data contained in
  /// this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.x: x,
      ApiFields.y: y,
      ApiFields.z: z,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is EntertainmentConfigurationPosition &&
        other.x == x &&
        other.y == y &&
        other.z == z;
  }

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  String toString() =>
      "Instance of 'EntertainmentConfigurationPosition' ${toJson().toString()}";
}
