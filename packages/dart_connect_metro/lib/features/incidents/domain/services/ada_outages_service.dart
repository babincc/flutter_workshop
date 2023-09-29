import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/incidents/domain/models/ada_incident.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class AdaOutagesService {
  static Future<List<AdaIncident>> fetchBusPositions(
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

    if (responseArr[ApiFields.elevatorIncidents] == null) return [];

    if (responseArr[ApiFields.elevatorIncidents] is List) {
      return ((responseArr[ApiFields.elevatorIncidents] as List?) ?? [])
          .map((adaIncident) => AdaIncident.fromJson(adaIncident))
          .toList();
    }

    return [];
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    String? stationCode,
  }) {
    const String baseUrl =
        'https://api.wmata.com/Incidents.svc/json/ElevatorIncidents';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    if (stationCode != null) {
      urlBuffer.write('?StationCode=$stationCode');
    }

    return urlBuffer.toString();
  }
}
