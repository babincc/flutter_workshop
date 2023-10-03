import 'package:dart_connect_metro/constants/api_fields.dart';

/// The type of service of a train.
enum ServiceType {
  /// This is a non-revenue train with no passengers on board.
  ///
  /// Note that this designation of noPassengers does not necessarily correlate
  /// with PIDS "No Passengers". As of 08/22/2016, this functionality has been
  /// reinstated to include all non-revenue vehicles, with minor exceptions.
  noPassengers(ApiFields.noPassengers),

  /// This is a normal revenue service train.
  normal(ApiFields.normal),

  /// This is a special revenue service train with an unspecified line and
  /// destination.
  ///
  /// This is more prevalent during scheduled track work.
  special(ApiFields.special),

  /// This often denotes cases with unknown data or work vehicles.
  unknown(ApiFields.unknown);

  const ServiceType(this.value);

  /// The string representation of this [ServiceType].
  final String value;

  /// Get a [ServiceType] from a given string `value`.
  static ServiceType fromString(String value) {
    return values.firstWhere(
      (unitType) => unitType.value == value,
      orElse: () => unknown,
    );
  }
}
