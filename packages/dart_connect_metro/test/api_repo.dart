import 'dart:io';

class ApiRepo {
  static final String path = '${Directory.current.path}/test/api_key.key';

  static String getApiKey() => File(path).readAsStringSync();
}
