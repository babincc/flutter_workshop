import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// The scene's metadata.
class ZigbeeDeviceDiscoveryAction {
  /// Creates a [ZigbeeDeviceDiscoveryAction] object.
  ZigbeeDeviceDiscoveryAction({
    required this.actionType,
    required List<String> searchCodes,
    required this.installCodes,
  })  : assert(searchCodes.length <= 10,
            "`searchCodes` must have 10 or fewer elements"),
        _originalActionType = actionType,
        _originalSearchCodes = List<String>.from(searchCodes),
        _searchCodes = searchCodes,
        _originalInstallCodes = List<String>.from(installCodes);

  /// Creates a [ZigbeeDeviceDiscoveryAction] object from the JSON response to a
  /// GET request.
  factory ZigbeeDeviceDiscoveryAction.fromJson(Map<String, dynamic> dataMap) {
    return ZigbeeDeviceDiscoveryAction(
      actionType: dataMap[ApiFields.actionType] ?? "",
      searchCodes: List<String>.from(dataMap[ApiFields.searchCodes] ?? []),
      installCodes: List<String>.from(dataMap[ApiFields.installCodes] ?? []),
    );
  }

  /// Creates an empty [ZigbeeDeviceDiscoveryAction] object.
  ZigbeeDeviceDiscoveryAction.empty()
      : actionType = "",
        _originalActionType = "",
        _originalSearchCodes = [],
        _searchCodes = [],
        _originalInstallCodes = [],
        installCodes = [];

  String actionType;

  String _originalActionType;

  List<String> _searchCodes;

  /// Collection of search codes.
  ///
  /// max items - 10
  ///
  /// Throws an [Exception] if [searchCodes] is set to a list with more than 10
  /// elements.
  List<String> get searchCodes =>
      List<String>.from(_searchCodes, growable: false);
  set searchCodes(List<String> searchCodes) {
    if (searchCodes.length <= 10) {
      _searchCodes = searchCodes;
    } else {
      throw Exception("`searchCodes` must have 10 or fewer elements");
    }
  }

  /// Adds a `searchCode` to the [searchCodes] array.
  ///
  /// Returns `true` if the `searchCode` was added to the array. If the array
  /// is full, the `searchCode` is not added, and `false` is returned.
  bool addSearchCode(String searchCode) {
    if (_searchCodes.length < 10) {
      _searchCodes.add(searchCode);
      return true;
    }

    return false;
  }

  /// Removes a `searchCode` from the [searchCodes] array.
  ///
  /// Returns `true` if `searchCode` was in the list, `false` otherwise.
  bool removeSearchCode(String searchCode) => _searchCodes.remove(searchCode);

  /// The value of [searchCodes] when this object was instantiated.
  List<String> _originalSearchCodes;

  List<String> installCodes;

  /// The value of [installCodes] when this object was instantiated.
  List<String> _originalInstallCodes;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      actionType != _originalActionType ||
      !(const DeepCollectionEquality.unordered()
          .equals(searchCodes, _originalSearchCodes)) ||
      !(const DeepCollectionEquality.unordered()
          .equals(installCodes, _originalInstallCodes));

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalActionType = actionType;
    _originalSearchCodes = List<String>.from(searchCodes);
    _originalInstallCodes = List<String>.from(installCodes);
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ZigbeeDeviceDiscoveryAction copyWith({
    String? actionType,
    List<String>? searchCodes,
    List<String>? installCodes,
    bool copyOriginalValues = true,
  }) {
    ZigbeeDeviceDiscoveryAction toReturn = ZigbeeDeviceDiscoveryAction(
      actionType: copyOriginalValues
          ? _originalActionType
          : (actionType ?? this.actionType),
      searchCodes: copyOriginalValues
          ? List<String>.from(_originalSearchCodes)
          : (searchCodes ?? List<String>.from(this.searchCodes)),
      installCodes: copyOriginalValues
          ? List<String>.from(_originalInstallCodes)
          : (installCodes ?? List<String>.from(this.installCodes)),
    );

    if (copyOriginalValues) {
      toReturn.actionType = actionType ?? this.actionType;
      toReturn.searchCodes = searchCodes ?? List<String>.from(this.searchCodes);
      toReturn.installCodes =
          installCodes ?? List<String>.from(this.installCodes);
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
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (actionType != _originalActionType) {
        toReturn[ApiFields.actionType] = actionType;
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(searchCodes, _originalSearchCodes)) {
        toReturn[ApiFields.searchCodes] = searchCodes;
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(installCodes, _originalInstallCodes)) {
        toReturn[ApiFields.installCodes] = installCodes;
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.actionType: actionType,
      ApiFields.searchCodes: searchCodes,
      ApiFields.installCodes: installCodes,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ZigbeeDeviceDiscoveryAction &&
        other.actionType == actionType &&
        const DeepCollectionEquality.unordered()
            .equals(other.searchCodes, searchCodes) &&
        const DeepCollectionEquality.unordered()
            .equals(other.installCodes, installCodes);
  }

  @override
  int get hashCode => Object.hash(
        actionType,
        const DeepCollectionEquality.unordered().hash(searchCodes),
        const DeepCollectionEquality.unordered().hash(installCodes),
      );

  @override
  String toString() =>
      "Instance of 'ZigbeeDeviceDiscoveryAction' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
