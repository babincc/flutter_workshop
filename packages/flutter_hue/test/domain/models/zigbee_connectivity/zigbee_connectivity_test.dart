import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/zigbee_connectivity/zigbee_connectivity.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ZigbeeConnectivity testZigbeeConnectivity = ZigbeeConnectivity(
    type: ResourceType.zigbeeConnectivity,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    status: "connected",
    macAddress: "00:11:22:33:44:55:66:77",
  );

  final Map<String, dynamic> testZigbeeConnectivityJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
      ApiFields.rType: ResourceType.device.value,
    },
    ApiFields.status: "connected",
    ApiFields.macAddress: "00:11:22:33:44:55:66:77",
    ApiFields.type: ResourceType.zigbeeConnectivity.value,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            ZigbeeConnectivity.fromJson(testZigbeeConnectivityJson),
            testZigbeeConnectivity,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            ZigbeeConnectivity.fromJson(
                {ApiFields.data: testZigbeeConnectivityJson}),
            testZigbeeConnectivity,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            ZigbeeConnectivity.fromJson({
              ApiFields.data: [testZigbeeConnectivityJson]
            }),
            testZigbeeConnectivity,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            ZigbeeConnectivity.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testZigbeeConnectivityJson]
            }),
            testZigbeeConnectivity,
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
          ZigbeeConnectivity copyZigbeeConnectivity =
              testZigbeeConnectivity.copyWith();

          expect(
            copyZigbeeConnectivity.toJson(
                optimizeFor: OptimizeFor.dontOptimize),
            testZigbeeConnectivityJson,
          );
        },
      );

      test(
        "with changes",
        () {
          ZigbeeConnectivity copyZigbeeConnectivity =
              testZigbeeConnectivity.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyZigbeeConnectivityJson =
              Map<String, dynamic>.from(testZigbeeConnectivityJson);

          copyZigbeeConnectivityJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyZigbeeConnectivityJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyZigbeeConnectivity.toJson(
                optimizeFor: OptimizeFor.dontOptimize),
            copyZigbeeConnectivityJson,
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
            testZigbeeConnectivity.toJson(
                optimizeFor: OptimizeFor.dontOptimize),
            testZigbeeConnectivityJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testZigbeeConnectivity.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          ZigbeeConnectivity alteredZigbeeConnectivity =
              testZigbeeConnectivity.copyWith();
          alteredZigbeeConnectivity.type = ResourceType.device;

          expect(
            alteredZigbeeConnectivity.toJson(optimizeFor: OptimizeFor.put),
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
              testZigbeeConnectivity.copyWith(id: "bad_value");
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
              testZigbeeConnectivity.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid mac address assertion",
        () {
          expect(
            () {
              testZigbeeConnectivity.copyWith(macAddress: "123456789");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid mac address (empty) assertion",
        () {
          expect(
            () {
              testZigbeeConnectivity.copyWith(macAddress: "");
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
