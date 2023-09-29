import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/incidents/domain/models/rail_incident.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class RailIncidentService {
  static Future<List<RailIncident>> fetchRailIncidents(String apiKey) async {
    const String host = 'https://api.wmata.com/Incidents.svc/json/Incidents';

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.incidents] == null) return [];

    if (responseArr[ApiFields.incidents] is List) {
      return ((responseArr[ApiFields.incidents] as List?) ?? [])
          .map((railIncident) => RailIncident.fromJson(railIncident))
          .toList();
    }

    return [];
  }
}
