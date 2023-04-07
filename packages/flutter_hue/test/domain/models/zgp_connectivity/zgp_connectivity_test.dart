import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/zgp_connectivity/zgp_connectivity.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ZgpConnectivity testZgpConnectivity = ZgpConnectivity(
    type: ResourceType.zgpConnectivity,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    status: "connected",
    sourceId: "abc123",
  );

  final Map<String, dynamic> testZgpConnectivityJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
      ApiFields.rType: ResourceType.device.value,
    },
    ApiFields.status: "connected",
    ApiFields.sourceId: "abc123",
    ApiFields.type: ResourceType.zgpConnectivity.value,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            ZgpConnectivity.fromJson(testZgpConnectivityJson),
            testZgpConnectivity,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            ZgpConnectivity.fromJson({ApiFields.data: testZgpConnectivityJson}),
            testZgpConnectivity,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            ZgpConnectivity.fromJson({
              ApiFields.data: [testZgpConnectivityJson]
            }),
            testZgpConnectivity,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            ZgpConnectivity.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testZgpConnectivityJson]
            }),
            testZgpConnectivity,
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
          ZgpConnectivity copyZgpConnectivity = testZgpConnectivity.copyWith();

          expect(
            copyZgpConnectivity.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testZgpConnectivityJson,
          );
        },
      );

      test(
        "with changes",
        () {
          ZgpConnectivity copyZgpConnectivity = testZgpConnectivity.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyZgpConnectivityJson =
              Map<String, dynamic>.from(testZgpConnectivityJson);

          copyZgpConnectivityJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyZgpConnectivityJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyZgpConnectivity.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyZgpConnectivityJson,
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
            testZgpConnectivity.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testZgpConnectivityJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testZgpConnectivity.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          ZgpConnectivity alteredZgpConnectivity =
              testZgpConnectivity.copyWith();
          alteredZgpConnectivity.type = ResourceType.device;

          expect(
            alteredZgpConnectivity.toJson(optimizeFor: OptimizeFor.put),
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
              testZgpConnectivity.copyWith(id: "bad_value");
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
              testZgpConnectivity.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
