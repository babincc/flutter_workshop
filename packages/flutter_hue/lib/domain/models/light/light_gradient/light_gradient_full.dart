import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/domain/models/light/light_gradient/light_gradient.dart';
import 'package:flutter_hue/exceptions/gradient_exception.dart';
import 'package:flutter_hue/exceptions/invalid_value_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents the current gradient and gradient capabilities of a light.
class LightGradientFull extends LightGradient {
  /// Creates a [LightGradientFull] object.
  LightGradientFull({
    required super.points,
    required super.mode,
    required super.modeValues,
    required this.pointsCapable,
    required this.pixelCount,
  });

  /// Creates a [LightGradientFull] object from the JSON response to a GET
  /// request.
  factory LightGradientFull.fromJson(Map<String, dynamic> dataMap) {
    // Extract the points from the data map.
    List<LightColorXy> points = List<LightColorXy>.from(
      dataMap[ApiFields.points]
              ?.map((bridge) => LightColorXy.fromJson(bridge)) ??
          [],
    );

    return LightGradientFull(
      points: points,
      mode: dataMap[ApiFields.mode] ?? "",
      modeValues: List<String>.from(dataMap[ApiFields.modeValues] ?? []),
      pointsCapable: dataMap[ApiFields.pointsCapable] ?? 0,
      pixelCount: dataMap[ApiFields.pixelCount] ?? 0,
    );
  }

  /// Creates an empty [LightGradientFull] object.
  LightGradientFull.empty()
      : pointsCapable = 0,
        pixelCount = 0,
        super.empty();

  /// Number of color points that gradient lamp is capable of showing with
  /// gradients.
  final int pointsCapable;

  /// Number of pixels in the device.
  final int pixelCount;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ///
  /// Throws [GradientException] if `points` has more than 5 elements.
  ///
  /// Throws [InvalidValueException] if the [LightGradient] copy has a [mode]
  /// that is not in its [modeValues] array.
  @override
  LightGradientFull copyWith({
    List<LightColorXy>? points,
    String? mode,
    List<String>? modeValues,
    int? pointsCapable,
    int? pixelCount,
    bool copyOriginalValues = true,
  }) {
    // Make sure the gradient is valid.
    if (!Validators.isValidGradientDraft(points)) {
      throw GradientException.withValue(points?.length ?? -1);
    }

    // Make sure the mode is valid.
    if (modeValues != null &&
        mode == null &&
        !Validators.isValidValue(this.mode, modeValues)) {
      throw InvalidValueException.withValue(this.mode, modeValues);
    }

    LightGradientFull toReturn = LightGradientFull(
      points: copyOriginalValues
          ? originalPoints
              .map((point) =>
                  point.copyWith(copyOriginalValues: copyOriginalValues))
              .toList()
          : (points ??
              this
                  .points
                  .map((point) =>
                      point.copyWith(copyOriginalValues: copyOriginalValues))
                  .toList()),
      mode: copyOriginalValues ? originalMode : (mode ?? this.mode),
      modeValues: modeValues ?? List<String>.from(this.modeValues),
      pointsCapable: pointsCapable ?? this.pointsCapable,
      pixelCount: pixelCount ?? this.pixelCount,
    );

    if (copyOriginalValues) {
      toReturn.points = points ??
          this
              .points
              .map((point) =>
                  point.copyWith(copyOriginalValues: copyOriginalValues))
              .toList();

      toReturn.mode = mode ?? this.mode;
    }

    return toReturn;
  }

  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // Super JSON
    Map<String, dynamic> superJson = super.toJson(optimizeFor: optimizeFor);

    // PUT & PUT FULL
    if (identical(optimizeFor, OptimizeFor.put) ||
        identical(optimizeFor, OptimizeFor.putFull)) {
      return superJson;
    }

    // DEFAULT
    return {
      ...superJson,
      ...{
        ApiFields.pointsCapable: pointsCapable,
        ApiFields.modeValues: modeValues,
        ApiFields.pixelCount: pixelCount,
      },
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightGradientFull &&
        const DeepCollectionEquality.unordered().equals(other.points, points) &&
        other.mode == mode &&
        const DeepCollectionEquality.unordered()
            .equals(other.modeValues, modeValues) &&
        other.pointsCapable == pointsCapable &&
        other.pixelCount == pixelCount;
  }

  @override
  int get hashCode => Object.hash(
        const DeepCollectionEquality.unordered().hash(points),
        mode,
        const DeepCollectionEquality.unordered().hash(modeValues),
        pointsCapable,
        pixelCount,
      );

  @override
  String toString() =>
      "Instance of 'LightGradientFull' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
