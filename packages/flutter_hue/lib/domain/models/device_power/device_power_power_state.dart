import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/utils/validators.dart';

/// The device's power state.
class DevicePowerPowerState {
  /// Creates a [DevicePowerPowerState] object.
  DevicePowerPowerState({
    required this.batteryState,
    required this.batteryLevel,
  }) : assert(Validators.isValidPercentage(batteryLevel),
            "`batteryPercent` must be between 0 and 100 (inclusive)");

  /// Creates a [DevicePowerPowerState] object from the JSON response to a GET
  /// request.
  factory DevicePowerPowerState.fromJson(Map<String, dynamic> dataMap) {
    return DevicePowerPowerState(
      batteryState: dataMap[ApiFields.batteryState] ?? "",
      batteryLevel: dataMap[ApiFields.batteryLevel] ?? 0,
    );
  }

  /// Creates an empty [DevicePowerPowerState] object.
  DevicePowerPowerState.empty()
      : batteryState = "",
        batteryLevel = 0;

  /// Status of the power source of a device, only for battery powered devices.
  ///
  /// * normal – battery level is sufficient
  /// * low – battery level low, some features (e.g. software update) might stop
  /// working, please change battery soon
  /// * critical – battery level critical, device can fail any moment
  final String batteryState;

  /// The current battery state in percent, only for battery powered devices.
  final int batteryLevel;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  DevicePowerPowerState copyWith({
    String? batteryState,
    int? batteryLevel,
  }) {
    return DevicePowerPowerState(
      batteryState: batteryState ?? this.batteryState,
      batteryLevel: batteryLevel ?? this.batteryLevel,
    );
  }

  /// Converts this object into JSON format.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.batteryState: batteryState,
      ApiFields.batteryLevel: batteryLevel,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is DevicePowerPowerState &&
        other.batteryState == batteryState &&
        other.batteryLevel == batteryLevel;
  }

  @override
  int get hashCode => Object.hash(batteryState, batteryLevel);

  @override
  String toString() =>
      "Instance of 'DevicePowerPowerState' ${toJson().toString()}";
}
