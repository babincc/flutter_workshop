import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "extractData",
    () {
      const Map<String, dynamic> expectedDataMap = {
        "id": "abcdefg",
        "name": "Test",
      };

      test(
        "normal",
        () {
          const Map<String, dynamic> rawDataMap = {
            "errors": [],
            "data": [
              {"id": "abcdefg", "name": "Test"},
            ],
          };

          expect(
            MiscTools.extractData(rawDataMap),
            expectedDataMap,
          );
        },
      );

      test(
        "multiple",
        () {
          const Map<String, dynamic> rawDataMap = {
            "errors": [],
            "data": [
              {"id": "abcdefg", "name": "Test"},
              {"id": "hijklmnop", "name": "Challenge"},
              {"id": "qrstuv", "name": "Assessment"},
            ],
          };

          expect(
            MiscTools.extractData(rawDataMap),
            expectedDataMap,
          );
        },
      );

      test(
        "with errors",
        () {
          const Map<String, dynamic> rawDataMap = {
            "errors": [
              {"type": 1, "description": "not available"},
            ],
            "data": [
              {"id": "abcdefg", "name": "Test"},
            ],
          };

          expect(
            MiscTools.extractData(rawDataMap),
            expectedDataMap,
          );
        },
      );

      test(
        "empty",
        () {
          const Map<String, dynamic> rawDataMap = {
            "errors": [],
            "data": [],
          };

          expect(
            MiscTools.extractData(rawDataMap),
            {},
          );
        },
      );

      test(
        "empty with errors",
        () {
          const Map<String, dynamic> rawDataMap = {
            "errors": [
              {"type": 1, "description": "not available"},
            ],
            "data": [],
          };

          expect(
            MiscTools.extractData(rawDataMap),
            {},
          );
        },
      );

      test(
        "just data nested",
        () {
          const Map<String, dynamic> rawDataMap = {
            "data": [
              {"id": "abcdefg", "name": "Test"},
            ],
          };

          expect(
            MiscTools.extractData(rawDataMap),
            expectedDataMap,
          );
        },
      );

      test(
        "just data",
        () {
          const Map<String, dynamic> rawDataMap = {
            "id": "abcdefg",
            "name": "Test"
          };

          expect(
            MiscTools.extractData(rawDataMap),
            expectedDataMap,
          );
        },
      );
    },
  );

  group(
    "extractDataList",
    () {
      const List<Map<String, dynamic>> expectedDataMaps = [
        {
          "id": "abcdefg",
          "name": "Test",
        },
      ];

      test(
        "normal",
        () {
          const Map<String, dynamic> rawDataMap = {
            "errors": [],
            "data": [
              {"id": "abcdefg", "name": "Test"},
            ],
          };

          expect(
            MiscTools.extractDataList(rawDataMap),
            expectedDataMaps,
          );
        },
      );

      test(
        "multiple",
        () {
          const Map<String, dynamic> rawDataMap = {
            "errors": [],
            "data": [
              {"id": "abcdefg", "name": "Test"},
              {"id": "hijklmnop", "name": "Challenge"},
              {"id": "qrstuv", "name": "Assessment"},
            ],
          };

          expect(
            MiscTools.extractDataList(rawDataMap),
            [
              {"id": "abcdefg", "name": "Test"},
              {"id": "hijklmnop", "name": "Challenge"},
              {"id": "qrstuv", "name": "Assessment"},
            ],
          );
        },
      );

      test(
        "with errors",
        () {
          const Map<String, dynamic> rawDataMap = {
            "errors": [
              {"type": 1, "description": "not available"},
            ],
            "data": [
              {"id": "abcdefg", "name": "Test"},
            ],
          };

          expect(
            MiscTools.extractDataList(rawDataMap),
            expectedDataMaps,
          );
        },
      );

      test(
        "empty",
        () {
          const Map<String, dynamic> rawDataMap = {
            "errors": [],
            "data": [],
          };

          expect(
            MiscTools.extractDataList(rawDataMap),
            [],
          );
        },
      );

      test(
        "empty with errors",
        () {
          const Map<String, dynamic> rawDataMap = {
            "errors": [
              {"type": 1, "description": "not available"},
            ],
            "data": [],
          };

          expect(
            MiscTools.extractDataList(rawDataMap),
            [],
          );
        },
      );

      test(
        "just data nested",
        () {
          const Map<String, dynamic> rawDataMap = {
            "data": [
              {"id": "abcdefg", "name": "Test"},
            ],
          };

          expect(
            MiscTools.extractDataList(rawDataMap),
            expectedDataMaps,
          );
        },
      );

      test(
        "just data",
        () {
          const Map<String, dynamic> rawDataMap = {
            "id": "abcdefg",
            "name": "Test"
          };

          expect(
            MiscTools.extractDataList(rawDataMap),
            null,
          );
        },
      );
    },
  );

  group(
    "randInt",
    () {
      test(
        "normal",
        () {
          const int min = 1;
          const int max = 10;

          for (int i = 0; i < 100; i++) {
            int rand = MiscTools.randInt(min, max);

            expect(
              rand >= min && rand <= max,
              true,
            );
          }
        },
      );

      test(
        "include zero",
        () {
          const int min = 0;
          const int max = 10;

          for (int i = 0; i < 100; i++) {
            int rand = MiscTools.randInt(min, max);

            expect(
              rand >= min && rand <= max,
              true,
            );
          }
        },
      );

      test(
        "same number",
        () {
          const int min = 5;
          const int max = 5;

          for (int i = 0; i < 100; i++) {
            int rand = MiscTools.randInt(min, max);

            expect(
              rand == 5,
              true,
            );
          }
        },
      );

      test(
        "inverted min and max",
        () {
          const int min = 10;
          const int max = 1;

          for (int i = 0; i < 100; i++) {
            int rand = MiscTools.randInt(min, max);

            expect(
              rand >= max && rand <= min,
              true,
            );
          }
        },
      );

      test(
        "negative numbers",
        () {
          const int min = -10;
          const int max = -1;

          for (int i = 0; i < 100; i++) {
            int rand = MiscTools.randInt(min, max);

            expect(
              rand >= min && rand <= max,
              true,
            );
          }
        },
      );

      test(
        "negative and positive numbers",
        () {
          const int min = -10;
          const int max = 10;

          for (int i = 0; i < 100; i++) {
            int rand = MiscTools.randInt(min, max);

            expect(
              rand >= min && rand <= max,
              true,
            );
          }
        },
      );
    },
  );
}
