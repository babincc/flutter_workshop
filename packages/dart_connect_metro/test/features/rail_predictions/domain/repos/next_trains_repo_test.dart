import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

Future<void> main() async {
  final String apiKey = ApiRepo.getApiKey();

  final List<Station> allStations = await fetchStations(apiKey);

  final String stationCode = allStations.first.stationCode;

  final List<String> stationCodes = [allStations.first.stationCode];
  for (Station station in allStations) {
    if (stationCodes.contains(station.stationCode)) {
      continue;
    }

    stationCodes.add(station.stationCode);

    if (stationCodes.length == 3) {
      break;
    }
  }

  group(
    'fetchNextTrains',
    () {
      test(
        'all stations',
        () async {
          final List<NextTrain> result = await fetchNextTrains(apiKey);

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'one station',
        () async {
          final List<NextTrain> result = await fetchNextTrains(
            apiKey,
            stationCodes: [stationCode],
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'multiple stations',
        () async {
          final List<NextTrain> result = await fetchNextTrains(
            apiKey,
            stationCodes: stationCodes,
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'one made up station',
        () async {
          final List<NextTrain> result = await fetchNextTrains(
            apiKey,
            stationCodes: ['abc123'],
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );

      test(
        'multiple made up stations',
        () async {
          final List<NextTrain> result = await fetchNextTrains(
            apiKey,
            stationCodes: ['abc123', 'def456', 'ghi789'],
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );

      // This yields unexpected results, but that is on the API side.
      // test(
      //   'one made up station among real stations',
      //   () async {
      //     final List<NextTrain> result = await fetchNextTrains(
      //       apiKey,
      //       stationCodes: ['abc123'] + stationCodes,
      //     );

      //     expect(
      //       result.isEmpty,
      //       true,
      //     );
      //   },
      // );
    },
  );
}
