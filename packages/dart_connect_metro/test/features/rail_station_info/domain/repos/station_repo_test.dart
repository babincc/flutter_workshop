import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  group(
    'fetchStations',
    () {
      test(
        'without lineCode',
        () async {
          final List<Station> stations = await fetchStations(apiKey);

          expect(
            stations.isNotEmpty,
            true,
          );
        },
      );

      test(
        'with lineCode',
        () async {
          final List<Station> allStations = await fetchStations(apiKey);

          final String lineCode = allStations.first.lineCode1;

          final List<Station> result = await fetchStations(
            apiKey,
            lineCode: lineCode,
          );

          int count = 0;

          for (final Station station in allStations) {
            if (station.lineCode1 == lineCode ||
                station.lineCode2 == lineCode ||
                station.lineCode3 == lineCode ||
                station.lineCode4 == lineCode) {
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

  test(
    'fetchStation',
    () async {
      final List<Station> allStations = await fetchStations(apiKey);

      final String stationCode = allStations.first.stationCode;

      final Station result = await fetchStation(
        apiKey,
        stationCode: stationCode,
      );

      expect(
        result,
        allStations.first,
      );
    },
  );
}
