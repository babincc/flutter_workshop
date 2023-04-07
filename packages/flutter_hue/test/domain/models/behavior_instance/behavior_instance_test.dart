import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/behavior_instance/behavior_instance.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_id_exception.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final BehaviorInstance testBehaviorInstance = BehaviorInstance(
    type: ResourceType.behaviorInstance,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    scriptId: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    isEnabled: false,
    state: {},
    configuration: {},
    dependees: [],
    status: "disabled",
    lastError: "",
    name: "Rise and Shine",
    migratedFrom: "/wxyz/abcd-1234",
    trigger: null,
  );

  final Map<String, dynamic> testBehaviorInstanceJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.behaviorInstance.value,
    ApiFields.scriptId: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ApiFields.isEnabled: false,
    ApiFields.configuration: {},
    ApiFields.dependees: [],
    ApiFields.status: "disabled",
    ApiFields.lastError: "",
    ApiFields.state: {},
    ApiFields.metadata: {
      ApiFields.name: "Rise and Shine",
    },
    ApiFields.migratedFrom: "/wxyz/abcd-1234",
    ApiFields.trigger: null,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            BehaviorInstance.fromJson(testBehaviorInstanceJson),
            testBehaviorInstance,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            BehaviorInstance.fromJson(
                {ApiFields.data: testBehaviorInstanceJson}),
            testBehaviorInstance,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            BehaviorInstance.fromJson({
              ApiFields.data: [testBehaviorInstanceJson]
            }),
            testBehaviorInstance,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            BehaviorInstance.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testBehaviorInstanceJson]
            }),
            testBehaviorInstance,
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
          BehaviorInstance copyBehaviorInstance =
              testBehaviorInstance.copyWith();

          expect(
            copyBehaviorInstance.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testBehaviorInstanceJson,
          );
        },
      );

      test(
        "with changes",
        () {
          BehaviorInstance copyBehaviorInstance = testBehaviorInstance.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyBehaviorInstanceJson =
              Map<String, dynamic>.from(testBehaviorInstanceJson);

          copyBehaviorInstanceJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyBehaviorInstanceJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyBehaviorInstance.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyBehaviorInstanceJson,
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
            testBehaviorInstance.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testBehaviorInstanceJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testBehaviorInstance.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          BehaviorInstance alteredBehaviorInstance =
              testBehaviorInstance.copyWith();
          alteredBehaviorInstance.type = ResourceType.device;

          expect(
            alteredBehaviorInstance.toJson(optimizeFor: OptimizeFor.put),
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
              testBehaviorInstance.copyWith(id: "bad_value");
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
              testBehaviorInstance.copyWith(idV1: "bad_value");
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
              testBehaviorInstance.name = "";
            },
            throwsA(isA<InvalidNameException>()),
          );
        },
      );

      test(
        "invalid script id exception",
        () {
          expect(
            () {
              testBehaviorInstance.scriptId = "bad_value";
            },
            throwsA(isA<InvalidIdException>()),
          );
        },
      );

      test(
        "invalid migrated from exception",
        () {
          expect(
            () {
              testBehaviorInstance.migratedFrom = "bad_value";
            },
            throwsA(isA<InvalidIdException>()),
          );
        },
      );
    },
  );
}
