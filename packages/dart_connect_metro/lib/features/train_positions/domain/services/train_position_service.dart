import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/train_positions/domain/models/train_position.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class TrainPositionService {
  static Future<List<TrainPosition>> fetchTrainPositions(String apiKey) async {
    const String host =
        'https://api.wmata.com/TrainPositions/TrainPositions?contentType=json';

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.trainPositions] == null) return [];

    if (responseArr[ApiFields.trainPositions] is List) {
      return ((responseArr[ApiFields.trainPositions] as List?) ?? [])
          .map((trainPosition) => TrainPosition.fromJson(trainPosition))
          .toList();
    }

    return [];
  }
}
