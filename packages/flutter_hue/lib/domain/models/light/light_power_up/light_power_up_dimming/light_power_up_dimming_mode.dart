/// The dimming mode the light is in.
enum LightPowerUpDimmingMode {
  /// When setting mode "dimming", the dimming property must be included.
  dimming("dimming"),

  /// Previous will set brightness to the state it was in before powering off.
  previous("previous");

  const LightPowerUpDimmingMode(this.value);

  /// The string representation of this [LightPowerUpDimmingMode].
  final String value;

  /// Get a [LightPowerUpDimmingMode] from a given string `value`.
  static LightPowerUpDimmingMode fromString(String value) {
    return values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => dimming,
    );
  }
}
