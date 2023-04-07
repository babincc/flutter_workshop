/// The mode the light is in.
enum LightMode {
  normal("normal"),
  streaming("streaming");

  const LightMode(this.value);

  /// The string representation of this [LightMode].
  final String value;

  /// Get a [LightMode] from a given string `value`.
  static LightMode fromString(String value) {
    return values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => normal,
    );
  }
}
