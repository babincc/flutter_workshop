import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/device_power/device_power.dart';
import 'package:flutter_hue/domain/models/device_power/device_power_power_state.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final DevicePower testDevicePower = DevicePower(
    type: ResourceType.devicePower,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    powerState: DevicePowerPowerState(
      batteryState: "normal",
      batteryLevel: 72,
    ),
  );

  final Map<String, dynamic> testDevicePowerJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
      ApiFields.rType: ResourceType.device.value,
    },
    ApiFields.powerState: {
      ApiFields.batteryState: "normal",
      ApiFields.batteryLevel: 72,
    },
    ApiFields.type: ResourceType.devicePower.value,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            DevicePower.fromJson(testDevicePowerJson),
            testDevicePower,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            DevicePower.fromJson({ApiFields.data: testDevicePowerJson}),
            testDevicePower,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            DevicePower.fromJson({
              ApiFields.data: [testDevicePowerJson]
            }),
            testDevicePower,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            DevicePower.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testDevicePowerJson]
            }),
            testDevicePower,
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
          DevicePower copyDevicePower = testDevicePower.copyWith();

          expect(
            copyDevicePower.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testDevicePowerJson,
          );
        },
      );

      test(
        "with changes",
        () {
          DevicePower copyDevicePower = testDevicePower.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyDevicePowerJson =
              Map<String, dynamic>.from(testDevicePowerJson);

          copyDevicePowerJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyDevicePowerJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyDevicePower.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyDevicePowerJson,
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
            testDevicePower.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testDevicePowerJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testDevicePower.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          DevicePower alteredDevicePower = testDevicePower.copyWith();
          alteredDevicePower.type = ResourceType.device;

          expect(
            alteredDevicePower.toJson(optimizeFor: OptimizeFor.put),
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
              testDevicePower.copyWith(id: "bad_value");
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
              testDevicePower.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid battery (low) assertion",
        () {
          expect(
            () {
              testDevicePower.copyWith(
                powerState: DevicePowerPowerState(
                  batteryState: "critical",
                  batteryLevel: -1,
                ),
              );
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid battery (high) assertion",
        () {
          expect(
            () {
              testDevicePower.copyWith(
                powerState: DevicePowerPowerState(
                  batteryState: "normal",
                  batteryLevel: 101,
                ),
              );
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
