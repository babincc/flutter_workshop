import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents a track circuit.
class RouteTrackCircuit implements Comparable {
  /// Creates a [RouteTrackCircuit].
  const RouteTrackCircuit({
    required this.circuitId,
    required this.seqNum,
    required this.stationCode,
  });

  /// Creates a [RouteTrackCircuit] from a JSON object.
  factory RouteTrackCircuit.fromJson(Map<String, dynamic> json) {
    return RouteTrackCircuit(
      circuitId: (json[ApiFields.circuitId] ?? -1).toString(),
      seqNum: ((json[ApiFields.seqNum] ?? -1) as num).toInt(),
      stationCode: json[ApiFields.stationCode] ?? '',
    );
  }

  /// Creates an empty [RouteTrackCircuit].
  const RouteTrackCircuit.empty()
      : circuitId = '-1',
        seqNum = -1,
        stationCode = '';

  /// Whether or not this [RouteTrackCircuit] is empty.
  bool get isEmpty => circuitId == '-1' && seqNum == -1 && stationCode.isEmpty;

  /// Whether or not this [RouteTrackCircuit] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// An internal system-wide uniquely identifiable circuit number.
  final String circuitId;

  /// Order in which the circuit appears for the given line and track.
  ///
  /// Sequences go from West to East and South to North.
  final int seqNum;

  /// If the circuit is at a station, this value will represent the station
  /// code; otherwise, it will be be `null`.
  final String stationCode;

  /// Returns a JSON representation of this [RouteTrackCircuit].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ApiFields.circuitId: int.tryParse(circuitId) ?? -1,
      ApiFields.seqNum: seqNum,
      ApiFields.stationCode: stationCode,
    };
  }

  @override
  int compareTo(other) => seqNum.compareTo(other.seqNum);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is RouteTrackCircuit &&
        other.circuitId == circuitId &&
        other.seqNum == seqNum &&
        other.stationCode == stationCode;
  }

  @override
  int get hashCode => Object.hash(
        circuitId,
        seqNum,
        stationCode,
      );

  @override
  String toString() => "Instance of 'RouteTrackCircuit' ${toJson().toString()}";
}
