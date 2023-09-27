import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/path_details/path_details.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class PathDetailsService {
  static Future<PathDetails> fetchPathDetails(
    String apiKey, {
    required String routeId,
    String? date,
  }) async {
    final String host = _buildUrl(
      routeId: routeId,
      date: date,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return PathDetails.empty();

    if (responseArr[ApiFields.routeId] == null) return PathDetails.empty();

    responseArr[ApiFields.dateTime] = date;

    return PathDetails.fromJson(responseArr);
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    required String routeId,
    String? date,
  }) {
    const String baseUrl = 'https://api.wmata.com/Bus.svc/json/jRouteDetails';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    urlBuffer.write('?RouteID=$routeId');

    if (date != null) {
      urlBuffer.write('&Date=$date');
    }

    return urlBuffer.toString();
  }
}
