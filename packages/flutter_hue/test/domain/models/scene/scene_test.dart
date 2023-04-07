import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming.dart';
import 'package:flutter_hue/domain/models/light/light_gradient/light_gradient.dart';
import 'package:flutter_hue/domain/models/light/light_on.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_color/light_power_up_color_color_temperature.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/scene/scene.dart';
import 'package:flutter_hue/domain/models/scene/scene_action/scene_action.dart';
import 'package:flutter_hue/domain/models/scene/scene_action/scene_action_action.dart';
import 'package:flutter_hue/domain/models/scene/scene_metadata.dart';
import 'package:flutter_hue/domain/models/scene/scene_palette/scene_palette.dart';
import 'package:flutter_hue/domain/models/scene/scene_palette/scene_palette_color_temperature.dart';
import 'package:flutter_hue/domain/models/scene/scene_recall.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/exceptions/negative_value_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Scene testScene = Scene(
    type: ResourceType.scene,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    actions: [
      SceneAction(
        target: Relative(
          type: ResourceType.light,
          id: "01234567-aaaa-aaaa-aaaa-0123456789ab",
        ),
        action: SceneActionAction(
          on: LightOn(isOn: true),
          dimming: LightDimming(brightness: 100.0),
          xy: LightColorXy.empty(),
          colorTemperature: LightPowerUpColorColorTemperature(mirek: 370),
          gradient: LightGradient.empty(),
          effect: "",
          durationMilliseconds: 0,
        ),
      ),
      SceneAction(
        target: Relative(
          type: ResourceType.light,
          id: "aaaaaaaa-1111-1111-1111-000000000000",
        ),
        action: SceneActionAction(
          on: LightOn(isOn: true),
          dimming: LightDimming(brightness: 100.0),
          xy: LightColorXy.empty(),
          colorTemperature: LightPowerUpColorColorTemperature(mirek: 370),
          gradient: LightGradient.empty(),
          effect: "",
          durationMilliseconds: 0,
        ),
      ),
    ],
    recall: SceneRecall.fromJson({}),
    metadata: SceneMetadata(
      name: "Bright",
      image: Relative(
        type: ResourceType.publicImage,
        id: "55555555-dddd-dddd-dddd-555555555555",
      ),
    ),
    group: Relative(
      id: "ffffffff-ffff-ffff-ffff-ffffffffffff",
      type: ResourceType.room,
    ),
    palette: ScenePalette(
      colors: [],
      dimmings: [],
      colorTemperatures: [
        ScenePaletteColorTemperature(
          colorTemperature: LightPowerUpColorColorTemperature(mirek: 370),
          dimming: LightDimming(brightness: 100.0),
        ),
      ],
    ),
    speed: 0.6031746031746031,
    autoDynamic: false,
  );

  final Map<String, dynamic> testSceneJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.scene.value,
    ApiFields.actions: [
      {
        ApiFields.target: {
          ApiFields.rid: "01234567-aaaa-aaaa-aaaa-0123456789ab",
          ApiFields.rType: ResourceType.light.value,
        },
        ApiFields.action: {
          ApiFields.isOn: {
            ApiFields.isOn: true,
          },
          ApiFields.dimming: {
            ApiFields.brightness: 100.0,
          },
          ApiFields.color: {
            ApiFields.xy: {
              ApiFields.x: 0.0,
              ApiFields.y: 0.0,
            },
          },
          ApiFields.colorTemperature: {
            ApiFields.mirek: 370,
          },
          ApiFields.gradient: {
            ApiFields.points: [],
            ApiFields.mode: "",
            ApiFields.modeValues: [],
          },
          ApiFields.effects: {
            ApiFields.effect: "",
          },
          ApiFields.dynamics: {
            ApiFields.duration: 0,
          },
        },
      },
      {
        ApiFields.target: {
          ApiFields.rid: "aaaaaaaa-1111-1111-1111-000000000000",
          ApiFields.rType: ResourceType.light.value,
        },
        ApiFields.action: {
          ApiFields.isOn: {
            ApiFields.isOn: true,
          },
          ApiFields.dimming: {
            ApiFields.brightness: 100.0,
          },
          ApiFields.color: {
            ApiFields.xy: {
              ApiFields.x: 0.0,
              ApiFields.y: 0.0,
            },
          },
          ApiFields.colorTemperature: {
            ApiFields.mirek: 370,
          },
          ApiFields.gradient: {
            ApiFields.points: [],
            ApiFields.mode: "",
            ApiFields.modeValues: [],
          },
          ApiFields.effects: {
            ApiFields.effect: "",
          },
          ApiFields.dynamics: {
            ApiFields.duration: 0,
          },
        },
      },
    ],
    ApiFields.recall: {
      ApiFields.action: "",
      ApiFields.status: "",
      ApiFields.duration: 0,
      ApiFields.dimming: {
        ApiFields.brightness: 0.0,
      },
    },
    ApiFields.metadata: {
      ApiFields.name: "Bright",
      ApiFields.image: {
        ApiFields.rid: "55555555-dddd-dddd-dddd-555555555555",
        ApiFields.rType: ResourceType.publicImage.value,
      },
    },
    ApiFields.group: {
      ApiFields.rid: "ffffffff-ffff-ffff-ffff-ffffffffffff",
      ApiFields.rType: ResourceType.room.value,
    },
    ApiFields.palette: {
      ApiFields.color: [],
      ApiFields.dimming: [],
      ApiFields.colorTemperature: [
        {
          ApiFields.colorTemperature: {
            ApiFields.mirek: 370,
          },
          ApiFields.dimming: {
            ApiFields.brightness: 100.0,
          },
        },
      ]
    },
    ApiFields.speed: 0.6031746031746031,
    ApiFields.autoDynamic: false,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Scene.fromJson(testSceneJson),
            testScene,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Scene.fromJson({ApiFields.data: testSceneJson}),
            testScene,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Scene.fromJson({
              ApiFields.data: [testSceneJson]
            }),
            testScene,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Scene.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testSceneJson]
            }),
            testScene,
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
          Scene copyScene = testScene.copyWith();

          expect(
            copyScene.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testSceneJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Scene copyScene = testScene.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copySceneJson =
              Map<String, dynamic>.from(testSceneJson);

          copySceneJson[ApiFields.id] = "00000000-0000-0000-0000-000000000000";
          copySceneJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copyScene.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copySceneJson,
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
            testScene.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testSceneJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testScene.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Scene alteredScene = testScene.copyWith();
          alteredScene.type = ResourceType.device;

          expect(
            alteredScene.toJson(optimizeFor: OptimizeFor.put),
            {
              "type": ResourceType.device.value,
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
              testScene.copyWith(id: "bad_value");
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
              testScene.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid scene action duration",
        () {
          expect(
            () {
              testScene.actions.first.action.durationMilliseconds = -2;
            },
            throwsA(isA<NegativeValueException>()),
          );
        },
      );

      test(
        "invalid scene recall duration",
        () {
          expect(
            () {
              testScene.recall.duration = -2;
            },
            throwsA(isA<NegativeValueException>()),
          );
        },
      );

      test(
        "invalid name assertion",
        () {
          expect(
            () {
              testScene.copyWith(
                metadata: SceneMetadata(
                  name: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                  image: Relative.fromJson({}),
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
              testScene.metadata.name = "";
            },
            throwsA(isA<InvalidNameException>()),
          );
        },
      );

      group(
        "speed",
        () {
          test(
            "invalid speed (low) assertion",
            () {
              expect(
                () {
                  Scene(
                    type: testScene.type,
                    id: testScene.id,
                    actions: testScene.actions,
                    recall: testScene.recall,
                    metadata: testScene.metadata,
                    group: testScene.group,
                    palette: testScene.palette,
                    speed: -0.1,
                    autoDynamic: testScene.autoDynamic,
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
                  Scene(
                    type: testScene.type,
                    id: testScene.id,
                    actions: testScene.actions,
                    recall: testScene.recall,
                    metadata: testScene.metadata,
                    group: testScene.group,
                    palette: testScene.palette,
                    speed: 1.1,
                    autoDynamic: testScene.autoDynamic,
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
