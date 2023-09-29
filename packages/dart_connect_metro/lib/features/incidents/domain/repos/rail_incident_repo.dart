import 'package:dart_connect_metro/features/incidents/domain/models/rail_incident.dart';
import 'package:dart_connect_metro/features/incidents/domain/services/rail_incident_service.dart';

/// Fetches rail incidents.
///
/// `apiKey` is your API key for the WMATA API.
Future<List<RailIncident>> fetchRailIncidents(String apiKey) async =>
    await RailIncidentService.fetchRailIncidents(apiKey);
