import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() async {
  final String apiKey = ApiRepo.getApiKey();

  final List<Stop> stops = await fetchAllStops(apiKey);

  final String stopId = stops.first.stopId.toString();

  group(
    'fetchScheduleAtStop',
    () {
      test(
        'with stopId',
        () async {
          final ScheduleAtStop result = await fetchScheduleAtStop(
            apiKey,
            stopId: stopId,
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'with stopId and date (past)',
        () async {
          final ScheduleAtStop result = await fetchScheduleAtStop(
            apiKey,
            stopId: stopId,
            date: DateTime(2023, 9, 23),
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );

      test(
        'with stopId and date (future)',
        () async {
          final DateTime futureDate = DateTime.now().add(
            const Duration(
              days: 3,
            ),
          );

          final ScheduleAtStop result = await fetchScheduleAtStop(
            apiKey,
            stopId: stopId,
            date: futureDate,
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'without stopId',
        () async {
          final ScheduleAtStop result = await fetchScheduleAtStop(
            apiKey,
            stopId: '',
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );

      test(
        'without stopId but with date (future)',
        () async {
          final DateTime futureDate = DateTime.now().add(
            const Duration(
              days: 3,
            ),
          );

          final ScheduleAtStop result = await fetchScheduleAtStop(
            apiKey,
            stopId: '',
            date: futureDate,
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
