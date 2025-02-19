import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_signaling/light_signaling_status.dart';

/// Represents light signalling properties.
class LightSignaling {
  /// Creates a [LightSignaling] object.
  const LightSignaling({required this.status, required this.signalValues});

  /// Creates a [LightSignaling] object from the JSON response to a GET request.
  factory LightSignaling.fromJson(Map<String, dynamic> dataMap) {
    // Extract signal values from data map.
    List<String> signalValues =
        List<String>.from(dataMap[ApiFields.signalValues] ?? {});

    return LightSignaling(
      status: LightSignalingStatus.fromJson(
        {
          ...Map<String, dynamic>.from(dataMap[ApiFields.status] ?? {}),
          ...{ApiFields.signalValues: signalValues},
        },
      ),
      signalValues: signalValues,
    );
  }

  /// Creates an empty [LightSignaling] object.
  LightSignaling.empty()
      : status = LightSignalingStatus.empty(),
        signalValues = [];

  /// The current signalling status.
  final LightSignalingStatus status;

  /// The accepted signal values.
  final List<String> signalValues;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  LightSignaling copyWith({
    LightSignalingStatus? status,
    List<String>? signalValues,
  }) {
    return LightSignaling(
      status: status ?? this.status.copyWith(),
      signalValues: signalValues ?? List<String>.from(this.signalValues),
    );
  }

  /// Converts this object into JSON format.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.status: status.toJson(),
      ApiFields.signalValues: signalValues,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightSignaling &&
        other.status == status &&
        const DeepCollectionEquality.unordered()
            .equals(other.signalValues, signalValues);
  }

  @override
  int get hashCode => Object.hash(
        status,
        const DeepCollectionEquality.unordered().hash(signalValues),
      );

  @override
  String toString() => "Instance of 'LightSignaling' ${toJson().toString()}";
}
