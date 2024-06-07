import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';

/// Used throughout the app to validate data.
class Validators {
  /// Returns `true` if the given `num` is between 0 and 1 (inclusive).
  static bool isUnitInterval(num num) => num >= 0 && num <= 1;

  /// Used when finalizing a gradient to send with PUT or POST.
  ///
  /// For a less strict test, used to validate a gradient while still working
  /// with it, see [isValidGradientDraft].
  ///
  /// Returns `true` if:
  /// * `points` is `null`
  /// * `points` is empty
  /// * `points` has 2 to 5 (inclusive) elements
  static bool isValidGradient(List<LightColorXy>? points) =>
      points == null ||
      points.isEmpty ||
      (points.length >= 2 && points.length <= 5);

  /// Used to verify that the gradient is valid to be used as a draft.
  ///
  /// This test just makes sure the gradient doesn't get too many elements. It
  /// it not a strict enough test to make sure the gradient is valid for a PUT
  /// or POST request. For that, see [isValidGradient].
  ///
  /// Returns `true` if:
  /// * `points` is `null`
  /// * `points` has 0 to 5 (inclusive) elements
  static bool isValidGradientDraft(List<LightColorXy>? points) =>
      points == null || points.length <= 5;

  /// Returns `true` if the given `id` conforms to the proper regex pattern.
  ///
  /// Regex pattern `^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$`
  static bool isValidId(String id) =>
      RegExp(r"^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$").hasMatch(id);

  /// Returns `true` if the given `idV1` conforms to the proper regex pattern or
  /// if it is empty.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  static bool isValidIdV1(String idV1) =>
      idV1.isEmpty ||
      RegExp(r"^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$").hasMatch(idV1);

  /// Returns `true` if the given `ipAddress` conforms to the proper regex
  /// pattern.
  ///
  /// Regex pattern `^(?:\d{1,3}\.){3}\d{1,3}$`
  static bool isValidIpAddress(String ipAddress) =>
      RegExp(r"^(?:\d{1,3}\.){3}\d{1,3}$").hasMatch(ipAddress);

  /// Returns `true` if the given `latitude` is between -90 and 90 (inclusive).
  static bool isValidLatitude(double latitude) =>
      latitude >= -90.0 && latitude <= 90.0;

  /// Returns `true` if the given `longitude` is between -180 and 180
  /// (inclusive).
  static bool isValidLongitude(double longitude) =>
      longitude >= -180.0 && longitude <= 180.0;

  /// Returns `true` if the given `macAddress` conforms to the proper regex
  /// pattern.
  ///
  /// Regex pattern `^([0-9A-Fa-f]{2}:){5,7}([0-9A-Fa-f]{2})$`
  static bool isValidMacAddress(String macAddress) =>
      RegExp(r"^([0-9A-Fa-f]{2}:){5,7}([0-9A-Fa-f]{2})$").hasMatch(macAddress);

  /// Returns `true` if the given `mired` is between 153 and 500 (inclusive).
  ///
  /// "Mired" is the common name for the scientific name "Mirek".
  static bool isValidMired(int mired) => isValidMirek(mired);

  /// Returns `true` if the given `mirek` is between 153 and 500 (inclusive).
  static bool isValidMirek(int mirek) => mirek >= 153 && mirek <= 500;

  /// Returns `true` if the length of `name` is between 1 and 32 characters
  /// (inclusive).
  static bool isValidName(String name) => name.isNotEmpty && name.length <= 32;

  /// Returns `true` if the given `percentage` is between 0 and 100 (inclusive).
  static bool isValidPercentage(num percentage) =>
      percentage >= 0 && percentage <= 100;

  /// Returns `true` if the given `scriptId` conforms to the proper regex
  /// pattern.
  ///
  /// Regex pattern `^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$`
  static bool isValidScriptId(String scriptId) =>
      RegExp(r"^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$").hasMatch(scriptId);

  /// Returns `true` if the given `scriptVersion` conforms to the proper regex
  /// pattern.
  ///
  /// Regex pattern `^(?!^\.)[0-9]{0,3}([.][0-9]{1,3}){1,2}$`
  static bool isValidScriptVersion(String scriptVersion) =>
      RegExp(r"^(?!^\.)[0-9]{0,3}([.][0-9]{1,3}){1,2}$")
          .hasMatch(scriptVersion);

  /// Returns `true` if the given `softwareVersion` conforms to the proper regex
  /// pattern.
  ///
  /// Regex pattern `^\d+\.\d+\.\d+$`
  static bool isValidSoftwareVersion(String softwareVersion) =>
      RegExp(r"^\d+\.\d+\.\d+$").hasMatch(softwareVersion);

  /// Returns `true` if the the given `value` is found within `validValues` or
  /// if the `validValues` list is empty and `value` is empty as well.
  static bool isValidValue<T>(T value, List<T> validValues) {
    if (value == null) return false;

    // Let empty values pass.
    if (value is String) {
      if (value.isEmpty) return true;
    } else if (value is Iterable) {
      if (value.isEmpty) return true;
    }

    return validValues.contains(value);
  }
}
