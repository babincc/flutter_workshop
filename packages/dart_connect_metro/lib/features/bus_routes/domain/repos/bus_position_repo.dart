import 'package:dart_connect_metro/features/bus_routes/domain/models/bus_position.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/services/bus_position_service.dart';

/// Fetches all bus positions.
///
/// `apiKey` is your API key for the WMATA API.
Future<List<BusPosition>> fetchAllBusPositions(String apiKey) async =>
    await BusPositionService.fetchBusPositions(apiKey);

/// Fetches bus positions for a specific route.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `routeId` is the base route name as shown on the bus. Note that the base
/// route name could also refer to any variant, so a RouteID of 10A could
/// refer to 10A, 10Av1, 10Av2, etc.
Future<List<BusPosition>> fetchBusPositionsForRoute(
  String apiKey, {
  required String routeId,
}) async =>
    await BusPositionService.fetchBusPositions(apiKey, routeId: routeId);

/// Fetches bus positions for a specific location.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `latitude` is the last reported Latitude of the bus.
///
/// `longitude` is the last reported Longitude of the bus.
///
/// `radiusMeters` is the radius, in meters, to include in the search area.
Future<List<BusPosition>> fetchBusPositionsForLocation(
  String apiKey, {
  required double latitude,
  required double longitude,
  required double radiusMeters,
}) async =>
    await BusPositionService.fetchBusPositions(
      apiKey,
      lat: latitude,
      lon: longitude,
      radius: radiusMeters,
    );

/// Fetches bus positions for a specific route and location.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `routeId` is the base route name as shown on the bus. Note that the base
/// route name could also refer to any variant, so a RouteID of 10A could
/// refer to 10A, 10Av1, 10Av2, etc.
///
/// `latitude` is the last reported Latitude of the bus.
///
/// `longitude` is the last reported Longitude of the bus.
///
/// `radiusMeters` is the radius, in meters, to include in the search area.
Future<List<BusPosition>> fetchBusPositionsForRouteAndLocation(
  String apiKey, {
  required String routeId,
  required double latitude,
  required double longitude,
  required double radiusMeters,
}) async =>
    await BusPositionService.fetchBusPositions(
      apiKey,
      routeId: routeId,
      lat: latitude,
      lon: longitude,
      radius: radiusMeters,
    );
