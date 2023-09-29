import 'package:dart_connect_metro/features/incidents/domain/models/ada_incident.dart';
import 'package:dart_connect_metro/features/incidents/domain/services/ada_outages_service.dart';

/// Fetches ADA incidents.
///
/// These are incidents affecting elevators and escalators. ADA stands for
/// Americans with Disabilities Act.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `stationCode` is the station code for the station you want to get incidents
/// for. If you want to get incidents for all stations, pass `null`.
Future<List<AdaIncident>> fetchAdaIncidents(
  String apiKey, {
  String? stationCode,
}) async =>
    await AdaOutagesService.fetchBusPositions(
      apiKey,
      stationCode: stationCode,
    );
