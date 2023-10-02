import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_predictions/domain/models/next_train.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class NextTrainsService {
  static Future<List<NextTrain>> fetchNextTrains(
    String apiKey, {
    required String stationCodes,
  }) async {
    final String host = _buildUrl(
      stationCodes: stationCodes,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.trains] == null) return [];

    if (responseArr[ApiFields.trains] is List) {
      return ((responseArr[ApiFields.trains] as List?) ?? [])
          .map((nextTrain) => NextTrain.fromJson(nextTrain))
          .toList();
    }

    return [];
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    required String stationCodes,
  }) {
    const String baseUrl =
        'https://api.wmata.com/StationPrediction.svc/json/GetPrediction/';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    urlBuffer.write(stationCodes);

    return urlBuffer.toString();
  }
}
