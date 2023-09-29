import 'package:dart_connect_metro/dart_connect_metro.dart';
import 'package:test/test.dart';

import '../../../../api_repo.dart';

void main() {
  group(
    'fetchApiKeyValidation',
    () {
      test(
        'primary key',
        () async {
          final String apiKey = ApiRepo.getApiKey();

          final bool result = await fetchApiKeyValidation(apiKey);

          expect(
            result,
            true,
          );
        },
      );

      test(
        'secondary key',
        () async {
          final String apiKey = ApiRepo.getApiKey2();

          final bool result = await fetchApiKeyValidation(apiKey);

          expect(
            result,
            true,
          );
        },
      );

      test(
        'made up key',
        () async {
          final bool result = await fetchApiKeyValidation('abc123');

          expect(
            result,
            false,
          );
        },
      );

      test(
        'empty key',
        () async {
          final bool result = await fetchApiKeyValidation('');

          expect(
            result,
            false,
          );
        },
      );
    },
  );
}
