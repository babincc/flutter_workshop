import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  test(
    'fetchRailIncidents',
    () async {
      // ignore: unused_local_variable
      final List<RailIncident> result = await fetchRailIncidents(apiKey);

      // print(result);

      // Can't use [expect] here because the API is dynamic.
    },
  );
}
