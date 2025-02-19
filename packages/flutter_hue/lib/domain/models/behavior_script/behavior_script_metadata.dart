import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// The behavior script's metadata.
class BehaviorScriptMetadata {
  /// Creates a [BehaviorScriptMetadata] object.
  BehaviorScriptMetadata({
    required String name,
    required this.category,
  })  : assert(name.isEmpty || Validators.isValidName(name),
            "`name` must be between 1 and 32 characters (inclusive)"),
        _originalName = name,
        _name = name;

  /// Creates a [BehaviorScriptMetadata] object from the JSON response to a GET
  /// request.
  factory BehaviorScriptMetadata.fromJson(Map<String, dynamic> dataMap) {
    return BehaviorScriptMetadata(
      name: dataMap[ApiFields.name] ?? "",
      category: dataMap[ApiFields.category] ?? "",
    );
  }

  /// Creates an empty [BehaviorScriptMetadata] object.
  BehaviorScriptMetadata.empty()
      : _originalName = "",
        _name = "",
        category = "";

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

  /// The category the script falls into.
  ///
  /// One of: automation, entertainment, accessory, other
  final String category;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate => name != _originalName;

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
  BehaviorScriptMetadata copyWith({
    String? name,
    String? category,
    bool copyOriginalValues = true,
  }) {
    BehaviorScriptMetadata toReturn = BehaviorScriptMetadata(
      name: copyOriginalValues ? _originalName : (name ?? this.name),
      category: category ?? this.category,
    );

    if (copyOriginalValues) {
      toReturn.name = name ?? this.name;
    }

    return toReturn;
  }

  /// Converts this object into JSON format.
  ///
  /// Throws [InvalidNameException] if [name] doesn't have 1 to 32 characters
  /// (inclusive), and `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // Validate [name].
    if (!identical(optimizeFor, OptimizeFor.dontOptimize)) {
      if (!Validators.isValidName(name)) {
        throw InvalidNameException.withValue(name);
      }
    }

    return {
      ApiFields.name: name,
      ApiFields.category: category,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is BehaviorScriptMetadata &&
        other.name == name &&
        other.category == category;
  }

  @override
  int get hashCode => Object.hash(name, category);

  @override
  String toString() =>
      "Instance of 'BehaviorScriptMetadata' ${toJson().toString()}";
}
