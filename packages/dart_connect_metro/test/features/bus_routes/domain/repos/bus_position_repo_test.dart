import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  test(
    'fetchAllBusPositions',
    () async {
      final List<BusPosition> result = await fetchAllBusPositions(apiKey);

      expect(
        result.isNotEmpty,
        true,
      );
    },
  );

  test(
    'fetchBusPositionsForRoute',
    () async {
      final List<BusPosition> allPositions = await fetchAllBusPositions(apiKey);

      final String routeId = allPositions[0].routeId;

      final List<BusPosition> result = await fetchBusPositionsForRoute(
        apiKey,
        routeId: routeId,
      );

      int count = 0;

      for (BusPosition busPosition in allPositions) {
        if (busPosition.routeId == routeId) {
          count++;
        }
      }

      expect(
        result.length,
        count,
      );
    },
  );

  test(
    'fetchBusPositionsForLocation',
    () async {
      final List<BusPosition> allPositions = await fetchAllBusPositions(apiKey);

      final double latitude = allPositions[0].latitude;
      final double longitude = allPositions[0].longitude;
      const double radiusMeters = 1000;

      final List<BusPosition> result = await fetchBusPositionsForLocation(
        apiKey,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      );

      int count = 0;

      for (BusPosition busPosition in allPositions) {
        final double distance = calculateDistance(
          latitude,
          longitude,
          busPosition.latitude,
          busPosition.longitude,
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

  test(
    'fetchBusPositionsForRouteAndLocation',
    () async {
      final List<BusPosition> allPositions = await fetchAllBusPositions(apiKey);

      final String routeId = allPositions[0].routeId;
      final double latitude = allPositions[0].latitude;
      final double longitude = allPositions[0].longitude;
      const double radiusMeters = 5000;

      final List<BusPosition> result =
          await fetchBusPositionsForRouteAndLocation(
        apiKey,
        routeId: routeId,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      );

      int count = 0;

      for (BusPosition busPosition in allPositions) {
        final double distance = calculateDistance(
          latitude,
          longitude,
          busPosition.latitude,
          busPosition.longitude,
        );

        if (busPosition.routeId == routeId && distance.abs() <= radiusMeters) {
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
