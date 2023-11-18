import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/features/art_crime/domain/models/art_crime.dart';
import 'package:dart_gov_fbi/features/art_crime/domain/models/art_crime_result_set.dart';
import 'package:dart_gov_fbi/utils/json_tool.dart';
import 'package:dart_gov_fbi/utils/url_tool.dart';
import 'package:http/http.dart' as http;

class ArtCrimeService {
  static Future<ArtCrime> fetchArtCrime(String id) async {
    final String host = 'https://api.fbi.gov/@artcrimes/$id';

    final response = await http.get(Uri.parse(host));

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return ArtCrime.empty();

    responseArr[ApiFields.id] = id;

    return ArtCrime.fromJson(responseArr);
  }

  static Future<ArtCrimeResultSet> fetchArtCrimes({
    int? pageSize,
    int? page,
    String? sortOn,
    String? sortOrder,
    String? title,
    String? crimeCategory,
    String? maker,
    String? referenceNumber,
  }) async {
    final String host = _buildUrl(
      pageSize: pageSize,
      page: page,
      sortOn: sortOn,
      sortOrder: sortOrder,
      title: title,
      crimeCategory: crimeCategory,
      maker: maker,
      referenceNumber: referenceNumber,
    );

    final response = await http.get(Uri.parse(host));

    Map<String, dynamic> responseArr = readJson(response.body);

    if (responseArr.isEmpty) return ArtCrimeResultSet.empty();

    return ArtCrimeResultSet.fromJson(responseArr);
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    int? pageSize,
    int? page,
    String? sortOn,
    String? sortOrder,
    String? title,
    String? crimeCategory,
    String? maker,
    String? referenceNumber,
  }) {
    const String baseUrl = 'https://api.fbi.gov/@artcrimes';

    return UrlTool.buildUrl(
      baseUrl: baseUrl,
      queryParams: {
        "pageSize": pageSize.toString(),
        "page": page.toString(),
        "sort_on": sortOn,
        "sort_order": sortOrder,
        "title": title,
        "crimeCategory": crimeCategory,
        "maker": maker,
        "referenceNumber": referenceNumber,
      },
    );
  }
}
