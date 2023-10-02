import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/schedule_at_stop/schedule_arrival.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/stop.dart';

/// Represents a schedule at a stop.
class ScheduleAtStop {
  /// Creates a new [ScheduleAtStop].
  const ScheduleAtStop({
    required this.arrivals,
    required this.stop,
  });

  /// Creates a new [ScheduleAtStop] from a JSON object.
  factory ScheduleAtStop.fromJson(Map<String, dynamic> json) {
    return ScheduleAtStop(
      arrivals: ((json[ApiFields.scheduleArrivals] as List?) ?? [])
          .map((arrival) => ScheduleArrival.fromJson(arrival))
          .toList(),
      stop: Stop.fromJson(json[ApiFields.stop] ?? {}),
    );
  }

  /// Creates an empty [ScheduleAtStop].
  const ScheduleAtStop.empty()
      : arrivals = const [],
        stop = const Stop.empty();

  /// Whether or not this [ScheduleAtStop] is empty.
  bool get isEmpty => arrivals.isEmpty && stop.isEmpty;

  /// Whether or not this [ScheduleAtStop] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Array containing scheduled arrival information.
  final List<ScheduleArrival> arrivals;

  /// Stop information.
  final Stop stop;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.scheduleArrivals:
          arrivals.map((arrival) => arrival.toJson()).toList(),
      ApiFields.stop: stop.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ScheduleAtStop &&
        const DeepCollectionEquality.unordered()
            .equals(other.arrivals, arrivals) &&
        other.stop == stop;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(arrivals),
        stop,
      );

  @override
  String toString() => "Instance of 'ScheduleAtStop' ${toJson().toString()}";
}
