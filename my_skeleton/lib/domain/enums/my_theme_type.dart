/// The main brightness level of the app's UI.
enum MyThemeType {
  /// All of the main background colors will be dark with lighter foreground
  /// colors for contrast.
  dark('dark'),

  /// All of the main background colors will be light with darker foreground
  /// colors for contrast.
  light('light');

  const MyThemeType(this.value);

  /// The string representation of this [MyThemeType].
  final String value;

  /// Get a [MyThemeType] from a given string `value`.
  static MyThemeType fromString(String value) {
    return values.firstWhere(
      (role) => role.value == value,
      orElse: () => dark,
    );
  }
}
