import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Represents a stop in a schedule.
class ScheduleStop {
  /// Creates a [ScheduleStop] object.
  const ScheduleStop({
    required this.stopId,
    required this.name,
    required this.seqNum,
    required this.time,
  });

  /// Creates a [ScheduleStop] object from a JSON object.
  factory ScheduleStop.fromJson(Map<String, dynamic> json) {
    return ScheduleStop(
      stopId: int.parse((json[ApiFields.stopId] ?? '0') as String),
      name: json[ApiFields.name] ?? '',
      seqNum: ((json[ApiFields.seqNum] ?? -1) as num).toInt(),
      time: DateTime.tryParse(json[ApiFields.time] ?? '') ?? emptyDateTime,
    );
  }

  /// Creates an empty [ScheduleStop] object.
  ScheduleStop.empty()
      : stopId = 0,
        name = '',
        seqNum = -1,
        time = emptyDateTime;

  /// Whether or not this object is empty.
  bool get isEmpty =>
      stopId == 0 && name.isEmpty && seqNum == -1 && time == emptyDateTime;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// 7-digit regional ID which can be used in various bus-related methods.
  ///
  /// If unavailable, the `stopId` will be `0`.
  final int stopId;

  /// Stop name.
  ///
  /// May be slightly different from what is spoken or displayed in the bus.
  final String name;

  /// Order of the stop in the sequence of stops.
  final int seqNum;

  /// Scheduled departure date and time (Eastern Standard Time) from this stop.
  final DateTime time;

  /// Returns a JSON object which represents this object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ApiFields.stopId: stopId,
      ApiFields.name: name,
      ApiFields.seqNum: seqNum,
      ApiFields.time: time.toWmataString(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ScheduleStop &&
        other.stopId == stopId &&
        other.name == name &&
        other.seqNum == seqNum &&
        other.time == time;
  }

  @override
  int get hashCode => Object.hash(
        stopId,
        name,
        seqNum,
        time,
      );

  @override
  String toString() => "Instance of 'ScheduleStop' ${toJson().toString()}";
}
