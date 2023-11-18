import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/utils/equality_tool.dart';

/// Represents the coordinates of a wanted person.
class WantedPersonCoordinates {
  /// Creates a new [WantedPersonCoordinates] object.
  const WantedPersonCoordinates({
    this.longitude,
    this.latitude,
    this.formatted,
  });

  /// Creates a [WantedPersonCoordinates] object from a JSON object.
  factory WantedPersonCoordinates.fromJson(Map<String, dynamic> json) {
    return WantedPersonCoordinates(
      longitude: json[ApiFields.longitude],
      latitude: json[ApiFields.latitude],
      formatted: json[ApiFields.formatted],
    );
  }

  /// Creates an empty [WantedPersonCoordinates] object.
  WantedPersonCoordinates.empty()
      : longitude = null,
        latitude = null,
        formatted = null;

  /// Whether or not this object is empty.
  bool get isEmpty =>
      longitude == null && latitude == null && formatted == null;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The longitude of the location.
  final double? longitude;

  /// The latitude of the location.
  final double? latitude;

  /// The formatted address of the location.
  final String? formatted;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.longitude: longitude,
      ApiFields.latitude: latitude,
      ApiFields.formatted: formatted,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is WantedPersonCoordinates &&
        other.longitude.equals(longitude) &&
        other.latitude.equals(latitude) &&
        other.formatted.equals(formatted);
  }

  @override
  int get hashCode => Object.hash(
        longitude,
        latitude,
        formatted,
      );

  @override
  String toString() =>
      "Instance of 'WantedPersonCoordinates' ${toJson().toString()}";
}
