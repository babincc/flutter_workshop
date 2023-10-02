import 'package:dart_connect_metro/utils/time.dart';

/// Returns an empty [DateTime].
DateTime get emptyDateTime => DateTime.fromMillisecondsSinceEpoch(0);

/// Returns an empty [Time].
Time get emptyTime => Time(0, 0);

/// Extension on [DateTime] to format it to WMATA API format.
extension DateTimeFormatter on DateTime {
  /// Formats the [DateTime] to WMATA API format.
  ///
  /// The WMATA API format is a string in the format of `YYYY-MM-DDTHH:mm:ss`.
  String toWmataString() => toIso8601String().replaceAll(RegExp(r'\.\d+'), '');

  /// Formats the [DateTime] to WMATA API format, but only the date.
  ///
  /// The WMATA API format is a string in the format of `YYYY-MM-DD`.
  String toWmataStringDateOnly() {
    final String str = toWmataString();
    return str.substring(0, str.indexOf('T'));
  }

  /// Formats the [DateTime] to WMATA API format, but only the time.
  ///
  /// The WMATA API format is a string in the format of `HH:mm:ss`.
  String toWmataStringTimeOnly() {
    final String str = toWmataString();
    return str.substring(str.indexOf('T') + 1);
  }
}
