import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// An entertainment configuration's metadata.
class EntertainmentConfigurationMetadata {
  /// Creates a [EntertainmentConfigurationMetadata] object.
  EntertainmentConfigurationMetadata({
    required String name,
  })  : assert(name.isEmpty || Validators.isValidName(name),
            "`name` must be between 1 and 32 characters (inclusive)"),
        _originalName = name,
        _name = name;

  /// Creates a [EntertainmentConfigurationMetadata] object from the JSON
  /// response to a GET request.
  factory EntertainmentConfigurationMetadata.fromJson(
      Map<String, dynamic> dataMap) {
    return EntertainmentConfigurationMetadata(
      name: dataMap[ApiFields.name] ?? "",
    );
  }

  /// Creates an empty [EntertainmentConfigurationMetadata] object.
  EntertainmentConfigurationMetadata.empty()
      : _originalName = "",
        _name = "";

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

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalName = name;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  EntertainmentConfigurationMetadata copyWith({
    String? name,
    bool copyOriginalValues = true,
  }) {
    EntertainmentConfigurationMetadata toReturn =
        EntertainmentConfigurationMetadata(
      name: copyOriginalValues ? _originalName : (name ?? this.name),
    );

    if (copyOriginalValues) {
      toReturn.name = name ?? this.name;
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
    // Validate [name].
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

      if (name != _originalName) {
        toReturn[ApiFields.name] = name;
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.name: name,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is EntertainmentConfigurationMetadata && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() =>
      "Instance of 'EntertainmentConfigurationMetadata' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
