import 'package:dart_connect_metro/features/rail_station_info/domain/models/station_to_station/station_to_station.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/services/station_to_station_service.dart';

/// Fetches the station to station information for the given stations.
///
/// `apiKey` is your API key for the WMATA API.
///
/// Omit both parameters to retrieve data for all stations.
///
/// Only include the `startStationCode` to retrieve data for all stations
/// starting at the given station.
///
/// Only include the `destinationStationCode` to retrieve data for all stations
/// ending at the given station.
Future<List<StationToStation>> fetchStationToStation(
  String apiKey, {
  String? startStationCode,
  String? destinationStationCode,
}) async =>
    await StationToStationService.fetchStationToStation(
      apiKey,
      startStationCode: startStationCode,
      destinationStationCode: destinationStationCode,
    );
