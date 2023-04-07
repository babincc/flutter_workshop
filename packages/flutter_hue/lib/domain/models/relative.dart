import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_id_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a relative to a resource.
class Relative extends Resource {
  /// Creates a [Relative] object.
  Relative({required super.type, required super.id});

  /// Creates a [Relative] object from the JSON response to a GET request.
  factory Relative.fromJson(Map<String, dynamic> dataMap) {
    return Relative(
      type: ResourceType.fromString(dataMap[ApiFields.rType] ?? ""),
      id: dataMap[ApiFields.rid] ?? "",
    );
  }

  /// Creates an empty [Relative] object.
  Relative.empty() : super.empty();

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  Relative copyWith({
    ResourceType? type,
    String? id,
    bool copyOriginalValues = true,
  }) {
    Relative toReturn = Relative(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
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
  /// Throws [InvalidIdException] if [id] is empty and `optimizeFor` is not set
  /// to [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // Validate [id].
    if (!identical(optimizeFor, OptimizeFor.dontOptimize)) {
      if (!Validators.isValidId(id)) {
        throw InvalidIdException.withValue(id);
      }
    }

    return {
      ApiFields.rid: id,
      ApiFields.rType: type.value,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Relative && identical(other.type, type) && other.id == id;
  }

  @override
  int get hashCode => Object.hash(type, id);

  @override
  String toString() =>
      "Instance of 'Relative' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
