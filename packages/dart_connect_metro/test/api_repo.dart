import 'dart:io';

class ApiRepo {
  static final String pathToPrimaryKey =
      '${Directory.current.path}/test/api_key.key';
  static final String pathToSecondaryKey =
      '${Directory.current.path}/test/api_key_2.key';

  static String getApiKey() => File(pathToPrimaryKey).readAsStringSync();

  static String getApiKey2() => File(pathToSecondaryKey).readAsStringSync();
}
