// ignore_for_file: deprecated_member_use_from_same_package

import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/behavior_script/behavior_script_metadata.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// API to manage instances of script.
class BehaviorScript extends Resource {
  /// Creates a [BehaviorScript] object.
  BehaviorScript({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.description,
    required this.configurationSchema,
    required this.triggerSchema,
    required this.stateSchema,
    required this.version,
    required this.metadata,
    required this.supportedFeatures,
    required this.maxNumberInstances,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        assert(Validators.isValidScriptVersion(version),
            '"$version" is not a valid `version`'),
        assert(maxNumberInstances >= 0 && maxNumberInstances <= 255,
            '"$maxNumberInstances" is not a valid `maxNumberInstances`');

  /// Creates a [BehaviorScript] object from the JSON response to a GET request.
  factory BehaviorScript.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return BehaviorScript(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      description: data[ApiFields.description] ?? "",
      configurationSchema:
          Map<String, dynamic>.from(data[ApiFields.configurationSchema] ?? {}),
      triggerSchema:
          Map<String, dynamic>.from(data[ApiFields.triggerSchema] ?? {}),
      stateSchema: Map<String, dynamic>.from(data[ApiFields.stateSchema] ?? {}),
      version: data[ApiFields.version] ?? "0.0.0",
      metadata: BehaviorScriptMetadata.fromJson(
          Map<String, dynamic>.from(data[ApiFields.metadata] ?? {})),
      supportedFeatures:
          List<String>.from(data[ApiFields.supportedFeatures] ?? []),
      maxNumberInstances: data[ApiFields.maxNumberInstances] ?? 255,
    );
  }

  /// Creates an empty [BehaviorScript] object.
  BehaviorScript.empty()
      : idV1 = "",
        description = "",
        configurationSchema = {},
        triggerSchema = {},
        stateSchema = {},
        version = "0.0.0",
        metadata = BehaviorScriptMetadata.empty(),
        supportedFeatures = [],
        maxNumberInstances = 255,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Short description of script.
  final String description;

  /// JSON schema object used for validating ScriptInstance.configuration
  /// property.
  final Map<String, dynamic> configurationSchema;

  /// JSON schema object used for validating ScriptInstance.trigger property.
  final Map<String, dynamic> triggerSchema;

  /// JSON schema of ScriptInstance.state property.
  final Map<String, dynamic> stateSchema;

  /// Version of script.
  ///
  /// Regex pattern `^[1-9]?[0-9]{0,2}([.][0-9]{1,3}){1,2}`
  final String version;

  /// The configuration of this script.
  final BehaviorScriptMetadata metadata;

  /// Features that the script supports.
  final List<String> supportedFeatures;

  /// Max number of script instances.
  ///
  /// Range: 0 - 255
  final int maxNumberInstances;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  BehaviorScript copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    String? description,
    Map<String, dynamic>? configurationSchema,
    Map<String, dynamic>? triggerSchema,
    Map<String, dynamic>? stateSchema,
    String? version,
    BehaviorScriptMetadata? metadata,
    List<String>? supportedFeatures,
    int? maxNumberInstances,
  }) {
    return BehaviorScript(
      type: type ?? this.type,
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      description: description ?? this.description,
      configurationSchema: configurationSchema ??
          Map<String, dynamic>.from(this.configurationSchema),
      triggerSchema:
          triggerSchema ?? Map<String, dynamic>.from(this.triggerSchema),
      stateSchema: stateSchema ?? Map<String, dynamic>.from(this.stateSchema),
      version: version ?? this.version,
      metadata: metadata ?? this.metadata.copyWith(),
      supportedFeatures:
          supportedFeatures ?? List<String>.from(this.supportedFeatures),
      maxNumberInstances: maxNumberInstances ?? this.maxNumberInstances,
    );
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
  /// Throws [InvalidNameException] if [metadata.name] doesn't have 1 to 32
  /// characters (inclusive), and `optimizeFor` is not set to
  /// [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.description: description,
      ApiFields.configurationSchema: configurationSchema,
      ApiFields.triggerSchema: triggerSchema,
      ApiFields.stateSchema: stateSchema,
      ApiFields.version: version,
      ApiFields.metadata:
          metadata.toJson(optimizeFor: OptimizeFor.dontOptimize),
      ApiFields.supportedFeatures: supportedFeatures,
      ApiFields.maxNumberInstances: maxNumberInstances,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is BehaviorScript &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.description == description &&
        const DeepCollectionEquality.unordered()
            .equals(other.configurationSchema, configurationSchema) &&
        const DeepCollectionEquality.unordered()
            .equals(other.triggerSchema, triggerSchema) &&
        const DeepCollectionEquality.unordered()
            .equals(other.stateSchema, stateSchema) &&
        other.version == version &&
        other.metadata == metadata &&
        const DeepCollectionEquality.unordered()
            .equals(other.supportedFeatures, supportedFeatures) &&
        other.maxNumberInstances == maxNumberInstances;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        description,
        MiscTools.hashAllUnorderedMap(configurationSchema),
        MiscTools.hashAllUnorderedMap(triggerSchema),
        MiscTools.hashAllUnorderedMap(stateSchema),
        version,
        metadata,
        Object.hashAllUnordered(supportedFeatures),
        maxNumberInstances,
      );

  @override
  String toString() =>
      "Instance of 'BehaviorScript' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
