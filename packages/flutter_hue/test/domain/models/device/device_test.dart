import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/device/device.dart';
import 'package:flutter_hue/domain/models/device/device_archetype.dart';
import 'package:flutter_hue/domain/models/device/device_metadata.dart';
import 'package:flutter_hue/domain/models/device/device_product_data.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Device testDevice = Device(
    type: ResourceType.device,
    id: "01234567-89ab-cdef-0123-456789abcdef",
    idV1: "/abcd/1234-abcd",
    productData: DeviceProductData(
      modelId: "LCA007",
      manufacturerName: "Signify Netherlands B.V.",
      productName: "Hue color lamp",
      productArchetype: DeviceArchetype.sultanBulb,
      isCertified: true,
      softwareVersion: "2.11.3",
      hardwarePlatformType: "100b-114",
    ),
    metadata: DeviceMetadata(
      name: "My Bulb",
      archetype: DeviceArchetype.sultanBulb,
    ),
    services: [
      Relative(
        type: ResourceType.light,
        id: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
      ),
      Relative(
        type: ResourceType.zigbeeConnectivity,
        id: "00001111-2222-3333-4444-555566667777",
      ),
      Relative(
        type: ResourceType.entertainment,
        id: "abababab-abab-abab-abab-abababababab",
      ),
    ],
  );

  final Map<String, dynamic> testDeviceJson = {
    ApiFields.id: "01234567-89ab-cdef-0123-456789abcdef",
    ApiFields.idV1: "/abcd/1234-abcd",
    ApiFields.productData: {
      ApiFields.modelId: "LCA007",
      ApiFields.manufacturerName: "Signify Netherlands B.V.",
      ApiFields.productName: "Hue color lamp",
      ApiFields.productArchetype: DeviceArchetype.sultanBulb.value,
      ApiFields.isCertified: true,
      ApiFields.softwareVersion: "2.11.3",
      ApiFields.hardwarePlatformType: "100b-114",
    },
    ApiFields.metadata: {
      ApiFields.name: "My Bulb",
      ApiFields.archetype: DeviceArchetype.sultanBulb.value,
    },
    ApiFields.identify: {
      ApiFields.action: null,
    },
    ApiFields.services: [
      {
        ApiFields.rid: "1a2b3c4d-5e6f-7a8b-9c0d-ef1a2b3c4d5e",
        ApiFields.rType: ResourceType.light.value,
      },
      {
        ApiFields.rid: "00001111-2222-3333-4444-555566667777",
        ApiFields.rType: ResourceType.zigbeeConnectivity.value,
      },
      {
        ApiFields.rid: "abababab-abab-abab-abab-abababababab",
        ApiFields.rType: ResourceType.entertainment.value,
      },
    ],
    ApiFields.type: ResourceType.device.value,
  };

  group(
    "fromJson",
    () {
      test(
        "ideal scenario",
        () {
          expect(
            Device.fromJson(testDeviceJson),
            testDevice,
          );
        },
      );

      test(
        "data scenario 1",
        () {
          expect(
            Device.fromJson({ApiFields.data: testDeviceJson}),
            testDevice,
          );
        },
      );

      test(
        "data scenario 2",
        () {
          expect(
            Device.fromJson({
              ApiFields.data: [testDeviceJson]
            }),
            testDevice,
          );
        },
      );

      test(
        "data scenario 3",
        () {
          expect(
            Device.fromJson({
              ApiFields.error: [],
              ApiFields.data: [testDeviceJson]
            }),
            testDevice,
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
          Device copyDevice = testDevice.copyWith();

          expect(
            copyDevice.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testDeviceJson,
          );
        },
      );

      test(
        "with changes",
        () {
          Device copyDevice = testDevice.copyWith(
            id: "00000000-0000-0000-0000-000000000000",
            idV1: "/test/1234-5678-9012-3456-7890",
          );

          Map<String, dynamic> copyDeviceJson =
              Map<String, dynamic>.from(testDeviceJson);

          copyDeviceJson[ApiFields.id] = "00000000-0000-0000-0000-000000000000";
          copyDeviceJson[ApiFields.idV1] = "/test/1234-5678-9012-3456-7890";

          expect(
            copyDevice.toJson(optimizeFor: OptimizeFor.dontOptimize),
            copyDeviceJson,
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
            testDevice.toJson(optimizeFor: OptimizeFor.dontOptimize),
            testDeviceJson,
          );
        },
      );

      test(
        "optimize for PUT (no change)",
        () {
          expect(
            testDevice.toJson(),
            {},
          );
        },
      );

      test(
        "optimize for PUT (with change)",
        () {
          Device alteredDevice = testDevice.copyWith();
          alteredDevice.type = ResourceType.light;

          expect(
            alteredDevice.toJson(optimizeFor: OptimizeFor.put),
            {
              ApiFields.type: ResourceType.light.value,
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
        "invalid idV1 assertion",
        () {
          expect(
            () {
              testDevice.copyWith(idV1: "bad_value");
            },
            throwsAssertionError,
          );
        },
      );

      test(
        "invalid name assertion",
        () {
          expect(
            () {
              testDevice.copyWith(
                metadata: DeviceMetadata(
                  name: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                  archetype: testDevice.metadata.archetype,
                ),
              );
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
              testDevice.metadata.name = "";
            },
            throwsA(isA<InvalidNameException>()),
          );
        },
      );

      group(
        "product data",
        () {
          test(
            "invalid software version assertion",
            () {
              expect(
                () {
                  testDevice.copyWith(
                    productData: DeviceProductData(
                      modelId: testDevice.productData.modelId,
                      manufacturerName: testDevice.productData.manufacturerName,
                      productName: testDevice.productData.productName,
                      productArchetype: testDevice.productData.productArchetype,
                      isCertified: testDevice.productData.isCertified,
                      softwareVersion: "1.2",
                      hardwarePlatformType:
                          testDevice.productData.hardwarePlatformType,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );

          test(
            "invalid software version (empty) assertion",
            () {
              expect(
                () {
                  testDevice.copyWith(
                    productData: DeviceProductData(
                      modelId: testDevice.productData.modelId,
                      manufacturerName: testDevice.productData.manufacturerName,
                      productName: testDevice.productData.productName,
                      productArchetype: testDevice.productData.productArchetype,
                      isCertified: testDevice.productData.isCertified,
                      softwareVersion: "",
                      hardwarePlatformType:
                          testDevice.productData.hardwarePlatformType,
                    ),
                  );
                },
                throwsAssertionError,
              );
            },
          );
        },
      );
    },
  );
}
