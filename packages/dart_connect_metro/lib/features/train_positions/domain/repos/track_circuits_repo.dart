import 'package:dart_connect_metro/features/train_positions/domain/models/track_circuits/track_circuit.dart';
import 'package:dart_connect_metro/features/train_positions/domain/services/track_circuits_service.dart';

/// Fetches all track circuits.
///
/// `apiKey` is your API key for the WMATA API.
Future<List<TrackCircuit>> fetchTrackCircuits(String apiKey) async =>
    await TrackCircuitsService.fetchTrackCircuits(apiKey);
