import 'package:dart_connect_metro/features/rail_station_info/domain/models/station/station.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/services/station_service.dart';

/// Fetches the station info for all stations.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `lineCode` is the line code for the line you want to fetch stations for. It
/// is a two character string. For example, the Orange line is "OR".
Future<List<Station>> fetchStations(
  String apiKey, {
  String? lineCode,
}) async =>
    await StationInfoService.fetchStations(
      apiKey,
      lineCode: lineCode,
    );

/// Fetches the station info for the given `stationCode`.
///
/// `apiKey` is your API key for the WMATA API.
Future<Station> fetchStation(
  String apiKey, {
  required String stationCode,
}) async =>
    await StationInfoService.fetchStation(
      apiKey,
      stationCode: stationCode,
    );
