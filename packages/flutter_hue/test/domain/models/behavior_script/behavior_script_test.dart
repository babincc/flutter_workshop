import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/behavior_script/behavior_script.dart';
import 'package:flutter_hue/domain/models/behavior_script/behavior_script_metadata.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final BehaviorScript testBehaviorScript = BehaviorScript(
    type: ResourceType.behaviorScript,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do "
        "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim "
        "ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
        "aliquip ex ea commodo consequat.",
    configurationSchema: {
      "\$ref": "leaving_home_config.json#",
    },
    triggerSchema: {
      "\$ref": "trigger.json#",
    },
    stateSchema: {},
    version: "0.0.1",
    metadata: BehaviorScriptMetadata(
      name: "Leaving Home Routine",
      category: "automation",
    ),
    supportedFeatures: [],
    maxNumberInstances: 255,
  );

  final Map<String, dynamic> testBehaviorScriptJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.behaviorScript.value,
    ApiFields.description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do "
            "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut "
            "enim ad minim veniam, quis nostrud exercitation ullamco laboris "
            "nisi ut aliquip ex ea commodo consequat.",
    ApiFields.configurationSchema: {
      "\$ref": "leaving_home_config.json#",
    },
    ApiFields.triggerSchema: {
      "\$ref": "trigger.json#",
    },
    ApiFields.stateSchema: {},
    ApiFields.version: "0.0.1",
    ApiFields.metadata: {
      ApiFields.name: "Leaving Home Routine",
      ApiFields.category: "automation",
    },
    ApiFields.supportedFeatures: [],
    ApiFields.maxNumberInstances: 255,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            BehaviorScript.fromJson(testBehaviorScriptJson),
            testBehaviorScript,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            BehaviorScript.fromJson({ApiFields.data: testBehaviorScriptJson}),
            testBehaviorScript,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            BehaviorScript.fromJson({
              ApiFields.data: [testBehaviorScriptJson]
            }),
            testBehaviorScript,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            BehaviorScript.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testBehaviorScriptJson]
            }),
            testBehaviorScript,
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
          BehaviorScript copyBehaviorScript = testBehaviorScript.copyWith();

          expect(
            copyBehaviorScript.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testBehaviorScriptJson,
          );
        },
      );

      test(
        "with changes",
        () {
          BehaviorScript copyBehaviorScript = testBehaviorScript.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyBehaviorScriptJson =
              Map<String, dynamic>.from(testBehaviorScriptJson);

          copyBehaviorScriptJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyBehaviorScriptJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyBehaviorScript.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyBehaviorScriptJson,
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
            testBehaviorScript.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testBehaviorScriptJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testBehaviorScript.toJson(),
            testBehaviorScriptJson,
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          BehaviorScript alteredBehaviorScript = testBehaviorScript.copyWith();
          alteredBehaviorScript.type = ResourceType.device;

          Map<String, dynamic> alteredBehaviorScriptJson =
              Map.from(testBehaviorScriptJson);
          alteredBehaviorScriptJson[ApiFields.type] = ResourceType.device.value;

          expect(
            alteredBehaviorScript.toJson(optimizeFor: OptimizeFor.put),
            alteredBehaviorScriptJson,
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
              testBehaviorScript.copyWith(id: "bad_value");
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
              testBehaviorScript.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid name assertion",
        () {
          expect(
            () {
              testBehaviorScript.copyWith(
                metadata: BehaviorScriptMetadata(
                  name: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                  category: "automation",
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
              testBehaviorScript.metadata.name = "";
            },
            throwsA(isA<InvalidNameException>()),
          );
        },
      );

      test(
        "invalid script version assertion",
        () {
          expect(
            () {
              testBehaviorScript.copyWith(version: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid num instances (low) assertion",
        () {
          expect(
            () {
              testBehaviorScript.copyWith(maxNumberInstances: -3);
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid num instances (high) assertion",
        () {
          expect(
            () {
              testBehaviorScript.copyWith(maxNumberInstances: 256);
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
