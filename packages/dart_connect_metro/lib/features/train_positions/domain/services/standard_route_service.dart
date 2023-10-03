import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/train_positions/domain/models/standard_routes/standard_route.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class StandardRouteService {
  static Future<List<StandardRoute>> fetchStandardRoutes(String apiKey) async {
    const String host =
        'https://api.wmata.com/TrainPositions/StandardRoutes?contentType=json';

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return [];

    if (responseArr[ApiFields.standardRoutes] == null) return [];

    if (responseArr[ApiFields.standardRoutes] is List) {
      return ((responseArr[ApiFields.standardRoutes] as List?) ?? [])
          .map((standardRoute) => StandardRoute.fromJson(standardRoute))
          .toList();
    }

    return [];
  }
}
