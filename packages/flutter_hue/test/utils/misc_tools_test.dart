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
    "hash all",
    () {
      final Map<String, dynamic> map1 = {
        "id": "abcdefg",
        "name": "Test",
        "date": DateTime(2020, 1, 1, 1),
        "children": [
          {
            "id": "hijklmnop",
            "name": "Challenge",
            "date": DateTime(2020, 1, 1, 2),
          },
          {
            "id": "qrstuv",
            "name": "Assessment",
            "date": DateTime(2020, 1, 1, 3),
          },
        ],
      };

      final Map<String, dynamic> map2 = {
        "id": "abcdefg",
        "name": "Test",
        "date": DateTime(2020, 1, 1, 1),
        "children": [
          {
            "id": "hijklmnop",
            "name": "Challenge",
            "date": DateTime(2020, 1, 1, 2),
          },
          {
            "id": "qrstuv",
            "name": "Assessment",
            "date": DateTime(2020, 1, 1, 3),
          },
        ],
      };

      final Map<String, dynamic> map3 = {
        "id": "abcdefg",
        "name": "Test",
        "date": DateTime(2020, 1, 1, 1),
        "children": [
          {
            "name": "Challenge",
            "id": "hijklmnop",
            "date": DateTime(2020, 1, 1, 2),
          },
          {
            "id": "qrstuv",
            "name": "Assessment",
            "date": DateTime(2020, 1, 1, 3),
          },
        ],
      };

      final Map<String, dynamic> map4 = {
        "id": "abcdefg",
        "date": DateTime(2020, 1, 1, 1),
        "name": "Test",
        "children": [
          {
            "id": "hijklmnop",
            "name": "Challenge",
            "date": DateTime(2020, 1, 1, 2),
          },
          {
            "id": "qrstuv",
            "name": "Assessment",
            "date": DateTime(2020, 1, 1, 3),
          },
        ],
      };

      final Map<String, dynamic> map5 = {
        "id": "abcdefg",
        "date": DateTime(2020, 1, 1, 1),
        "children": [
          {
            "id": "hijklmnop",
            "name": "Challenge",
            "date": DateTime(2020, 1, 1, 2),
          },
          {
            "id": "qrstuv",
            "name": "Assessment",
            "date": DateTime(2020, 1, 1, 3),
          },
        ],
      };

      final Map<String, dynamic> map6 = {
        "id": "abcdefg",
        "name": "Test",
        "size": 14,
        "date": DateTime(2020, 1, 1, 1),
        "children": [
          {
            "id": "hijklmnop",
            "name": "Challenge",
            "date": DateTime(2020, 1, 1, 2),
          },
          {
            "id": "qrstuv",
            "name": "Assessment",
            "date": DateTime(2020, 1, 1, 3),
          },
        ],
      };

      final Map<String, dynamic> map7 = {
        "id": "abcdefg",
        "name": "Test",
        "date": DateTime(2020, 1, 1, 1),
        "children": [
          {
            "id": "qrstuv",
            "name": "Assessment",
            "date": DateTime(2020, 1, 1, 3),
          },
          {
            "id": "hijklmnop",
            "name": "Challenge",
            "date": DateTime(2020, 1, 1, 2),
          },
        ],
      };

      group(
        "ordered",
        () {
          test(
            "identical",
            () {
              final int hash1 = MiscTools.hashAllMap(map1);
              final int hash2 = MiscTools.hashAllMap(map2);

              expect(
                hash1 == hash2,
                true,
              );
            },
          );

          test(
            "different order nested",
            () {
              final int hash1 = MiscTools.hashAllMap(map1);
              final int hash2 = MiscTools.hashAllMap(map3);

              expect(
                hash1 == hash2,
                false,
              );
            },
          );

          test(
            "different order",
            () {
              final int hash1 = MiscTools.hashAllMap(map1);
              final int hash2 = MiscTools.hashAllMap(map4);

              expect(
                hash1 == hash2,
                false,
              );
            },
          );

          test(
            "missing key",
            () {
              final int hash1 = MiscTools.hashAllMap(map1);
              final int hash2 = MiscTools.hashAllMap(map5);

              expect(
                hash1 == hash2,
                false,
              );
            },
          );

          test(
            "added key",
            () {
              final int hash1 = MiscTools.hashAllMap(map1);
              final int hash2 = MiscTools.hashAllMap(map6);

              expect(
                hash1 == hash2,
                false,
              );
            },
          );

          test(
            "different nested order",
            () {
              final int hash1 = MiscTools.hashAllMap(map1);
              final int hash2 = MiscTools.hashAllMap(map7);

              expect(
                hash1 == hash2,
                false,
              );
            },
          );
        },
      );

      group(
        "unordered",
        () {
          test(
            "identical",
            () {
              final int hash1 = MiscTools.hashAllUnorderedMap(map1);
              final int hash2 = MiscTools.hashAllUnorderedMap(map2);

              expect(
                hash1 == hash2,
                true,
              );
            },
          );

          test(
            "different order nested",
            () {
              final int hash1 = MiscTools.hashAllUnorderedMap(map1);
              final int hash2 = MiscTools.hashAllUnorderedMap(map3);

              expect(
                hash1 == hash2,
                true,
              );
            },
          );

          test(
            "different order",
            () {
              final int hash1 = MiscTools.hashAllUnorderedMap(map1);
              final int hash2 = MiscTools.hashAllUnorderedMap(map4);

              expect(
                hash1 == hash2,
                true,
              );
            },
          );

          test(
            "missing key",
            () {
              final int hash1 = MiscTools.hashAllUnorderedMap(map1);
              final int hash2 = MiscTools.hashAllUnorderedMap(map5);

              expect(
                hash1 == hash2,
                false,
              );
            },
          );

          test(
            "added key",
            () {
              final int hash1 = MiscTools.hashAllUnorderedMap(map1);
              final int hash2 = MiscTools.hashAllUnorderedMap(map6);

              expect(
                hash1 == hash2,
                false,
              );
            },
          );

          test(
            "different nested order",
            () {
              final int hash1 = MiscTools.hashAllUnorderedMap(map1);
              final int hash2 = MiscTools.hashAllUnorderedMap(map7);

              expect(
                hash1 == hash2,
                true,
              );
            },
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
