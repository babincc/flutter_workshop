import 'package:dart_connect_metro/features/incidents/domain/models/bus_incident.dart';
import 'package:dart_connect_metro/features/incidents/domain/services/bus_incident_service.dart';

/// Fetches bus incidents for a specific route.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `routeId` is the base route name as shown on the bus. Note that the base
/// route name could also refer to any variant, so a RouteID of 10A could
/// refer to 10A, 10Av1, 10Av2, etc.
Future<List<BusIncident>> fetchBusIncidents(
  String apiKey, {
  String? routeId,
}) async =>
    await BusIncidentService.fetchBusIncidents(apiKey, routeId: routeId);
