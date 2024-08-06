import 'package:cloud_firestore/cloud_firestore.dart';

/// Contains default values for the application.
///
/// These will be used in cases such as empty objects, etc. This way, we can
/// determine which values have actually been set by the user.
class Defaults {
  /// Default date.
  ///
  /// Equivalent to [timestamp].
  static DateTime get dateTime => DateTime(1);

  /// Default timestamp.
  ///
  /// Equivalent to [dateTime].
  static Timestamp get timestamp => Timestamp.fromDate(dateTime);

  /// Used in [copyWith] methods to check if nullable values are meant to be
  /// copied over.
  static const sentinelValue = Object();
}
