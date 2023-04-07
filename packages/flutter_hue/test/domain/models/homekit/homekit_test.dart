import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/homekit/homekit.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Homekit testHomekit = Homekit(
    type: ResourceType.homekit,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    status: "paired",
  );

  final Map<String, dynamic> testHomekitJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.homekit.value,
    ApiFields.status: "paired",
    ApiFields.action: null,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Homekit.fromJson(testHomekitJson),
            testHomekit,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Homekit.fromJson({ApiFields.data: testHomekitJson}),
            testHomekit,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Homekit.fromJson({
              ApiFields.data: [testHomekitJson]
            }),
            testHomekit,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Homekit.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testHomekitJson]
            }),
            testHomekit,
          );
        },
      );
    },
  );

  group(
    "copyWith",
    () {
      test(
        "no change",
        () {
          Homekit copyHomekit = testHomekit.copyWith();

          expect(
            copyHomekit.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testHomekitJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Homekit copyHomekit = testHomekit.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyHomekitJson =
              Map<String, dynamic>.from(testHomekitJson);

          copyHomekitJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyHomekitJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copyHomekit.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyHomekitJson,
          );
        },
      );
    },
  );

  group(
    "toJson",
    () {
      test(
        "don't optimize",
        () {
          expect(
            testHomekit.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testHomekitJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testHomekit.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Homekit alteredHomekit = testHomekit.copyWith();
          alteredHomekit.type = ResourceType.device;

          expect(
            alteredHomekit.toJson(optimizeFor: OptimizeFor.put),
            {
              ApiFields.type: ResourceType.device.value,
            },
          );
        },
      );
    },
  );

  group(
    "exceptions and assertions",
    () {
      test(
        "invalid id assertion",
        () {
          expect(
            () {
              testHomekit.copyWith(id: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid idV1 assertion",
        () {
          expect(
            () {
              testHomekit.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
