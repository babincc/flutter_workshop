import 'package:dart_connect_metro/features/train_positions/domain/models/standard_routes/standard_route.dart';
import 'package:dart_connect_metro/features/train_positions/domain/services/standard_route_service.dart';

/// Fetches standard routes from the WMATA API.
///
/// `apiKey` is your API key for the WMATA API.
Future<List<StandardRoute>> fetchStandardRoutes(String apiKey) async =>
    await StandardRouteService.fetchStandardRoutes(apiKey);
