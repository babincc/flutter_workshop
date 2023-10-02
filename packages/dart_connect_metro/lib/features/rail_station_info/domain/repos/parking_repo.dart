import 'package:dart_connect_metro/features/rail_station_info/domain/models/parking/parking.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/services/parking_service.dart';

/// Fetches parking information.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `stationCode` is the unique identifier for the station you want to fetch
/// parking information for. If `null`, all stations will be returned.
Future<List<Parking>> fetchParking(
  String apiKey, {
  String? stationCode,
}) async =>
    await ParkingService.fetchParking(
      apiKey,
      stationCode: stationCode,
    );
