import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/time_format_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represent the time that a smart scene timeslot starts.
class SmartSceneWeekStartTime {
  /// Creates a [SmartSceneWeekStartTime] object.
  SmartSceneWeekStartTime({
    required this.kind,
    required int hour,
    required int minute,
    required int second,
  })  : assert(hour >= 0 && hour <= 23,
            "`hour` must be between 0 and 23 (inclusive)"),
        assert(minute >= 0 && minute <= 59,
            "`minute` must be between 0 and 59 (inclusive)"),
        assert(second >= 0 && second <= 59,
            "`second` must be between 0 and 59 (inclusive)"),
        _originalKind = kind,
        _hour = hour,
        _originalHour = hour,
        _minute = minute,
        _originalMinute = minute,
        _second = second,
        _originalSecond = second;

  /// Creates a [SmartSceneWeekStartTime] object from the JSON response to a GET
  /// request.
  factory SmartSceneWeekStartTime.fromJson(Map<String, dynamic> dataMap) {
    Map<String, dynamic> timeMap =
        Map<String, dynamic>.from(dataMap[ApiFields.time] ?? {});

    return SmartSceneWeekStartTime(
      kind: dataMap[ApiFields.kind] ?? "",
      hour: timeMap[ApiFields.hour] ?? 0,
      minute: timeMap[ApiFields.minute] ?? 0,
      second: timeMap[ApiFields.second] ?? 0,
    );
  }

  /// Creates an empty [SmartSceneWeekStartTime] object.
  SmartSceneWeekStartTime.empty()
      : kind = "",
        _originalKind = "",
        _hour = 0,
        _originalHour = 0,
        _minute = 0,
        _originalMinute = 0,
        _second = 0,
        _originalSecond = 0;

  /// "time"
  String kind;

  /// The value [kind] when this object was instantiated.
  String _originalKind;

  int _hour;

  /// Range: 0 - 23 (inclusive)
  ///
  /// Throws [InvalidHourException] if `hour` is set to a value that is not in
  /// the valid range.
  int get hour => _hour;
  set hour(int hour) {
    if (hour >= 0 && hour <= 23) {
      _hour = hour;
    } else {
      throw InvalidHourException.withValue(hour);
    }
  }

  /// The value [hour] when this object was instantiated.
  int _originalHour;

  int _minute;

  /// Range: 0 - 59 (inclusive)
  ///
  /// Throws [InvalidMinuteException] if `minute` is set to a value that is not
  /// in the valid range.
  int get minute => _minute;
  set minute(int minute) {
    if (minute >= 0 && minute <= 59) {
      _minute = minute;
    } else {
      throw InvalidMinuteException.withValue(minute);
    }
  }

  /// The value [minute] when this object was instantiated.
  int _originalMinute;

  int _second;

  /// Range: 0 - 59 (inclusive)
  ///
  /// Throws [InvalidSecondException] if `second` is set to a value that is not
  /// in the valid range.
  int get second => _second;
  set second(int second) {
    if (second >= 0 && second <= 59) {
      _second = second;
    } else {
      throw InvalidSecondException.withValue(second);
    }
  }

  /// The value [second] when this object was instantiated.
  int _originalSecond;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      kind != _originalKind ||
      hour != _originalHour ||
      minute != _originalMinute ||
      second != _originalSecond;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalKind = kind;
    _originalHour = hour;
    _originalMinute = minute;
    _originalSecond = second;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  SmartSceneWeekStartTime copyWith({
    String? kind,
    int? hour,
    int? minute,
    int? second,
    bool copyOriginalValues = true,
  }) {
    SmartSceneWeekStartTime toReturn = SmartSceneWeekStartTime(
      kind: copyOriginalValues ? _originalKind : (kind ?? this.kind),
      hour: copyOriginalValues ? _originalHour : (hour ?? this.hour),
      minute: copyOriginalValues ? _originalMinute : (minute ?? this.minute),
      second: copyOriginalValues ? _originalSecond : (second ?? this.second),
    );

    if (copyOriginalValues) {
      toReturn.kind = kind ?? this.kind;
      toReturn.hour = hour ?? this.hour;
      toReturn.minute = minute ?? this.minute;
      toReturn.second = second ?? this.second;
    }

    return toReturn;
  }

  /// Converts this object into JSON format.
  ///
  /// `optimizeFor` lets the program know what information to include in the
  /// JSON data map.
  /// * [OptimizeFor.put] (the default value) is used when making a data map
  /// that is being placed in a PUT request. This only includes data that has
  /// changed.
  /// * [OptimizeFor.putFull] is used when a parent object updates; so, all of
  /// the children are required to be present for the PUT request.
  /// * [OptimizeFor.post] is used when making a data map for a POST request.
  /// * [OptimizeFor.dontOptimize] is used to get all of the data contained in
  /// this object.
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};
      Map<String, dynamic> toReturnInner = {};

      if (kind != _originalKind) {
        toReturn[ApiFields.kind] = kind;
      }

      if (hour != _originalHour) {
        toReturnInner[ApiFields.hour] = hour;
      }

      if (minute != _originalMinute) {
        toReturnInner[ApiFields.minute] = minute;
      }

      if (second != _originalSecond) {
        toReturnInner[ApiFields.second] = second;
      }

      if (toReturnInner.isNotEmpty) {
        toReturn[ApiFields.time] = toReturnInner;
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.kind: kind,
      ApiFields.time: {
        ApiFields.hour: hour,
        ApiFields.minute: minute,
        ApiFields.second: second,
      },
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is SmartSceneWeekStartTime &&
        other.kind == kind &&
        other.hour == hour &&
        other.minute == minute &&
        other.second == second;
  }

  @override
  int get hashCode => Object.hash(
        kind,
        hour,
        minute,
        second,
      );

  @override
  String toString() =>
      "Instance of 'SmartSceneWeekStartTime' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
