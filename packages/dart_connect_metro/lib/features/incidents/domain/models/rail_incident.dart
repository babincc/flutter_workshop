import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Represents a rail incident.
class RailIncident {
  /// Creates a [RailIncident] object.
  RailIncident({
    required this.timeOfLastUpdate,
    required this.description,
    required this.incidentId,
    required this.incidentType,
    required this.affectedLines,
  });

  /// Creates a [RailIncident] object from a JSON object.
  factory RailIncident.fromJson(Map<String, dynamic> json) {
    late final List<String> affectedLines;

    late final bool affectedLinesWasString;

    if (json[ApiFields.linesAffected] == null) {
      affectedLines = const [];
      affectedLinesWasString = false;
    } else if (json[ApiFields.linesAffected] is String) {
      final String affectedLinesString = json[ApiFields.linesAffected] ?? '';

      affectedLines = affectedLinesString
          .split(RegExp(r';[\s]?'))
          .where((line) => line.isNotEmpty)
          .toList();

      affectedLinesWasString = true;
    } else if (json[ApiFields.linesAffected] is List) {
      affectedLines = List<String>.from(json[ApiFields.linesAffected] ?? []);

      affectedLinesWasString = false;
    } else {
      affectedLines = const [];
      affectedLinesWasString = false;
    }

    return RailIncident(
      timeOfLastUpdate:
          DateTime.tryParse(json[ApiFields.dateUpdated] ?? '') ?? emptyDateTime,
      description: json[ApiFields.description] ?? '',
      incidentId: json[ApiFields.incidentId] ?? '',
      incidentType: json[ApiFields.incidentType] ?? '',
      affectedLines: affectedLines,
    ).._affectedLinesWasString = affectedLinesWasString;
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
      affectedLines.isEmpty &&
      !_affectedLinesWasString;

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

  /// Whether or not the [affectedLines] field was a string.
  bool _affectedLinesWasString = false;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      ApiFields.dateUpdated: timeOfLastUpdate.toIso8601String(),
      ApiFields.description: description,
      ApiFields.incidentId: incidentId,
      ApiFields.incidentType: incidentType,
    };

    if (_affectedLinesWasString) {
      json[ApiFields.linesAffected] = "${affectedLines.join('; ')};";
    } else {
      json[ApiFields.linesAffected] = affectedLines;
    }

    return json;
  }

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
