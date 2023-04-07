import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/percentage_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents the current brightness of a light.
class LightDimming {
  /// Creates a [LightDimming] object.
  LightDimming({
    required double brightness,
  })  : assert(Validators.isValidPercentage(brightness),
            "`brightness` must be between 0 - 100 (inclusive)"),
        _originalBrightness = brightness,
        _brightness = brightness;

  /// Creates a [LightDimming] object from the JSON response to a GET request.
  factory LightDimming.fromJson(Map<String, dynamic> dataMap) {
    return LightDimming(
      brightness: dataMap[ApiFields.brightness] ?? 0.0,
    );
  }

  /// Creates an empty [LightDimming] object.
  LightDimming.empty()
      : _originalBrightness = 0.0,
        _brightness = 0.0;

  double _brightness;

  /// Brightness percentage.
  ///
  /// Range: 0 - 100
  ///
  /// Value cannot be 0, writing 0 changes it to lowest possible brightness.
  ///
  /// Throws [PercentageException] if `brightness` is set to something outside
  /// of the range 0 to 100 (inclusive).
  double get brightness => _brightness;
  set brightness(double brightness) {
    if (Validators.isValidPercentage(brightness)) {
      _brightness = brightness;
    } else {
      throw PercentageException.withValue(brightness);
    }
  }

  double _originalBrightness;

  /// The value of [brightness] when this object was instantiated.
  double get originalBrightness => _originalBrightness;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalBrightness = brightness;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightDimming copyWith({
    double? brightness,
    bool copyOriginalValues = true,
  }) {
    LightDimming toReturn = LightDimming(
      brightness: copyOriginalValues
          ? originalBrightness
          : (brightness ?? this.brightness),
    );

    if (copyOriginalValues) {
      toReturn.brightness = brightness ?? this.brightness;
    }

    return toReturn;
  }

  /// Converts this object into JSON format.
  ///
  /// `optimizeFor` lets the program know what information to include in the
  /// JSON data map.
  /// * [OptimizeFor.put] (the default value) is used when making a data map
  /// that is being placed in a PUT request. This only includes data that has
  /// changed.
  /// * [OptimizeFor.putFull] is used when a parent object updates; so, all of
  /// the children are required to be present for the PUT request.
  /// * [OptimizeFor.post] is used when making a data map for a POST request.
  /// * [OptimizeFor.dontOptimize] is used to get all of the data contained in
  /// this object.
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (brightness != originalBrightness) {
        toReturn[ApiFields.brightness] = brightness;
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.brightness: brightness,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightDimming && other.brightness == brightness;
  }

  @override
  int get hashCode => brightness.hashCode;

  @override
  String toString() =>
      "Instance of 'LightDimming' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
