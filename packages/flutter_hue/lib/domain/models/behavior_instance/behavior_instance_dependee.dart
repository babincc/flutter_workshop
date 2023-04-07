import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// A behavior instance's dependee.
class BehaviorInstanceDependee {
  /// Creates a [BehaviorInstanceDependee] object.
  BehaviorInstanceDependee({
    required this.type,
    required this.target,
    required this.level,
  });

  /// Creates a [BehaviorInstanceDependee] object from the JSON response to a
  /// GET request.
  factory BehaviorInstanceDependee.fromJson(Map<String, dynamic> dataMap) {
    return BehaviorInstanceDependee(
      type: dataMap[ApiFields.type] ?? "",
      target: Relative.fromJson(dataMap[ApiFields.target] ?? {}),
      level: dataMap[ApiFields.level] ?? "",
    );
  }

  /// Creates an empty [BehaviorInstanceDependee] object.
  BehaviorInstanceDependee.empty()
      : type = "",
        target = Relative.empty(),
        level = "";

  /// Describes the type of this dependee.
  final String type;

  /// Id of the dependency resource (target).
  final Relative target;

  /// The level of importance of this dependee.
  ///
  /// * non_critical: Defines a dependency between resources. Although source is
  /// impacted by removal of target, source remains of target means removal of
  /// source.
  /// * critical: Defines a critical dependency between resources. Source cannot
  /// function without target, hence removal of target means removal of source.
  final String level;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  BehaviorInstanceDependee copyWith({
    String? type,
    Relative? target,
    String? level,
  }) {
    return BehaviorInstanceDependee(
      type: type ?? this.type,
      target: target ?? this.target.copyWith(),
      level: level ?? this.level,
    );
  }

  /// Converts this object into JSON format.
  ///
  /// Throws [InvalidIdException] if [target.id] is empty and `optimizeFor` is
  /// not set to [OptimizeFor.dontOptimize].
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    return {
      ApiFields.type: type,
      ApiFields.target: target.toJson(optimizeFor: optimizeFor),
      ApiFields.level: level,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is BehaviorInstanceDependee &&
        other.type == type &&
        other.target == target &&
        other.level == level;
  }

  @override
  int get hashCode => Object.hash(type, target, level);

  @override
  String toString() =>
      "Instance of 'BehaviorScriptMetadata' ${toJson().toString()}";
}
