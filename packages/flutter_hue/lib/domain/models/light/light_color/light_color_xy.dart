import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/unit_interval_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents CIE XY gamut position.
class LightColorXy {
  /// Creates a [LightColorXy] object.
  LightColorXy({
    required double x,
    required double y,
  })  : assert(Validators.isUnitInterval(x),
            "`x` must be between 0 and 1 (inclusive)"),
        assert(Validators.isUnitInterval(y),
            "`y` must be between 0 and 1 (inclusive)"),
        _x = x,
        _originalX = x,
        _y = y,
        _originalY = y;

  /// Creates a [LightColorXy] object from the JSON response to a GET request.
  factory LightColorXy.fromJson(Map<String, dynamic> dataMap) {
    return LightColorXy(
      x: ((dataMap[ApiFields.x] ?? 0.0) as num).toDouble(),
      y: ((dataMap[ApiFields.y] ?? 0.0) as num).toDouble(),
    );
  }

  /// Creates an empty [LightColorXy] object.
  LightColorXy.empty()
      : _x = 0.0,
        _originalX = 0.0,
        _y = 0.0,
        _originalY = 0.0;

  double _x;

  /// X position in color gamut.
  ///
  /// Range: 0 - 1
  ///
  /// Throws [UnitIntervalException] if `x` is set to something outside of the
  /// range 0 to 1 (inclusive).
  double get x => _x;
  set x(double x) {
    if (Validators.isUnitInterval(x)) {
      _x = x;
    } else {
      throw UnitIntervalException.withValue(x);
    }
  }

  /// The value of [x] when this object was instantiated.
  double _originalX;

  double _y;

  /// Y position in color gamut.
  ///
  /// Range: 0 - 1
  ///
  /// Throws [UnitIntervalException] if `y` is set to something outside of the
  /// range 0 to 1 (inclusive).
  double get y => _y;
  set y(double y) {
    if (Validators.isUnitInterval(y)) {
      _y = y;
    } else {
      throw UnitIntervalException.withValue(y);
    }
  }

  /// The value of [y] when this object was instantiated.
  double _originalY;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate => x != _originalX || y != _originalY;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalX = x;
    _originalY = y;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightColorXy copyWith({
    double? x,
    double? y,
    bool copyOriginalValues = true,
  }) {
    LightColorXy toReturn = LightColorXy(
      x: copyOriginalValues ? _originalX : (x ?? this.x),
      y: copyOriginalValues ? _originalY : (y ?? this.y),
    );

    if (copyOriginalValues) {
      toReturn.x = x ?? this.x;
      toReturn.y = y ?? this.y;
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

      if (x != _originalX) {
        toReturn[ApiFields.x] = x;
      }

      if (y != _originalY) {
        toReturn[ApiFields.y] = y;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.x: x,
        ApiFields.y: y,
      };
    }

    // DEFAULT
    return {
      ApiFields.x: x,
      ApiFields.y: y,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightColorXy && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() =>
      "Instance of 'LightColorXy' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
