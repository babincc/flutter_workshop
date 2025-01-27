import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/invalid_value_exception.dart';
import 'package:flutter_hue/exceptions/negative_value_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents the timed effects of a light.
class LightTimedEffects {
  /// Creates a [LightTimedEffects] object.
  LightTimedEffects({
    required String effect,
    required this.effectValues,
    required int duration,
    required this.status,
    required this.statusValues,
  })  : assert(duration >= 0, "`duration` must be greater than 0"),
        _originalEffect = effect,
        _effect = effect,
        _originalDuration = duration,
        _duration = duration;

  /// Creates a [LightTimedEffects] object from the JSON response to a GET
  /// request.
  factory LightTimedEffects.fromJson(Map<String, dynamic> dataMap) {
    return LightTimedEffects(
      effect: dataMap[ApiFields.effect] ?? "",
      effectValues: List<String>.from(dataMap[ApiFields.effectValues] ?? []),
      duration: dataMap[ApiFields.duration] ?? 0,
      status: dataMap[ApiFields.status] ?? "",
      statusValues: List<String>.from(dataMap[ApiFields.statusValues] ?? []),
    );
  }

  /// Creates an empty [LightTimedEffects] object.
  LightTimedEffects.empty()
      : effectValues = [],
        statusValues = [],
        _originalEffect = "",
        _effect = "",
        _originalDuration = 0,
        _duration = 0,
        status = "";

  String _effect;

  /// Alert effect for the light.
  ///
  /// Throws [InvalidValueException] if `effect` is not found within
  /// [effectValues].
  String get effect => _effect;
  set effect(String effect) {
    if (Validators.isValidValue(effect, effectValues)) {
      _effect = effect;
    } else {
      throw InvalidValueException.withValue(effect, effectValues);
    }
  }

  /// The value of [effect] when this object was instantiated.
  String _originalEffect;

  /// Possible timed effect values you can set in a light.
  final List<String> effectValues;

  int _duration;

  /// Duration is mandatory when timed effect is set except for noEffect.
  ///
  /// Resolution decreases for a larger duration. e.g Effects with duration
  /// smaller than a minute will be rounded to a resolution of 1s, while effects
  /// with duration larger than an hour will be rounded up to a resolution of
  /// 300s. Duration has a max of 21600000 ms.
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

  /// Current status values the light is in regarding timed effects.
  final String status;

  /// Possible status values in which a light could be when playing a timed effect.
  final List<String> statusValues;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      effect != _originalEffect || duration != _originalDuration;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalEffect = effect;
    _originalDuration = duration;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ///
  /// Throws [InvalidValueException] if the [LightTimedEffects] copy has an
  /// [effect] that is not in its [effectValues] array or if it has a [status]
  /// that is not in its [statusValues] array.
  LightTimedEffects copyWith({
    String? effect,
    List<String>? effectValues,
    int? duration,
    String? status,
    List<String>? statusValues,
    bool copyOriginalValues = true,
  }) {
    // Make sure [effect] is valid.
    if (effectValues != null &&
        effect == null &&
        !Validators.isValidValue(this.effect, effectValues)) {
      throw InvalidValueException.withValue(this.effect, effectValues);
    }

    // Make sure [status] is valid.
    if (statusValues != null &&
        status == null &&
        !Validators.isValidValue(this.status, statusValues)) {
      throw InvalidValueException.withValue(this.status, statusValues);
    }

    LightTimedEffects toReturn = LightTimedEffects(
      effect: copyOriginalValues ? _originalEffect : (effect ?? this.effect),
      effectValues: effectValues ?? List<String>.from(this.effectValues),
      duration:
          copyOriginalValues ? _originalDuration : (duration ?? this.duration),
      status: status ?? this.status,
      statusValues: statusValues ?? List<String>.from(this.statusValues),
    );

    if (copyOriginalValues) {
      toReturn.effect = effect ?? this.effect;
      toReturn.duration = duration ?? this.duration;
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
  /// Throws [InvalidValueException] if [effect] is empty and `optimizeFor` is
  /// not set to [OptimizeFor.dontOptimize].
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // Validate [effect].
    if (!identical(optimizeFor, OptimizeFor.dontOptimize)) {
      if (!Validators.isValidValue(effect, effectValues)) {
        if (!identical(optimizeFor, OptimizeFor.put) ||
            effect != _originalEffect) {
          throw InvalidValueException.withValue(effect, effectValues);
        }
      }
    }

    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (effect != _originalEffect) {
        toReturn[ApiFields.effect] = effect;
      }

      if (duration != _originalDuration) {
        toReturn[ApiFields.duration] = duration;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.effect: effect,
        ApiFields.duration: duration,
      };
    }

    // DEFAULT
    return {
      ApiFields.effect: effect,
      ApiFields.duration: duration,
      ApiFields.statusValues: statusValues,
      ApiFields.status: status,
      ApiFields.effectValues: effectValues,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightTimedEffects &&
        other.effect == effect &&
        const DeepCollectionEquality.unordered()
            .equals(other.effectValues, effectValues) &&
        other.duration == duration &&
        other.status == status &&
        const DeepCollectionEquality.unordered()
            .equals(other.statusValues, statusValues);
  }

  @override
  int get hashCode => Object.hash(
        effect,
        Object.hashAllUnordered(effectValues),
        duration,
        status,
        Object.hashAllUnordered(statusValues),
      );

  @override
  String toString() =>
      "Instance of 'LightTimedEffects' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
