/// Tools for dealing with date and time objects in the app and the Philips Hue
/// system.
class DateTimeTool {
  /// Converts the given `dateTime` to a string that the Hue bridge can
  /// understand.
  static String toHueString(DateTime dateTime) {
    String dateTimeStr = dateTime.toIso8601String();
    return dateTimeStr.substring(0, dateTimeStr.indexOf("."));
  }
}
