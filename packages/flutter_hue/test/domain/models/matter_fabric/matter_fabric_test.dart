import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/matter_fabric/matter_fabric.dart';
import 'package:flutter_hue/domain/models/matter_fabric/matter_fabric_data.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final MatterFabric testMatterFabric = MatterFabric(
    type: ResourceType.matterFabric,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    status: "paired",
    fabricData: MatterFabricData(
      label: "My Matter Fabric",
      vendorId: 626,
    ),
    creationTime: DateTime(2023, 2, 20, 4, 15, 33),
  );

  final Map<String, dynamic> testMatterFabricJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.matterFabric.value,
    ApiFields.status: "paired",
    ApiFields.fabricData: {
      ApiFields.label: "My Matter Fabric",
      ApiFields.vendorId: 626,
    },
    ApiFields.creationTime: "2023-02-20T04:15:33",
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            MatterFabric.fromJson(testMatterFabricJson),
            testMatterFabric,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            MatterFabric.fromJson({ApiFields.data: testMatterFabricJson}),
            testMatterFabric,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            MatterFabric.fromJson({
              ApiFields.data: [testMatterFabricJson]
            }),
            testMatterFabric,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            MatterFabric.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testMatterFabricJson]
            }),
            testMatterFabric,
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
          MatterFabric copyMatterFabric = testMatterFabric.copyWith();

          expect(
            copyMatterFabric.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testMatterFabricJson,
          );
        },
      );

      test(
        "with changes",
        () {
          MatterFabric copyMatterFabric = testMatterFabric.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyMatterFabricJson =
              Map<String, dynamic>.from(testMatterFabricJson);

          copyMatterFabricJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyMatterFabricJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyMatterFabric.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyMatterFabricJson,
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
            testMatterFabric.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testMatterFabricJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testMatterFabric.toJson(),
            testMatterFabricJson,
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          MatterFabric alteredMatterFabric = testMatterFabric.copyWith();
          alteredMatterFabric.type = ResourceType.device;

          Map<String, dynamic> alteredMatterFabricJson =
              Map<String, dynamic>.from(testMatterFabricJson);
          alteredMatterFabricJson[ApiFields.type] = ResourceType.device.value;

          expect(
            alteredMatterFabric.toJson(optimizeFor: OptimizeFor.put),
            alteredMatterFabricJson,
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
              testMatterFabric.copyWith(id: "bad_value");
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
              testMatterFabric.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
