import 'package:dart_connect_metro/features/bus_predictions/domain/models/next_buses/next_buses.dart';
import 'package:dart_connect_metro/features/bus_predictions/domain/services/next_buses_service.dart';

/// Fetches the next buses for a given stop.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `stopId` is the ID of the stop you want to get the next buses for.
Future<NextBuses> fetchNextBuses(
  String apiKey, {
  required String stopId,
}) async =>
    NextBusesService.fetchNextBuses(
      apiKey,
      stopId: stopId,
    );
