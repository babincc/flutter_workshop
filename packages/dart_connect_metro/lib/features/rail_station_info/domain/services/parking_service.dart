import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/parking/parking.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class ParkingService {
  static Future<List<Parking>> fetchParking(
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

    if (responseArr[ApiFields.stationsParking] == null) return [];

    if (responseArr[ApiFields.stationsParking] is List) {
      return ((responseArr[ApiFields.stationsParking] as List?) ?? [])
          .map((parking) => Parking.fromJson(parking))
          .toList();
    }

    return [];
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    String? stationCode,
  }) {
    const String baseUrl =
        'https://api.wmata.com/Rail.svc/json/jStationParking';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    if (stationCode != null) {
      urlBuffer.write('?StationCode=$stationCode');
    }

    return urlBuffer.toString();
  }
}
