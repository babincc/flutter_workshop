import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature_mirek_schema.dart';
import 'package:flutter_hue/exceptions/mirek_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents the current color temperature and the color temperature
/// capabilities of a light.
class LightColorTemperature {
  /// Creates a [LightColorTemperature] object.
  LightColorTemperature({
    required int? mirek,
    required this.mirekValid,
    required this.mirekSchema,
  })  : assert(isValidMirek(mirek),
            "`mirek` must be between 153 and 500 (inclusive)"),
        _originalMirek = mirek,
        _mirek = mirek;

  /// Creates a [LightColorTemperature] object from the JSON response to a GET
  /// request.
  factory LightColorTemperature.fromJson(Map<String, dynamic> dataMap) {
    return LightColorTemperature(
      mirek: dataMap[ApiFields.mirek],
      mirekValid: dataMap[ApiFields.mirekValid] ?? false,
      mirekSchema: LightColorTemperatureMirekSchema.fromJson(
          dataMap[ApiFields.mirekSchema] ?? {}),
    );
  }

  /// Creates an empty [LightColorTemperature] object.
  LightColorTemperature.empty()
      : _mirek = null,
        mirekValid = false,
        mirekSchema = const LightColorTemperatureMirekSchema.empty(),
        _originalMirek = null;

  int? _mirek;

  /// Color temperature in mirek or null when the light color is not in the ct
  /// spectrum.
  ///
  /// Range: 153 - 500
  ///
  /// Throws [MirekException] if `mirek` is set to something outside of the
  /// range 153 to 500 (inclusive).
  int? get mirek => _mirek;
  set mirek(int? mirek) {
    if (isValidMirek(mirek)) {
      _mirek = mirek;
    } else {
      throw MirekException.withValue(mirek);
    }
  }

  /// The value of [mirek] when this object was instantiated.
  int? _originalMirek;

  /// Whether or not the value presented in [_mirek] is valid.
  final bool mirekValid;

  /// The color temperature range for the light.
  final LightColorTemperatureMirekSchema mirekSchema;

  /// Returns `true` if `mirek` is `null` or if it is in the valid range.
  ///
  /// Valid range is between 153 - 500 (inclusive).
  static bool isValidMirek(int? mirek) {
    if (mirek == null) return true;

    return Validators.isValidMirek(mirek);
  }

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate => mirek != _originalMirek;

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
  /// Since [mirek] is nullable, it is defaulted to a negative number in this
  /// method. If left as a negative number, its current value in this
  /// [LightColorTemperature] object will be used. This way, if it is `null`,
  /// the program will know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightColorTemperature copyWith({
    int? mirek = -1,
    bool? mirekValid,
    LightColorTemperatureMirekSchema? mirekSchema,
    bool copyOriginalValues = true,
  }) {
    LightColorTemperature toReturn = LightColorTemperature(
      mirek: copyOriginalValues
          ? _originalMirek
          : (mirek == null || mirek >= 0 ? mirek : this.mirek),
      mirekValid: mirekValid ?? this.mirekValid,
      mirekSchema: mirekSchema ?? this.mirekSchema.copyWith(),
    );

    if (copyOriginalValues) {
      toReturn.mirek = mirek == null || mirek >= 0 ? mirek : this.mirek;
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

      if (mirek != _originalMirek) {
        toReturn[ApiFields.mirek] = mirek;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.mirek: mirek,
      };
    }

    // DEFAULT
    return {
      ApiFields.mirek: mirek,
      ApiFields.mirekValid: mirekValid,
      ApiFields.mirekSchema: mirekSchema.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightColorTemperature &&
        ((other.mirek == null && mirek == null) ||
            ((other.mirek != null && mirek != null) &&
                (other.mirek == mirek))) &&
        other.mirekValid == mirekValid &&
        other.mirekSchema == mirekSchema;
  }

  @override
  int get hashCode => Object.hash(mirek, mirekValid, mirekSchema);

  @override
  String toString() =>
      "Instance of 'LightColorTemperature' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
