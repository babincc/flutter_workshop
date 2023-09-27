import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/bus_position.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class BusPositionService {
  static Future<List<BusPosition>> fetchBusPositions(
    String apiKey, {
    String? routeId,
    double? lat,
    double? lon,
    double? radius,
  }) async {
    final String host = _buildUrl(
      routeId: routeId,
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

    if (responseArr[ApiFields.busPositions] == null) return [];

    if (responseArr[ApiFields.busPositions] is List) {
      return ((responseArr[ApiFields.busPositions] as List?) ?? [])
          .map((busPosition) => BusPosition.fromJson(busPosition))
          .toList();
    }

    return [];
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    String? routeId,
    double? lat,
    double? lon,
    double? radius,
  }) {
    const String baseUrl = 'https://api.wmata.com/Bus.svc/json/jBusPositions';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    /// Whether or not the URL already has query parameters.
    bool hasQueryParameters = false;

    if (routeId != null) {
      urlBuffer.write('?RouteID=$routeId');
      hasQueryParameters = true;
    }

    if (lat != null && lon != null && radius != null) {
      if (hasQueryParameters) {
        urlBuffer.write('&');
      } else {
        urlBuffer.write('?');
      }

      urlBuffer.write('Lat=$lat&Lon=$lon&Radius=$radius');
    }

    return urlBuffer.toString();
  }
}
