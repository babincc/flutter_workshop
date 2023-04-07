// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// API to manage geofencing functionality.
class GeofenceClient extends Resource {
  /// Creates a [GeofenceClient] object.
  GeofenceClient({
    required super.type,
    required super.id,
    this.idV1 = "",
    required String name,
    this.isAtHome,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        assert(name.isEmpty || Validators.isValidName(name),
            "`name` must be between 1 and 32 characters (inclusive)"),
        _name = name,
        _originalName = name,
        _originalIsAtHome = isAtHome;

  /// Creates a [GeofenceClient] object from the JSON response to a GET request.
  factory GeofenceClient.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return GeofenceClient(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      name: data[ApiFields.name] ?? "",
      isAtHome: data[ApiFields.isAtHome],
    );
  }

  /// Creates an empty [GeofenceClient] object.
  GeofenceClient.empty()
      : idV1 = "",
        _name = "",
        _originalName = "",
        _originalIsAtHome = null,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  String _name;

  /// Human readable name of a resource.
  ///
  /// Length: 1 - 32 chars
  ///
  /// Throws [InvalidNameException] if `name` is set to a string that does not
  /// have a length of 1 - 32 (inclusive).
  String get name => _name;
  set name(String name) {
    if (Validators.isValidName(name)) {
      _name = name;
    } else {
      throw InvalidNameException.withValue(name);
    }
  }

  /// The value of [name] when this object was instantiated.
  String _originalName;

  /// Whether or not this geofence client is at home.
  bool? isAtHome;

  /// The value of [isAtHome] when this object was instantiated.
  bool? _originalIsAtHome;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    _originalName = name;
    _originalIsAtHome = isAtHome;
    super.refreshOriginals();
  }

  /// Used in the [copyWith] method to check if nullable values are meant to be
  /// copied over.
  static const sentinelValue = Object();

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [isAtHome] is nullable, it is defaulted to an empty object in this
  /// method. If left as an empty object, its current value in this
  /// [GeofenceClient] object will be used. This way, if it is `null`, the
  /// program will know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  GeofenceClient copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    String? name,
    Object? isAtHome = sentinelValue,
    bool copyOriginalValues = true,
  }) {
    if (!identical(isAtHome, sentinelValue)) {
      assert(isAtHome is bool?, "`isAtHome` must be a `bool?` object");
    }

    GeofenceClient toReturn = GeofenceClient(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      name: copyOriginalValues ? _originalName : (name ?? this.name),
      isAtHome: copyOriginalValues
          ? _originalIsAtHome
          : (identical(isAtHome, sentinelValue)
              ? this.isAtHome
              : isAtHome as bool?),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.name = name ?? this.name;
      toReturn.isAtHome = identical(isAtHome, sentinelValue)
          ? this.isAtHome
          : isAtHome as bool?;
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
  /// Throws [InvalidNameException] if [name] doesn't have a length of 1 - 32
  /// (inclusive) and `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    /// Validate data.
    if (!identical(optimizeFor, OptimizeFor.dontOptimize)) {
      if (!Validators.isValidName(name)) {
        if (!identical(optimizeFor, OptimizeFor.put) || name != _originalName) {
          throw InvalidNameException.withValue(name);
        }
      }
    }

    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (type != originalType) {
        toReturn[ApiFields.type] = type.value;
      }

      if (name != _originalName) {
        toReturn[ApiFields.name] = name;
      }

      if (isAtHome != _originalIsAtHome) {
        toReturn[ApiFields.isAtHome] = isAtHome;
      }

      return toReturn;
    }

    // PUT FULL & POST
    if (identical(optimizeFor, OptimizeFor.putFull) ||
        identical(optimizeFor, OptimizeFor.post)) {
      return {
        ApiFields.type: type,
        ApiFields.name: name,
        ApiFields.isAtHome: isAtHome,
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.name: name,
      ApiFields.isAtHome: isAtHome,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is GeofenceClient &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.name == name &&
        other.isAtHome == isAtHome;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        name,
        isAtHome,
      );

  @override
  String toString() =>
      "Instance of 'GeofenceClient' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
