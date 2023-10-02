import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() async {
  final String apiKey = ApiRepo.getApiKey();

  final List<Station> allStations = await fetchStations(apiKey);

  final String startStationCode = allStations.first.stationCode;

  String destinationStationCode = allStations.first.stationCode;

  for (Station station in allStations) {
    if (station.stationCode != startStationCode) {
      destinationStationCode = station.stationCode;
      break;
    }
  }

  group(
    'fetchStationToStation',
    () {
      test(
        'with no start or destination stations',
        () async {
          final List<StationToStation> result = await fetchStationToStation(
            apiKey,
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'with start and destination stations',
        () async {
          final List<StationToStation> result = await fetchStationToStation(
            apiKey,
            startStationCode: startStationCode,
            destinationStationCode: destinationStationCode,
          );

          expect(
            result.isNotEmpty,
            true,
          );
        },
      );

      test(
        'made up start station',
        () async {
          final List<StationToStation> result = await fetchStationToStation(
            apiKey,
            startStationCode: 'startStationCode',
            destinationStationCode: destinationStationCode,
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );

      test(
        'made up destination station',
        () async {
          final List<StationToStation> result = await fetchStationToStation(
            apiKey,
            startStationCode: startStationCode,
            destinationStationCode: 'destinationStationCode',
          );

          expect(
            result.isEmpty,
            true,
          );
        },
      );

      test(
        'same station for start and destination',
        () async {
          final List<StationToStation> result = await fetchStationToStation(
            apiKey,
            startStationCode: startStationCode,
            destinationStationCode: startStationCode,
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
