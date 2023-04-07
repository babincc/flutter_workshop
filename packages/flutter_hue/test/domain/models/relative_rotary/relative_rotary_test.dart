import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/relative_rotary/relative_rotary.dart';
import 'package:flutter_hue/domain/models/relative_rotary/relative_rotary_last_event.dart';
import 'package:flutter_hue/domain/models/relative_rotary/relative_rotary_rotation.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final RelativeRotary testRelativeRotary = RelativeRotary(
    type: ResourceType.relativeRotary,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    lastEvent: RelativeRotaryLastEvent(
      action: "start",
      rotation: RelativeRotaryRotation(
        direction: "clock_wise",
        steps: 15240,
        durationMilliseconds: 51223,
      ),
    ),
  );

  final Map<String, dynamic> testRelativeRotaryJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rType: ResourceType.device.value,
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    },
    ApiFields.type: ResourceType.relativeRotary.value,
    ApiFields.relativeRotary: {
      ApiFields.lastEvent: {
        ApiFields.action: "start",
        ApiFields.rotation: {
          ApiFields.direction: "clock_wise",
          ApiFields.steps: 15240,
          ApiFields.duration: 51223,
        },
      },
    },
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            RelativeRotary.fromJson(testRelativeRotaryJson),
            testRelativeRotary,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            RelativeRotary.fromJson({ApiFields.data: testRelativeRotaryJson}),
            testRelativeRotary,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            RelativeRotary.fromJson({
              ApiFields.data: [testRelativeRotaryJson]
            }),
            testRelativeRotary,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            RelativeRotary.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testRelativeRotaryJson]
            }),
            testRelativeRotary,
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
          RelativeRotary copyRelativeRotary = testRelativeRotary.copyWith();

          expect(
            copyRelativeRotary.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testRelativeRotaryJson,
          );
        },
      );

      test(
        "with changes",
        () {
          RelativeRotary copyRelativeRotary = testRelativeRotary.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyRelativeRotaryJson =
              Map<String, dynamic>.from(testRelativeRotaryJson);

          copyRelativeRotaryJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyRelativeRotaryJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyRelativeRotary.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyRelativeRotaryJson,
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
            testRelativeRotary.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testRelativeRotaryJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testRelativeRotary.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          RelativeRotary alteredRelativeRotary = testRelativeRotary.copyWith();
          alteredRelativeRotary.type = ResourceType.device;

          expect(
            alteredRelativeRotary.toJson(optimizeFor: OptimizeFor.put),
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
              testRelativeRotary.copyWith(id: "bad_value");
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
              testRelativeRotary.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      group(
        "rotation",
        () {
          test(
            "invalid steps (low) assertion",
            () {
              expect(
                () {
                  testRelativeRotary.copyWith(
                    lastEvent: testRelativeRotary.lastEvent.copyWith(
                      rotation: testRelativeRotary.lastEvent.rotation
                          .copyWith(steps: -2),
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid steps (high) assertion",
            () {
              expect(
                () {
                  testRelativeRotary.copyWith(
                    lastEvent: testRelativeRotary.lastEvent.copyWith(
                      rotation: testRelativeRotary.lastEvent.rotation
                          .copyWith(steps: 33333),
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid duration (low) assertion",
            () {
              expect(
                () {
                  testRelativeRotary.copyWith(
                    lastEvent: testRelativeRotary.lastEvent.copyWith(
                      rotation: testRelativeRotary.lastEvent.rotation
                          .copyWith(durationMilliseconds: -2),
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid duration (high) assertion",
            () {
              expect(
                () {
                  testRelativeRotary.copyWith(
                    lastEvent: testRelativeRotary.lastEvent.copyWith(
                      rotation: testRelativeRotary.lastEvent.rotation
                          .copyWith(durationMilliseconds: 65634),
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );
        },
      );
    },
  );
}
