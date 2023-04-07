import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/invalid_value_exception.dart';
import 'package:flutter_hue/utils/date_time_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents light signalling properties.
class LightSignalingStatus {
  /// Creates a [LightSignalingStatus] object.
  LightSignalingStatus({
    required this.signal,
    required this.signalValues,
    required this.estimatedEnd,
  }) : assert(signal.isEmpty || Validators.isValidValue(signal, signalValues),
            '`signalValues`does not contain "$signal"');

  /// Creates a [LightSignalingStatus] object from the JSON response to a GET
  /// request.
  factory LightSignalingStatus.fromJson(Map<String, dynamic> dataMap) {
    return LightSignalingStatus(
      signal: dataMap[ApiFields.signal] ?? "",
      signalValues: List<String>.from(dataMap[ApiFields.signalValues] ?? []),
      estimatedEnd: DateTime.tryParse(dataMap[ApiFields.estimatedEnd] ?? "") ??
          DateUtils.dateOnly(DateTime.now()),
    );
  }

  /// Creates an empty [LightSignalingStatus] object.
  LightSignalingStatus.empty()
      : signal = "",
        signalValues = [],
        estimatedEnd = DateUtils.dateOnly(DateTime.now());

  /// Indicates which signal is currently active.
  final String signal;

  /// The accepted signal values.
  final List<String> signalValues;

  /// Timestamp indicating when the active signal is expected to end.
  ///
  /// Value is not set if there is no signal.
  final DateTime estimatedEnd;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Throws [InvalidValueException] if the [LightSignalingStatus] copy has a
  /// [signal] that is not in its [signalValues] array.
  LightSignalingStatus copyWith({
    String? signal,
    List<String>? signalValues,
    DateTime? estimatedEnd,
  }) {
    // Make sure [signal] is valid.
    if (signalValues != null &&
        signal == null &&
        !Validators.isValidValue(this.signal, signalValues)) {
      throw InvalidValueException.withValue(this.signal, signalValues);
    }

    return LightSignalingStatus(
      signal: signal ?? this.signal,
      signalValues: signalValues ?? List<String>.from(this.signalValues),
      estimatedEnd: estimatedEnd ?? this.estimatedEnd.copyWith(),
    );
  }

  /// Converts this object into JSON format.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.signal: signal,
      ApiFields.signalValues: signalValues,
      ApiFields.estimatedEnd: DateTimeTool.toHueString(estimatedEnd),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightSignalingStatus &&
        other.signal == signal &&
        const DeepCollectionEquality.unordered()
            .equals(other.signalValues, signalValues) &&
        other.estimatedEnd == estimatedEnd;
  }

  @override
  int get hashCode => Object.hash(
        signal,
        Object.hashAllUnordered(signalValues),
        estimatedEnd,
      );

  @override
  String toString() =>
      "Instance of 'LightSignalingStatus' ${toJson().toString()}";
}
