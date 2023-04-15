import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "readJson",
    () {
      test(
        "valid JSON string",
        () {
          const String jsonString =
              '{"name":"John","age":30,"city":"New York"}';
          const Map<String, dynamic> expectedMap = {
            "name": "John",
            "age": 30,
            "city": "New York"
          };

          expect(JsonTool.readJson(jsonString), expectedMap);
        },
      );

      test(
        "invalid JSON string",
        () {
          const String jsonString =
              '{"name":"John", "age":30, "city":"New York"';

          expect(() => JsonTool.readJson(jsonString),
              throwsA(isA<FormatException>()));
        },
      );

      test(
        "empty JSON string",
        () {
          const String jsonString = "";

          expect(JsonTool.readJson(jsonString), {});
        },
      );

      test(
        "JSON string with empty object",
        () {
          const String jsonString = "{}";

          expect(JsonTool.readJson(jsonString), {});
        },
      );

      test(
        "JSON string with array",
        () {
          const String jsonString = "[1, 2, 3]";

          expect(JsonTool.readJson(jsonString), {});
        },
      );
    },
  );

  group(
    "readJsonOr",
    () {
      test(
        "valid JSON string with single object",
        () {
          const String jsonString =
              '{"name":"John","age":30,"city":"New York"}';
          const List<Map<String, dynamic>> expectedList = [
            {"name": "John", "age": 30, "city": "New York"}
          ];

          expect(JsonTool.readJsonOr(jsonString), expectedList);
        },
      );

      test(
        "valid JSON string with array of objects",
        () {
          const String jsonString =
              '[{"name":"John","age":30,"city":"New York"},{"name":"Jane","age":25,"city":"Boston"}]';
          const List<Map<String, dynamic>> expectedList = [
            {"name": "John", "age": 30, "city": "New York"},
            {"name": "Jane", "age": 25, "city": "Boston"}
          ];

          expect(JsonTool.readJsonOr(jsonString), expectedList);
        },
      );

      test(
        "valid JSON string with array of mixed types",
        () {
          const String jsonString = '["John", 30, {"city": "New York"}]';

          expect(
            JsonTool.readJsonOr(jsonString),
            [
              {"city": "New York"}
            ],
          );
        },
      );

      test(
        "invalid JSON string",
        () {
          const String jsonString =
              '{"name":"John", "age":30, "city":"New York"';

          expect(() => JsonTool.readJsonOr(jsonString),
              throwsA(isA<FormatException>()));
        },
      );

      test(
        "empty JSON string",
        () {
          const String jsonString = "";

          expect(JsonTool.readJsonOr(jsonString), null);
        },
      );

      test(
        "JSON string with empty object",
        () {
          const String jsonString = "{}";

          expect(JsonTool.readJsonOr(jsonString), [{}]);
        },
      );

      test(
        "JSON string with array of empty objects",
        () {
          const String jsonString = "[{}, {}, {}]";

          expect(JsonTool.readJsonOr(jsonString), [{}, {}, {}]);
        },
      );
    },
  );

  group(
    "readJsonList",
    () {
      test(
        "valid JSON string",
        () {
          const String jsonString =
              '[{"name":"John","age":30,"city":"New York"}, {"name":"Jane","age":28,"city":"Paris"}]';
          const List<Map<String, dynamic>> expectedList = [
            {"name": "John", "age": 30, "city": "New York"},
            {"name": "Jane", "age": 28, "city": "Paris"}
          ];

          expect(JsonTool.readJsonList(jsonString), expectedList);
        },
      );

      test(
        "invalid JSON string",
        () {
          const String jsonString =
              '{"name":"John", "age":30, "city":"New York"';

          expect(() => JsonTool.readJsonList(jsonString),
              throwsA(isA<FormatException>()));
        },
      );

      test(
        "empty JSON string",
        () {
          const String jsonString = "";

          expect(JsonTool.readJsonList(jsonString), []);
        },
      );

      test(
        "JSON string with empty array",
        () {
          const String jsonString = "[]";

          expect(JsonTool.readJsonList(jsonString), []);
        },
      );

      test(
        "JSON string with non-object array",
        () {
          const String jsonString = "[1, 2, 3]";

          expect(() => JsonTool.readJsonList(jsonString),
              throwsA(isA<FormatException>()));
        },
      );
    },
  );

  group(
    "writeJson",
    () {
      test(
        "valid map object",
        () {
          const Map<String, dynamic> jsonMap = {
            "name": "John",
            "age": 30,
            "city": "New York"
          };

          const String expectedJsonString =
              '{"name":"John","age":30,"city":"New York"}';

          expect(JsonTool.writeJson(jsonMap), expectedJsonString);
        },
      );

      test(
        "empty map object",
        () {
          const Map<String, dynamic> jsonMap = {};

          const String expectedJsonString = '{}';

          expect(JsonTool.writeJson(jsonMap), expectedJsonString);
        },
      );
    },
  );
}
