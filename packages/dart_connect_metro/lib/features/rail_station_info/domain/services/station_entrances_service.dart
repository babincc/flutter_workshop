import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/station_entrance.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class StationEntrancesService {
  static Future<List<StationEntrance>> fetchStationEntrances(
    String apiKey, {
    double? lat,
    double? lon,
    double? radius,
  }) async {
    final String host = _buildUrl(
      lat: lat,
      lon: lon,
      radius: radius,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.entrances] == null) return [];

    if (responseArr[ApiFields.entrances] is List) {
      return ((responseArr[ApiFields.entrances] as List?) ?? [])
          .map((entrance) => StationEntrance.fromJson(entrance))
          .toList();
    }

    return [];
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    double? lat,
    double? lon,
    double? radius,
  }) {
    const String baseUrl =
        'https://api.wmata.com/Rail.svc/json/jStationEntrances';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    if (lat != null && lon != null && radius != null) {
      urlBuffer.write('?Lat=$lat&Lon=$lon&Radius=$radius');
    }

    return urlBuffer.toString();
  }
}
