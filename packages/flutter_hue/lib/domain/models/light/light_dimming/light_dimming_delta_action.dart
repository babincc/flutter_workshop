/// Describes the action be taken with a light's dim level.
enum LightDimmingDeltaAction {
  up("up"),
  down("down"),
  stop("stop");

  const LightDimmingDeltaAction(this.value);

  /// The string representation of this [LightDimmingDeltaAction].
  final String value;

  /// Get a [LightDimmingDeltaAction] from a given string `value`.
  static LightDimmingDeltaAction fromString(String value) {
    return values.firstWhere(
      (action) => action.value == value,
      orElse: () => stop,
    );
  }
}
