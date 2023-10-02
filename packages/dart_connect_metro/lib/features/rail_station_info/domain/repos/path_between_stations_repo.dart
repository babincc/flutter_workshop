import 'package:dart_connect_metro/features/rail_station_info/domain/models/path/path.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/services/path_between_stations_service.dart';

/// Fetches the path between two stations.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `startStationCode` is the station code of the station you want to start at.
///
/// `destinationStationCode` is the station code of the station you want to end
/// at.
Future<Path> fetchPath(
  String apiKey, {
  required String startStationCode,
  required String destinationStationCode,
}) async =>
    await PathBetweenStationsService.fetchPath(
      apiKey,
      startStationCode: startStationCode,
      destinationStationCode: destinationStationCode,
    );
