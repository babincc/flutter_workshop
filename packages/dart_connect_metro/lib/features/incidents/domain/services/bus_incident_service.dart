import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/incidents/domain/models/bus_incident.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class BusIncidentService {
  static Future<List<BusIncident>> fetchBusIncidents(
    String apiKey, {
    String? routeId,
  }) async {
    final String host = _buildUrl(
      routeId: routeId,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.busIncidents] == null) return [];

    if (responseArr[ApiFields.busIncidents] is List) {
      return ((responseArr[ApiFields.busIncidents] as List?) ?? [])
          .map((busIncident) => BusIncident.fromJson(busIncident))
          .toList();
    }

    return [];
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    String? routeId,
  }) {
    const String baseUrl =
        'https://api.wmata.com/Incidents.svc/json/BusIncidents';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    if (routeId != null) {
      urlBuffer.write('?Route=$routeId');
    }

    return urlBuffer.toString();
  }
}
