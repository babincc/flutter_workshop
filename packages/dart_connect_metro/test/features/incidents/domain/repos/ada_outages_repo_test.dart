import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  group(
    'fetchAdaIncidents',
    () {
      test(
        'without stationCode',
        () async {
          // ignore: unused_local_variable
          final List<AdaIncident> result = await fetchAdaIncidents(apiKey);

          // print(result);

          // Can't use [expect] here because the API is dynamic.
        },
      );

      test(
        'with stationCode',
        () async {
          final List<AdaIncident> allAdaIncidents =
              await fetchAdaIncidents(apiKey);

          if (allAdaIncidents.isEmpty) return;

          final String stationCode = allAdaIncidents.first.stationCode;

          final List<AdaIncident> result = await fetchAdaIncidents(
            apiKey,
            stationCode: stationCode,
          );

          int count = 0;

          for (AdaIncident incident in allAdaIncidents) {
            if (incident.stationCode == stationCode) {
              count++;
            }
          }

          expect(
            result.length,
            count,
          );
        },
      );
    },
  );
}
