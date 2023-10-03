import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents a track circuit neighbor.
class TrackCircuitNeighbor {
  /// Creates a [TrackCircuitNeighbor].
  const TrackCircuitNeighbor({
    required this.circuitIds,
    required this.neighborType,
  });

  /// Creates a [TrackCircuitNeighbor] from a JSON object.
  factory TrackCircuitNeighbor.fromJson(Map<String, dynamic> json) {
    final List<int> circuitIds =
        List<int>.from(json[ApiFields.circuitIds] ?? []);

    return TrackCircuitNeighbor(
      circuitIds: circuitIds.map((id) => id.toString()).toList(),
      neighborType: NeighborType.fromString(
          json[ApiFields.neighborType] ?? NeighborType.unknown.value),
    );
  }

  /// Creates an empty [TrackCircuitNeighbor].
  const TrackCircuitNeighbor.empty()
      : circuitIds = const [],
        neighborType = NeighborType.unknown;

  /// Whether or not this [TrackCircuitNeighbor] is empty.
  bool get isEmpty =>
      circuitIds.isEmpty && identical(neighborType, NeighborType.unknown);

  /// Whether or not this [TrackCircuitNeighbor] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Array containing neighboring circuit ids.
  final List<String> circuitIds;

  /// Left or Right neighbor group.
  ///
  /// Generally speaking, left neighbors are to the west and south, while right
  /// neighbors are to the east/north.
  final NeighborType neighborType;

  /// Returns a JSON representation of this [TrackCircuitNeighbor].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ApiFields.circuitIds:
          circuitIds.map((e) => int.tryParse(e) ?? -1).toList(),
      ApiFields.neighborType: neighborType.value,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is TrackCircuitNeighbor &&
        const DeepCollectionEquality.unordered()
            .equals(other.circuitIds, circuitIds) &&
        other.neighborType == neighborType;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(circuitIds),
        neighborType,
      );

  @override
  String toString() =>
      "Instance of 'TrackCircuitNeighbor' ${toJson().toString()}";
}

/// The type of neighbor of a track circuit.
enum NeighborType {
  left('Left'),
  right('Right'),
  unknown(ApiFields.unknown);

  const NeighborType(this.value);

  /// The string representation of this [NeighborType].
  final String value;

  /// Get a [NeighborType] from a given string `value`.
  static NeighborType fromString(String value) {
    return values.firstWhere(
      (unitType) => unitType.value == value,
      orElse: () => unknown,
    );
  }
}
