import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/train_positions/domain/models/track_circuits/track_circuit.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class TrackCircuitsService {
  static Future<List<TrackCircuit>> fetchTrackCircuits(String apiKey) async {
    const String host =
        'https://api.wmata.com/TrainPositions/TrackCircuits?contentType=json';

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.trackCircuits] == null) return [];

    if (responseArr[ApiFields.trackCircuits] is List) {
      return ((responseArr[ApiFields.trackCircuits] as List?) ?? [])
          .map((trackCircuit) => TrackCircuit.fromJson(trackCircuit))
          .toList();
    }

    return [];
  }
}
