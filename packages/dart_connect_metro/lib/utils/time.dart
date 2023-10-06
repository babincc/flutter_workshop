/// Represents a time of day.
///
/// This is 24h time. For example, 1:30pm is represented as 13:30.
///
/// Range is 00:00 to 23:59.
class Time {
  /// Creates a new [Time] object.
  ///
  /// [hour] must be between 0 and 23.
  ///
  /// [minute] must be between 0 and 59.
  Time(int hour, int minute)
      : assert(hour >= 0 && hour <= 23,
            "Hour must be between 0 and 23 (inclusive)."),
        assert(minute >= 0 && minute <= 59,
            "Minute must be between 0 and 59 (inclusive)."),
        _dateTime = DateTime(0, 0, 0, hour, minute);

  /// Creates a new [Time] object from the current time.
  factory Time.now() {
    final DateTime now = DateTime.now();
    return Time(now.hour, now.minute);
  }

  /// Creates a new [Time] object from a [DateTime] object.
  factory Time.fromDateTime(DateTime dateTime) {
    return Time(dateTime.hour, dateTime.minute);
  }

  /// Keeps track of the time behind the scenes.
  DateTime _dateTime;

  /// The hour of the day.
  int get hour => _dateTime.hour;
  set hour(int hour) => _dateTime = DateTime(0, 0, 0, hour, minute);

  /// The minute of the [hour].
  int get minute => _dateTime.minute;
  set minute(int minute) => _dateTime = DateTime(0, 0, 0, hour, minute);

  /// Adds `duration` to this [Time] object.
  void add(Duration duration) {
    final DateTime temp = _dateTime.add(duration);

    _dateTime = DateTime(0, 0, 0, temp.hour, temp.minute);
  }

  /// Subtracts `duration` from this [Time] object.
  void subtract(Duration duration) {
    final DateTime temp = _dateTime.subtract(duration);

    _dateTime = DateTime(0, 0, 0, temp.hour, temp.minute);
  }

  /// Calculates the difference between this [Time] object and another [Time]
  /// object.
  Duration difference(Time other) => _dateTime.difference(other._dateTime);

  /// Whether or not this [Time] object is before `other`.
  bool isBefore(Time other) => _dateTime.isBefore(other._dateTime);

  /// Whether or not this [Time] object is at the same moment as `other`.
  bool isAtSameMomentAs(Time other) =>
      _dateTime.isAtSameMomentAs(other._dateTime);

  /// Whether or not this [Time] object is after `other`.
  bool isAfter(Time other) => _dateTime.isAfter(other._dateTime);

  /// Compares this [Time] object to [other], returning `0` if the values are
  /// equal.
  ///
  /// A [compareTo] function returns:
  /// - a negative value if this [Time] [isBefore] `other`.
  /// - 0 if this DateTime [isAtSameMomentAs] `other`.
  /// - a positive value if this [Time] [isAfter] `other`.
  int compareTo(Time other) => _dateTime.compareTo(other._dateTime);

  /// Returns [hour] as a two digit string, padded with a leading zero if
  /// necessary.
  ///
  /// This is 24h time. For the 12h version, use [hourStr_12h].
  String get hourStr => hour.toString().padLeft(2, '0');

  /// Returns [hour] (converted to 12h time) as a two digit string, padded with
  /// a leading zero if necessary.
  String get hourStr_12h {
    final int hour = this.hour % 12;
    return hour == 0 ? '12' : hour.toString().padLeft(2, '0');
  }

  /// Returns [minute] as a two digit string, padded with a leading zero if
  /// necessary.
  String get minuteStr => minute.toString().padLeft(2, '0');

  /// Returns [hourStr] and [minuteStr] separated by a colon.
  String get timeStr => '$hourStr:$minuteStr';

  /// Returns [hourStr_12h] and [minuteStr] separated by a colon.
  String get timeStr_12h => '$hourStr_12h:$minuteStr';

  /// Returns a [DateTime] object which represents this [Time] object.
  ///
  /// The date is set to the current date.
  DateTime toDateTime() {
    final DateTime now = DateTime.now();

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Time && other.hour == hour && other.minute == minute;
  }

  @override
  int get hashCode => Object.hash(
        hour,
        minute,
      );

  @override
  String toString() => timeStr;
}
