/// Describes the color mode state to activate after power up.
enum LightPowerUpColorMode {
  /// Color temperature will set the color temperature to the specified value
  /// after power up.
  ///
  /// When setting color_temperature, the color_temperature property must be
  /// included.
  colorTemperature("color_temperature"),

  /// Color will set the color to the specified value after power up.
  ///
  /// When setting color mode, the color property must be included.
  color("color"),

  /// Previous will set color to the state it was in before powering off.
  previous("previous");

  const LightPowerUpColorMode(this.value);

  /// The string representation of this [LightPowerUpColorMode].
  final String value;

  /// Get a [LightPowerUpColorMode] from a given string `value`.
  static LightPowerUpColorMode fromString(String value) {
    return values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => colorTemperature,
    );
  }
}
