import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents the fare for a rail journey.
class RailFare {
  /// Creates a new [RailFare] object.
  const RailFare({
    required this.duringPeakTime,
    required this.offPeakTime,
    required this.seniorCitizen,
  });

  /// Creates a new [RailFare] object from a JSON object.
  factory RailFare.fromJson(Map<String, dynamic> json) {
    return RailFare(
      duringPeakTime: ((json[ApiFields.peakTime] ?? -1.0) as num).toDouble(),
      offPeakTime: ((json[ApiFields.offPeakTime] ?? -1.0) as num).toDouble(),
      seniorCitizen:
          ((json[ApiFields.seniorDisabled] ?? -1.0) as num).toDouble(),
    );
  }

  /// Creates an empty [RailFare] object.
  RailFare.empty()
      : duringPeakTime = -1.0,
        offPeakTime = -1.0,
        seniorCitizen = -1.0;

  /// Whether or not this [RailFare] object is empty.
  bool get isEmpty =>
      duringPeakTime == -1.0 && offPeakTime == -1.0 && seniorCitizen == -1.0;

  /// Whether or not this [RailFare] object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The fare for a journey during peak hours.
  ///
  /// That is:
  /// - weekdays from opening to 9:30 AM as well as 3-7 PM
  /// - weekends from midnight to closing
  final double duringPeakTime;

  /// The fare for a journey during off-peak hours.
  ///
  /// That is any time not covered by [duringPeakTime].
  final double offPeakTime;

  /// Reduced fare for senior citizens.
  ///
  /// https://www.wmata.com/fares/reduced.cfm
  final double seniorCitizen;

  /// Reduced fare for disabled citizens.
  ///
  /// Same as [seniorCitizen].
  ///
  /// https://www.wmata.com/fares/reduced.cfm
  double get disabledCitizen => seniorCitizen;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.peakTime: duringPeakTime,
      ApiFields.offPeakTime: offPeakTime,
      ApiFields.seniorDisabled: seniorCitizen,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is RailFare &&
        other.duringPeakTime == duringPeakTime &&
        other.offPeakTime == offPeakTime &&
        other.seniorCitizen == seniorCitizen;
  }

  @override
  int get hashCode => Object.hash(
        duringPeakTime,
        offPeakTime,
        seniorCitizen,
      );

  @override
  String toString() => "Instance of 'RailFare' ${toJson().toString()}";
}
