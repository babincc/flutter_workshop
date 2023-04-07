import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/matter/matter.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Matter testMatter = Matter(
    type: ResourceType.matter,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    maxFabrics: 15,
    hasQrCode: true,
  );

  final Map<String, dynamic> testMatterJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.matter.value,
    ApiFields.maxFabrics: 15,
    ApiFields.hasQrCode: true,
    ApiFields.action: null,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Matter.fromJson(testMatterJson),
            testMatter,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Matter.fromJson({ApiFields.data: testMatterJson}),
            testMatter,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Matter.fromJson({
              ApiFields.data: [testMatterJson]
            }),
            testMatter,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Matter.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testMatterJson]
            }),
            testMatter,
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
          Matter copyMatter = testMatter.copyWith();

          expect(
            copyMatter.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testMatterJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Matter copyMatter = testMatter.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyMatterJson =
              Map<String, dynamic>.from(testMatterJson);

          copyMatterJson[ApiFields.id] = "00000000-0000-0000-0000-000000000000";
          copyMatterJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copyMatter.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyMatterJson,
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
            testMatter.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testMatterJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testMatter.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Matter alteredMatter = testMatter.copyWith();
          alteredMatter.type = ResourceType.device;

          expect(
            alteredMatter.toJson(optimizeFor: OptimizeFor.put),
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
              testMatter.copyWith(id: "bad_value");
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
              testMatter.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
