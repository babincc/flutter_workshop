import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() async {
  final String apiKey = ApiRepo.getApiKey();

  final List<Route> routes = await fetchRoutes(apiKey);

  final String routeId = routes.first.routeId;

  group(
    'fetchPathDetails',
    () {
      test(
        'without date',
        () async {
          final PathDetails result = await fetchPathDetails(
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
        'with date - past',
        () async {
          final PathDetails result = await fetchPathDetails(
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
        'with date - future',
        () async {
          final DateTime futureDate = DateTime.now().add(
            const Duration(
              days: 3,
            ),
          );

          final PathDetails result = await fetchPathDetails(
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
        'without routeId',
        () async {
          final PathDetails result = await fetchPathDetails(
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
        'without routeId but with date',
        () async {
          final PathDetails result = await fetchPathDetails(
            apiKey,
            routeId: '',
            date: DateTime(2023, 9, 23),
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
