/// Contains default values for the application.
///
/// These will be used in cases such as empty objects, etc. This way, we can
/// determine which values have actually been set by the user.
class Defaults {
  /// Default date.
  static DateTime get dateTime => DateTime(1);

  /// Used in [copyWith] methods to check if nullable values are meant to be
  /// copied over.
  static const sentinelValue = Object();
}
