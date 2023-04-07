import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/temperature/temperature.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Temperature testTemperature = Temperature(
    type: ResourceType.temperature,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    owner: Relative(
      type: ResourceType.device,
      id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    ),
    isEnabled: true,
    temperatureCelsius: 71.12,
    isValidTemperature: true,
  );

  final Map<String, dynamic> testTemperatureJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.owner: {
      ApiFields.rType: ResourceType.device.value,
      ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
    },
    ApiFields.isEnabled: true,
    ApiFields.type: ResourceType.temperature.value,
    ApiFields.temperature: {
      ApiFields.temperature: 71.12,
      ApiFields.temperatureValid: true,
    },
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Temperature.fromJson(testTemperatureJson),
            testTemperature,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Temperature.fromJson({ApiFields.data: testTemperatureJson}),
            testTemperature,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Temperature.fromJson({
              ApiFields.data: [testTemperatureJson]
            }),
            testTemperature,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Temperature.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testTemperatureJson]
            }),
            testTemperature,
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
          Temperature copyTemperature = testTemperature.copyWith();

          expect(
            copyTemperature.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testTemperatureJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Temperature copyTemperature = testTemperature.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyTemperatureJson =
              Map<String, dynamic>.from(testTemperatureJson);

          copyTemperatureJson[ApiFields.id] =
              "00000000-0000-0000-0000-000000000000";
          copyTemperatureJson[ApiFields.idV1] =
              "/test/1234-5678-9012-3456-7890";

          expect(
            copyTemperature.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyTemperatureJson,
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
            testTemperature.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testTemperatureJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testTemperature.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Temperature alteredTemperature = testTemperature.copyWith();
          alteredTemperature.type = ResourceType.device;

          expect(
            alteredTemperature.toJson(optimizeFor: OptimizeFor.put),
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
              testTemperature.copyWith(id: "bad_value");
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
              testTemperature.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );
    },
  );
}
