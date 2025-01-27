import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/invalid_value_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents the effects of a light.
class LightEffects {
  /// Creates a [LightEffects] object.
  LightEffects({
    required String effect,
    required this.effectValues,
    required this.status,
    required this.statusValues,
  })  : assert(effect.isEmpty || Validators.isValidValue(effect, effectValues),
            '`effectValues` does not contain "$effect"'),
        assert(Validators.isValidValue(status, statusValues),
            '`statusValues` does not contain "$status"'),
        _originalEffect = effect,
        _effect = effect;

  /// Creates a [LightEffects] object from the JSON response to a GET request.
  factory LightEffects.fromJson(Map<String, dynamic> dataMap) {
    return LightEffects(
      effect: dataMap[ApiFields.effect] ?? "",
      effectValues: List<String>.from(dataMap[ApiFields.effectValues] ?? []),
      status: dataMap[ApiFields.status] ?? "",
      statusValues: List<String>.from(dataMap[ApiFields.statusValues] ?? []),
    );
  }

  /// Creates an empty [LightEffects] object.
  LightEffects.empty()
      : effectValues = [],
        status = "",
        statusValues = [],
        _originalEffect = "",
        _effect = "";

  String _effect;

  /// Alert effect for the light.
  ///
  /// Throws [InvalidValueException] if `effect` is not found within
  /// [effectValues].
  String get effect => _effect;
  set effect(String effect) {
    if (effect.isEmpty || Validators.isValidValue(effect, effectValues)) {
      _effect = effect;
    } else {
      throw InvalidValueException.withValue(effect, effectValues);
    }
  }

  /// The value of [effect] when this object was instantiated.
  String _originalEffect;

  /// Possible effect values you can set in a light.
  final List<String> effectValues;

  /// Current status values the light is in regarding effects
  final String status;

  /// Possible status values in which a light could be when playing an effect.
  final List<String> statusValues;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate => effect != _originalEffect;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalEffect = effect;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ///
  /// Throws [InvalidValueException] if the [LightEffects] copy has an [effect]
  /// that is not in its [effectValues] array or if it has a [status] that is
  /// not in its [statusValues] array.
  LightEffects copyWith({
    String? effect,
    List<String>? effectValues,
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

    LightEffects toReturn = LightEffects(
      effect: copyOriginalValues ? _originalEffect : (effect ?? this.effect),
      effectValues: effectValues ?? List<String>.from(this.effectValues),
      status: status ?? this.status,
      statusValues: statusValues ?? List<String>.from(this.statusValues),
    );

    if (copyOriginalValues) {
      toReturn.effect = effect ?? this.effect;
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
      if (effect == _originalEffect) return {};

      return {
        ApiFields.effect: effect,
      };
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.effect: effect,
      };
    }

    // DEFAULT
    return {
      ApiFields.effect: effect,
      ApiFields.statusValues: statusValues,
      ApiFields.status: status,
      ApiFields.effectValues: effectValues,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightEffects &&
        other.effect == effect &&
        const DeepCollectionEquality.unordered()
            .equals(other.effectValues, effectValues) &&
        other.status == status &&
        const DeepCollectionEquality.unordered()
            .equals(other.statusValues, statusValues);
  }

  @override
  int get hashCode => Object.hash(
        effect,
        Object.hashAllUnordered(effectValues),
        status,
        Object.hashAllUnordered(statusValues),
      );

  @override
  String toString() =>
      "Instance of 'LightEffects' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
