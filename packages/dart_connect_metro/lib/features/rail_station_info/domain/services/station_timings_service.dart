import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/station_timings/station_timings.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class StationTimingsService {
  static Future<List<StationTimings>> fetchStationTimings(
    String apiKey, {
    String? stationCode,
  }) async {
    final String host = _buildUrl(
      stationCode: stationCode,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.stationTimes] == null) return [];

    if (responseArr[ApiFields.stationTimes] is List) {
      return ((responseArr[ApiFields.stationTimes] as List?) ?? [])
          .map((stationTimings) => StationTimings.fromJson(stationTimings))
          .toList();
    }

    return [];
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    String? stationCode,
  }) {
    const String baseUrl = 'https://api.wmata.com/Rail.svc/json/jStationTimes';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    if (stationCode != null) {
      urlBuffer.write('?StationCode=$stationCode');
    }

    return urlBuffer.toString();
  }
}
