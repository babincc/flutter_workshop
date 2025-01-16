import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/exceptions/gradient_exception.dart';
import 'package:flutter_hue/exceptions/invalid_value_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents the current gradient of a light.
class LightGradient {
  /// Creates a [LightGradient] object.
  LightGradient({
    required List<LightColorXy> points,
    required String mode,
    required this.modeValues,
  })  : assert(points.length <= 5, "`points` must have 5 or fewer elements"),
        _originalPoints = points.map((point) => point.copyWith()).toList(),
        _points = points,
        _originalMode = mode,
        _mode = mode;

  /// Creates a [LightGradient] object from the JSON response to a GET request.
  factory LightGradient.fromJson(Map<String, dynamic> dataMap) {
    // Extract the points from the data map.
    List<LightColorXy> points = List<LightColorXy>.from(
      dataMap[ApiFields.points]?.map((point) => LightColorXy.fromJson(point)) ??
          [],
    );

    return LightGradient(
      points: points,
      mode: dataMap[ApiFields.mode] ?? "",
      modeValues: List<String>.from(dataMap[ApiFields.modeValues] ?? []),
    );
  }

  /// Creates an empty [LightGradient] object.
  LightGradient.empty()
      : modeValues = [],
        _points = [],
        _originalPoints = [],
        _originalMode = "",
        _mode = "";

  List<LightColorXy> _points;

  /// Collection of gradients points.
  ///
  /// For control of the gradient points through a PUT a minimum of 2 points and
  /// a maximum of 5 need to be provided.
  List<LightColorXy> get points =>
      List<LightColorXy>.from(_points, growable: false);
  set points(List<LightColorXy> points) {
    if (points.length < 5) {
      _points = points;
    } else {
      // This was removed because some lights don't follow this rule even though
      // the Hue API says they should.
      // throw Exception("`points` must have 5 or fewer elements");
    }
  }

  /// Adds a `point` to the [points] array.
  ///
  /// Returns `true` if the point was added to the array. If the array
  /// is full, the point is not added, and `false` is returned.
  bool addPoint(LightColorXy point) {
    if (_points.length < 5) {
      _points.add(point);
      return true;
    }

    return false;
  }

  /// Removes a `point` from the [points] array.
  ///
  /// Returns `true` if `point` was in the list, `false` otherwise.
  bool removePoint(LightColorXy point) => _points.remove(point);

  List<LightColorXy> _originalPoints;

  /// The value of [points] when this object was instantiated.
  List<LightColorXy> get originalPoints => _originalPoints;

  /// Mode in which the points are currently being deployed.
  ///
  /// If not provided during PUT/POST it will be defaulted to
  /// interpolated_palette
  String _mode;

  /// Mode in which the points are currently being deployed.
  ///
  /// If not provided during PUT/POST it will be defaulted to
  /// interpolated_palette
  ///
  /// Throws [InvalidValueException] if [modeValues] does not contain `mode`.
  String get mode => _mode;
  set mode(String mode) {
    if (Validators.isValidValue(mode, modeValues)) {
      _mode = mode;
    } else {
      throw InvalidValueException.withValue(mode, modeValues);
    }
  }

  String _originalMode;

  /// The value of [mode] when this object was instantiated.
  String get originalMode => _originalMode;

  /// Modes a gradient device can deploy the gradient palette of colors.
  final List<String> modeValues;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalPoints = points.map((point) {
      point.refreshOriginals();
      return point.copyWith();
    }).toList();
    _originalMode = mode;
  }

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
  LightGradient copyWith({
    List<LightColorXy>? points,
    String? mode,
    List<String>? modeValues,
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

    LightGradient toReturn = LightGradient(
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
  ///
  /// Throws [GradientException] if [points] has is not in the proper range. It
  /// must either have 0 elements or between 2 and 5 (inclusive), and
  /// `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  ///
  /// Throws [InvalidValueException] if [mode] is empty and `optimizeFor` is not
  /// set to [OptimizeFor.dontOptimize].
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // Make sure data is valid.
    if (!identical(optimizeFor, OptimizeFor.dontOptimize)) {
      // Validate [points].
      if (!Validators.isValidGradient(points)) {
        throw GradientException.withValue(points.length);
      }

      // Validate [mode].
      if (!Validators.isValidValue(mode, modeValues)) {
        if (!identical(optimizeFor, OptimizeFor.put) || mode != originalMode) {
          throw InvalidValueException.withValue(mode, modeValues);
        }
      }
    }

    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (!const DeepCollectionEquality.unordered()
          .equals(points, originalPoints)) {
        toReturn[ApiFields.points] = points
            .map((point) => {
                  ApiFields.color: {
                    ApiFields.xy: point.toJson(optimizeFor: OptimizeFor.putFull)
                  }
                })
            .toList();
      }

      if (mode != originalMode) {
        toReturn[ApiFields.mode] = mode;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.points: points
            .map((point) => {
                  ApiFields.color: {
                    ApiFields.xy: point.toJson(optimizeFor: OptimizeFor.putFull)
                  }
                })
            .toList(),
        ApiFields.mode: mode,
      };
    }

    // DEFAULT
    return {
      ApiFields.points: points
          .map(
            (point) => {
              ApiFields.color: {
                ApiFields.xy: point.toJson(
                  optimizeFor: identical(optimizeFor, OptimizeFor.dontOptimize)
                      ? optimizeFor
                      : OptimizeFor.putFull,
                )
              }
            },
          )
          .toList(),
      ApiFields.mode: mode,
      ApiFields.modeValues: modeValues,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightGradient &&
        const DeepCollectionEquality.unordered().equals(other.points, points) &&
        other.mode == mode &&
        const DeepCollectionEquality.unordered()
            .equals(other.modeValues, modeValues);
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(points),
        mode,
        Object.hashAllUnordered(modeValues),
      );

  @override
  String toString() =>
      "Instance of 'LightGradient' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
