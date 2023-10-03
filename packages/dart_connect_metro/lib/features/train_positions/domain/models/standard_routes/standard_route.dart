import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/train_positions/domain/models/standard_routes/route_track_circuit.dart';

/// Standard route model.
class StandardRoute {
  /// Creates a new [StandardRoute] object.
  const StandardRoute({
    required this.lineCode,
    required this.trackCircuits,
    required this.trackNum,
  });

  /// Creates a [StandardRoute] from a JSON object.
  factory StandardRoute.fromJson(Map<String, dynamic> json) {
    return StandardRoute(
      lineCode: json[ApiFields.lineCode] ?? '',
      trackCircuits: ((json[ApiFields.trackCircuits] as List?) ?? [])
          .map((trackCircuit) => RouteTrackCircuit.fromJson(trackCircuit))
          .toList()
        ..sort(),
      trackNum: ((json[ApiFields.trackNum] ?? -1) as num).toInt(),
    );
  }

  /// Creates an empty [StandardRoute].
  const StandardRoute.empty()
      : lineCode = '',
        trackCircuits = const [],
        trackNum = -1;

  /// Whether or not this [StandardRoute] is empty.
  bool get isEmpty =>
      lineCode.isEmpty && trackCircuits.isEmpty && trackNum == -1;

  /// Whether or not this [StandardRoute] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Abbreviation for the revenue line.
  final String lineCode;

  /// Array containing ordered track circuit information.
  final List<RouteTrackCircuit> trackCircuits;

  /// Track number (`1` or `2`).
  final int trackNum;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.lineCode: lineCode,
      ApiFields.trackNum: trackNum,
      ApiFields.trackCircuits:
          trackCircuits.map((trackCircuit) => trackCircuit.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is StandardRoute &&
        other.lineCode == lineCode &&
        const DeepCollectionEquality.unordered()
            .equals(other.trackCircuits, trackCircuits) &&
        other.trackNum == trackNum;
  }

  @override
  int get hashCode => Object.hash(
        lineCode,
        Object.hashAllUnordered(trackCircuits),
        trackNum,
      );

  @override
  String toString() => "Instance of 'StandardRoute' ${toJson().toString()}";
}
