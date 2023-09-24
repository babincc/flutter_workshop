import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/services/bus_position_service.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  test(
    'fetchBusPositions',
    () async {
      final List<BusPosition> result =
          await BusPositionService.fetchBusPositions(apiKey);

      expect(
        result.isNotEmpty,
        true,
      );
    },
  );
}
