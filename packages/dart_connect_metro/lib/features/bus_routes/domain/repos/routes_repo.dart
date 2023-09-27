import 'package:dart_connect_metro/features/bus_routes/domain/models/route.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/services/routes_service.dart';

/// Fetches the routes from the WMATA API.
///
/// `apiKey` is your API key for the WMATA API.
Future<List<Route>> fetchRoutes(String apiKey) async =>
    await RoutesService.fetchRoutes(apiKey);
