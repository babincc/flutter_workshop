import 'package:dart_connect_metro/features/rail_predictions/domain/models/next_train.dart';
import 'package:dart_connect_metro/features/rail_predictions/domain/services/next_trains_service.dart';

/// Fetches the next trains for the given station codes.
///
/// `apiKey` is your API key for the WMATA API.
///
/// If `stationCodes` is `null`, then all stations will be returned.
Future<List<NextTrain>> fetchNextTrains(
  String apiKey, {
  List<String>? stationCodes,
}) async =>
    NextTrainsService.fetchNextTrains(
      apiKey,
      stationCodes: stationCodes == null ? 'All' : stationCodes.join(','),
    );
