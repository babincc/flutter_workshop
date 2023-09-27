import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() async {
  final String apiKey = ApiRepo.getApiKey();

  final List<Route> routes = await fetchRoutes(apiKey);

  final String routeId = routes.first.routeId;

  group(
    'fetchSchedule',
    () {
      test(
        'with routeId',
        () async {
          final Schedule result = await fetchSchedule(
            apiKey,
            routeId: routeId,
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'with routeId and date (past)',
        () async {
          final Schedule result = await fetchSchedule(
            apiKey,
            routeId: routeId,
            date: DateTime(2023, 9, 23),
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );

      test(
        'with routeId and date (future)',
        () async {
          final DateTime futureDate = DateTime.now().add(
            const Duration(
              days: 3,
            ),
          );

          final Schedule result = await fetchSchedule(
            apiKey,
            routeId: routeId,
            date: futureDate,
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'with routeId and includingVariations',
        () async {
          final Schedule result = await fetchSchedule(
            apiKey,
            routeId: routeId,
            includingVariations: true,
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'without routeId',
        () async {
          final Schedule result = await fetchSchedule(
            apiKey,
            routeId: '',
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );

      test(
        'without routeId but with date (future)',
        () async {
          final DateTime futureDate = DateTime.now().add(
            const Duration(
              days: 3,
            ),
          );

          final Schedule result = await fetchSchedule(
            apiKey,
            routeId: '',
            date: futureDate,
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );

      test(
        'without routeId but with includingVariations',
        () async {
          final Schedule result = await fetchSchedule(
            apiKey,
            routeId: '',
            includingVariations: true,
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );

      test(
        'with routeId, date (future), and includingVariations',
        () async {
          final DateTime futureDate = DateTime.now().add(
            const Duration(
              days: 3,
            ),
          );

          final Schedule result = await fetchSchedule(
            apiKey,
            routeId: routeId,
            date: futureDate,
            includingVariations: true,
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'without routeId but with date (future), and includingVariations',
        () async {
          final DateTime futureDate = DateTime.now().add(
            const Duration(
              days: 3,
            ),
          );

          final Schedule result = await fetchSchedule(
            apiKey,
            routeId: '',
            date: futureDate,
            includingVariations: true,
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
