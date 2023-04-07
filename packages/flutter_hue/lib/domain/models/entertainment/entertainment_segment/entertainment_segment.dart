import 'package:flutter_hue/constants/api_fields.dart';

/// Represents an entertainment resource segment.
class EntertainmentSegment {
  /// Creates a [EntertainmentSegment] object.
  EntertainmentSegment({
    required this.start,
    required this.length,
  })  : assert(start >= 0, "`start` must be at least 0"),
        assert(length >= 1, "`length` must be at least 1");

  /// Creates a [EntertainmentSegment] object from the JSON response to a GET
  /// request.
  factory EntertainmentSegment.fromJson(Map<String, dynamic> dataMap) {
    return EntertainmentSegment(
      start: dataMap[ApiFields.start] ?? 0,
      length: dataMap[ApiFields.length] ?? 1,
    );
  }

  /// Creates an empty [EntertainmentSegment] object.
  EntertainmentSegment.empty()
      : start = 0,
        length = 1;

  /// Must be at least 0.
  final int start;

  /// Must be at least 1.
  final int length;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [action] is nullable, it is defaulted to an empty string in this
  /// method. If left as an empty string, its current value in this
  /// [EntertainmentSegment] object will be used. This way, if it is
  /// `null`, the program will know that it is intentionally being set to
  /// `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  EntertainmentSegment copyWith({
    int? start,
    int? length,
    bool copyOriginalValues = true,
  }) {
    return EntertainmentSegment(
      start: start ?? this.start,
      length: length ?? this.length,
    );
  }

  /// Converts this object into JSON format.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.start: start,
      ApiFields.length: length,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is EntertainmentSegment &&
        other.start == start &&
        other.length == length;
  }

  @override
  int get hashCode => Object.hash(start, length);

  @override
  String toString() =>
      "Instance of 'EntertainmentSegment' ${toJson().toString()}";
}
