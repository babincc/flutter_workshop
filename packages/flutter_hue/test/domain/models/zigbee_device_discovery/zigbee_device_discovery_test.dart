import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/zigbee_device_discovery/zigbee_device_discovery.dart';
import 'package:flutter_hue/domain/models/zigbee_device_discovery/zigbee_device_discovery_action.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ZigbeeDeviceDiscovery testZigbeeDeviceDiscovery = ZigbeeDeviceDiscovery(
    type: ResourceType.zigbeeDeviceDiscovery,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    status: "ready",
    action: ZigbeeDeviceDiscoveryAction.empty(),
  );

  final Map<String, dynamic> testZigbeeDeviceDiscoveryJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rType: ResourceType.device.value,
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    },
    ApiFields.status: "ready",
    ApiFields.type: ResourceType.zigbeeDeviceDiscovery.value,
    ApiFields.action: {
      ApiFields.actionType: "",
      ApiFields.searchCodes: [],
      ApiFields.installCodes: [],
    },
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            ZigbeeDeviceDiscovery.fromJson(testZigbeeDeviceDiscoveryJson),
            testZigbeeDeviceDiscovery,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            ZigbeeDeviceDiscovery.fromJson(
                {ApiFields.data: testZigbeeDeviceDiscoveryJson}),
            testZigbeeDeviceDiscovery,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            ZigbeeDeviceDiscovery.fromJson({
              ApiFields.data: [testZigbeeDeviceDiscoveryJson]
            }),
            testZigbeeDeviceDiscovery,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            ZigbeeDeviceDiscovery.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testZigbeeDeviceDiscoveryJson]
            }),
            testZigbeeDeviceDiscovery,
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
          ZigbeeDeviceDiscovery copyZigbeeDeviceDiscovery =
              testZigbeeDeviceDiscovery.copyWith();

          expect(
            copyZigbeeDeviceDiscovery.toJson(
                optimizeFor: OptimizeFor.dontOptimize),
            testZigbeeDeviceDiscoveryJson,
          );
        },
      );

      test(
        "with changes",
        () {
          ZigbeeDeviceDiscovery copyZigbeeDeviceDiscovery =
              testZigbeeDeviceDiscovery.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyZigbeeDeviceDiscoveryJson =
              Map<String, dynamic>.from(testZigbeeDeviceDiscoveryJson);

          copyZigbeeDeviceDiscoveryJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyZigbeeDeviceDiscoveryJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyZigbeeDeviceDiscovery.toJson(
                optimizeFor: OptimizeFor.dontOptimize),
            copyZigbeeDeviceDiscoveryJson,
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
            testZigbeeDeviceDiscovery.toJson(
                optimizeFor: OptimizeFor.dontOptimize),
            testZigbeeDeviceDiscoveryJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testZigbeeDeviceDiscovery.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          ZigbeeDeviceDiscovery alteredZigbeeDeviceDiscovery =
              testZigbeeDeviceDiscovery.copyWith();
          alteredZigbeeDeviceDiscovery.type = ResourceType.device;

          expect(
            alteredZigbeeDeviceDiscovery.toJson(optimizeFor: OptimizeFor.put),
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
              testZigbeeDeviceDiscovery.copyWith(id: "bad_value");
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
              testZigbeeDeviceDiscovery.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      group(
        "action",
        () {
          test(
            "too many search codes assertion",
            () {
              expect(
                () {
                  testZigbeeDeviceDiscovery.copyWith(
                    action: ZigbeeDeviceDiscoveryAction(
                      actionType: "search",
                      searchCodes: [
                        "codeA",
                        "codeB",
                        "codeC",
                        "codeD",
                        "codeE",
                        "codeF",
                        "codeG",
                        "codeH",
                        "codeI",
                        "codeJ",
                        "codeK",
                      ],
                      installCodes: ["code1", "code2", "code3"],
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "too many search codes exception",
            () {
              ZigbeeDeviceDiscovery alteredZigbeeDeviceDiscovery =
                  testZigbeeDeviceDiscovery.copyWith(
                      action: ZigbeeDeviceDiscoveryAction.empty());

              expect(
                () {
                  alteredZigbeeDeviceDiscovery.action!.searchCodes = [
                    "codeA",
                    "codeB",
                    "codeC",
                    "codeD",
                    "codeE",
                    "codeF",
                    "codeG",
                    "codeH",
                    "codeI",
                    "codeJ",
                    "codeK",
                  ];
                },
                throwsException,
              );
            },
          );
        },
      );
    },
  );
}
