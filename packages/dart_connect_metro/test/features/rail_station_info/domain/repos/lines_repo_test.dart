import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  final String apiKey = ApiRepo.getApiKey();

  test(
    'fetchLines',
    () async {
      final List<Line> result = await fetchLines(apiKey);

      expect(
        result.isNotEmpty,
        true,
      );
    },
  );
}
