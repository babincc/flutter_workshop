import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents all-day parking information at a station.
class AllDayParking {
  /// Creates an [AllDayParking] object.
  AllDayParking({
    required this.totalSpaces,
    required this.riderCost,
    required this.nonRiderCost,
    required this.saturdayRiderCost,
    required this.saturdayNonRiderCost,
  });

  /// Creates an [AllDayParking] object from a JSON object.
  factory AllDayParking.fromJson(Map<String, dynamic> json) {
    return AllDayParking(
      totalSpaces: ((json[ApiFields.totalCount] ?? -1) as num).toInt(),
      riderCost: ((json[ApiFields.riderCost] ?? -1.0) as num).toDouble(),
      nonRiderCost: ((json[ApiFields.nonRiderCost] ?? -1.0) as num).toDouble(),
      saturdayRiderCost:
          ((json[ApiFields.saturdayRiderCost] ?? -1.0) as num).toDouble(),
      saturdayNonRiderCost:
          ((json[ApiFields.saturdayNonRiderCost] ?? -1.0) as num).toDouble(),
    );
  }

  /// Creates an empty [AllDayParking] object.
  AllDayParking.empty()
      : totalSpaces = -1,
        riderCost = -1.0,
        nonRiderCost = -1.0,
        saturdayRiderCost = -1.0,
        saturdayNonRiderCost = -1.0;

  /// Whether or not this [AllDayParking] object is empty.
  bool get isEmpty =>
      totalSpaces == -1 &&
      riderCost == -1.0 &&
      nonRiderCost == -1.0 &&
      saturdayRiderCost == -1.0 &&
      saturdayNonRiderCost == -1.0;

  /// Whether or not this [AllDayParking] object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Number of all-day parking spots available at a station.
  final int totalSpaces;

  /// All-day cost per day (weekday) for Metro riders.
  ///
  /// `null` when no all-day spots are available. For most stations, this value
  /// is identical to the [nonRiderCost].
  ///
  /// For cases where the [nonRiderCost] is different, the lower cost per day
  /// requires a valid rail trip using a SmarTrip® card originating from a
  /// station other than the one where the patron parked. To receive this lower
  /// rate, patrons must pay for their parking with the same SmarTrip® card used
  /// to enter/exit Metrorail, and must exit the parking lot within two hours of
  /// exiting Metrorail.
  final double riderCost;

  /// All-day cost per day (weekday) for non-Metro riders.
  ///
  /// `null` when no all-day spots are available.For most stations, this value
  /// is identical to the [riderCost].
  ///
  /// For cases where the [riderCost] is different, the lower cost per day
  /// requires a valid rail trip using a SmarTrip® card originating from a
  /// station other than the one where the patron parked. To receive this lower
  /// rate, patrons must pay for their parking with the same SmarTrip® card used
  /// to enter/exit Metrorail, and must exit the parking lot within two hours of
  /// exiting Metrorail.
  final double nonRiderCost;

  /// All-day cost per day (Saturday) for Metro riders.
  ///
  /// `null` when no all-day spots are available. For most stations, this value
  /// is identical to the [saturdayNonRiderCost].
  ///
  /// For cases where the [saturdayNonRiderCost] is different, the lower cost
  /// per day requires a valid rail trip using a SmarTrip® card originating from
  /// a station other than the one where the patron parked. To receive this
  /// lower rate, patrons must pay for their parking with the same SmarTrip®
  /// card used to enter/exit Metrorail, and must exit the parking lot within
  /// two hours of exiting Metrorail.
  final double saturdayRiderCost;

  /// All-day cost per day (Saturday) for non-Metro riders.
  ///
  /// `null` when no all-day spots are available. For most stations, this value
  /// is identical to the [saturdayRiderCost].
  ///
  /// For cases where the [saturdayRiderCost] is different, the lower cost per
  /// day requires a valid rail trip using a SmarTrip® card originating from a
  /// station other than the one where the patron parked. To receive this lower
  /// rate, patrons must pay for their parking with the same SmarTrip® card used
  /// to enter/exit Metrorail, and must exit the parking lot within two hours of
  /// exiting Metrorail.
  final double saturdayNonRiderCost;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.totalCount: totalSpaces,
      ApiFields.riderCost: riderCost,
      ApiFields.nonRiderCost: nonRiderCost,
      ApiFields.saturdayRiderCost: saturdayRiderCost,
      ApiFields.saturdayNonRiderCost: saturdayNonRiderCost,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is AllDayParking &&
        other.totalSpaces == totalSpaces &&
        other.riderCost == riderCost &&
        other.nonRiderCost == nonRiderCost &&
        other.saturdayRiderCost == saturdayRiderCost &&
        other.saturdayNonRiderCost == saturdayNonRiderCost;
  }

  @override
  int get hashCode => Object.hash(
        totalSpaces,
        riderCost,
        nonRiderCost,
        saturdayRiderCost,
        saturdayNonRiderCost,
      );

  @override
  String toString() => "Instance of 'AllDayParking' ${toJson().toString()}";
}
