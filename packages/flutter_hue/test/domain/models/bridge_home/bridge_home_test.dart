import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/bridge_home/bridge_home.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final BridgeHome testBridgeHome = BridgeHome(
    type: ResourceType.bridgeHome,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    children: [
      Relative(
        type: ResourceType.room,
        id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
      ),
    ],
    services: [
      Relative(
        type: ResourceType.groupedLight,
        id: "99999999-9999-8888-7777-666655554444",
      ),
    ],
  );

  final Map<String, dynamic> testBridgeHomeJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.children: [
      {
        ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
        ApiFields.rType: ResourceType.room.value,
      },
    ],
    ApiFields.services: [
      {
        ApiFields.rid: "99999999-9999-8888-7777-666655554444",
        ApiFields.rType: ResourceType.groupedLight.value,
      },
    ],
    ApiFields.type: ResourceType.bridgeHome.value,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            BridgeHome.fromJson(testBridgeHomeJson),
            testBridgeHome,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            BridgeHome.fromJson({ApiFields.data: testBridgeHomeJson}),
            testBridgeHome,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            BridgeHome.fromJson({
              ApiFields.data: [testBridgeHomeJson]
            }),
            testBridgeHome,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            BridgeHome.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testBridgeHomeJson]
            }),
            testBridgeHome,
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
          BridgeHome copyBridgeHome = testBridgeHome.copyWith();

          expect(
            copyBridgeHome.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testBridgeHomeJson,
          );
        },
      );

      test(
        "with changes",
        () {
          BridgeHome copyBridgeHome = testBridgeHome.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyBridgeHomeJson =
              Map<String, dynamic>.from(testBridgeHomeJson);

          copyBridgeHomeJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyBridgeHomeJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copyBridgeHome.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyBridgeHomeJson,
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
            testBridgeHome.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testBridgeHomeJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testBridgeHome.toJson(),
            testBridgeHomeJson,
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          BridgeHome alteredBridgeHome = testBridgeHome.copyWith();
          alteredBridgeHome.type = ResourceType.device;

          Map<String, dynamic> copyBridgeHomeJson =
              Map<String, dynamic>.from(testBridgeHomeJson);

          copyBridgeHomeJson[ApiFields.type] = ResourceType.device.value;

          expect(
            alteredBridgeHome.toJson(optimizeFor: OptimizeFor.put),
            copyBridgeHomeJson,
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
              testBridgeHome.copyWith(id: "bad_value");
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
              testBridgeHome.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
