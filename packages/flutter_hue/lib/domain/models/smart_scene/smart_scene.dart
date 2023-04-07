// ignore_for_file: deprecated_member_use_from_same_package

import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene_active_timeslot.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene_metadata.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene_week/smart_scene_week.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a smart scene resource.
class SmartScene extends Resource {
  /// Creates a [SmartScene] object.
  SmartScene({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.metadata,
    required this.group,
    required this.weekTimeslots,
    required this.activeTimeslot,
    required this.state,
    this.recallAction,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        _originalMetadata = metadata.copyWith(),
        _originalWeekTimeslots = weekTimeslots
            .map((weekTimeslot) => weekTimeslot.copyWith())
            .toList(),
        _originalRecallAction = recallAction;

  /// Creates a [SmartScene] object from the JSON response to a GET request.
  factory SmartScene.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return SmartScene(
        type: ResourceType.fromString(data[ApiFields.type] ?? ""),
        id: data[ApiFields.id] ?? "",
        idV1: data[ApiFields.idV1] ?? "",
        metadata: SmartSceneMetadata.fromJson(
            Map<String, dynamic>.from(data[ApiFields.metadata] ?? {})),
        group: Relative.fromJson(
            Map<String, dynamic>.from(data[ApiFields.group] ?? {})),
        weekTimeslots: (data[ApiFields.weekTimeslots] as List<dynamic>?)
                ?.map((weekTimeslotMap) => SmartSceneWeek.fromJson(
                    Map<String, dynamic>.from(weekTimeslotMap)))
                .toList() ??
            [],
        activeTimeslot: SmartSceneActiveTimeslot.fromJson(
            Map<String, dynamic>.from(data[ApiFields.activeTimeslot] ?? {})),
        state: data[ApiFields.state] ?? "",
        recallAction: Map<String, dynamic>.from(
            data[ApiFields.recall] ?? {})[ApiFields.action]);
  }

  /// Creates an empty [SmartScene] object.
  SmartScene.empty()
      : idV1 = "",
        metadata = SmartSceneMetadata.empty(),
        _originalMetadata = SmartSceneMetadata.empty(),
        group = Relative.empty(),
        weekTimeslots = [],
        _originalWeekTimeslots = [],
        activeTimeslot = SmartSceneActiveTimeslot.empty(),
        state = "",
        _originalRecallAction = null,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Metadata about this smart scene.
  SmartSceneMetadata metadata;

  /// The value of [metadata] when this object was instantiated.
  SmartSceneMetadata _originalMetadata;

  /// Group associated with this Scene.
  ///
  /// All services in the group are part of this scene. If the group is changed
  /// the scene is update (e.g. light added/removed)
  final Relative group;

  /// Information on what is the light state for every timeslot of the day.
  List<SmartSceneWeek> weekTimeslots;

  /// The value of [weekTimeslots] when this object was instantiated.
  List<SmartSceneWeek> _originalWeekTimeslots;

  /// The active time slot in execution.
  final SmartSceneActiveTimeslot activeTimeslot;

  /// The current state of the smart scene.
  ///
  /// The default state is inactive if no recall is provided.
  ///
  /// one of: active, inactive
  final String state;

  /// "activate" will start the smart (24h) scene; "deactivate" will stop it.
  String? recallAction;

  /// The value of [recallAction] when this object was instantiated.
  String? _originalRecallAction;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    metadata.refreshOriginals();
    _originalMetadata = metadata.copyWith();
    _originalWeekTimeslots = weekTimeslots.map((weekTimeslot) {
      weekTimeslot.refreshOriginals();
      return weekTimeslot.copyWith();
    }).toList();
    _originalRecallAction = recallAction;
    super.refreshOriginals();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [recallAction] is nullable, it is defaulted to an empty string in
  /// this method. If left as an empty string, its current value in this
  /// [SmartScene] object will be used. This way, if it is `null`, the program
  /// will know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  SmartScene copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    SmartSceneMetadata? metadata,
    Relative? group,
    List<SmartSceneWeek>? weekTimeslots,
    SmartSceneActiveTimeslot? activeTimeslot,
    String? state,
    String? recallAction = "",
    bool copyOriginalValues = true,
  }) {
    SmartScene toReturn = SmartScene(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      metadata: copyOriginalValues
          ? _originalMetadata.copyWith(copyOriginalValues: copyOriginalValues)
          : (metadata ??
              this.metadata.copyWith(copyOriginalValues: copyOriginalValues)),
      group: group ?? this.group,
      weekTimeslots: copyOriginalValues
          ? _originalWeekTimeslots
              .map((weekTimeslot) =>
                  weekTimeslot.copyWith(copyOriginalValues: copyOriginalValues))
              .toList()
          : (weekTimeslots ??
              this
                  .weekTimeslots
                  .map((weekTimeslot) => weekTimeslot.copyWith(
                      copyOriginalValues: copyOriginalValues))
                  .toList()),
      activeTimeslot: activeTimeslot ?? this.activeTimeslot,
      state: state ?? this.state,
      recallAction: copyOriginalValues
          ? _originalRecallAction
          : (recallAction == null || recallAction.isNotEmpty
              ? recallAction
              : this.recallAction),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.metadata = metadata ??
          this.metadata.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.weekTimeslots = weekTimeslots ??
          this
              .weekTimeslots
              .map((weekTimeslot) =>
                  weekTimeslot.copyWith(copyOriginalValues: copyOriginalValues))
              .toList();
      toReturn.recallAction = recallAction == null || recallAction.isNotEmpty
          ? recallAction
          : this.recallAction;
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
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (type != originalType) {
        toReturn[ApiFields.type] = type.value;
      }

      if (metadata != _originalMetadata) {
        toReturn[ApiFields.metadata] =
            metadata.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(weekTimeslots, _originalWeekTimeslots)) {
        toReturn[ApiFields.weekTimeslots] = weekTimeslots
            .map((weekTimeslot) =>
                weekTimeslot.toJson(optimizeFor: OptimizeFor.putFull))
            .toList();
      }

      if (recallAction != _originalRecallAction) {
        toReturn[ApiFields.recall] = {ApiFields.action: recallAction};
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
        ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
        ApiFields.weekTimeslots: weekTimeslots
            .map(
                (weekTimeslot) => weekTimeslot.toJson(optimizeFor: optimizeFor))
            .toList(),
        ApiFields.recall: {ApiFields.action: recallAction},
      };
    }

    // POST
    if (identical(optimizeFor, OptimizeFor.post)) {
      return {
        ApiFields.type: type.value,
        ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
        ApiFields.group: group.toJson(optimizeFor: optimizeFor),
        ApiFields.weekTimeslots: weekTimeslots
            .map(
                (weekTimeslot) => weekTimeslot.toJson(optimizeFor: optimizeFor))
            .toList(),
        ApiFields.recall: {ApiFields.action: recallAction},
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
      ApiFields.group: group.toJson(optimizeFor: optimizeFor),
      ApiFields.weekTimeslots: weekTimeslots
          .map((weekTimeslot) => weekTimeslot.toJson(optimizeFor: optimizeFor))
          .toList(),
      ApiFields.activeTimeslot: activeTimeslot.toJson(),
      ApiFields.state: state,
      ApiFields.recall: {ApiFields.action: recallAction},
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is SmartScene &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.metadata == metadata &&
        other.group == group &&
        const DeepCollectionEquality.unordered()
            .equals(other.weekTimeslots, weekTimeslots) &&
        other.activeTimeslot == activeTimeslot &&
        other.state == state &&
        other.recallAction == recallAction;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        metadata,
        group,
        Object.hashAllUnordered(weekTimeslots),
        activeTimeslot,
        state,
        recallAction,
      );

  @override
  String toString() => "Instance of 'SmartScene' ${toJson().toString()}";
}
