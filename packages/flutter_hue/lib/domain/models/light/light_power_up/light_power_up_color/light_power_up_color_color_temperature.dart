import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/mirek_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents the color temperature that should be applied to the light on
/// power up.
class LightPowerUpColorColorTemperature {
  /// Creates a [LightPowerUpColorColorTemperature] object .
  LightPowerUpColorColorTemperature({required int mirek})
      : _mirek = mirek,
        assert(Validators.isValidMirek(mirek),
            "`mirek` must be between 153 and 500 (inclusive)"),
        _originalMirek = mirek;

  /// Creates a [LightPowerUpColorColorTemperature] object from the JSON
  /// response to a GET request.
  factory LightPowerUpColorColorTemperature.fromJson(
      Map<String, dynamic> dataMap) {
    return LightPowerUpColorColorTemperature(
      mirek: dataMap[ApiFields.mirek] ?? 153,
    );
  }

  /// Creates an empty [LightPowerUpColorColorTemperature] object.
  LightPowerUpColorColorTemperature.empty()
      : _mirek = 153,
        _originalMirek = 153;

  int _mirek;

  /// Color temperature in mirek or null when the light color is not in the ct
  /// spectrum.
  ///
  /// Range: 153 - 500
  ///
  /// Throws [MirekException] if `mirek` is set to something outside of the
  /// range 153 to 500 (inclusive).
  int get mirek => _mirek;
  set mirek(int mirek) {
    if (Validators.isValidMirek(mirek)) {
      _mirek = mirek;
    } else {
      throw MirekException.withValue(mirek);
    }
  }

  /// The value of [mirek] when this object was instantiated.
  int _originalMirek;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalMirek = mirek;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightPowerUpColorColorTemperature copyWith({
    int? mirek,
    bool copyOriginalValues = true,
  }) {
    LightPowerUpColorColorTemperature toReturn =
        LightPowerUpColorColorTemperature(
      mirek: copyOriginalValues ? _originalMirek : (mirek ?? this.mirek),
    );

    if (copyOriginalValues) {
      toReturn.mirek = mirek ?? this.mirek;
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
      if (mirek == _originalMirek) return {};
    }

    // DEFAULT
    return {
      ApiFields.mirek: mirek,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightPowerUpColorColorTemperature && other.mirek == mirek;
  }

  @override
  int get hashCode => mirek.hashCode;

  @override
  String toString() =>
      "Instance of 'LightPowerUpColorColorTemperature' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
