import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/line.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class LinesService {
  static Future<List<Line>> fetchLines(String apiKey) async {
    const String host = 'https://api.wmata.com/Rail.svc/json/jLines';

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.lines] == null) return [];

    if (responseArr[ApiFields.lines] is List) {
      return ((responseArr[ApiFields.lines] as List?) ?? [])
          .map((line) => Line.fromJson(line))
          .toList();
    }

    return [];
  }
}
