import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/geolocation/geolocation.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/coordinate_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Geolocation testGeolocation = Geolocation(
    type: ResourceType.geolocation,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    isConfigured: false,
  );

  final Map<String, dynamic> testGeolocationJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.type: ResourceType.geolocation.value,
    ApiFields.isConfigured: false,
    ApiFields.longitude: null,
    ApiFields.latitude: null,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Geolocation.fromJson(testGeolocationJson),
            testGeolocation,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Geolocation.fromJson({ApiFields.data: testGeolocationJson}),
            testGeolocation,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Geolocation.fromJson({
              ApiFields.data: [testGeolocationJson]
            }),
            testGeolocation,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Geolocation.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testGeolocationJson]
            }),
            testGeolocation,
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
          Geolocation copyGeolocation = testGeolocation.copyWith();

          expect(
            copyGeolocation.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testGeolocationJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Geolocation copyGeolocation = testGeolocation.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyGeolocationJson =
              Map<String, dynamic>.from(testGeolocationJson);

          copyGeolocationJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyGeolocationJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyGeolocation.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyGeolocationJson,
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
            testGeolocation.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testGeolocationJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testGeolocation.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Geolocation alteredGeolocation = testGeolocation.copyWith();
          alteredGeolocation.type = ResourceType.device;

          expect(
            alteredGeolocation.toJson(optimizeFor: OptimizeFor.put),
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
              testGeolocation.copyWith(id: "bad_value");
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
              testGeolocation.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      group(
        "coordinates",
        () {
          test(
            "invalid latitude (low) assertion",
            () {
              expect(
                () {
                  Geolocation(
                    type: testGeolocation.type,
                    id: testGeolocation.id,
                    isConfigured: testGeolocation.isConfigured,
                    latitude: -91,
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid latitude (low) exception",
            () {
              expect(
                () {
                  testGeolocation.latitude = -91;
                },
                throwsA(isA<InvalidLatitudeException>()),
              );
            },
          );

          test(
            "invalid latitude (high) assertion",
            () {
              expect(
                () {
                  Geolocation(
                    type: testGeolocation.type,
                    id: testGeolocation.id,
                    isConfigured: testGeolocation.isConfigured,
                    latitude: 91,
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid latitude (high) exception",
            () {
              expect(
                () {
                  testGeolocation.latitude = 91;
                },
                throwsA(isA<InvalidLatitudeException>()),
              );
            },
          );

          test(
            "invalid longitude (low) assertion",
            () {
              expect(
                () {
                  Geolocation(
                    type: testGeolocation.type,
                    id: testGeolocation.id,
                    isConfigured: testGeolocation.isConfigured,
                    longitude: -181,
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid longitude (low) exception",
            () {
              expect(
                () {
                  testGeolocation.longitude = -181;
                },
                throwsA(isA<InvalidLongitudeException>()),
              );
            },
          );

          test(
            "invalid longitude (high) assertion",
            () {
              expect(
                () {
                  Geolocation(
                    type: testGeolocation.type,
                    id: testGeolocation.id,
                    isConfigured: testGeolocation.isConfigured,
                    longitude: 181,
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid longitude (high) exception",
            () {
              expect(
                () {
                  testGeolocation.longitude = 181;
                },
                throwsA(isA<InvalidLongitudeException>()),
              );
            },
          );
        },
      );
    },
  );
}
