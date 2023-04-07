import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/motion/motion.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Motion testMotion = Motion(
    type: ResourceType.motion,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    isEnabled: true,
    hasMotion: false,
    isValidMotion: true,
  );

  final Map<String, dynamic> testMotionJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rType: ResourceType.device.value,
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    },
    ApiFields.isEnabled: true,
    ApiFields.type: ResourceType.motion.value,
    ApiFields.motion: {
      ApiFields.motion: false,
      ApiFields.motionValid: true,
    },
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Motion.fromJson(testMotionJson),
            testMotion,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Motion.fromJson({ApiFields.data: testMotionJson}),
            testMotion,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Motion.fromJson({
              ApiFields.data: [testMotionJson]
            }),
            testMotion,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Motion.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testMotionJson]
            }),
            testMotion,
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
          Motion copyMotion = testMotion.copyWith();

          expect(
            copyMotion.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testMotionJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Motion copyMotion = testMotion.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyMotionJson =
              Map<String, dynamic>.from(testMotionJson);

          copyMotionJson[ApiFields.id] = "00000000-0000-0000-0000-000000000000";
          copyMotionJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copyMotion.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyMotionJson,
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
            testMotion.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testMotionJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testMotion.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Motion alteredMotion = testMotion.copyWith();
          alteredMotion.type = ResourceType.device;

          expect(
            alteredMotion.toJson(optimizeFor: OptimizeFor.put),
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
              testMotion.copyWith(id: "bad_value");
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
              testMotion.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
