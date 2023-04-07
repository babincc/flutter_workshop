import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/device/device_archetype.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents the product data of a Philips Hue device.
class DeviceProductData {
  /// Creates a [DeviceProductData] object.
  DeviceProductData({
    required this.modelId,
    required this.manufacturerName,
    required this.productName,
    required this.productArchetype,
    required this.isCertified,
    required this.softwareVersion,
    required this.hardwarePlatformType,
  }) : assert(Validators.isValidSoftwareVersion(softwareVersion),
            '"$softwareVersion" is not a valid `softwareVersion`');

  /// Creates a [DeviceProductData] object from the JSON response to a GET
  /// request.
  factory DeviceProductData.fromJson(Map<String, dynamic> dataMap) {
    return DeviceProductData(
      modelId: dataMap[ApiFields.modelId] ?? "",
      manufacturerName: dataMap[ApiFields.manufacturerName] ?? "",
      productName: dataMap[ApiFields.productName] ?? "",
      productArchetype:
          DeviceArchetype.fromString(dataMap[ApiFields.productArchetype] ?? ""),
      isCertified: dataMap[ApiFields.isCertified] ?? false,
      softwareVersion: dataMap[ApiFields.softwareVersion] ?? "0.0.0",
      hardwarePlatformType: dataMap[ApiFields.hardwarePlatformType] ?? "",
    );
  }

  /// Creates an empty [DeviceProductData] object.
  DeviceProductData.empty()
      : modelId = "",
        manufacturerName = "",
        productName = "",
        productArchetype = DeviceArchetype.fromString(""),
        isCertified = false,
        softwareVersion = "0.0.0",
        hardwarePlatformType = "";

  /// Unique identification of device model.
  final String modelId;

  /// Name of device manufacturer
  final String manufacturerName;

  /// Name of the product.
  final String productName;

  /// Archetype of the product.
  final DeviceArchetype productArchetype;

  /// Whether or not this device is Hue certified
  final bool isCertified;

  /// Software version of the product.
  ///
  /// Regex pattern `^\d+\.\d+\.\d+$`.
  final String softwareVersion;

  /// Hardware type - identified by Manufacturer code and ImageType.
  final String hardwarePlatformType;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  DeviceProductData copyWith({
    String? modelId,
    String? manufacturerName,
    String? productName,
    DeviceArchetype? productArchetype,
    bool? isCertified,
    String? softwareVersion,
    String? hardwarePlatformType,
  }) {
    return DeviceProductData(
      modelId: modelId ?? this.modelId,
      manufacturerName: manufacturerName ?? this.manufacturerName,
      productName: productName ?? this.productName,
      productArchetype: productArchetype ?? this.productArchetype,
      isCertified: isCertified ?? this.isCertified,
      softwareVersion: softwareVersion ?? this.softwareVersion,
      hardwarePlatformType: hardwarePlatformType ?? this.hardwarePlatformType,
    );
  }

  /// Converts this object into JSON format.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.modelId: modelId,
      ApiFields.manufacturerName: manufacturerName,
      ApiFields.productName: productName,
      ApiFields.productArchetype: productArchetype.value,
      ApiFields.isCertified: isCertified,
      ApiFields.softwareVersion: softwareVersion,
      ApiFields.hardwarePlatformType: hardwarePlatformType,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is DeviceProductData &&
        other.modelId == modelId &&
        other.manufacturerName == manufacturerName &&
        other.productName == productName &&
        identical(other.productArchetype, productArchetype) &&
        other.isCertified == isCertified &&
        other.softwareVersion == softwareVersion &&
        other.hardwarePlatformType == hardwarePlatformType;
  }

  @override
  int get hashCode => Object.hash(
        modelId,
        manufacturerName,
        productName,
        productArchetype,
        isCertified,
        softwareVersion,
        hardwarePlatformType,
      );

  @override
  String toString() => "Instance of 'DeviceProductData' ${toJson().toString()}";
}
