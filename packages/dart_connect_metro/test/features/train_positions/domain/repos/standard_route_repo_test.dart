import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  test(
    'fetchStandardRoutes',
    () async {
      final List<StandardRoute> result = await fetchStandardRoutes(apiKey);

      expect(
        result.isNotEmpty,
        true,
      );
    },
  );
}
