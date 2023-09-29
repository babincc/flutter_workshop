import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Represents a rail incident.
class RailIncident {
  /// Creates a [RailIncident] object.
  const RailIncident({
    required this.timeOfLastUpdate,
    required this.description,
    required this.incidentId,
    required this.incidentType,
    required this.affectedLines,
  });

  /// Creates a [RailIncident] object from a JSON object.
  factory RailIncident.fromJson(Map<String, dynamic> json) {
    final String affectedLinesString = json[ApiFields.linesAffected] ?? '';

    final List<String> affectedLines = affectedLinesString
        .split(RegExp(r';[\s]?'))
        .where((line) => line.isNotEmpty)
        .toList();

    return RailIncident(
      timeOfLastUpdate:
          DateTime.tryParse(json[ApiFields.dateUpdated] ?? '') ?? emptyDateTime,
      description: json[ApiFields.description] ?? '',
      incidentId: json[ApiFields.incidentId] ?? '',
      incidentType: json[ApiFields.incidentType] ?? '',
      affectedLines: affectedLines,
    );
  }

  /// Creates an empty [RailIncident] object.
  RailIncident.empty()
      : timeOfLastUpdate = emptyDateTime,
        description = '',
        incidentId = '',
        incidentType = '',
        affectedLines = const [];

  /// Whether or not this [RailIncident] object is empty.
  bool get isEmpty =>
      timeOfLastUpdate == emptyDateTime &&
      description.isEmpty &&
      incidentId.isEmpty &&
      incidentType.isEmpty &&
      affectedLines.isEmpty;

  /// Whether or not this [RailIncident] object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Date and time (Eastern Standard Time) of last update.
  final DateTime timeOfLastUpdate;

  /// Free-text description of the incident.
  final String description;

  /// Unique identifier for an incident.
  final String incidentId;

  /// Free-text description of the incident type.
  ///
  /// Usually "Delay" or "Alert" but is subject to change at any time.
  final String incidentType;

  /// Array containing lines affected.
  final List<String> affectedLines;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() => <String, dynamic>{
        ApiFields.dateUpdated: timeOfLastUpdate.toIso8601String(),
        ApiFields.description: description,
        ApiFields.incidentId: incidentId,
        ApiFields.incidentType: incidentType,
        ApiFields.linesAffected: "${affectedLines.join('; ')};",
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is RailIncident &&
        other.timeOfLastUpdate == timeOfLastUpdate &&
        other.description == description &&
        other.incidentId == incidentId &&
        other.incidentType == incidentType &&
        const DeepCollectionEquality.unordered()
            .equals(other.affectedLines, affectedLines);
  }

  @override
  int get hashCode => Object.hash(
        timeOfLastUpdate,
        description,
        incidentId,
        incidentType,
        Object.hashAllUnordered(affectedLines),
      );

  @override
  String toString() => "Instance of 'RailIncident' ${toJson().toString()}";
}
