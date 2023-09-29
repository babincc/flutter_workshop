import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() async {
  final String apiKey = ApiRepo.getApiKey();

  test(
    'fetchAllStops',
    () async {
      final List<Stop> result = await fetchAllStops(apiKey);

      expect(
        result.isNotEmpty,
        true,
      );
    },
  );

  test(
    'fetchStopsForLocation',
    () async {
      final List<Stop> allStops = await fetchAllStops(apiKey);

      final double latitude = allStops[0].latitude;
      final double longitude = allStops[0].longitude;
      const double radiusMeters = 1000;

      final List<Stop> result = await fetchStopsForLocation(
        apiKey,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      );

      int count = 0;

      for (Stop stop in allStops) {
        final double distance = calculateDistance(
          latitude,
          longitude,
          stop.latitude,
          stop.longitude,
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
