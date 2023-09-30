import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/station/station.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class StationInfoService {
  static Future<List<Station>> fetchStations(
    String apiKey, {
    String? lineCode,
  }) async {
    final String host = _buildAllStationUrl(
      lineCode: lineCode,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.stations] == null) return [];

    if (responseArr[ApiFields.stations] is List) {
      return ((responseArr[ApiFields.stations] as List?) ?? [])
          .map((station) => Station.fromJson(station))
          .toList();
    }

    return [];
  }

  static Future<Station> fetchStation(
    String apiKey, {
    required String stationCode,
  }) async {
    final String host = _buildSingleStationUrl(
      stationCode: stationCode,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return Station.empty();

    return Station.fromJson(responseArr);
  }

  /// Builds the URL for the API call.
  static String _buildAllStationUrl({
    String? lineCode,
  }) {
    const String baseUrl = 'https://api.wmata.com/Rail.svc/json/jStations';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    if (lineCode != null) {
      urlBuffer.write('?LineCode=$lineCode');
    }

    return urlBuffer.toString();
  }

  /// Builds the URL for the API call.
  static String _buildSingleStationUrl({
    required String stationCode,
  }) {
    const String baseUrl = 'https://api.wmata.com/Rail.svc/json/jStationInfo';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    urlBuffer.write('?StationCode=$stationCode');

    return urlBuffer.toString();
  }
}
