import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents short-term parking information at a station.
class ShortTermParking {
  /// Creates a [ShortTermParking] object.
  ShortTermParking({
    required this.totalSpaces,
    this.notes,
  });

  /// Creates a [ShortTermParking] object from a JSON object.
  factory ShortTermParking.fromJson(Map<String, dynamic> json) {
    return ShortTermParking(
      totalSpaces: ((json[ApiFields.totalCount] ?? -1) as num).toInt(),
      notes: json[ApiFields.notes],
    );
  }

  /// Creates an empty [ShortTermParking] object.
  ShortTermParking.empty()
      : totalSpaces = -1,
        notes = null;

  /// Whether or not this [ShortTermParking] object is empty.
  bool get isEmpty => totalSpaces == -1 && notes == null;

  /// Whether or not this [ShortTermParking] object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Number of short-term parking spots available at a station (parking
  /// meters).
  final int totalSpaces;

  /// Misc. information relating to short-term parking.
  ///
  /// `null` when no short-term spots are available.
  final String? notes;

  /// Returns a JSON representation of this [ShortTermParking] object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.totalCount: totalSpaces,
      ApiFields.notes: notes,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ShortTermParking &&
        other.totalSpaces == totalSpaces &&
        ((other.notes == null && notes == null) ||
            ((other.notes != null && notes != null) && (other.notes == notes)));
  }

  @override
  int get hashCode => Object.hash(
        totalSpaces,
        notes,
      );

  @override
  String toString() => "Instance of 'ShortTermParking' ${toJson().toString()}";
}
