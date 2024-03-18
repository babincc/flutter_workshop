import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/grouped_light/grouped_light.dart';
import 'package:flutter_hue/domain/models/light/light_alert.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature_delta.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature_delta_action.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature_mirek_schema.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming_delta.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming_delta_action.dart';
import 'package:flutter_hue/domain/models/light/light_on.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_value_exception.dart';
import 'package:flutter_hue/exceptions/negative_value_exception.dart';
import 'package:flutter_hue/exceptions/percentage_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final GroupedLight testGroupedLight = GroupedLight(
    type: ResourceType.groupedLight,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.room,
      id: "ffffffff-ffff-ffff-ffff-ffffffffffff",
    ),
    on: LightOn(isOn: true),
    dimming: LightDimming(brightness: 100.0),
    xy: LightColorXy.empty(),
    alert: LightAlert(
      actionValues: ["breathe"],
      action: "breathe",
    ),
  );

  final Map<String, dynamic> testGroupedLightJson = {
    ApiFields.type: ResourceType.groupedLight.value,
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rid: "ffffffff-ffff-ffff-ffff-ffffffffffff",
      ApiFields.rType: ResourceType.room.value,
    },
    ApiFields.isOn: {
      ApiFields.isOn: true,
    },
    ApiFields.dimming: {
      ApiFields.brightness: 100.0,
    },
    ApiFields.dimmingDelta: null,
    ApiFields.colorTemperature: null,
    ApiFields.colorTemperatureDelta: null,
    ApiFields.color: {
      ApiFields.xy: {
        ApiFields.x: 0.0,
        ApiFields.y: 0.0,
      },
    },
    ApiFields.alert: {
      ApiFields.actionValues: ["breathe"],
      ApiFields.action: "breathe",
    },
    ApiFields.dynamics: {ApiFields.duration: null},
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            GroupedLight.fromJson(testGroupedLightJson),
            testGroupedLight,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            GroupedLight.fromJson({ApiFields.data: testGroupedLightJson}),
            testGroupedLight,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            GroupedLight.fromJson({
              ApiFields.data: [testGroupedLightJson]
            }),
            testGroupedLight,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            GroupedLight.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testGroupedLightJson]
            }),
            testGroupedLight,
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
          GroupedLight copyGroupedLight = testGroupedLight.copyWith();

          expect(
            copyGroupedLight.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testGroupedLightJson,
          );
        },
      );

      test(
        "with changes",
        () {
          GroupedLight copyGroupedLight = testGroupedLight.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyGroupedLightJson =
              Map<String, dynamic>.from(testGroupedLightJson);

          copyGroupedLightJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyGroupedLightJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyGroupedLight.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyGroupedLightJson,
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
            testGroupedLight.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testGroupedLightJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testGroupedLight.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          GroupedLight alteredGroupedLight = testGroupedLight.copyWith();
          alteredGroupedLight.type = ResourceType.device;

          expect(
            alteredGroupedLight.toJson(optimizeFor: OptimizeFor.put),
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
              testGroupedLight.copyWith(id: "bad_value");
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
              testGroupedLight.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      group(
        "dimming",
        () {
          test(
            "invalid brightness (low) assertion",
            () {
              expect(
                () {
                  testGroupedLight.copyWith(
                    dimming: LightDimming(
                      brightness: -1.0,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid brightness (high) assertion",
            () {
              expect(
                () {
                  testGroupedLight.copyWith(
                    dimming: LightDimming(
                      brightness: 100.1,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid brightness (low) exception",
            () {
              expect(
                () {
                  testGroupedLight.dimming.brightness = -0.001;
                },
                throwsA(isA<PercentageException>()),
              );
            },
          );

          test(
            "invalid brightness (high) exception",
            () {
              expect(
                () {
                  testGroupedLight.dimming.brightness = 100.00000000001;
                },
                throwsA(isA<PercentageException>()),
              );
            },
          );
        },
      );

      group(
        "dimming delta",
        () {
          GroupedLight alteredGroupedLight = testGroupedLight.copyWith(
            dimmingDelta: LightDimmingDelta(
              action: LightDimmingDeltaAction.stop,
              delta: 0.0,
            ),
          );

          test(
            "invalid delta (low) assertion",
            () {
              expect(
                () {
                  testGroupedLight.copyWith(
                    dimmingDelta: LightDimmingDelta(
                      action: LightDimmingDeltaAction.stop,
                      delta: -0.1,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid delta (high) assertion",
            () {
              expect(
                () {
                  testGroupedLight.copyWith(
                    dimmingDelta: LightDimmingDelta(
                      action: LightDimmingDeltaAction.stop,
                      delta: 1000,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid delta (low) exception",
            () {
              expect(
                () {
                  alteredGroupedLight.dimmingDelta!.delta = -125.23;
                },
                throwsA(isA<PercentageException>()),
              );
            },
          );

          test(
            "invalid delta (high) exception",
            () {
              expect(
                () {
                  alteredGroupedLight.dimmingDelta!.delta = 101;
                },
                throwsA(isA<PercentageException>()),
              );
            },
          );
        },
      );

      group(
        "color temperature",
        () {
          test(
            "invalid mirek (low) assertion",
            () {
              expect(
                () {
                  testGroupedLight.copyWith(
                    colorTemperature: LightColorTemperature(
                      mirek: 152,
                      mirekValid: true,
                      mirekSchema: const LightColorTemperatureMirekSchema(
                        min: 153,
                        max: 500,
                      ),
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid mirek (high) assertion",
            () {
              expect(
                () {
                  testGroupedLight.copyWith(
                    colorTemperature: LightColorTemperature(
                      mirek: 501,
                      mirekValid: true,
                      mirekSchema: const LightColorTemperatureMirekSchema(
                        min: 153,
                        max: 500,
                      ),
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );
        },
      );

      group(
        "color temperature delta",
        () {
          GroupedLight alteredGroupedLight = testGroupedLight.copyWith(
            colorTemperatureDelta: LightColorTemperatureDelta(
              action: LightColorTemperatureDeltaAction.stop,
              delta: 0,
            ),
          );

          test(
            "invalid delta (low) assertion",
            () {
              expect(
                () {
                  testGroupedLight.copyWith(
                    colorTemperatureDelta: LightColorTemperatureDelta(
                      action: LightColorTemperatureDeltaAction.stop,
                      delta: -1,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid delta (high) assertion",
            () {
              expect(
                () {
                  testGroupedLight.copyWith(
                    colorTemperatureDelta: LightColorTemperatureDelta(
                      action: LightColorTemperatureDeltaAction.stop,
                      delta: 348,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid delta (low) exception",
            () {
              expect(
                () {
                  alteredGroupedLight.colorTemperatureDelta!.delta = -125;
                },
                throwsException,
              );
            },
          );

          test(
            "invalid delta (high) exception",
            () {
              expect(
                () {
                  alteredGroupedLight.colorTemperatureDelta!.delta = 350;
                },
                throwsException,
              );
            },
          );
        },
      );

      group(
        "alert",
        () {
          GroupedLight alteredGroupedLight = testGroupedLight.copyWith(
            alert: LightAlert(
              actionValues: ["value1", "value2"],
              action: "value1",
            ),
          );

          test(
            "invalid action value assertion",
            () {
              expect(
                () {
                  testGroupedLight.copyWith(
                    alert: LightAlert(
                      actionValues: ["value1", "value2"],
                      action: "valueZ",
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid action value (empty) assertion",
            () {
              expect(
                () {
                  testGroupedLight.copyWith(
                    alert: LightAlert(
                      actionValues: ["value1", "value2"],
                      action: "",
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid action value (old value) exception",
            () {
              expect(
                () {
                  alteredGroupedLight.copyWith(
                    alert: alteredGroupedLight.alert
                        .copyWith(actionValues: ["itemA", "itemB"]),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );

          test(
            "invalid action value (old value - empty list) exception",
            () {
              expect(
                () {
                  alteredGroupedLight.copyWith(
                    alert: alteredGroupedLight.alert.copyWith(actionValues: []),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );
        },
      );

      test(
        "invalid duration assertion",
        () {
          expect(
            () {
              testGroupedLight.durationMilliseconds = -10;
            },
            throwsA(isA<NegativeValueException>()),
          );
        },
      );
    },
  );
}
