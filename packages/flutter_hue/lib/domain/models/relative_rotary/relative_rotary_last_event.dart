import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative_rotary/relative_rotary_rotation.dart';

/// The rotary switch's last event.
class RelativeRotaryLastEvent {
  /// Creates a [RelativeRotaryLastEvent] object.
  RelativeRotaryLastEvent({
    required this.action,
    required this.rotation,
  });

  /// Creates a [RelativeRotaryLastEvent] object from the JSON response to a GET
  /// request.
  factory RelativeRotaryLastEvent.fromJson(Map<String, dynamic> dataMap) {
    return RelativeRotaryLastEvent(
        action: dataMap[ApiFields.action] ?? "",
        rotation:
            RelativeRotaryRotation.fromJson(dataMap[ApiFields.rotation] ?? {}));
  }

  /// Creates an empty [RelativeRotaryLastEvent] object.
  RelativeRotaryLastEvent.empty()
      : action = "",
        rotation = RelativeRotaryRotation.empty();

  /// Which type of rotary event is received.
  ///
  /// one of: start, repeat
  final String action;

  /// Describes the rotation of the switch.
  final RelativeRotaryRotation rotation;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  RelativeRotaryLastEvent copyWith({
    String? action,
    RelativeRotaryRotation? rotation,
  }) {
    return RelativeRotaryLastEvent(
      action: action ?? this.action,
      rotation: rotation ?? this.rotation.copyWith(),
    );
  }

  /// Converts this object into JSON format.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.action: action,
      ApiFields.rotation: rotation.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is RelativeRotaryLastEvent &&
        other.action == action &&
        other.rotation == rotation;
  }

  @override
  int get hashCode => Object.hash(action, rotation);

  @override
  String toString() =>
      "Instance of 'RelativeRotaryLastEvent' ${toJson().toString()}";
}
