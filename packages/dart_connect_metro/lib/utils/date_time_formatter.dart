/// Extension on [DateTime] to format it to WMATA API format.
extension DateTimeFormatter on DateTime {
  /// Formats the [DateTime] to WMATA API format.
  ///
  /// The WMATA API format is a string in the format of `YYYY-MM-DDTHH:mm:ss`.
  String toWmataString() => toIso8601String().replaceAll(RegExp(r'\.\d+'), '');
}
