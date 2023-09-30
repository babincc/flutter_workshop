import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/path/path.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class PathBetweenStationsService {
  static Future<Path> fetchPath(
    String apiKey, {
    required String startStationCode,
    required String destinationStationCode,
  }) async {
    final String host = _buildUrl(
      startStationCode: startStationCode,
      destinationStationCode: destinationStationCode,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return Path.empty();

    if (responseArr[ApiFields.path] == null) return Path.empty();

    return Path.fromJson(responseArr);
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    required String startStationCode,
    required String destinationStationCode,
  }) {
    const String baseUrl = 'https://api.wmata.com/Rail.svc/json/jPath';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    urlBuffer.write('?FromStationCode=$startStationCode');

    urlBuffer.write('&ToStationCode=$destinationStationCode');

    return urlBuffer.toString();
  }
}
