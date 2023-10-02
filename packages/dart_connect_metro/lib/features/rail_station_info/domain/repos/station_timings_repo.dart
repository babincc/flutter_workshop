import 'package:dart_connect_metro/features/rail_station_info/domain/models/station_timings/station_timings.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/services/station_timings_service.dart';

/// Fetches station timing info.
///
/// `apiKey` is your API key for the WMATA API.
///
/// Returns opening and scheduled first/last train times based on a given
/// `stationCode`. Omit the `stationCode` to return timing information for all
/// stations.
///
/// Note that for stations with multiple platforms (e.g.: Metro Center, L'Enfant
/// Plaza, etc.), a distinct call is required for each `stationCode` to retrieve
/// the full set of train times at such stations.
Future<List<StationTimings>> fetchStationTimings(
  String apiKey, {
  String? stationCode,
}) async =>
    await StationTimingsService.fetchStationTimings(
      apiKey,
      stationCode: stationCode,
    );
