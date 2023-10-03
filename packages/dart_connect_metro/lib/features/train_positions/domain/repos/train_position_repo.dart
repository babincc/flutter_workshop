import 'package:dart_connect_metro/features/train_positions/domain/models/train_position.dart';
import 'package:dart_connect_metro/features/train_positions/domain/services/train_position_service.dart';

/// Fetches all train positions.
///
/// `apiKey` is your API key for the WMATA API.
Future<List<TrainPosition>> fetchTrainPositions(String apiKey) async =>
    await TrainPositionService.fetchTrainPositions(apiKey);
