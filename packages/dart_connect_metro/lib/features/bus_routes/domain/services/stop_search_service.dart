import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/stop.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class StopSearchService {
  static Future<List<Stop>> fetchStops(
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

    if (responseArr[ApiFields.stops] == null) return [];

    if (responseArr[ApiFields.stops] is List) {
      return ((responseArr[ApiFields.stops] as List?) ?? [])
          .map((stop) => Stop.fromJson(stop))
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
    const String baseUrl = 'https://api.wmata.com/Bus.svc/json/jStops';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    if (lat != null && lon != null && radius != null) {
      urlBuffer.write('?Lat=$lat&Lon=$lon&Radius=$radius');
    }

    return urlBuffer.toString();
  }
}
