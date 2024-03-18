import 'package:flutter_hue/constants/api_fields.dart';

/// Represents the mirek capabilities of a light.
class LightColorTemperatureMirekSchema {
  /// Creates a [LightColorTemperatureMirekSchema] object.
  const LightColorTemperatureMirekSchema({
    required this.min,
    required this.max,
  });

  /// Creates a [LightColorTemperatureMirekSchema] object from the JSON response
  /// to a GET request.
  factory LightColorTemperatureMirekSchema.fromJson(
      Map<String, dynamic> dataMap) {
    return LightColorTemperatureMirekSchema(
      min: dataMap[ApiFields.mirekMinimum] ?? 153,
      max: dataMap[ApiFields.mirekMaximum] ?? 500,
    );
  }

  /// Creates an empty [LightColorTemperatureMirekSchema] object.
  const LightColorTemperatureMirekSchema.empty()
      : min = 153,
        max = 500;

  /// The minimum color temperature the light supports.
  ///
  /// Range: 153 - 500
  final int min;

  /// The maximum color temperature the light supports.
  ///
  /// Range: 153 - 500
  final int max;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  LightColorTemperatureMirekSchema copyWith({
    int? min,
    int? max,
  }) {
    return LightColorTemperatureMirekSchema(
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  /// Converts this object into JSON format.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.mirekMinimum: min,
      ApiFields.mirekMaximum: max,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightColorTemperatureMirekSchema &&
        other.min == min &&
        other.max == max;
  }

  @override
  int get hashCode => Object.hash(min, max);

  @override
  String toString() =>
      "Instance of 'LightCtMirekSchema' ${toJson().toString()}";
}
