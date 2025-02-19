import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the on/off state of the light.
class LightOn {
  /// Creates a [LightOn] object.
  LightOn({required this.isOn}) : _originalIsOn = isOn;

  /// Creates a [LightOn] object from the JSON response to a GET request.
  factory LightOn.fromJson(Map<String, dynamic> dataMap) {
    return LightOn(
      isOn: dataMap[ApiFields.isOn] ?? false,
    );
  }

  /// Creates an empty [LightOn] object.
  LightOn.empty()
      : isOn = false,
        _originalIsOn = false;

  /// Whether or not the light is on.
  bool isOn;

  /// The value of [isOn] when this object was instantiated.
  bool _originalIsOn;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate => isOn != _originalIsOn;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalIsOn = isOn;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightOn copyWith({
    bool? isOn,
    bool copyOriginalValues = true,
  }) {
    LightOn toReturn = LightOn(
      isOn: copyOriginalValues ? _originalIsOn : (isOn ?? this.isOn),
    );

    if (copyOriginalValues) {
      toReturn.isOn = isOn ?? this.isOn;
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

      if (isOn != _originalIsOn) {
        toReturn[ApiFields.isOn] = isOn;
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.isOn: isOn,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightOn && other.isOn == isOn;
  }

  @override
  int get hashCode => isOn.hashCode;

  @override
  String toString() =>
      "Instance of 'LightOn' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
