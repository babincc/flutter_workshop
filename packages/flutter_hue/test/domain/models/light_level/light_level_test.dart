import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light_level/light_level.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final LightLevel testLightLevel = LightLevel(
    type: ResourceType.lightLevel,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    isEnabled: true,
    level: 654,
    isValidLevel: true,
  );

  final Map<String, dynamic> testLightLevelJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rType: ResourceType.device.value,
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    },
    ApiFields.isEnabled: true,
    ApiFields.type: ResourceType.lightLevel.value,
    ApiFields.light: {
      ApiFields.lightLevel: 654,
      ApiFields.lightLevelValid: true,
    },
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            LightLevel.fromJson(testLightLevelJson),
            testLightLevel,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            LightLevel.fromJson({ApiFields.data: testLightLevelJson}),
            testLightLevel,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            LightLevel.fromJson({
              ApiFields.data: [testLightLevelJson]
            }),
            testLightLevel,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            LightLevel.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testLightLevelJson]
            }),
            testLightLevel,
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
          LightLevel copyLightLevel = testLightLevel.copyWith();

          expect(
            copyLightLevel.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testLightLevelJson,
          );
        },
      );

      test(
        "with changes",
        () {
          LightLevel copyLightLevel = testLightLevel.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyLightLevelJson =
              Map<String, dynamic>.from(testLightLevelJson);

          copyLightLevelJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyLightLevelJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copyLightLevel.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyLightLevelJson,
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
            testLightLevel.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testLightLevelJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testLightLevel.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          LightLevel alteredLightLevel = testLightLevel.copyWith();
          alteredLightLevel.type = ResourceType.device;

          expect(
            alteredLightLevel.toJson(optimizeFor: OptimizeFor.put),
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
              testLightLevel.copyWith(id: "bad_value");
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
              testLightLevel.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
