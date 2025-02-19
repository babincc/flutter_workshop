import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the entire range of colors and tones achievable by the Hue device
/// this class is applied to.
class LightColorGamut {
  /// Creates a [LightColorGamut] object.
  const LightColorGamut({
    required this.red,
    required this.green,
    required this.blue,
  });

  /// Creates a [LightColorGamut] object from the JSON response to a GET
  /// request.
  factory LightColorGamut.fromJson(Map<String, dynamic> dataMap) {
    return LightColorGamut(
      red: LightColorXy.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.red] ?? {})),
      green: LightColorXy.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.green] ?? {})),
      blue: LightColorXy.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.blue] ?? {})),
    );
  }

  /// Creates an empty [LightColorGamut] object.
  LightColorGamut.empty()
      : red = LightColorXy.empty(),
        green = LightColorXy.empty(),
        blue = LightColorXy.empty();

  /// CIE XY gamut position in the red color channel.
  final LightColorXy red;

  /// CIE XY gamut position in the green color channel.
  final LightColorXy green;

  /// CIE XY gamut position in the blue color channel.
  final LightColorXy blue;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate => red.hasUpdate || green.hasUpdate || blue.hasUpdate;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightColorGamut copyWith({
    LightColorXy? red,
    LightColorXy? green,
    LightColorXy? blue,
    bool copyOriginalValues = true,
  }) {
    return LightColorGamut(
      red: red ?? this.red.copyWith(copyOriginalValues: copyOriginalValues),
      green:
          green ?? this.green.copyWith(copyOriginalValues: copyOriginalValues),
      blue: blue ?? this.blue.copyWith(copyOriginalValues: copyOriginalValues),
    );
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
    return {
      ApiFields.red: red.toJson(optimizeFor: optimizeFor),
      ApiFields.green: green.toJson(optimizeFor: optimizeFor),
      ApiFields.blue: blue.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightColorGamut &&
        other.red == red &&
        other.green == green &&
        other.blue == blue;
  }

  @override
  int get hashCode => Object.hash(red, green, blue);

  @override
  String toString() => "Instance of 'LightColorGamut' ${toJson().toString()}";
}
