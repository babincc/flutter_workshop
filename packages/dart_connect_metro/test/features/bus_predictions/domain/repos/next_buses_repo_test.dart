import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  group(
    'fetchNextBuses',
    () {
      test(
        'normal',
        () async {
          final List<Stop> allStops = await fetchAllStops(apiKey);

          final int stopId = allStops.first.stopId;

          final NextBuses result = await fetchNextBuses(
            apiKey,
            stopId: stopId.toString(),
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'made up stopId',
        () async {
          final NextBuses result = await fetchNextBuses(
            apiKey,
            stopId: 'abc123',
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );
    },
  );
}
