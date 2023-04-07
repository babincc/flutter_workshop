/// Describes the on/off state the light should take on power up.
enum LightPowerUpOnMode {
  /// On will use the value specified in the "on" property. When setting mode
  /// "on", the on property must be included.
  on("on"),

  /// Toggle will alternate between on and off on each subsequent power toggle.
  toggle("toggle"),

  /// Previous will return to the state it was in before powering off.
  previous("previous");

  const LightPowerUpOnMode(this.value);

  /// The string representation of this [LightPowerUpOnMode].
  final String value;

  /// Get a [LightPowerUpOnMode] from a given string `value`.
  static LightPowerUpOnMode fromString(String value) {
    return values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => on,
    );
  }
}
