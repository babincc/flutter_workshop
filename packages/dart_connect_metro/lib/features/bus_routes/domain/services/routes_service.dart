import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/route.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class RoutesService {
  static Future<List<Route>> fetchRoutes(String apiKey) async {
    const String host = 'https://api.wmata.com/Bus.svc/json/jRoutes';

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.routes] == null) return [];

    if (responseArr[ApiFields.routes] is List) {
      return ((responseArr[ApiFields.routes] as List?) ?? [])
          .map((route) => Route.fromJson(route))
          .toList();
    }

    return [];
  }
}
