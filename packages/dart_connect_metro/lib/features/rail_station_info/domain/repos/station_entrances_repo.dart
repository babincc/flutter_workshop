import 'package:dart_connect_metro/features/rail_station_info/domain/models/station_entrance.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/services/station_entrances_service.dart';

/// Fetches all station entrances.
///
/// `apiKey` is your API key for the WMATA API.
Future<List<StationEntrance>> fetchAllStationEntrances(String apiKey) async =>
    await StationEntrancesService.fetchStationEntrances(apiKey);

/// Fetches all station entrances.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `latitude` is the center point Latitude of the search area.
///
/// `longitude` is the center point Longitude of the search area.
///
/// `radiusMeters` is the radius, in meters, to include in the search area.
Future<List<StationEntrance>> fetchStationEntrancesForLocation(
  String apiKey, {
  required double latitude,
  required double longitude,
  required double radiusMeters,
}) async =>
    await StationEntrancesService.fetchStationEntrances(
      apiKey,
      lat: latitude,
      lon: longitude,
      radius: radiusMeters,
    );
