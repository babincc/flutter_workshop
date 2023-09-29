import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents a rail line.
class Line {
  /// Creates a new [Line].
  const Line({
    required this.name,
    required this.startStationCode,
    required this.endStationCode,
    required this.internalDestination1,
    required this.internalDestination2,
    required this.lineCode,
  });

  /// Creates a new [Line] from a JSON object.
  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      name: json[ApiFields.displayName] ?? '',
      startStationCode: json[ApiFields.startStationCode] ?? '',
      endStationCode: json[ApiFields.endStationCode] ?? '',
      internalDestination1: json[ApiFields.internalDestination1] ?? '',
      internalDestination2: json[ApiFields.internalDestination2] ?? '',
      lineCode: json[ApiFields.lineCode] ?? '',
    );
  }

  /// Creates an empty [Line].
  Line.empty()
      : name = '',
        startStationCode = '',
        endStationCode = '',
        internalDestination1 = '',
        internalDestination2 = '',
        lineCode = '';

  /// Whether or not this [Line] is empty.
  bool get isEmpty =>
      name.isEmpty &&
      startStationCode.isEmpty &&
      endStationCode.isEmpty &&
      internalDestination1.isEmpty &&
      internalDestination2.isEmpty &&
      lineCode.isEmpty;

  /// Whether or not this [Line] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Full name of line color.
  final String name;

  /// Start station code.
  /// For example, will be "F11" (Branch Avenue) for the Green Line, "A15"
  /// (Shady Grove) for the Red Line, etc.
  final String startStationCode;

  /// End station code.
  ///
  /// For example, will be "E10" (Greenbelt) for the Green Line, "B11"
  /// (Glenmont) for the Red Line, etc.
  final String endStationCode;

  /// Intermediate terminal station code.
  ///
  /// During normal service, some trains on some lines might end their trip
  /// prior to the [startStationCode] or [endStationCode]. A good example is on
  /// the Red Line where some trains stop at A11 (Grosvenor) or B08 (Silver
  /// Spring).
  ///
  /// Empty string if not defined.
  final String internalDestination1;

  /// Intermediate terminal station code.
  ///
  /// During normal service, some trains on some lines might end their trip
  /// prior to the [startStationCode] or [endStationCode]. A good example is on
  /// the Red Line where some trains stop at A11 (Grosvenor) or B08 (Silver
  /// Spring).
  ///
  /// Empty string if not defined.
  final String internalDestination2;

  /// Two-letter abbreviation for the line (e.g.: RD, BL, YL, OR, GR, or SV).
  final String lineCode;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ApiFields.displayName: name,
      ApiFields.startStationCode: startStationCode,
      ApiFields.endStationCode: endStationCode,
      ApiFields.internalDestination1: internalDestination1,
      ApiFields.internalDestination2: internalDestination2,
      ApiFields.lineCode: lineCode,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Line &&
        other.name == name &&
        other.startStationCode == startStationCode &&
        other.endStationCode == endStationCode &&
        other.internalDestination1 == internalDestination1 &&
        other.internalDestination2 == internalDestination2 &&
        other.lineCode == lineCode;
  }

  @override
  int get hashCode => Object.hash(
        name,
        startStationCode,
        endStationCode,
        internalDestination1,
        internalDestination2,
        lineCode,
      );

  @override
  String toString() => "Instance of 'Line' ${toJson().toString()}";
}
