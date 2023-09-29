import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Represents an incident affecting a station elevator or escalator.
///
/// ADA stands for Americans with Disabilities Act.
class AdaIncident {
  /// Creates an [AdaIncident] object.
  const AdaIncident({
    required this.timeOfInitialReport,
    required this.timeOfLastUpdate,
    this.estimatedTimeOfFix,
    required this.locationDescription,
    required this.stationCode,
    required this.stationName,
    required this.symptomDescription,
    required this.unitName,
    required this.unitType,
  });

  /// Creates an [AdaIncident] object from a JSON object.
  factory AdaIncident.fromJson(Map<String, dynamic> json) {
    return AdaIncident(
      timeOfInitialReport:
          DateTime.tryParse(json[ApiFields.dateOutOfService] ?? '') ??
              emptyDateTime,
      timeOfLastUpdate:
          DateTime.tryParse(json[ApiFields.dateUpdated] ?? '') ?? emptyDateTime,
      estimatedTimeOfFix:
          DateTime.tryParse(json[ApiFields.estimatedTimeOfFix] ?? ''),
      locationDescription: json[ApiFields.locationDescription] ?? '',
      stationCode: json[ApiFields.stationCode] ?? '',
      stationName: json[ApiFields.stationName] ?? '',
      symptomDescription: json[ApiFields.symptomDescription] ?? '',
      unitName: json[ApiFields.unitName] ?? '',
      unitType: AdaUnitType.fromString(
          json[ApiFields.unitType] ?? AdaUnitType.unknown.value),
    );
  }

  /// Creates an empty [AdaIncident] object.
  AdaIncident.empty()
      : timeOfInitialReport = emptyDateTime,
        timeOfLastUpdate = emptyDateTime,
        estimatedTimeOfFix = null,
        locationDescription = '',
        stationCode = '',
        stationName = '',
        symptomDescription = '',
        unitName = '',
        unitType = AdaUnitType.unknown;

  /// Whether or not this [AdaIncident] is empty.
  bool get isEmpty =>
      timeOfInitialReport == emptyDateTime &&
      timeOfLastUpdate == emptyDateTime &&
      estimatedTimeOfFix == null &&
      locationDescription.isEmpty &&
      stationCode.isEmpty &&
      stationName.isEmpty &&
      symptomDescription.isEmpty &&
      unitName.isEmpty &&
      identical(unitType, AdaUnitType.unknown);

  /// Whether or not this [AdaIncident] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Date and time (Eastern Standard Time) unit was reported out of service.
  final DateTime timeOfInitialReport;

  /// Date and time (Eastern Standard Time) outage details was last updated.
  final DateTime timeOfLastUpdate;

  /// Estimated date and time (Eastern Standard Time) by when unit is expected
  /// to return to normal service.
  ///
  /// Will be `null` if no estimate is available.
  final DateTime? estimatedTimeOfFix;

  /// Free-text description of the unit location within a station.
  ///
  /// e.g.: Escalator between mezzanine and platform.
  final String locationDescription;

  /// Unique identifier for the station.
  final String stationCode;

  /// Full station name.
  ///
  /// May include entrance information (e.g.: Metro Center, G and 11th St
  /// Entrance).
  final String stationName;

  /// Description for why the unit is out of service or otherwise in reduced
  /// operation.
  final String symptomDescription;

  /// Unique identifier for unit, by type.
  ///
  /// A single elevator and escalator may have the same [unitName], but no two
  /// elevators or two escalators will have the same [unitName].
  final String unitName;

  /// Type of unit.
  final AdaUnitType unitType;

  /// Returns a JSON object representing this [AdaIncident].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ApiFields.dateOutOfService: timeOfInitialReport.toWmataString(),
      ApiFields.dateUpdated: timeOfLastUpdate.toWmataString(),
      ApiFields.estimatedTimeOfFix: estimatedTimeOfFix?.toWmataString(),
      ApiFields.locationDescription: locationDescription,
      ApiFields.stationCode: stationCode,
      ApiFields.stationName: stationName,
      ApiFields.symptomDescription: symptomDescription,
      ApiFields.unitName: unitName,
      ApiFields.unitType: unitType.value,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is AdaIncident &&
        other.timeOfInitialReport == timeOfInitialReport &&
        other.timeOfLastUpdate == timeOfLastUpdate &&
        ((other.estimatedTimeOfFix == null && estimatedTimeOfFix == null) ||
            ((other.estimatedTimeOfFix != null && estimatedTimeOfFix != null) &&
                (other.estimatedTimeOfFix == estimatedTimeOfFix))) &&
        other.locationDescription == locationDescription &&
        other.stationCode == stationCode &&
        other.stationName == stationName &&
        other.symptomDescription == symptomDescription &&
        other.unitName == unitName &&
        other.unitType == unitType;
  }

  @override
  int get hashCode => Object.hash(
        timeOfInitialReport,
        timeOfLastUpdate,
        estimatedTimeOfFix,
        locationDescription,
        stationCode,
        stationName,
        symptomDescription,
        unitName,
        unitType,
      );

  @override
  String toString() => "Instance of 'AdaIncident' ${toJson().toString()}";
}

/// Enum representing the type of unit.
enum AdaUnitType {
  elevator("ELEVATOR"),
  escalator("ESCALATOR"),
  unknown("UNKNOWN");

  const AdaUnitType(this.value);

  /// The string representation of this [AdaUnitType].
  final String value;

  /// Get a [AdaUnitType] from a given string `value`.
  static AdaUnitType fromString(String value) {
    return values.firstWhere(
      (unitType) => unitType.value == value,
      orElse: () => unknown,
    );
  }
}
