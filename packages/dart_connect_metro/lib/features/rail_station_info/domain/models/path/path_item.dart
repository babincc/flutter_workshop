import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents a path between two stations.
class PathItem implements Comparable {
  /// Creates a new [PathItem] instance.
  const PathItem({
    required this.distanceToPrevFeet,
    required this.lineCode,
    required this.seqNum,
    required this.stationCode,
    required this.stationName,
  });

  /// Creates a new [PathItem] instance from a JSON object.
  factory PathItem.fromJson(Map<String, dynamic> json) {
    return PathItem(
      distanceToPrevFeet:
          ((json[ApiFields.distanceToPrev] ?? -1) as num).toInt(),
      lineCode: json[ApiFields.lineCode] ?? '',
      seqNum: ((json[ApiFields.seqNum] ?? -1) as num).toInt(),
      stationCode: json[ApiFields.stationCode] ?? '',
      stationName: json[ApiFields.stationName] ?? '',
    );
  }

  /// Creates an empty [PathItem] instance.
  PathItem.empty()
      : distanceToPrevFeet = -1,
        lineCode = '',
        seqNum = -1,
        stationCode = '',
        stationName = '';

  /// Whether or not this [PathItem] is empty.
  bool get isEmpty =>
      distanceToPrevFeet == -1 &&
      lineCode.isEmpty &&
      seqNum == -1 &&
      stationCode.isEmpty &&
      stationName.isEmpty;

  /// Distance in feet to the previous station in the list.
  final int distanceToPrevFeet;

  /// Two-letter abbreviation for the line (e.g.: RD, BL, YL, OR, GR, or SV)
  /// this station's platform is on.
  final String lineCode;

  /// Order of this station in the path.
  final int seqNum;

  /// Unique identifier for the station.
  final String stationCode;

  /// Full name for this station, as shown on the WMATA website.
  final String stationName;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() => {
        ApiFields.distanceToPrev: distanceToPrevFeet,
        ApiFields.lineCode: lineCode,
        ApiFields.seqNum: seqNum,
        ApiFields.stationCode: stationCode,
        ApiFields.stationName: stationName,
      };

  @override
  int compareTo(other) => seqNum.compareTo(other.seqNum);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is PathItem &&
        other.distanceToPrevFeet == distanceToPrevFeet &&
        other.lineCode == lineCode &&
        other.seqNum == seqNum &&
        other.stationCode == stationCode &&
        other.stationName == stationName;
  }

  @override
  int get hashCode => Object.hash(
        distanceToPrevFeet,
        lineCode,
        seqNum,
        stationCode,
        stationName,
      );

  @override
  String toString() => "Instance of 'PathItem' ${toJson().toString()}";
}
