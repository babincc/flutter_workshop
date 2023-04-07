import 'package:flutter_hue/constants/api_fields.dart';

/// Helps identify a matter fabric resource.
class MatterFabricData {
  /// Creates a [MatterFabricData] object.
  MatterFabricData({
    required this.label,
    required this.vendorId,
  });

  /// Creates a [MatterFabricData] object from the JSON  response to a GET
  /// request.
  factory MatterFabricData.fromJson(Map<String, dynamic> dataMap) {
    return MatterFabricData(
      label: dataMap[ApiFields.label] ?? "",
      vendorId: dataMap[ApiFields.vendorId] ?? 0,
    );
  }

  /// Creates an empty [MatterFabricData] object.
  MatterFabricData.empty()
      : label = "",
        vendorId = 0;

  /// Human readable context to identify fabric.
  final String label;

  /// Matter vendor id of entity that created the fabric association.
  final int vendorId;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  MatterFabricData copyWith({
    String? label,
    int? vendorId,
  }) {
    return MatterFabricData(
      label: label ?? this.label,
      vendorId: vendorId ?? this.vendorId,
    );
  }

  /// Converts this object into JSON format.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.label: label,
      ApiFields.vendorId: vendorId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is MatterFabricData &&
        other.label == label &&
        other.vendorId == vendorId;
  }

  @override
  int get hashCode => Object.hash(label, vendorId);

  @override
  String toString() => "Instance of 'MatterFabricData' ${toJson().toString()}";
}
