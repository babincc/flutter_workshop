import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/geofence_client/geofence_client.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final GeofenceClient testGeofenceClient = GeofenceClient(
    type: ResourceType.geofenceClient,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    name: "My Geo Client",
  );

  final Map<String, dynamic> testGeofenceClientJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.geofenceClient.value,
    ApiFields.name: "My Geo Client",
    ApiFields.isAtHome: null,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            GeofenceClient.fromJson(testGeofenceClientJson),
            testGeofenceClient,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            GeofenceClient.fromJson({ApiFields.data: testGeofenceClientJson}),
            testGeofenceClient,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            GeofenceClient.fromJson({
              ApiFields.data: [testGeofenceClientJson]
            }),
            testGeofenceClient,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            GeofenceClient.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testGeofenceClientJson]
            }),
            testGeofenceClient,
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
          GeofenceClient copyGeofenceClient = testGeofenceClient.copyWith();

          expect(
            copyGeofenceClient.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testGeofenceClientJson,
          );
        },
      );

      test(
        "with changes",
        () {
          GeofenceClient copyGeofenceClient = testGeofenceClient.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyGeofenceClientJson =
              Map<String, dynamic>.from(testGeofenceClientJson);

          copyGeofenceClientJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyGeofenceClientJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyGeofenceClient.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyGeofenceClientJson,
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
            testGeofenceClient.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testGeofenceClientJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testGeofenceClient.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          GeofenceClient alteredGeofenceClient = testGeofenceClient.copyWith();
          alteredGeofenceClient.type = ResourceType.device;

          expect(
            alteredGeofenceClient.toJson(optimizeFor: OptimizeFor.put),
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
              testGeofenceClient.copyWith(id: "bad_value");
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
              testGeofenceClient.copyWith(idV1: "bad_value");
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
              testGeofenceClient.name = "";
            },
            throwsA(isA<InvalidNameException>()),
          );
        },
      );
    },
  );
}
