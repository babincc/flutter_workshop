import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/station_to_station/station_to_station.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class StationToStationService {
  static Future<List<StationToStation>> fetchStationToStation(
    String apiKey, {
    String? startStationCode,
    String? destinationStationCode,
  }) async {
    final String host = _buildUrl(
      startStationCode: startStationCode,
      destinationStationCode: destinationStationCode,
    );

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.stationToStationInfos] == null) return [];

    if (responseArr[ApiFields.stationToStationInfos] is List) {
      return ((responseArr[ApiFields.stationToStationInfos] as List?) ?? [])
          .map(
              (stationToStation) => StationToStation.fromJson(stationToStation))
          .toList();
    }

    return [];
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    String? startStationCode,
    String? destinationStationCode,
  }) {
    const String baseUrl =
        'https://api.wmata.com/Rail.svc/json/jSrcStationToDstStationInfo';

    final StringBuffer urlBuffer = StringBuffer(baseUrl);

    /// Whether or not the URL already has query parameters.
    bool hasQueryParameters = false;

    if (startStationCode != null) {
      urlBuffer.write('?FromStationCode=$startStationCode');
      hasQueryParameters = true;
    }

    if (destinationStationCode != null) {
      if (hasQueryParameters) {
        urlBuffer.write('&');
      } else {
        urlBuffer.write('?');
      }

      urlBuffer.write('ToStationCode=$destinationStationCode');
    }

    return urlBuffer.toString();
  }
}
