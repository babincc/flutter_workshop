import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// The scene's metadata.
class SceneMetadata {
  /// Creates a [SceneMetadata] object.
  SceneMetadata({
    required String name,
    required this.image,
  })  : assert(name.isEmpty || Validators.isValidName(name),
            "`name` must be between 1 and 32 characters (inclusive)"),
        _originalName = name,
        _name = name;

  /// Creates a [SceneMetadata] object from the JSON response to a GET request.
  factory SceneMetadata.fromJson(Map<String, dynamic> dataMap) {
    return SceneMetadata(
      name: dataMap[ApiFields.name] ?? "",
      image: Relative.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.image] ?? {})),
    );
  }

  /// Creates an empty [SceneMetadata] object.
  SceneMetadata.empty()
      : _originalName = "",
        _name = "",
        image = Relative.empty();

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

  /// Reference with unique identifier for the image representing the scene only
  /// accepting "rtype": "public_image" on creation.
  final Relative image;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate => name != _originalName || image.hasUpdate;

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
  SceneMetadata copyWith({
    String? name,
    Relative? image,
    bool copyOriginalValues = true,
  }) {
    SceneMetadata toReturn = SceneMetadata(
      name: copyOriginalValues ? _originalName : (name ?? this.name),
      image:
          image ?? this.image.copyWith(copyOriginalValues: copyOriginalValues),
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
  ///
  /// Throws [InvalidIdException] if [image.id] is empty and `optimizeFor` is
  /// not set to [OptimizeFor.dontOptimize].
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

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.name: name,
      };
    }

    // DEFAULT
    return {
      ApiFields.name: name,
      ApiFields.image: image.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is SceneMetadata && other.name == name && other.image == image;
  }

  @override
  int get hashCode => Object.hash(name, image);

  @override
  String toString() =>
      "Instance of 'SceneMetadata' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
