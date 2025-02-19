import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the color palette of a scene.
class ScenePaletteColor {
  /// Creates a [ScenePaletteColor] object.
  ScenePaletteColor({
    required this.xy,
    required this.dimming,
  })  : _originalXy = xy.copyWith(),
        _originalDimming = dimming.copyWith();

  /// Creates a [ScenePaletteColor] object from the JSON response to a GET
  /// request.
  factory ScenePaletteColor.fromJson(Map<String, dynamic> dataMap) {
    return ScenePaletteColor(
      xy: LightColorXy.fromJson(
        Map<String, dynamic>.from(
          Map<String, dynamic>.from(
                dataMap[ApiFields.color] ?? {},
              )[ApiFields.xy] ??
              {},
        ),
      ),
      dimming: LightDimming.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.dimming] ?? {})),
    );
  }

  /// Creates an empty [ScenePaletteColor] object.
  ScenePaletteColor.empty()
      : _originalXy = LightColorXy.empty(),
        xy = LightColorXy.empty(),
        _originalDimming = LightDimming.empty(),
        dimming = LightDimming.empty();

  /// CIE XY gamut position.
  LightColorXy xy;

  /// The value of [xy] when this object was instantiated.
  LightColorXy _originalXy;

  /// The dimming and brightness of the light.
  LightDimming dimming;

  /// The value of [dimming] when this object was instantiated.
  LightDimming _originalDimming;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      xy != _originalXy ||
      xy.hasUpdate ||
      dimming != _originalDimming ||
      dimming.hasUpdate;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    xy.refreshOriginals();
    _originalXy = xy.copyWith();
    dimming.refreshOriginals();
    _originalDimming = dimming.copyWith();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ScenePaletteColor copyWith({
    LightColorXy? xy,
    LightDimming? dimming,
    bool copyOriginalValues = true,
  }) {
    ScenePaletteColor toReturn = ScenePaletteColor(
      xy: copyOriginalValues
          ? _originalXy.copyWith(copyOriginalValues: copyOriginalValues)
          : (xy ?? this.xy.copyWith(copyOriginalValues: copyOriginalValues)),
      dimming: copyOriginalValues
          ? _originalDimming.copyWith(copyOriginalValues: copyOriginalValues)
          : (dimming ??
              this.dimming.copyWith(copyOriginalValues: copyOriginalValues)),
    );

    if (copyOriginalValues) {
      toReturn.xy =
          xy ?? this.xy.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.dimming = dimming ??
          this.dimming.copyWith(copyOriginalValues: copyOriginalValues);
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
        toReturn[ApiFields.color] = {
          ApiFields.xy: xy.toJson(optimizeFor: OptimizeFor.putFull)
        };
      }

      if (dimming != _originalDimming) {
        toReturn[ApiFields.dimming] =
            dimming.toJson(optimizeFor: OptimizeFor.putFull);
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.color: {ApiFields.xy: xy.toJson(optimizeFor: optimizeFor)},
      ApiFields.dimming: dimming.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ScenePaletteColor &&
        other.xy == xy &&
        other.dimming == dimming;
  }

  @override
  int get hashCode => Object.hash(xy, dimming);

  @override
  String toString() =>
      "Instance of 'ScenePaletteColor' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
