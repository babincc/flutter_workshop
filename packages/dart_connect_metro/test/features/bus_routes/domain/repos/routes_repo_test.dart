import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  test(
    'fetchRoutes',
    () async {
      final List<Route> result = await fetchRoutes(apiKey);

      expect(
        result.isNotEmpty,
        true,
      );
    },
  );
}
