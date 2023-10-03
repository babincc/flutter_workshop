import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/train_positions/domain/models/track_circuits/track_circuit_neighbor.dart';

/// Represents a track circuit.
class TrackCircuit {
  /// Creates a [TrackCircuit].
  const TrackCircuit({
    required this.circuitId,
    required this.neighbors,
    required this.trackNum,
  });

  /// Creates a [TrackCircuit] from a JSON object.
  factory TrackCircuit.fromJson(Map<String, dynamic> json) {
    return TrackCircuit(
      circuitId: (json[ApiFields.circuitId] ?? -1).toString(),
      neighbors: ((json[ApiFields.neighbors] as List?) ?? [])
          .map((neighbor) => TrackCircuitNeighbor.fromJson(neighbor))
          .toList(),
      trackNum: ((json[ApiFields.track] ?? -1) as num).toInt(),
    );
  }

  /// Creates an empty [TrackCircuit].
  const TrackCircuit.empty()
      : circuitId = '-1',
        neighbors = const [],
        trackNum = -1;

  /// Whether or not this [TrackCircuit] is empty.
  bool get isEmpty => circuitId == '-1' && neighbors.isEmpty && trackNum == -1;

  /// Whether or not this [TrackCircuit] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// An internal system-wide uniquely identifiable circuit number.
  final String circuitId;

  /// Array containing track circuit neighbor information.
  ///
  /// Note that some track circuits have no neighbors in one direction. All
  /// track circuits have at least one neighbor.
  ///
  /// See
  /// https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/57644238031f59363c586dcb?
  /// for more information.
  final List<TrackCircuitNeighbor> neighbors;

  /// Track number.
  ///
  /// 1 and 2 denote "main" lines, while 0 and 3 are connectors (between
  /// different types of tracks) and pocket tracks, respectively.
  final int trackNum;

  /// Returns a JSON representation of this [TrackCircuit].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ApiFields.circuitId: int.tryParse(circuitId) ?? -1,
      ApiFields.neighbors:
          neighbors.map((neighbor) => neighbor.toJson()).toList(),
      ApiFields.track: trackNum,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is TrackCircuit &&
        other.circuitId == circuitId &&
        const DeepCollectionEquality.unordered()
            .equals(other.neighbors, neighbors) &&
        other.trackNum == trackNum;
  }

  @override
  int get hashCode => Object.hash(
        circuitId,
        Object.hashAllUnordered(neighbors),
        trackNum,
      );

  @override
  String toString() => "Instance of 'TrackCircuit' ${toJson().toString()}";
}
