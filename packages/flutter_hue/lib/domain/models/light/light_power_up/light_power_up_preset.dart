/// Describes the power up preset settings.
enum LightPowerUpPreset {
  safety("safety"),
  powerFail("powerfail"),
  lastOnState("last_on_state"),
  custom("custom");

  const LightPowerUpPreset(this.value);

  /// The string representation of this [LightPowerUpPreset].
  final String value;

  /// Get a [LightPowerUpPreset] from a given string `value`.
  static LightPowerUpPreset fromString(String value) {
    return values.firstWhere(
      (preset) => preset.value == value,
      orElse: () => safety,
    );
  }
}
