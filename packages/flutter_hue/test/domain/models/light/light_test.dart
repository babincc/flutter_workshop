import 'package:flutter/material.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light.dart';
import 'package:flutter_hue/domain/models/light/light_alert.dart';
import 'package:flutter_hue/domain/models/light/light_archetype.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_gamut.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_gamut_type.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature_delta.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature_delta_action.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature_mirek_schema.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming_delta.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming_delta_action.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming_full.dart';
import 'package:flutter_hue/domain/models/light/light_dynamics.dart';
import 'package:flutter_hue/domain/models/light/light_effects.dart';
import 'package:flutter_hue/domain/models/light/light_gradient/light_gradient_full.dart';
import 'package:flutter_hue/domain/models/light/light_metadata.dart';
import 'package:flutter_hue/domain/models/light/light_mode.dart';
import 'package:flutter_hue/domain/models/light/light_on.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_color/light_power_up_color.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_color/light_power_up_color_color_temperature.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_color/light_power_up_color_mode.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_dimming/light_power_up_dimming.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_dimming/light_power_up_dimming_mode.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_on/light_power_up_on.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_on/light_power_up_on_mode.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_preset.dart';
import 'package:flutter_hue/domain/models/light/light_signaling/light_signaling.dart';
import 'package:flutter_hue/domain/models/light/light_signaling/light_signaling_status.dart';
import 'package:flutter_hue/domain/models/light/light_timed_effects.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/gradient_exception.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/exceptions/invalid_value_exception.dart';
import 'package:flutter_hue/exceptions/mirek_exception.dart';
import 'package:flutter_hue/exceptions/percentage_exception.dart';
import 'package:flutter_hue/exceptions/unit_interval_exception.dart';
import 'package:flutter_hue/utils/date_time_tool.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Light testLight = Light(
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    type: ResourceType.light,
    owner: Relative(
      id: "ffffffff-ffff-ffff-ffff-ffffffffffff",
      type: ResourceType.device,
    ),
    metadata: LightMetadata(
      name: "Test Light",
      archetype: LightArchetype.sultanBulb,
      fixedMired: 153,
    ),
    on: LightOn(isOn: true),
    dimming:
        LightDimmingFull(brightness: 100.0, minDimLevel: 0.20000000298023224),
    dimmingDelta: null,
    colorTemperature: LightColorTemperature(
      mirek: 230,
      mirekValid: true,
      mirekSchema: const LightColorTemperatureMirekSchema(min: 153, max: 500),
    ),
    colorTemperatureDelta: null,
    color: LightColor(
      xy: LightColorXy(x: 0.367, y: 0.3707),
      gamut: LightColorGamut(
          red: LightColorXy(x: 0.6915, y: 0.3083),
          green: LightColorXy(x: 0.17, y: 0.7),
          blue: LightColorXy(x: 0.1532, y: 0.0475)),
      gamutType: LightColorGamutType.c,
    ),
    dynamics: LightDynamics(
      status: "none",
      statusValues: ["none", "dynamic_palette"],
      speed: 0.0,
      speedValid: false,
    ),
    alert: LightAlert(actionValues: ["breathe"]),
    signaling: LightSignaling(
      status: LightSignalingStatus.fromJson(
        {
          ApiFields.signal: "no_signal",
          ApiFields.signalValues: ["no_signal", "on_off"],
        },
      ),
      signalValues: ["no_signal", "on_off"],
    ),
    mode: LightMode.normal,
    gradient: LightGradientFull.fromJson({}),
    effects: LightEffects(
      effect: "no_effect",
      effectValues: const ["no_effect", "candle", "fire"],
      status: "no_effect",
      statusValues: const ["no_effect", "candle", "fire"],
    ),
    timedEffects: LightTimedEffects.fromJson({}),
    powerUp: LightPowerUp(
      preset: LightPowerUpPreset.safety,
      isConfigured: true,
      on: LightPowerUpOn(
        mode: LightPowerUpOnMode.on,
        on: LightOn(isOn: true),
      ),
      dimming: LightPowerUpDimming(
        mode: LightPowerUpDimmingMode.dimming,
        brightness: 100.0,
      ),
      color: LightPowerUpColor(
        mode: LightPowerUpColorMode.colorTemperature,
        colorTemperature: LightPowerUpColorColorTemperature(mirek: 366),
        color: LightColorXy.fromJson({}),
      ),
    ),
  );

  final Map<String, dynamic> testLightJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rid: "ffffffff-ffff-ffff-ffff-ffffffffffff",
      ApiFields.rType: ResourceType.device.value,
    },
    ApiFields.metadata: {
      ApiFields.name: "Test Light",
      ApiFields.archetype: LightArchetype.sultanBulb.value,
      ApiFields.fixedMired: 153,
    },
    ApiFields.isOn: {
      ApiFields.isOn: true,
    },
    ApiFields.dimming: {
      ApiFields.brightness: 100.0,
      ApiFields.minDimLevel: 0.20000000298023224,
    },
    ApiFields.dimmingDelta: null,
    ApiFields.colorTemperature: {
      ApiFields.mirek: 230,
      ApiFields.mirekValid: true,
      ApiFields.mirekSchema: {
        ApiFields.mirekMinimum: 153,
        ApiFields.mirekMaximum: 500,
      },
    },
    ApiFields.colorTemperatureDelta: null,
    ApiFields.color: {
      ApiFields.xy: {
        ApiFields.x: 0.367,
        ApiFields.y: 0.3707,
      },
      ApiFields.gamut: {
        ApiFields.red: {
          ApiFields.x: 0.6915,
          ApiFields.y: 0.3083,
        },
        ApiFields.green: {
          ApiFields.x: 0.17,
          ApiFields.y: 0.7,
        },
        ApiFields.blue: {
          ApiFields.x: 0.1532,
          ApiFields.y: 0.0475,
        }
      },
      ApiFields.gamutType: LightColorGamutType.c.value
    },
    ApiFields.dynamics: {
      ApiFields.status: "none",
      ApiFields.statusValues: ["none", "dynamic_palette"],
      ApiFields.speed: 0.0,
      ApiFields.speedValid: false,
      ApiFields.duration: null,
    },
    ApiFields.alert: {
      ApiFields.actionValues: ["breathe"],
      ApiFields.action: null,
    },
    ApiFields.signaling: {
      ApiFields.status: {
        ApiFields.signal: "no_signal",
        ApiFields.signalValues: ["no_signal", "on_off"],
        ApiFields.estimatedEnd:
            DateTimeTool.toHueString(DateUtils.dateOnly(DateTime.now())),
      },
      ApiFields.signalValues: ["no_signal", "on_off"]
    },
    ApiFields.mode: LightMode.normal.value,
    ApiFields.gradient: {
      ApiFields.points: [],
      ApiFields.mode: "",
      ApiFields.modeValues: [],
      ApiFields.pointsCapable: 0,
      ApiFields.pixelCount: 0,
    },
    ApiFields.effects: {
      ApiFields.effect: "no_effect",
      ApiFields.statusValues: ["no_effect", "candle", "fire"],
      ApiFields.status: "no_effect",
      ApiFields.effectValues: ["no_effect", "candle", "fire"]
    },
    ApiFields.timedEffects: {
      ApiFields.effect: "",
      ApiFields.duration: 0,
      ApiFields.statusValues: [],
      ApiFields.status: "",
      ApiFields.effectValues: []
    },
    ApiFields.powerUp: {
      ApiFields.preset: LightPowerUpPreset.safety.value,
      ApiFields.isConfigured: true,
      ApiFields.isOn: {
        ApiFields.mode: LightPowerUpOnMode.on.value,
        ApiFields.isOn: {
          ApiFields.isOn: true,
        }
      },
      ApiFields.dimming: {
        ApiFields.mode: LightPowerUpDimmingMode.dimming.value,
        ApiFields.dimming: {
          ApiFields.brightness: 100.0,
        }
      },
      ApiFields.color: {
        ApiFields.mode: LightPowerUpColorMode.colorTemperature.value,
        ApiFields.colorTemperature: {
          ApiFields.mirek: 366,
        },
        ApiFields.color: {
          ApiFields.x: 0.0,
          ApiFields.y: 0.0,
        },
      },
    },
    ApiFields.type: "light",
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Light.fromJson(testLightJson),
            testLight,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Light.fromJson({ApiFields.data: testLightJson}),
            testLight,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Light.fromJson({
              ApiFields.data: [testLightJson]
            }),
            testLight,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Light.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testLightJson]
            }),
            testLight,
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
          Light copyLight = testLight.copyWith();

          expect(
            copyLight.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testLightJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Light copyLight = testLight.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyLightJson =
              Map<String, dynamic>.from(testLightJson);

          copyLightJson[ApiFields.id] = "00000000-0000-0000-0000-000000000000";
          copyLightJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copyLight.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyLightJson,
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
            testLight.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testLightJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testLight.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change) 1",
        () {
          Light alteredLight = testLight.copyWith(
            gradient: LightGradientFull(
              points: [
                LightColorXy(x: 0.1, y: 0.2),
                LightColorXy(x: 0.3, y: 0.4),
              ],
              mode: "interpolated_palette",
              modeValues: [
                "interpolated_palette",
                "interpolated_palette_mirrored",
                "random_pixelated"
              ],
              pointsCapable: 0,
              pixelCount: 0,
            ),
          );
          alteredLight.type = ResourceType.device;
          alteredLight.color.xy.y = 0.123456;
          alteredLight.gradient.addPoint(LightColorXy(x: 0.5, y: 0.6));

          expect(
            alteredLight.toJson(optimizeFor: OptimizeFor.put),
            {
              ApiFields.type: ResourceType.device.value,
              ApiFields.color: {
                ApiFields.xy: {
                  ApiFields.x: 0.367,
                  ApiFields.y: 0.123456,
                },
              },
              ApiFields.gradient: {
                ApiFields.mode: "interpolated_palette",
                ApiFields.points: [
                  {
                    ApiFields.color: {
                      ApiFields.xy: {
                        ApiFields.x: 0.1,
                        ApiFields.y: 0.2,
                      },
                    },
                  },
                  {
                    ApiFields.color: {
                      ApiFields.xy: {
                        ApiFields.x: 0.3,
                        ApiFields.y: 0.4,
                      },
                    },
                  },
                  {
                    ApiFields.color: {
                      ApiFields.xy: {
                        ApiFields.x: 0.5,
                        ApiFields.y: 0.6,
                      },
                    },
                  },
                ],
              },
            },
          );
        },
      );

      test(
        "optimize for PUT (with change) 2",
        () {
          Light alteredLight = testLight.copyWith();
          alteredLight.gradient.addPoint(LightColorXy(x: 0.1, y: 0.2));
          alteredLight.gradient.addPoint(LightColorXy(x: 0.3, y: 0.4));

          expect(
            alteredLight.toJson(optimizeFor: OptimizeFor.put),
            {
              ApiFields.gradient: {
                ApiFields.mode: "",
                ApiFields.points: [
                  {
                    ApiFields.color: {
                      ApiFields.xy: {
                        ApiFields.x: 0.1,
                        ApiFields.y: 0.2,
                      },
                    },
                  },
                  {
                    ApiFields.color: {
                      ApiFields.xy: {
                        ApiFields.x: 0.3,
                        ApiFields.y: 0.4,
                      },
                    },
                  },
                ],
              },
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
              testLight.copyWith(id: "bad_value");
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
              testLight.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid relative id assertion",
        () {
          expect(
            () {
              testLight.copyWith(
                  owner: Relative(
                type: ResourceType.device,
                id: "bad_value",
              ));
            },
            throwsAssertionError,
          );
        },
      );

      group(
        "metadata",
        () {
          test(
            "invalid name assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    metadata: LightMetadata(
                      name:
                          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                      archetype: LightArchetype.sultanBulb,
                      fixedMired: 153,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid mired (low) assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    metadata: LightMetadata(
                      name: "My Light",
                      archetype: LightArchetype.sultanBulb,
                      fixedMired: 100,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid mired (high) assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    metadata: LightMetadata(
                      name: "My Light",
                      archetype: LightArchetype.sultanBulb,
                      fixedMired: 501,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid name exception",
            () {
              expect(
                () {
                  // ignore: deprecated_member_use_from_same_package
                  testLight.metadata.name = "";
                },
                throwsA(isA<InvalidNameException>()),
              );
            },
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
                  testLight.copyWith(
                    dimming: LightDimmingFull(
                      brightness: -1.0,
                      minDimLevel: 10.0,
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
                  testLight.copyWith(
                    dimming: LightDimmingFull(
                      brightness: 100.1,
                      minDimLevel: 10.0,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid min dim level (low) assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    dimming: LightDimmingFull(
                      brightness: 100.0,
                      minDimLevel: -1.0,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid min dim level (high) assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    dimming: LightDimmingFull(
                      brightness: 100.0,
                      minDimLevel: 100.1,
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
                  testLight.dimming.brightness = -0.001;
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
                  testLight.dimming.brightness = 100.00000000001;
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
          Light alteredLight = testLight.copyWith(
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
                  testLight.copyWith(
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
                  testLight.copyWith(
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
                  alteredLight.dimmingDelta!.delta = -125.23;
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
                  alteredLight.dimmingDelta!.delta = 101;
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
                  testLight.copyWith(
                    colorTemperature: LightColorTemperature(
                      mirek: 152,
                      mirekValid: true,
                      mirekSchema: testLight.colorTemperature.mirekSchema,
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
                  testLight.copyWith(
                    colorTemperature: LightColorTemperature(
                      mirek: 501,
                      mirekValid: true,
                      mirekSchema: testLight.colorTemperature.mirekSchema,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid mirek (low) exception",
            () {
              expect(
                () {
                  testLight.colorTemperature.mirek = -250;
                },
                throwsA(isA<MirekException>()),
              );
            },
          );

          test(
            "invalid mirek (high) exception",
            () {
              expect(
                () {
                  testLight.colorTemperature.mirek = 2500;
                },
                throwsA(isA<MirekException>()),
              );
            },
          );
        },
      );

      group(
        "color temperature delta",
        () {
          Light alteredLight = testLight.copyWith(
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
                  testLight.copyWith(
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
                  testLight.copyWith(
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
                  alteredLight.colorTemperatureDelta!.delta = -125;
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
                  alteredLight.colorTemperatureDelta!.delta = 350;
                },
                throwsException,
              );
            },
          );
        },
      );

      group(
        "dynamics",
        () {
          Light alteredLight = testLight.copyWith(
            dynamics: testLight.dynamics
                .copyWith(status: "value1", statusValues: ["value1", "value2"]),
          );

          test(
            "invalid status assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    dynamics: testLight.dynamics.copyWith(
                        status: "valueZ", statusValues: ["value1", "value2"]),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid speed (low) assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    dynamics: LightDynamics(
                      status: testLight.dynamics.status,
                      statusValues: testLight.dynamics.statusValues,
                      speed: -2.0,
                      speedValid: testLight.dynamics.speedValid,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid speed (high) assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    dynamics: LightDynamics(
                      status: testLight.dynamics.status,
                      statusValues: testLight.dynamics.statusValues,
                      speed: 2.0,
                      speedValid: testLight.dynamics.speedValid,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid duration assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    dynamics: LightDynamics(
                      status: testLight.dynamics.status,
                      statusValues: testLight.dynamics.statusValues,
                      speed: 0.5,
                      speedValid: testLight.dynamics.speedValid,
                      durationMilliseconds: -10,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid status (old value) exception",
            () {
              expect(
                () {
                  alteredLight.copyWith(
                    dynamics: alteredLight.dynamics
                        .copyWith(statusValues: ["itemA", "itemB"]),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );

          test(
            "invalid status (old value - empty list) exception",
            () {
              expect(
                () {
                  alteredLight.copyWith(
                    dynamics: alteredLight.dynamics.copyWith(statusValues: []),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );

          test(
            "invalid speed (low) exception",
            () {
              expect(
                () {
                  testLight.copyWith(
                    dynamics: testLight.dynamics.copyWith(speed: -2.0),
                  );
                },
                throwsA(isA<UnitIntervalException>()),
              );
            },
          );

          test(
            "invalid speed (high) exception",
            () {
              expect(
                () {
                  testLight.copyWith(
                    dynamics: testLight.dynamics.copyWith(speed: 2.0),
                  );
                },
                throwsA(isA<UnitIntervalException>()),
              );
            },
          );
        },
      );

      group(
        "alert",
        () {
          Light alteredLight = testLight.copyWith(
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
                  testLight.copyWith(
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
                  testLight.copyWith(
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
                  alteredLight.copyWith(
                    alert: alteredLight.alert
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
                  alteredLight.copyWith(
                    alert: alteredLight.alert.copyWith(actionValues: []),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );
        },
      );

      group(
        "signaling status",
        () {
          Light alteredLight = testLight.copyWith(
            signaling: LightSignaling(
              status: LightSignalingStatus(
                signal: "value1",
                signalValues: ["value1", "value2"],
                estimatedEnd: testLight.signaling.status.estimatedEnd,
              ),
              signalValues: ["value1", "value2"],
            ),
          );

          test(
            "invalid signal assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    signaling: LightSignaling(
                      status: LightSignalingStatus(
                        signal: "valueZ",
                        signalValues: ["value1", "value2"],
                        estimatedEnd: testLight.signaling.status.estimatedEnd,
                      ),
                      signalValues: ["value1", "value2"],
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          // test(
          //   "invalid signal (empty) assertion",
          //   () {
          //     expect(
          //       () {
          //         testLight.copyWith(
          //           signaling: LightSignaling(
          //             status: LightSignalingStatus(
          //               signal: "",
          //               signalValues: ["value1", "value2"],
          //               estimatedEnd: testLight.signaling.status.estimatedEnd,
          //             ),
          //             signalValues: ["value1", "value2"],
          //           ),
          //         );
          //       },
          //       throwsAssertionError,
          //     );
          //   },
          // );

          test(
            "invalid signal (old value) exception",
            () {
              expect(
                () {
                  alteredLight.signaling.copyWith(
                    status: alteredLight.signaling.status
                        .copyWith(signalValues: ["itemA", "itemB"]),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );

          test(
            "invalid signal (old value - empty list) exception",
            () {
              expect(
                () {
                  alteredLight.signaling.copyWith(
                    status: alteredLight.signaling.status
                        .copyWith(signalValues: []),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );
        },
      );

      group(
        "gradient",
        () {
          test(
            "too many points assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    gradient: LightGradientFull(
                      points: [
                        LightColorXy(x: 0.0, y: 0.1),
                        LightColorXy(x: 0.2, y: 0.3),
                        LightColorXy(x: 0.4, y: 0.5),
                        LightColorXy(x: 0.6, y: 0.7),
                        LightColorXy(x: 0.8, y: 0.9),
                        LightColorXy(x: 0.01, y: 0.11),
                      ],
                      mode: testLight.gradient.mode,
                      modeValues: testLight.gradient.modeValues,
                      pointsCapable: testLight.gradient.pointsCapable,
                      pixelCount: testLight.gradient.pixelCount,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "add point overflow",
            () {
              Light alteredLight = testLight.copyWith(
                gradient: LightGradientFull(
                  points: [
                    LightColorXy(x: 0.0, y: 0.1),
                    LightColorXy(x: 0.2, y: 0.3),
                    LightColorXy(x: 0.4, y: 0.5),
                    LightColorXy(x: 0.6, y: 0.7),
                    LightColorXy(x: 0.8, y: 0.9),
                  ],
                  mode: testLight.gradient.mode,
                  modeValues: testLight.gradient.modeValues,
                  pointsCapable: testLight.gradient.pointsCapable,
                  pixelCount: testLight.gradient.pixelCount,
                ),
              );

              expect(
                alteredLight.gradient.addPoint(LightColorXy(x: 0.01, y: 0.11)),
                false,
              );
            },
          );

          test(
            "remove point (existing)",
            () {
              LightColorXy testColor = LightColorXy(x: 0.2, y: 0.3);

              Light alteredLight = testLight.copyWith(
                gradient: LightGradientFull(
                  points: [
                    LightColorXy(x: 0.0, y: 0.1),
                    testColor,
                    LightColorXy(x: 0.4, y: 0.5),
                    LightColorXy(x: 0.6, y: 0.7),
                    LightColorXy(x: 0.8, y: 0.9),
                  ],
                  mode: testLight.gradient.mode,
                  modeValues: testLight.gradient.modeValues,
                  pointsCapable: testLight.gradient.pointsCapable,
                  pixelCount: testLight.gradient.pixelCount,
                ),
              );

              expect(
                alteredLight.gradient.removePoint(testColor),
                true,
              );
            },
          );

          test(
            "remove point (non-existing)",
            () {
              LightColorXy testColor = LightColorXy(x: 0.01, y: 0.11);

              Light alteredLight = testLight.copyWith(
                gradient: LightGradientFull(
                  points: [
                    LightColorXy(x: 0.0, y: 0.1),
                    LightColorXy(x: 0.2, y: 0.3),
                    LightColorXy(x: 0.4, y: 0.5),
                    LightColorXy(x: 0.6, y: 0.7),
                    LightColorXy(x: 0.8, y: 0.9),
                  ],
                  mode: testLight.gradient.mode,
                  modeValues: testLight.gradient.modeValues,
                  pointsCapable: testLight.gradient.pointsCapable,
                  pixelCount: testLight.gradient.pixelCount,
                ),
              );

              expect(
                alteredLight.gradient.removePoint(testColor),
                false,
              );
            },
          );

          test(
            "set points (too many)",
            () {
              Light alteredLight = testLight.copyWith(
                gradient: LightGradientFull(
                  points: [
                    LightColorXy(x: 0.0001, y: 0.1111),
                  ],
                  mode: testLight.gradient.mode,
                  modeValues: testLight.gradient.modeValues,
                  pointsCapable: testLight.gradient.pointsCapable,
                  pixelCount: testLight.gradient.pixelCount,
                ),
              );

              expect(
                () {
                  alteredLight.gradient.points = [
                    LightColorXy(x: 0.0, y: 0.1),
                    LightColorXy(x: 0.2, y: 0.3),
                    LightColorXy(x: 0.4, y: 0.5),
                    LightColorXy(x: 0.6, y: 0.7),
                    LightColorXy(x: 0.8, y: 0.9),
                    LightColorXy(x: 0.01, y: 0.11),
                  ];
                },
                throwsException,
              );
            },
          );

          test(
            "finalize with invalid points",
            () {
              Light alteredLight = testLight.copyWith(
                gradient: LightGradientFull(
                  points: [
                    LightColorXy(x: 0.0, y: 0.1),
                  ],
                  mode: testLight.gradient.mode,
                  modeValues: testLight.gradient.modeValues,
                  pointsCapable: testLight.gradient.pointsCapable,
                  pixelCount: testLight.gradient.pixelCount,
                ),
              );

              expect(
                () {
                  alteredLight.gradient.toJson();
                },
                throwsA(isA<GradientException>()),
              );
            },
          );
        },
      );

      group(
        "effects",
        () {
          Light alteredLight = testLight.copyWith(
            effects: LightEffects(
              effect: "effect1",
              effectValues: ["effect1", "effect2"],
              status: "status1",
              statusValues: ["status1", "status2"],
            ),
          );

          test(
            "invalid effect assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    effects: LightEffects(
                      effect: "effectZ",
                      effectValues: ["effect1", "effect2"],
                      status: "status1",
                      statusValues: ["status1", "status2"],
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          // test(
          //   "invalid effect (empty) assertion",
          //   () {
          //     expect(
          //       () {
          //         testLight.copyWith(
          //           effects: LightEffects(
          //             effect: "",
          //             effectValues: ["effect1", "effect2"],
          //             status: "status1",
          //             statusValues: ["status1", "status2"],
          //           ),
          //         );
          //       },
          //       throwsAssertionError,
          //     );
          //   },
          // );

          test(
            "invalid effect (old value) exception",
            () {
              expect(
                () {
                  alteredLight.copyWith(
                    effects: alteredLight.effects
                        .copyWith(effectValues: ["effectA", "effectB"]),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );

          test(
            "invalid effect (old value - empty list) exception",
            () {
              expect(
                () {
                  alteredLight.copyWith(
                    effects: alteredLight.effects.copyWith(effectValues: []),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );

          test(
            "invalid status assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    effects: LightEffects(
                      effect: "effect1",
                      effectValues: ["effect1", "effect2"],
                      status: "statusZ",
                      statusValues: ["status1", "status2"],
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid status (empty) assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    effects: LightEffects(
                      effect: "effect1",
                      effectValues: ["effect1", "effect2"],
                      status: "",
                      statusValues: ["status1", "status2"],
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid status (old value) exception",
            () {
              expect(
                () {
                  alteredLight.copyWith(
                    effects: alteredLight.effects
                        .copyWith(statusValues: ["statusA", "statusB"]),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );

          test(
            "invalid status (old value - empty list) exception",
            () {
              expect(
                () {
                  alteredLight.copyWith(
                    effects: alteredLight.effects.copyWith(statusValues: []),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );
        },
      );

      group(
        "timed effects",
        () {
          Light alteredLight = testLight.copyWith(
            timedEffects: LightTimedEffects(
              effect: "effect1",
              effectValues: ["effect1", "effect2"],
              status: "status1",
              statusValues: ["status1", "status2"],
              duration: 2,
            ),
          );

          test(
            "invalid effect assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    timedEffects: LightTimedEffects(
                      effect: "effectZ",
                      effectValues: ["effect1", "effect2"],
                      status: "status1",
                      statusValues: ["status1", "status2"],
                      duration: 2,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid effect (empty) assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    timedEffects: LightTimedEffects(
                      effect: "",
                      effectValues: ["effect1", "effect2"],
                      status: "status1",
                      statusValues: ["status1", "status2"],
                      duration: 2,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid effect (old value) exception",
            () {
              expect(
                () {
                  alteredLight.copyWith(
                    timedEffects: alteredLight.timedEffects
                        .copyWith(effectValues: ["effectA", "effectB"]),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );

          test(
            "invalid effect (old value - empty list) exception",
            () {
              expect(
                () {
                  alteredLight.copyWith(
                    timedEffects:
                        alteredLight.timedEffects.copyWith(effectValues: []),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );

          test(
            "invalid status assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    timedEffects: LightTimedEffects(
                      effect: "effect1",
                      effectValues: ["effect1", "effect2"],
                      status: "statusZ",
                      statusValues: ["status1", "status2"],
                      duration: 2,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid status (empty) assertion",
            () {
              expect(
                () {
                  testLight.copyWith(
                    timedEffects: LightTimedEffects(
                      effect: "effect1",
                      effectValues: ["effect1", "effect2"],
                      status: "statusZ",
                      statusValues: ["status1", "status2"],
                      duration: 2,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid status (old value) exception",
            () {
              expect(
                () {
                  alteredLight.copyWith(
                    timedEffects: alteredLight.timedEffects
                        .copyWith(statusValues: ["effectA", "effectB"]),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );

          test(
            "invalid status (old value - empty list) exception",
            () {
              expect(
                () {
                  alteredLight.copyWith(
                    timedEffects:
                        alteredLight.timedEffects.copyWith(statusValues: []),
                  );
                },
                throwsA(isA<InvalidValueException>()),
              );
            },
          );
        },
      );
    },
  );
}
