import 'package:dart_connect_metro/constants/api_fields.dart';

class ShapePoint implements Comparable<ShapePoint> {
  /// Creates a [ShapePoint] object.
  ShapePoint({
    required this.latitude,
    required this.longitude,
    required this.seqNum,
  });

  /// Creates a [ShapePoint] object from a JSON object.
  factory ShapePoint.fromJson(Map<String, dynamic> json) {
    return ShapePoint(
      latitude: ((json[ApiFields.latitude] ?? 0.0) as num).toDouble(),
      longitude: ((json[ApiFields.longitude] ?? 0.0) as num).toDouble(),
      seqNum: ((json[ApiFields.seqNum] ?? -1) as num).toInt(),
    );
  }

  /// Creates an empty [ShapePoint] object.
  ShapePoint.empty()
      : latitude = 0.0,
        longitude = 0.0,
        seqNum = -1;

  /// Whether or not this object is empty.
  bool get isEmpty => latitude == 0.0 && longitude == 0.0 && seqNum == -1;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  final double latitude;

  final double longitude;

  /// Order of the point in the sequence of shape points.
  final int seqNum;

  /// Returns a JSON object which represents this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.latitude: latitude,
      ApiFields.longitude: longitude,
      ApiFields.seqNum: seqNum,
    };
  }

  @override
  int compareTo(ShapePoint other) => seqNum.compareTo(other.seqNum);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ShapePoint &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.seqNum == seqNum;
  }

  @override
  int get hashCode => Object.hash(
        latitude,
        longitude,
        seqNum,
      );

  @override
  String toString() => "Instance of 'ShapePoint' ${toJson().toString()}";
}
