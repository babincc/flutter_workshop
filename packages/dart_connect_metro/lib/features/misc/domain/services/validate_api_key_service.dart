import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/utils/json_tool.dart';
import 'package:http/http.dart' as http;

class ValidateApiKeyService {
  static Future<bool> fetchApiKeyValidation(String apiKey) async {
    const String host = 'https://api.wmata.com/Misc/Validate';

    final response = await http.get(
      Uri.parse(host),
      headers: {"api_key": apiKey},
    );

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.containsKey(ApiFields.statusCode)) {
      if (responseArr[ApiFields.statusCode] == 401) {
        return false;
      }
    }

    return true;
  }
}
