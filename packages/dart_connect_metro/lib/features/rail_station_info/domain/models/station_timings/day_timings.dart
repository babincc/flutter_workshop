import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/station_timings/terminus_train.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';
import 'package:dart_connect_metro/utils/time.dart';

/// Represents the timing of certain events at a station on a given day.
class DayTimings {
  /// Creates a new [DayTimings] object.
  const DayTimings({
    required this.openingTime,
    required this.firstTrains,
    required this.lastTrains,
  });

  /// Creates a new [DayTimings] object from JSON data.
  factory DayTimings.fromJson(Map<String, dynamic> json) {
    final String timeStr = json[ApiFields.openingTime] ?? '';

    late final Time time;

    if (timeStr.isEmpty) {
      time = emptyTime;
    } else {
      if (!RegExp(r'\d{2}:\d{2}').hasMatch(timeStr)) {
        time = emptyTime;
      } else {
        final String hourStr = timeStr.substring(0, 2);
        final String minuteStr = timeStr.substring(3);

        final int hour = int.parse(hourStr);
        final int minute = int.parse(minuteStr);

        time = Time(hour, minute);
      }
    }

    return DayTimings(
      openingTime: time,
      firstTrains: ((json[ApiFields.firstTrains] as List?) ?? [])
          .map((stop) => TerminusTrain.fromJson(stop))
          .toList(),
      lastTrains: ((json[ApiFields.lastTrains] as List?) ?? [])
          .map((stop) => TerminusTrain.fromJson(stop))
          .toList(),
    );
  }

  /// Creates an empty [DayTimings] object.
  DayTimings.empty()
      : openingTime = emptyTime,
        firstTrains = const [],
        lastTrains = const [];

  /// Whether or not this [DayTimings] object is empty.
  bool get isEmpty =>
      openingTime == emptyTime && firstTrains.isEmpty && lastTrains.isEmpty;

  /// Whether or not this [DayTimings] object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Station opening time.
  final Time openingTime;

  /// Structure containing information about the first train of the day.
  final List<TerminusTrain> firstTrains;

  /// Structure containing information about the last train of the day.
  final List<TerminusTrain> lastTrains;

  /// Returns a JSON representation of this [DayTimings] object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.openingTime: openingTime.toString(),
      ApiFields.firstTrains:
          firstTrains.map((train) => train.toJson()).toList(),
      ApiFields.lastTrains: lastTrains.map((train) => train.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is DayTimings &&
        other.openingTime == openingTime &&
        const DeepCollectionEquality.unordered()
            .equals(other.firstTrains, firstTrains) &&
        const DeepCollectionEquality.unordered()
            .equals(other.lastTrains, lastTrains);
  }

  @override
  int get hashCode => Object.hash(
        openingTime,
        Object.hashAllUnordered(firstTrains),
        Object.hashAllUnordered(lastTrains),
      );

  @override
  String toString() => "Instance of 'DayTimings' ${toJson().toString()}";
}
