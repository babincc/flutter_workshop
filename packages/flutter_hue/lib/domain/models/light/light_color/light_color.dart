import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_gamut.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_gamut_type.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the current color and color capabilities of a Philips Hue light.
class LightColor {
  /// Creates a [LightColor] object.
  LightColor({
    required this.xy,
    required this.gamut,
    required this.gamutType,
  }) : _originalXy = xy.copyWith();

  /// Creates a [LightColor] object from the JSON response to a GET request.
  factory LightColor.fromJson(Map<String, dynamic> dataMap) {
    return LightColor(
      xy: LightColorXy.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.xy] ?? {})),
      gamut: LightColorGamut.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.gamut] ?? {})),
      gamutType:
          LightColorGamutType.fromString(dataMap[ApiFields.gamutType] ?? ""),
    );
  }

  /// Creates an empty [LightColor] object.
  LightColor.empty()
      : xy = LightColorXy.empty(),
        _originalXy = LightColorXy.empty(),
        gamut = LightColorGamut.empty(),
        gamutType = LightColorGamutType.fromString("");

  /// CIE XY gamut position.
  LightColorXy xy;

  /// The value of [xy] when this object was instantiated.
  LightColorXy _originalXy;

  /// Color gamut of color bulb.
  ///
  /// Some bulbs do not properly return the Gamut information. In this case this
  /// is not present.
  final LightColorGamut gamut;

  /// The gamut types supported by hue.
  final LightColorGamutType gamutType;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate => xy != _originalXy || xy.hasUpdate || gamut.hasUpdate;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    xy.refreshOriginals();
    _originalXy = xy.copyWith();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightColor copyWith({
    LightColorXy? xy,
    LightColorGamut? gamut,
    LightColorGamutType? gamutType,
    bool copyOriginalValues = true,
  }) {
    LightColor toReturn = LightColor(
      xy: copyOriginalValues
          ? _originalXy.copyWith(copyOriginalValues: copyOriginalValues)
          : (xy ?? this.xy.copyWith(copyOriginalValues: copyOriginalValues)),
      gamut:
          gamut ?? this.gamut.copyWith(copyOriginalValues: copyOriginalValues),
      gamutType: gamutType ?? this.gamutType,
    );

    if (copyOriginalValues) {
      toReturn.xy =
          xy ?? this.xy.copyWith(copyOriginalValues: copyOriginalValues);
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

      if (xy != _originalXy) {
        toReturn[ApiFields.xy] = xy.toJson(optimizeFor: OptimizeFor.putFull);
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.xy: xy.toJson(optimizeFor: optimizeFor),
      };
    }

    // DEFAULT
    return {
      ApiFields.xy: xy.toJson(optimizeFor: optimizeFor),
      ApiFields.gamut: gamut.toJson(optimizeFor: optimizeFor),
      ApiFields.gamutType: gamutType.value,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightColor &&
        other.xy == xy &&
        other.gamut == gamut &&
        other.gamutType == gamutType;
  }

  @override
  int get hashCode => Object.hash(xy, gamut, gamutType);

  @override
  String toString() =>
      "Instance of 'LightColor' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
