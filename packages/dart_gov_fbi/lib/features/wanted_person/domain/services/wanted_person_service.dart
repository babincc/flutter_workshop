import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/features/wanted_person/domain/models/wanted_person.dart';
import 'package:dart_gov_fbi/features/wanted_person/domain/models/wanted_person_result_set.dart';
import 'package:dart_gov_fbi/utils/json_tool.dart';
import 'package:dart_gov_fbi/utils/url_tool.dart';
import 'package:http/http.dart' as http;

class WantedPersonService {
  static Future<WantedPerson> fetchWantedPerson(String id) async {
    final String host = 'https://api.fbi.gov/@wanted-person/$id';

    final response = await http.get(Uri.parse(host));

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return WantedPerson.empty();

    responseArr[ApiFields.id] = id;

    return WantedPerson.fromJson(responseArr);
  }

  static Future<WantedPersonResultSet> fetchWantedPersons({
    int? pageSize,
    int? page,
    String? sortOn,
    String? sortOrder,
    String? title,
    String? fieldOffices,
    String? personClassification,
    String? posterClassification,
    String? status,
  }) async {
    final String host = _buildUrl(
      pageSize: pageSize,
      page: page,
      sortOn: sortOn,
      sortOrder: sortOrder,
      title: title,
      fieldOffices: fieldOffices,
      personClassification: personClassification,
      posterClassification: posterClassification,
      status: status,
    );

    final response = await http.get(Uri.parse(host));

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return WantedPersonResultSet.empty();

    return WantedPersonResultSet.fromJson(responseArr);
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    int? pageSize,
    int? page,
    String? sortOn,
    String? sortOrder,
    String? title,
    String? fieldOffices,
    String? personClassification,
    String? posterClassification,
    String? status,
  }) {
    const String baseUrl = 'https://api.fbi.gov/@wanted';

    return UrlTool.buildUrl(
      baseUrl: baseUrl,
      queryParams: {
        "pageSize": pageSize.toString(),
        "page": page.toString(),
        "sort_on": sortOn,
        "sort_order": sortOrder,
        "title": title,
        "field_offices": fieldOffices,
        "person_classification": personClassification,
        "poster_classification": posterClassification,
        "status": status,
      },
    );
  }
}
