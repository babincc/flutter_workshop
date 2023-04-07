import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Bridge testBridge = Bridge(
    type: ResourceType.bridge,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    ipAddress: "192.168.0.1",
    owner: Relative(
      id: "ffffffff-ffff-ffff-ffff-ffffffffffff",
      type: ResourceType.device,
    ),
    bridgeId: "a1b2c3d4e5f6",
    timeZone: "America/New_York",
  );

  final Map<String, dynamic> testBridgeJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.applicationKey: null,
    ApiFields.ipAddress: "192.168.0.1",
    ApiFields.owner: {
      ApiFields.rid: "ffffffff-ffff-ffff-ffff-ffffffffffff",
      ApiFields.rType: ResourceType.device.value,
    },
    ApiFields.bridgeId: "a1b2c3d4e5f6",
    ApiFields.timeZone: {
      ApiFields.timeZone: "America/New_York",
    },
    ApiFields.type: ResourceType.bridge.value,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Bridge.fromJson(testBridgeJson),
            testBridge,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Bridge.fromJson({ApiFields.data: testBridgeJson}),
            testBridge,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Bridge.fromJson({
              ApiFields.data: [testBridgeJson]
            }),
            testBridge,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Bridge.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testBridgeJson]
            }),
            testBridge,
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
          Bridge copyBridge = testBridge.copyWith();

          expect(
            copyBridge.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testBridgeJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Bridge copyBridge = testBridge.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
            ipAddress: null,
          );

          Map<String, dynamic> copyBridgeJson =
              Map<String, dynamic>.from(testBridgeJson);

          copyBridgeJson[ApiFields.id] = "00000000-0000-0000-0000-000000000000";
          copyBridgeJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";
          copyBridgeJson[ApiFields.ipAddress] = null;

          expect(
            copyBridge.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyBridgeJson,
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
            testBridge.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testBridgeJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testBridge.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Bridge alteredBridge = testBridge.copyWith();
          alteredBridge.type = ResourceType.device;

          expect(
            alteredBridge.toJson(optimizeFor: OptimizeFor.put),
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
              testBridge.copyWith(id: "bad_value");
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
              testBridge.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid ip address assertion",
        () {
          expect(
            () {
              testBridge.copyWith(ipAddress: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
