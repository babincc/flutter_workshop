import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming.dart';
import 'package:flutter_hue/domain/models/scene/scene_palette/scene_palette_color.dart';
import 'package:flutter_hue/domain/models/scene/scene_palette/scene_palette_color_temperature.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the palette in a scene.
class ScenePalette {
  /// Creates a [ScenePalette] object.
  ScenePalette({
    required this.colors,
    required this.dimmings,
    required this.colorTemperatures,
  })  : _originalColors = colors.map((color) => color.copyWith()).toList(),
        _originalDimmings = dimmings.map((d) => d.copyWith()).toList(),
        _originalColorTemperatures =
            colorTemperatures.map((ct) => ct.copyWith()).toList();

  /// Creates a [ScenePalette] object from the JSON response to a GET request.
  factory ScenePalette.fromJson(Map<String, dynamic> dataMap) {
    return ScenePalette(
      colors: (dataMap[ApiFields.color] as List<dynamic>?)
              ?.map((color) => ScenePaletteColor.fromJson(color))
              .toList() ??
          [],
      dimmings: (dataMap[ApiFields.dimming] as List<dynamic>?)
              ?.map((d) => LightDimming.fromJson(d))
              .toList() ??
          [],
      colorTemperatures: (dataMap[ApiFields.colorTemperature] as List<dynamic>?)
              ?.map((ct) => ScenePaletteColorTemperature.fromJson(ct))
              .toList() ??
          [],
    );
  }

  /// Creates an empty [ScenePalette] object.
  ScenePalette.empty()
      : _originalColors = [],
        colors = [],
        _originalDimmings = [],
        dimmings = [],
        _originalColorTemperatures = [],
        colorTemperatures = [];

  /// The list of colors in this color palette.
  List<ScenePaletteColor> colors;

  /// The value of [colors] when this object was instantiated.
  List<ScenePaletteColor> _originalColors;

  /// The list of dimming and brightness settings for this palette.
  List<LightDimming> dimmings;

  List<LightDimming> _originalDimmings;

  /// The list of color temperature settings for this palette.
  List<ScenePaletteColorTemperature> colorTemperatures;

  List<ScenePaletteColorTemperature> _originalColorTemperatures;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      !(const DeepCollectionEquality.unordered()
          .equals(colors, _originalColors)) ||
      colors.any((color) => color.hasUpdate) ||
      !(const DeepCollectionEquality.unordered()
          .equals(dimmings, _originalDimmings)) ||
      dimmings.any((dimming) => dimming.hasUpdate) ||
      !(const DeepCollectionEquality.unordered()
          .equals(colorTemperatures, _originalColorTemperatures)) ||
      colorTemperatures.any((colorTemp) => colorTemp.hasUpdate);

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalColors = colors.map((color) {
      color.refreshOriginals();
      return color.copyWith();
    }).toList();
    _originalDimmings = dimmings.map((d) {
      d.refreshOriginals();
      return d.copyWith();
    }).toList();
    _originalColorTemperatures = colorTemperatures.map((ct) {
      ct.refreshOriginals();
      return ct.copyWith();
    }).toList();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ScenePalette copyWith({
    List<ScenePaletteColor>? colors,
    List<LightDimming>? dimmings,
    List<ScenePaletteColorTemperature>? colorTemperatures,
    bool copyOriginalValues = true,
  }) {
    ScenePalette toReturn = ScenePalette(
      colors: copyOriginalValues
          ? _originalColors
              .map((color) =>
                  color.copyWith(copyOriginalValues: copyOriginalValues))
              .toList()
          : (colors ??
              this
                  .colors
                  .map((color) =>
                      color.copyWith(copyOriginalValues: copyOriginalValues))
                  .toList()),
      dimmings: copyOriginalValues
          ? _originalDimmings
              .map((d) => d.copyWith(copyOriginalValues: copyOriginalValues))
              .toList()
          : (dimmings ??
              this
                  .dimmings
                  .map(
                      (d) => d.copyWith(copyOriginalValues: copyOriginalValues))
                  .toList()),
      colorTemperatures: copyOriginalValues
          ? _originalColorTemperatures
              .map((ct) => ct.copyWith(copyOriginalValues: copyOriginalValues))
              .toList()
          : (colorTemperatures ??
              this
                  .colorTemperatures
                  .map((ct) =>
                      ct.copyWith(copyOriginalValues: copyOriginalValues))
                  .toList()),
    );

    if (copyOriginalValues) {
      toReturn.colors = colors ??
          this
              .colors
              .map((color) =>
                  color.copyWith(copyOriginalValues: copyOriginalValues))
              .toList();
      toReturn.dimmings = dimmings ??
          this
              .dimmings
              .map((d) => d.copyWith(copyOriginalValues: copyOriginalValues))
              .toList();
      toReturn.colorTemperatures = colorTemperatures ??
          this
              .colorTemperatures
              .map((ct) => ct.copyWith(copyOriginalValues: copyOriginalValues))
              .toList();
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

      if (!const DeepCollectionEquality.unordered()
          .equals(colors, _originalColors)) {
        toReturn[ApiFields.color] = colors
            .map((color) => color.toJson(optimizeFor: OptimizeFor.putFull))
            .toList();
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(dimmings, _originalDimmings)) {
        toReturn[ApiFields.dimming] = dimmings
            .map((d) => d.toJson(optimizeFor: OptimizeFor.putFull))
            .toList();
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(colorTemperatures, _originalColorTemperatures)) {
        toReturn[ApiFields.colorTemperature] = colorTemperatures
            .map((ct) => ct.toJson(optimizeFor: OptimizeFor.putFull))
            .toList();
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.color: colors
          .map((color) => color.toJson(
              optimizeFor: identical(optimizeFor, OptimizeFor.dontOptimize)
                  ? optimizeFor
                  : OptimizeFor.putFull))
          .toList(),
      ApiFields.dimming: dimmings
          .map((d) => d.toJson(
              optimizeFor: identical(optimizeFor, OptimizeFor.dontOptimize)
                  ? optimizeFor
                  : OptimizeFor.putFull))
          .toList(),
      ApiFields.colorTemperature: colorTemperatures
          .map((ct) => ct.toJson(
              optimizeFor: identical(optimizeFor, OptimizeFor.dontOptimize)
                  ? optimizeFor
                  : OptimizeFor.putFull))
          .toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ScenePalette &&
        const DeepCollectionEquality.unordered().equals(other.colors, colors) &&
        const DeepCollectionEquality.unordered()
            .equals(other.dimmings, dimmings) &&
        const DeepCollectionEquality.unordered()
            .equals(other.colorTemperatures, colorTemperatures);
  }

  @override
  int get hashCode => Object.hash(
        const DeepCollectionEquality.unordered().hash(colors),
        const DeepCollectionEquality.unordered().hash(dimmings),
        const DeepCollectionEquality.unordered().hash(colorTemperatures),
      );

  @override
  String toString() =>
      "Instance of 'ScenePalette' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
