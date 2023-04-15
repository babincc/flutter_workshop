import 'package:flutter_hue/utils/date_time_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "toHueString",
    () {
      final DateTime dateTime = DateTime(2021, 1, 1, 1, 1, 1, 1, 1);

      test(
        "normal",
        () {
          expect(
            DateTimeTool.toHueString(dateTime),
            "2021-01-01T01:01:01",
          );
        },
      );
    },
  );
}
