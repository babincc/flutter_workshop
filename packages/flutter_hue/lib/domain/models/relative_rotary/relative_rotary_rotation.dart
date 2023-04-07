import 'package:flutter_hue/constants/api_fields.dart';

/// Represents a rotary switch's rotation.
class RelativeRotaryRotation {
  /// Creates a [RelativeRotaryRotation] object.
  RelativeRotaryRotation({
    required this.direction,
    required this.steps,
    required this.durationMilliseconds,
  })  : assert(steps >= 0 && steps <= 32767,
            "`steps` must be between 0 and 32767 (inclusive)"),
        assert(durationMilliseconds >= 0 && durationMilliseconds <= 65534,
            "`durationMilliseconds` must be between 0 and 65534 (inclusive)");

  /// Creates a [RelativeRotaryRotation] object from the JSON response to a GET
  /// request.
  factory RelativeRotaryRotation.fromJson(Map<String, dynamic> dataMap) {
    return RelativeRotaryRotation(
      direction: dataMap[ApiFields.direction] ?? "",
      steps: dataMap[ApiFields.steps] ?? 0,
      durationMilliseconds: dataMap[ApiFields.duration] ?? 0,
    );
  }

  /// Creates an empty [RelativeRotaryRotation] object.
  RelativeRotaryRotation.empty()
      : direction = "",
        steps = 0,
        durationMilliseconds = 0;

  /// A rotation opposite to the previous rotation, will always start with new
  /// start command.
  ///
  /// one of: clock_wise, counter_clock_wise
  final String direction;

  /// Amount of rotation since previous event, in the case of repeat.
  ///
  /// Amount of rotation since start, in the case of a start_event.
  ///
  /// Resolution = 1000 steps / 360 degree rotation.
  ///
  /// Range: 0 - 32767
  final int steps;

  /// Duration of rotation since previous event, in the case of repeat
  ///
  /// Amount of rotation since start, in the case of a start_event.
  ///
  /// Duration is specified in milliseconds.
  final int durationMilliseconds;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  RelativeRotaryRotation copyWith({
    String? direction,
    int? steps,
    int? durationMilliseconds,
  }) {
    return RelativeRotaryRotation(
      direction: direction ?? this.direction,
      steps: steps ?? this.steps,
      durationMilliseconds: durationMilliseconds ?? this.durationMilliseconds,
    );
  }

  /// Converts this object into JSON format.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.direction: direction,
      ApiFields.steps: steps,
      ApiFields.duration: durationMilliseconds,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is RelativeRotaryRotation &&
        other.direction == direction &&
        other.steps == steps &&
        other.durationMilliseconds == durationMilliseconds;
  }

  @override
  int get hashCode => Object.hash(direction, steps, durationMilliseconds);

  @override
  String toString() =>
      "Instance of 'RelativeRotaryRotation' ${toJson().toString()}";
}
