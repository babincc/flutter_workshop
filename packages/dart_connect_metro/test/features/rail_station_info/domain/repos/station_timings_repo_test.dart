import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  group(
    'fetchStationTimings',
    () {
      test(
        'without stationId',
        () async {
          final List<StationTimings> result = await fetchStationTimings(apiKey);

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'with stationId',
        () async {
          final List<StationTimings> allStations =
              await fetchStationTimings(apiKey);

          final String stationCode = allStations.last.stationCode;

          final List<StationTimings> result = await fetchStationTimings(
            apiKey,
            stationCode: stationCode,
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );
    },
  );
}
