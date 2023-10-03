import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  test(
    'fetchTrackCircuits',
    () async {
      final List<TrackCircuit> result = await fetchTrackCircuits(apiKey);

      expect(
        result.isNotEmpty,
        true,
      );
    },
  );
}
