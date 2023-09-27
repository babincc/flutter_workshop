import 'package:dart_connect_metro/features/bus_routes/domain/models/schedule/schedule.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  static Future<Schedule> fetchSchedule(
    String apiKey, {
    required String routeId,
    String? date,
    bool? includingVariations,
  }) async {
    final String host = _buildUrl(
      routeId: routeId,
      date: date,
      includingVariations: includingVariations,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return const Schedule.empty();

    return Schedule.fromJson(responseArr);
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    required String routeId,
    String? date,
    bool? includingVariations,
  }) {
    const String baseUrl = 'https://api.wmata.com/Bus.svc/json/jRouteSchedule';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    urlBuffer.write('?RouteID=$routeId');

    if (date != null) {
      urlBuffer.write('&Date=$date');
    }

    if (includingVariations != null) {
      urlBuffer.write('&IncludingVariations=$includingVariations');
    }

    return urlBuffer.toString();
  }
}
