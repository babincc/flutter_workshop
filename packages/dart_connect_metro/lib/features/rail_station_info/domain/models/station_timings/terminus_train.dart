import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';
import 'package:dart_connect_metro/utils/time.dart';

/// Represents a train that is either the first or last train of the day at a
/// station.
class TerminusTrain {
  /// Creates a [TerminusTrain].
  const TerminusTrain({
    required this.time,
    required this.destination,
  });

  /// Creates a [TerminusTrain] from JSON data.
  factory TerminusTrain.fromJson(Map<String, dynamic> json) {
    final String timeStr = json[ApiFields.time] ?? '';

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

    return TerminusTrain(
      time: time,
      destination: json[ApiFields.destinationStation],
    );
  }

  /// Creates an empty [TerminusTrain].
  TerminusTrain.empty()
      : time = emptyTime,
        destination = '';

  /// Whether or not this [TerminusTrain] is empty.
  bool get isEmpty => time == emptyTime && destination.isEmpty;

  /// Whether or not this [TerminusTrain] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The time that the train leaves the station.
  final Time time;

  /// Station code for the train's destination.
  final String destination;

  /// Returns a JSON representation of this [TerminusTrain].
  Map<String, dynamic> toJson() {
    return {
      ApiFields.time: time.toString(),
      ApiFields.destinationStation: destination,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is TerminusTrain &&
        other.time == time &&
        other.destination == destination;
  }

  @override
  int get hashCode => Object.hash(
        time,
        destination,
      );

  @override
  String toString() => "Instance of 'TerminusTrain' ${toJson().toString()}";
}
