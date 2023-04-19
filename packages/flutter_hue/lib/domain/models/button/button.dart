// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a Philips Hue button.
class Button extends Resource {
  /// Creates a [Button] object.
  Button({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.owner,
    required this.controlId,
    required this.lastEvent,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        assert(controlId >= 0 && controlId <= 8,
            '"$controlId" is not a valid `controlId`');

  /// Creates a [Button] object from the JSON response to a GET request.
  factory Button.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return Button(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      owner: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.owner] ?? {})),
      controlId: Map<String, dynamic>.from(
              data[ApiFields.metadata] ?? {})[ApiFields.controlId] ??
          0,
      lastEvent: Map<String, dynamic>.from(
              data[ApiFields.button] ?? {})[ApiFields.lastEvent] ??
          "",
    );
  }

  /// Creates an empty [Button] object.
  Button.empty()
      : idV1 = "",
        owner = Relative.empty(),
        controlId = 0,
        lastEvent = "",
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Owner of the service, in case the owner service is deleted, the service
  /// also gets deleted
  final Relative owner;

  /// Returns a [Resource] object that represents the [owner] of this
  /// [Resource].
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if the
  /// [owner] cannot be found on the [hueNetwork], or if the [owner]'s
  /// [ResourceType] cannot be found on the [hueNetwork].
  Resource get ownerAsResource => getRelativeAsResource(owner);

  /// Control identifier of the switch which is unique per device.
  ///
  /// Meaning in combination with:
  /// * type
  /// * dots - Number of dots
  /// * number - Number printed on device
  /// * other - a logical order of controls in switch
  final int controlId;

  /// Event which can be send by a button control.
  ///
  /// one of: initial_press, repeat, short_release, long_release,
  /// double_short_release, long_press
  final String lastEvent;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  Button copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    Relative? owner,
    int? controlId,
    String? lastEvent,
    bool copyOriginalValues = true,
  }) {
    Button toReturn = Button(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      owner:
          owner ?? this.owner.copyWith(copyOriginalValues: copyOriginalValues),
      controlId: controlId ?? this.controlId,
      lastEvent: lastEvent ?? this.lastEvent,
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
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
  /// Throws [InvalidIdException] if [owner.id] is empty and `optimizeFor` is
  /// not set to [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (!identical(type, originalType)) {
        toReturn[ApiFields.type] = type.value;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.owner: owner.toJson(optimizeFor: optimizeFor),
      ApiFields.metadata: {
        ApiFields.controlId: controlId,
      },
      ApiFields.button: {
        ApiFields.lastEvent: lastEvent,
      },
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Button &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.owner == owner &&
        other.controlId == controlId &&
        other.lastEvent == lastEvent;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        owner,
        controlId,
        lastEvent,
      );

  @override
  String toString() =>
      "Instance of 'Button' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
