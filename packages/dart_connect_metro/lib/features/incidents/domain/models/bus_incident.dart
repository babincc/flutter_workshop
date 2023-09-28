import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Represents a bus incident.
class BusIncident {
  /// Creates a [BusIncident] object.
  const BusIncident({
    required this.timeOfLastUpdate,
    required this.description,
    required this.incidentId,
    required this.incidentType,
    required this.affectedRoutes,
  });

  /// Creates a [BusIncident] object from a JSON object.
  factory BusIncident.fromJson(Map<String, dynamic> json) {
    return BusIncident(
      timeOfLastUpdate:
          DateTime.tryParse(json[ApiFields.dateUpdated] ?? '') ?? emptyDateTime,
      description: json[ApiFields.description] ?? '',
      incidentId: json[ApiFields.incidentId] ?? '',
      incidentType: json[ApiFields.incidentType] ?? '',
      affectedRoutes: List<String>.from(json[ApiFields.routesAffected] ?? []),
    );
  }

  /// Creates an empty [BusIncident] object.
  BusIncident.empty()
      : timeOfLastUpdate = emptyDateTime,
        description = '',
        incidentId = '',
        incidentType = '',
        affectedRoutes = const [];

  /// Whether or not this [BusIncident] is empty.
  bool get isEmpty =>
      timeOfLastUpdate == emptyDateTime &&
      description.isEmpty &&
      incidentId.isEmpty &&
      incidentType.isEmpty &&
      affectedRoutes.isEmpty;

  /// Whether or not this [BusIncident] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Date and time (Eastern Standard Time) of last update.
  final DateTime timeOfLastUpdate;

  /// Free-text description of the delay or incident.
  final String description;

  /// Unique identifier for an incident.
  final String incidentId;

  /// Free-text description of the incident type.
  ///
  /// Usually "Delay" or "Alert" but is subject to change at any time.
  final String incidentType;

  /// Array containing routes affected.
  final List<String> affectedRoutes;

  /// Returns a JSON object representing this [BusIncident].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ApiFields.dateUpdated: timeOfLastUpdate.toWmataString(),
      ApiFields.description: description,
      ApiFields.incidentId: incidentId,
      ApiFields.incidentType: incidentType,
      ApiFields.routesAffected: affectedRoutes,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is BusIncident &&
        other.timeOfLastUpdate == timeOfLastUpdate &&
        other.description == description &&
        other.incidentId == incidentId &&
        other.incidentType == incidentType &&
        const DeepCollectionEquality.unordered()
            .equals(other.affectedRoutes, affectedRoutes);
  }

  @override
  int get hashCode => Object.hash(
        timeOfLastUpdate,
        description,
        incidentId,
        incidentType,
        Object.hashAllUnordered(affectedRoutes),
      );

  @override
  String toString() => "Instance of 'BusIncident' ${toJson().toString()}";
}
