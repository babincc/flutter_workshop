// ignore_for_file: deprecated_member_use_from_same_package

import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_position.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/exceptions/unit_interval_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// An entertainment configuration's location.
class EntertainmentConfigurationLocation {
  /// Creates a [EntertainmentConfigurationLocation] object.
  EntertainmentConfigurationLocation({
    required this.service,
    EntertainmentConfigurationPosition? position,
    required this.positions,
    required double equalizationFactor,
  })  : assert(Validators.isUnitInterval(equalizationFactor),
            "`equalizationFactor` must be between 0 and 1 (inclusive)"),
        position = position ?? EntertainmentConfigurationPosition.empty(),
        _originalService = service.copyWith(),
        _originalPositions =
            positions.map((position) => position.copyWith()).toList(),
        _equalizationFactor = equalizationFactor,
        _originalEqualizationFactor = equalizationFactor;

  /// Creates a [EntertainmentConfigurationLocation] object from the JSON
  /// response to a GET request.
  factory EntertainmentConfigurationLocation.fromJson(
      Map<String, dynamic> dataMap) {
    return EntertainmentConfigurationLocation(
      service: Relative.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.service] ?? {})),
      position: EntertainmentConfigurationPosition.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.position] ?? {})),
      positions: (dataMap[ApiFields.positions] as List<dynamic>?)
              ?.map((positionMap) =>
                  EntertainmentConfigurationPosition.fromJson(
                      Map<String, dynamic>.from(positionMap)))
              .toList() ??
          [],
      equalizationFactor: dataMap[ApiFields.equalizationFactor] ?? 0,
    );
  }

  /// Creates an empty [EntertainmentConfigurationLocation] object.
  EntertainmentConfigurationLocation.empty()
      : service = Relative.empty(),
        _originalService = Relative.empty(),
        position = EntertainmentConfigurationPosition.empty(),
        positions = [],
        _originalPositions = [],
        _equalizationFactor = 0,
        _originalEqualizationFactor = 0;

  /// The entertainment configuration location's resource.
  Relative service;

  /// The value of [service] when this object was instantiated.
  Relative _originalService;

  /// Describes the location of the service.
  @Deprecated("use positions")
  final EntertainmentConfigurationPosition position;

  /// Describes the location of the service.
  List<EntertainmentConfigurationPosition> positions;

  /// The value of [positions] when this object was instantiated.
  List<EntertainmentConfigurationPosition> _originalPositions;

  /// Relative equalization factor applied to the entertainment service, to
  /// compensate for differences in brightness in the entertainment
  /// configuration.
  ///
  /// Range: >0 - 1
  ///
  /// Value cannot be 0, writing 0 changes it to lowest possible value.
  double _equalizationFactor;

  /// Relative equalization factor applied to the entertainment service, to
  /// compensate for differences in brightness in the entertainment
  /// configuration.
  ///
  /// Range: >0 - 1
  ///
  /// Value cannot be 0, writing 0 changes it to lowest possible value.
  ///
  /// Throws [UnitIntervalException] if `equalizationFactor` is set to a value
  /// that is not between 0 and 1 (inclusive).
  double get equalizationFactor => _equalizationFactor;
  set equalizationFactor(double equalizationFactor) {
    if (Validators.isUnitInterval(equalizationFactor)) {
      _equalizationFactor = equalizationFactor;
    } else {
      throw UnitIntervalException.withValue(equalizationFactor);
    }
  }

  /// The value of [equalizationFactor] when this object was instantiated.
  double _originalEqualizationFactor;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      service.hasUpdate ||
      service != _originalService ||
      !(const DeepCollectionEquality.unordered()
          .equals(positions, _originalPositions)) ||
      equalizationFactor != _originalEqualizationFactor;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalService = service.copyWith();
    _originalPositions =
        positions.map((position) => position.copyWith()).toList();
    _originalEqualizationFactor = equalizationFactor;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  EntertainmentConfigurationLocation copyWith({
    Relative? service,
    EntertainmentConfigurationPosition? position,
    List<EntertainmentConfigurationPosition>? positions,
    double? equalizationFactor,
    bool copyOriginalValues = true,
  }) {
    EntertainmentConfigurationLocation toReturn =
        EntertainmentConfigurationLocation(
      service: copyOriginalValues
          ? _originalService.copyWith(copyOriginalValues: copyOriginalValues)
          : (service ??
              this.service.copyWith(copyOriginalValues: copyOriginalValues)),
      position: position ??
          this.position.copyWith(copyOriginalValues: copyOriginalValues),
      positions: copyOriginalValues
          ? _originalPositions
              .map((position) =>
                  position.copyWith(copyOriginalValues: copyOriginalValues))
              .toList()
          : (positions ??
              this
                  .positions
                  .map((position) =>
                      position.copyWith(copyOriginalValues: copyOriginalValues))
                  .toList()),
      equalizationFactor: copyOriginalValues
          ? _originalEqualizationFactor
          : (equalizationFactor ?? this.equalizationFactor),
    );

    if (copyOriginalValues) {
      toReturn.service = service ??
          this.service.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.positions = positions ??
          this
              .positions
              .map((position) =>
                  position.copyWith(copyOriginalValues: copyOriginalValues))
              .toList();
      toReturn.equalizationFactor =
          equalizationFactor ?? this.equalizationFactor;
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
  /// Throws [InvalidNameException] if `name` does not have a length of 1 - 32
  /// (inclusive), and `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (service != _originalService) {
        toReturn[ApiFields.service] =
            service.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(positions, _originalPositions)) {
        toReturn[ApiFields.positions] =
            positions.map((position) => position.toJson()).toList();
      }

      if (equalizationFactor != _originalEqualizationFactor) {
        toReturn[ApiFields.equalizationFactor] = equalizationFactor;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.service: service.toJson(optimizeFor: optimizeFor),
        ApiFields.positions:
            positions.map((position) => position.toJson()).toList(),
        ApiFields.equalizationFactor: equalizationFactor,
      };
    }

    // POST
    if (identical(optimizeFor, OptimizeFor.post)) {
      return {
        ApiFields.service: service.toJson(optimizeFor: optimizeFor),
        ApiFields.positions:
            positions.map((position) => position.toJson()).toList(),
      };
    }

    // DEFAULT
    return {
      ApiFields.service: service.toJson(optimizeFor: optimizeFor),
      ApiFields.position: position.toJson(),
      ApiFields.positions:
          positions.map((position) => position.toJson()).toList(),
      ApiFields.equalizationFactor: equalizationFactor,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is EntertainmentConfigurationLocation &&
        other.service == service &&
        other.position == position &&
        const DeepCollectionEquality.unordered()
            .equals(other.positions, positions) &&
        other.equalizationFactor == equalizationFactor;
  }

  @override
  int get hashCode => Object.hash(
        service,
        position,
        Object.hashAllUnordered(positions),
        equalizationFactor,
      );

  @override
  String toString() =>
      "Instance of 'EntertainmentConfigurationLocation' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
