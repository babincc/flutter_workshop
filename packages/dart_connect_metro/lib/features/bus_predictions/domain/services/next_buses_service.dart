import 'package:dart_connect_metro/features/bus_predictions/domain/models/next_buses/next_buses.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class NextBusesService {
  static Future<NextBuses> fetchNextBuses(
    String apiKey, {
    required String stopId,
  }) async {
    final String host = _buildUrl(
      stopId: stopId,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return const NextBuses.empty();

    return NextBuses.fromJson(responseArr);
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    required String stopId,
  }) {
    const String baseUrl =
        'https://api.wmata.com/NextBusService.svc/json/jPredictions';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    urlBuffer.write('?StopID=$stopId');

    return urlBuffer.toString();
  }
}
