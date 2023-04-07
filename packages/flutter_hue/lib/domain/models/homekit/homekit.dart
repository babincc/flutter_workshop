// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// The configuration settings for a homekit resource.
class Homekit extends Resource {
  /// Creates a [Homekit] object.
  Homekit({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.status,
    this.action,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        _originalAction = action;

  /// Creates a [Homekit] object from the JSON response to a
  /// GET request.
  factory Homekit.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return Homekit(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      status: data[ApiFields.status] ?? "",
      action: data[ApiFields.action],
    );
  }

  /// Creates an empty [Homekit] object.
  Homekit.empty()
      : idV1 = "",
        status = "",
        _originalAction = null,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Read only field indicating whether homekit is already paired, currently
  /// open for pairing, or unpaired.
  ///
  /// Transitions:
  /// * unpaired > pairing – pushlink button press or power cycle
  /// * pairing > paired – through HAP
  /// * pairing > unpaired – 10 minutes
  /// * paired > unpaired – homekit reset
  ///
  /// one of: paired, pairing, unpaired
  final String status;

  /// Reset homekit, including removing all pairings and reset state and Bonjour
  /// service to factory settings.
  ///
  /// The Homekit will start functioning after approximately 10 seconds.
  ///
  /// "homekit_reset"
  String? action;

  /// The value of [action] when this object was instantiated.
  String? _originalAction;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    _originalAction = action;
    super.refreshOriginals();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [action] is nullable, it is defaulted to an empty string in this
  /// method. If left as an empty string, its current value in this
  /// [Homekit] object will be used. This way, if it is `null`, the program will
  /// know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  Homekit copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    String? status,
    String? action = "",
    bool copyOriginalValues = true,
  }) {
    Homekit toReturn = Homekit(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      status: status ?? this.status,
      action: copyOriginalValues
          ? _originalAction
          : (action == null || action.isNotEmpty ? action : this.action),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.action =
          action == null || action.isNotEmpty ? action : this.action;
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

      if (action != _originalAction) {
        toReturn[ApiFields.action] = action;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type,
        ApiFields.action: action,
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.status: status,
      ApiFields.action: action,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Homekit &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.status == status &&
        other.action == action;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        status,
        action,
      );

  @override
  String toString() =>
      "Instance of 'Homekit' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
