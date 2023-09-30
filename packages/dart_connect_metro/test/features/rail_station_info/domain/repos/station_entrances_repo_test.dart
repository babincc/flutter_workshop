import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  test(
    'fetchAllStationEntrances',
    () async {
      final List<StationEntrance> result =
          await fetchAllStationEntrances(apiKey);

      expect(
        result.isNotEmpty,
        true,
      );
    },
  );

  test(
    'fetchStationEntrancesForLocation',
    () async {
      final List<StationEntrance> allEntrances =
          await fetchAllStationEntrances(apiKey);

      final double latitude = allEntrances[0].latitude;
      final double longitude = allEntrances[0].longitude;
      const double radiusMeters = 1000;

      final List<StationEntrance> result =
          await fetchStationEntrancesForLocation(
        apiKey,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      );

      int count = 0;

      for (StationEntrance entrance in allEntrances) {
        final double distance = calculateDistance(
          latitude,
          longitude,
          entrance.latitude,
          entrance.longitude,
        );

        if (distance.abs() <= radiusMeters) {
          count++;
        }
      }

      expect(
        result.length,
        count,
      );
    },
  );
}
