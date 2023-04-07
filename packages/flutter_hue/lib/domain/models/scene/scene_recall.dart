import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming.dart';
import 'package:flutter_hue/exceptions/negative_value_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the recall settings for a scene.
class SceneRecall {
  /// Creates a [SceneRecall] object.
  SceneRecall({
    required this.action,
    required this.status,
    required int duration,
    required this.dimming,
  })  : _originalAction = action,
        _originalStatus = status,
        _originalDuration = duration,
        _duration = duration,
        _originalDimming = dimming.copyWith();

  /// Creates a [SceneRecall] object from the JSON response to a GET request.
  factory SceneRecall.fromJson(Map<String, dynamic> dataMap) {
    return SceneRecall(
      action: dataMap[ApiFields.action] ?? "",
      status: dataMap[ApiFields.status] ?? "",
      duration: dataMap[ApiFields.duration] ?? 0,
      dimming: LightDimming.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.dimming] ?? {})),
    );
  }

  /// Creates an empty [SceneRecall] object.
  SceneRecall.empty()
      : action = "",
        status = "",
        _originalDimming = LightDimming.empty(),
        dimming = LightDimming.empty(),
        _originalAction = "",
        _originalStatus = "",
        _originalDuration = 0,
        _duration = 0;

  /// When writing active, the actions in the scene are executed on the target.
  ///
  /// one of active, dynamic_palette, static
  ///
  /// dynamic_palette starts dynamic scene with colors in the Palette object.
  String action;

  /// The value of [action] when this object was instantiated.
  String _originalAction;

  /// When writing active, the actions in the scene are executed on the target.
  ///
  /// one of active, dynamic_palette
  ///
  /// dynamic_palette starts dynamic scene with colors in the Palette object.
  String status;

  /// The value of [status] when this object was instantiated.
  String _originalStatus;

  int _duration;

  /// Transition to the scene within the time frame given by duration.
  ///
  /// Throws [NegativeValueException] if `duration` is less than 0.
  int get duration => _duration;
  set duration(int duration) {
    if (duration >= 0) {
      _duration = duration;
    } else {
      throw NegativeValueException.withValue(duration);
    }
  }

  /// The value of [duration] when this object was instantiated.
  int _originalDuration;

  /// Override the scene dimming/brightness.
  LightDimming dimming;

  /// The value of [dimming] when this object was instantiated.
  LightDimming _originalDimming;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalAction = action;
    _originalStatus = status;
    _originalDuration = duration;
    dimming.refreshOriginals();
    _originalDimming = dimming.copyWith();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  SceneRecall copyWith({
    String? action,
    String? status,
    int? duration,
    LightDimming? dimming,
    bool copyOriginalValues = true,
  }) {
    SceneRecall toReturn = SceneRecall(
      action: copyOriginalValues ? _originalAction : (action ?? this.action),
      status: copyOriginalValues ? _originalStatus : (status ?? this.status),
      duration:
          copyOriginalValues ? _originalDuration : (duration ?? this.duration),
      dimming: copyOriginalValues
          ? _originalDimming.copyWith(copyOriginalValues: copyOriginalValues)
          : (dimming ??
              this.dimming.copyWith(copyOriginalValues: copyOriginalValues)),
    );

    if (copyOriginalValues) {
      toReturn.action = action ?? this.action;
      toReturn.status = status ?? this.status;
      toReturn.duration = duration ?? this.duration;
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

      if (action != _originalAction) {
        toReturn[ApiFields.action] = action;
      }

      if (status != _originalStatus) {
        toReturn[ApiFields.status] = status;
      }

      if (duration != _originalDuration) {
        toReturn[ApiFields.duration] = duration;
      }

      if (dimming != _originalDimming) {
        toReturn[ApiFields.dimming] =
            dimming.toJson(optimizeFor: OptimizeFor.putFull);
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.action: action,
      ApiFields.status: status,
      ApiFields.duration: duration,
      ApiFields.dimming: dimming.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is SceneRecall &&
        other.action == action &&
        other.status == status &&
        other.duration == duration &&
        other.dimming == dimming;
  }

  @override
  int get hashCode => Object.hash(action, status, duration, dimming);

  @override
  String toString() =>
      "Instance of 'SceneRecall' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
