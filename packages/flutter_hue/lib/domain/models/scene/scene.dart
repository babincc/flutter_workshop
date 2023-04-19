// ignore_for_file: deprecated_member_use_from_same_package

import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/scene/scene_action/scene_action.dart';
import 'package:flutter_hue/domain/models/scene/scene_metadata.dart';
import 'package:flutter_hue/domain/models/scene/scene_palette/scene_palette.dart';
import 'package:flutter_hue/domain/models/scene/scene_recall.dart';
import 'package:flutter_hue/exceptions/unit_interval_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a Philips Hue scene.
class Scene extends Resource {
  /// Creates a [Scene] object.
  Scene({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.actions,
    required this.recall,
    required this.metadata,
    required this.group,
    required this.palette,
    required double speed,
    required this.autoDynamic,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        assert(Validators.isUnitInterval(speed),
            "`speed` must be between 0 and 1 (inclusive) "),
        _originalActions = actions.map((action) => action.copyWith()).toList(),
        _originalRecall = recall.copyWith(),
        _originalMetadata = metadata.copyWith(),
        _originalSpeed = speed,
        _originalPalette = palette.copyWith(),
        _speed = speed,
        _originalAutoDynamic = autoDynamic;

  /// Creates a [Scene] object from the JSON response to a GET request.
  factory Scene.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return Scene(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      actions: List<SceneAction>.from(
          List<Map<String, dynamic>>.from(data[ApiFields.actions] ?? {})
              .map((actionJson) => SceneAction.fromJson(actionJson))
              .toList()),
      recall: SceneRecall.fromJson(
          Map<String, dynamic>.from(data[ApiFields.recall] ?? {})),
      metadata: SceneMetadata.fromJson(
          Map<String, dynamic>.from(data[ApiFields.metadata] ?? {})),
      group: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.group] ?? {})),
      palette: ScenePalette.fromJson(
          Map<String, dynamic>.from(data[ApiFields.palette] ?? {})),
      speed: ((data[ApiFields.speed] ?? 0.0) as num).toDouble(),
      autoDynamic: data[ApiFields.autoDynamic] ?? false,
    );
  }

  /// Creates an empty [Scene] object.
  Scene.empty()
      : idV1 = "",
        actions = [],
        recall = SceneRecall.empty(),
        metadata = SceneMetadata.empty(),
        group = Relative.empty(),
        palette = ScenePalette.empty(),
        autoDynamic = false,
        _originalActions = [],
        _originalRecall = SceneRecall.empty(),
        _originalMetadata = SceneMetadata.empty(),
        _originalSpeed = 0.0,
        _originalPalette = ScenePalette.empty(),
        _speed = 0.0,
        _originalAutoDynamic = false,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// List of actions to be executed synchronously on recall.
  List<SceneAction> actions;

  /// The value of [actions] when this object was instantiated.
  List<SceneAction> _originalActions;

  /// Returns a list of the action targets as [Resource] objects.
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if a
  /// target can not be found on the [hueNetwork], or if the target's
  /// [ResourceType] cannot be found on the [hueNetwork].
  List<Resource> get targetsAsResources {
    List<Relative> targets = actions.map((action) => action.target).toList();

    return getRelativesAsResources(targets);
  }

  /// The recall settings for a scene.
  SceneRecall recall;

  /// The value of [recall] when this object was instantiated.
  SceneRecall _originalRecall;

  /// Metadata about this scene.
  SceneMetadata metadata;

  /// The value of [metadata] when this object was instantiated.
  SceneMetadata _originalMetadata;

  /// Returns a [Resource] object that represents the [metadata.image] of this
  /// [Resource].
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if the
  /// image cannot be found on the [hueNetwork], or if the image's
  /// [ResourceType] cannot be found on the [hueNetwork].
  Resource get imageAsResource => getRelativeAsResource(metadata.image);

  /// Group associated with this Scene.
  ///
  /// All services in the group are part of this scene. If the group is changed
  /// the scene is updated (e.g. light added/removed).
  final Relative group;

  /// Returns a [Resource] object that represents the [group] of this
  /// [Resource].
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if the
  /// [group] cannot be found on the [hueNetwork], or if the [group]'s
  /// [ResourceType] cannot be found on the [hueNetwork].
  Resource get groupAsResource => getRelativeAsResource(group);

  /// Group of colors that describe the palette of colors to be used when
  /// playing dynamics.
  ScenePalette palette;

  /// The value of [palette] when this object was instantiated.
  ScenePalette _originalPalette;

  double _speed;

  /// Speed of dynamic palette for this scene.
  ///
  /// Range: 0 - 1
  ///
  /// Throws [UnitIntervalException] if `speed` is set to something outside of
  /// the range 0 to 1 (inclusive).
  double get speed => _speed;
  set speed(double speed) {
    if (speed >= 0.0 && speed <= 1.0) {
      _speed = speed;
    } else {
      throw UnitIntervalException.withValue(speed);
    }
  }

  /// The value of [speed] when this object was instantiated.
  double _originalSpeed;

  /// Whether or not to automatically start the scene dynamically on active
  /// recall.
  bool autoDynamic;

  /// The value of [recall] when this object was instantiated.
  bool _originalAutoDynamic;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    _originalActions = actions.map((action) {
      action.refreshOriginals();
      return action.copyWith();
    }).toList();
    recall.refreshOriginals();
    _originalRecall = recall.copyWith();
    metadata.refreshOriginals();
    _originalMetadata = metadata.copyWith();
    palette.refreshOriginals();
    _originalPalette = palette.copyWith();
    _originalSpeed = speed;
    _originalAutoDynamic = autoDynamic;
    super.refreshOriginals();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  Scene copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    List<SceneAction>? actions,
    SceneRecall? recall,
    SceneMetadata? metadata,
    Relative? group,
    ScenePalette? palette,
    double? speed,
    bool? autoDynamic,
    bool copyOriginalValues = true,
  }) {
    Scene toReturn = Scene(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      actions: copyOriginalValues
          ? _originalActions
              .map((action) =>
                  action.copyWith(copyOriginalValues: copyOriginalValues))
              .toList()
          : (actions ??
              this
                  .actions
                  .map((action) =>
                      action.copyWith(copyOriginalValues: copyOriginalValues))
                  .toList()),
      recall: copyOriginalValues
          ? _originalRecall.copyWith(copyOriginalValues: copyOriginalValues)
          : (recall ??
              this.recall.copyWith(copyOriginalValues: copyOriginalValues)),
      metadata: copyOriginalValues
          ? _originalMetadata.copyWith(copyOriginalValues: copyOriginalValues)
          : (metadata ??
              this.metadata.copyWith(copyOriginalValues: copyOriginalValues)),
      group:
          group ?? this.group.copyWith(copyOriginalValues: copyOriginalValues),
      palette: copyOriginalValues
          ? _originalPalette.copyWith(copyOriginalValues: copyOriginalValues)
          : (palette ??
              this.palette.copyWith(copyOriginalValues: copyOriginalValues)),
      speed: copyOriginalValues ? _originalSpeed : (speed ?? this.speed),
      autoDynamic: copyOriginalValues
          ? _originalAutoDynamic
          : (autoDynamic ?? this.autoDynamic),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.actions = actions ??
          this
              .actions
              .map((action) =>
                  action.copyWith(copyOriginalValues: copyOriginalValues))
              .toList();
      toReturn.recall = recall ??
          this.recall.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.metadata = metadata ??
          this.metadata.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.palette = palette ??
          this.palette.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.speed = speed ?? this.speed;
      toReturn.autoDynamic = autoDynamic ?? this.autoDynamic;
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
  /// Throws [InvalidNameException] if [metadata.name] does not have a length of
  /// 1 - 32 (inclusive), and `optimizeFor` is not set to
  /// [OptimizeFor.dontOptimize].
  ///
  /// Throws [InvalidIdException] if [group.id] or [metadata.image.id] is empty
  /// and `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (!identical(type, originalType)) {
        toReturn[ApiFields.type] = type.value;
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(actions, _originalActions)) {
        toReturn[ApiFields.actions] = actions
            .map((action) => action.toJson(optimizeFor: OptimizeFor.putFull))
            .toList();
      }

      if (recall != _originalRecall) {
        toReturn[ApiFields.recall] =
            recall.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (metadata != _originalMetadata) {
        toReturn[ApiFields.metadata] =
            metadata.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (palette != _originalPalette) {
        toReturn[ApiFields.palette] =
            palette.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (speed != _originalSpeed) {
        toReturn[ApiFields.speed] = speed;
      }

      if (autoDynamic != _originalAutoDynamic) {
        toReturn[ApiFields.autoDynamic] = autoDynamic;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
        ApiFields.actions: actions
            .map((action) => action.toJson(optimizeFor: optimizeFor))
            .toList(),
        ApiFields.recall: recall.toJson(optimizeFor: optimizeFor),
        ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
        ApiFields.palette: palette.toJson(optimizeFor: optimizeFor),
        ApiFields.speed: speed,
        ApiFields.autoDynamic: autoDynamic,
      };
    }

    // POST
    if (identical(optimizeFor, OptimizeFor.post)) {
      return {
        ApiFields.type: type.value,
        ApiFields.actions: actions
            .map((action) => action.toJson(optimizeFor: optimizeFor))
            .toList(),
        ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
        ApiFields.group: group.toJson(optimizeFor: optimizeFor),
        ApiFields.palette: palette.toJson(optimizeFor: optimizeFor),
        ApiFields.speed: speed,
        ApiFields.autoDynamic: autoDynamic,
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.actions: actions
          .map((action) => action.toJson(optimizeFor: optimizeFor))
          .toList(),
      ApiFields.recall: recall.toJson(optimizeFor: optimizeFor),
      ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
      ApiFields.group: group.toJson(optimizeFor: optimizeFor),
      ApiFields.palette: palette.toJson(optimizeFor: optimizeFor),
      ApiFields.speed: speed,
      ApiFields.autoDynamic: autoDynamic,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Scene &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        const DeepCollectionEquality.unordered()
            .equals(other.actions, actions) &&
        other.recall == recall &&
        other.metadata == metadata &&
        other.group == group &&
        other.palette == palette &&
        other.speed == speed &&
        other.autoDynamic == autoDynamic;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        Object.hashAllUnordered(actions),
        recall,
        metadata,
        group,
        palette,
        speed,
        autoDynamic,
      );

  @override
  String toString() =>
      "Instance of 'Scene' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
