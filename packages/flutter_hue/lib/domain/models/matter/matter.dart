// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// The configuration settings for a matter resource.
class Matter extends Resource {
  /// Creates a [Matter] object.
  Matter({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.maxFabrics,
    required this.hasQrCode,
    this.action,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        _originalAction = action;

  /// Creates a [Matter] object from the JSON response to a
  /// GET request.
  factory Matter.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return Matter(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      maxFabrics: data[ApiFields.maxFabrics] ?? 0,
      hasQrCode: data[ApiFields.hasQrCode] ?? false,
      action: data[ApiFields.action],
    );
  }

  /// Creates an empty [Matter] object.
  Matter.empty()
      : idV1 = "",
        maxFabrics = 0,
        hasQrCode = false,
        _originalAction = null,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Maximum number of fabrics that can exist at a time.
  final int maxFabrics;

  /// Whether or not a physical QR code is present.
  final bool hasQrCode;

  /// matter_reset: Resets Matter, including removing all fabrics and reset
  /// state to factory settings.
  String? action;

  /// The value of [action] when this object was instantiated.
  String? _originalAction;

  @override
  bool get hasUpdate => super.hasUpdate || action != _originalAction;

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
  /// [Matter] object will be used. This way, if it is `null`, the program will
  /// know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  Matter copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    int? maxFabrics,
    bool? hasQrCode,
    String? action = "",
    bool copyOriginalValues = true,
  }) {
    Matter toReturn = Matter(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      maxFabrics: maxFabrics ?? this.maxFabrics,
      hasQrCode: hasQrCode ?? this.hasQrCode,
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
      ApiFields.maxFabrics: maxFabrics,
      ApiFields.hasQrCode: hasQrCode,
      ApiFields.action: action,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Matter &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.maxFabrics == maxFabrics &&
        other.hasQrCode == hasQrCode &&
        other.action == action;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        maxFabrics,
        hasQrCode,
        action,
      );

  @override
  String toString() =>
      "Instance of 'Matter' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
