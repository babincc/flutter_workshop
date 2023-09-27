import 'package:dart_connect_metro/features/bus_routes/domain/models/stop.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/services/stop_search_service.dart';

/// Fetches all bus stops.
///
/// `apiKey` is your API key for the WMATA API.
Future<List<Stop>> fetchAllStops(String apiKey) async =>
    await StopSearchService.fetchStops(apiKey);

/// Fetches bus stops for a specific location.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `latitude` is the center point Latitude of the search area.
///
/// `longitude` is the center point Longitude of the search area.
///
/// `radiusMeters` is the radius, in meters, to include in the search area.
Future<List<Stop>> fetchStopsForLocation(
  String apiKey, {
  required double latitude,
  required double longitude,
  required double radiusMeters,
}) async =>
    await StopSearchService.fetchStops(
      apiKey,
      lat: latitude,
      lon: longitude,
      radius: radiusMeters,
    );
