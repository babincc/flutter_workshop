// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/coordinate_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a physical location on Earth.
class Geolocation extends Resource {
  /// Creates a [Geolocation] object.
  Geolocation({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.isConfigured,
    double? latitude,
    double? longitude,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        assert(latitude == null || Validators.isValidLatitude(latitude),
            '"$latitude" is not a valid `latitude`'),
        assert(longitude == null || Validators.isValidLongitude(longitude),
            '"$longitude" is not a valid `longitude`'),
        _originalLatitude = latitude,
        _latitude = latitude,
        _originalLongitude = longitude,
        _longitude = longitude;

  /// Creates a [Geolocation] object from the JSON response to a GET request.
  factory Geolocation.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return Geolocation(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      isConfigured: data[ApiFields.isConfigured] ?? false,
      latitude: (data[ApiFields.latitude] as num?)?.toDouble(),
      longitude: (data[ApiFields.longitude] as num?)?.toDouble(),
    );
  }

  /// Creates an empty [Geolocation] object.
  Geolocation.empty()
      : idV1 = "",
        isConfigured = false,
        _originalLongitude = null,
        _originalLatitude = null,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Whether or not this geolocation is configured.
  final bool isConfigured;

  double? _longitude;

  /// The longitude of this geolocation.
  ///
  /// Latitude (north or south) always precedes longitude (east or west).
  ///
  /// Throws [InvalidLongitudeException] if `longitude` is set to a value that
  /// is not between -180 and 180 (inclusive).
  double? get longitude => _longitude;
  set longitude(double? longitude) {
    if (longitude == null || Validators.isValidLongitude(longitude)) {
      _longitude = longitude;
    } else {
      throw InvalidLongitudeException.withValue(longitude);
    }
  }

  /// The value of [longitude] when this object was instantiated.
  double? _originalLongitude;

  double? _latitude;

  /// The latitude of this geolocation.
  ///
  /// Latitude (north or south) always precedes longitude (east or west).
  ///
  /// Throws [InvalidLongitudeException] if `latitude` is set to a value that
  /// is not between -90 and 90 (inclusive).
  double? get latitude => _latitude;
  set latitude(double? latitude) {
    if (latitude == null || Validators.isValidLatitude(latitude)) {
      _latitude = latitude;
    } else {
      throw InvalidLatitudeException.withValue(latitude);
    }
  }

  /// The value of [latitude] when this object was instantiated.
  double? _originalLatitude;

  @override
  bool get hasUpdate =>
      super.hasUpdate ||
      !identical(latitude, _originalLatitude) ||
      !identical(longitude, _originalLongitude);

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    _originalLatitude = latitude;
    _originalLongitude = longitude;
    super.refreshOriginals();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [isAtHome] is nullable, it is defaulted to an empty object in this
  /// method. If left as an empty object, its current value in this
  /// [Geolocation] object will be used. This way, if it is `null`, the
  /// program will know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  Geolocation copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    bool? isConfigured,
    double? latitude,
    double? longitude,
    bool copyOriginalValues = true,
  }) {
    Geolocation toReturn = Geolocation(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      isConfigured: isConfigured ?? this.isConfigured,
      latitude:
          copyOriginalValues ? _originalLatitude : (latitude ?? this.latitude),
      longitude: copyOriginalValues
          ? _originalLongitude
          : (longitude ?? this.longitude),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.latitude = latitude ?? this.latitude;
      toReturn.longitude = longitude ?? this.longitude;
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

      if (latitude != _originalLatitude) {
        toReturn[ApiFields.latitude] = latitude;
      }

      if (longitude != _originalLongitude) {
        toReturn[ApiFields.longitude] = longitude;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type,
        ApiFields.longitude: longitude,
        ApiFields.latitude: latitude,
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.isConfigured: isConfigured,
      ApiFields.longitude: longitude,
      ApiFields.latitude: latitude,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Geolocation &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.isConfigured == isConfigured &&
        ((other.longitude == null && longitude == null) ||
            ((other.longitude != null && longitude != null) &&
                (other.longitude == longitude))) &&
        ((other.latitude == null && latitude == null) ||
            ((other.latitude != null && latitude != null) &&
                (other.latitude == latitude)));
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        isConfigured,
        longitude,
        latitude,
      );

  @override
  String toString() =>
      "Instance of 'Geolocation' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
