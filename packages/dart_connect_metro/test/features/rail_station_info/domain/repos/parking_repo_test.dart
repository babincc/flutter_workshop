import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  group(
    'fetchParking',
    () {
      test(
        'without stationId',
        () async {
          // ignore: unused_local_variable
          final List<Parking> result = await fetchParking(apiKey);

          // print(result);

          // Can't use [expect] here because the API is dynamic.
        },
      );

      test(
        'with stationId',
        () async {
          final List<Parking> allParking = await fetchParking(apiKey);

          if (allParking.isEmpty) return;

          final String stationCode = allParking.first.stationCode;

          final List<Parking> result = await fetchParking(
            apiKey,
            stationCode: stationCode,
          );

          int count = 0;

          for (Parking parking in allParking) {
            if (parking.stationCode == stationCode) {
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
