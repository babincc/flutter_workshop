import 'package:dart_connect_metro/features/bus_routes/domain/models/schedule_at_stop/schedule_at_stop.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class ScheduleAtStopService {
  static Future<ScheduleAtStop> fetchScheduleAtStop(
    String apiKey, {
    required String stopId,
    String? date,
  }) async {
    final String host = _buildUrl(
      stopId: stopId,
      date: date,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return const ScheduleAtStop.empty();

    return ScheduleAtStop.fromJson(responseArr);
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    required String stopId,
    String? date,
  }) {
    const String baseUrl = 'https://api.wmata.com/Bus.svc/json/jStopSchedule';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    urlBuffer.write('?StopID=$stopId');

    if (date != null) {
      urlBuffer.write('&Date=$date');
    }

    return urlBuffer.toString();
  }
}
