/// Describes the action be taken with a light's color temperature.
enum LightColorTemperatureDeltaAction {
  up("up"),
  down("down"),
  stop("stop");

  const LightColorTemperatureDeltaAction(this.value);

  /// The string representation of this [LightColorTemperatureDeltaAction].
  final String value;

  /// Get a [LightColorTemperatureDeltaAction] from a given string `value`.
  static LightColorTemperatureDeltaAction fromString(String value) {
    return values.firstWhere(
      (action) => action.value == value,
      orElse: () => stop,
    );
  }
}
