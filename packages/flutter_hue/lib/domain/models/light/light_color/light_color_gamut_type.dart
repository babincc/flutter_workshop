/// The gamut types supported by hue.
enum LightColorGamutType {
  /// Gamut of early Philips color-only products.
  a("A"),

  /// Limited gamut of first Hue color products.
  b("B"),

  /// Richer color gamut of Hue white and color ambiance products.
  c("C"),

  /// Color gamut of non-hue products with non-hue gamuts.
  other("other");

  const LightColorGamutType(this.value);

  /// The string representation of this [LightColorGamutType].
  final String value;

  /// Get a [LightColorGamutType] from a given string `value`.
  static LightColorGamutType fromString(String value) {
    return values.firstWhere(
      (gamutType) => gamutType.value == value,
      orElse: () => other,
    );
  }
}
