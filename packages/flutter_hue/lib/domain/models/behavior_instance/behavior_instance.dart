// ignore_for_file: deprecated_member_use_from_same_package

import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/behavior_instance/behavior_instance_dependee.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_id_exception.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// API to manage instances of script.
class BehaviorInstance extends Resource {
  /// Creates a [BehaviorInstance] object.
  BehaviorInstance({
    required super.type,
    required super.id,
    this.idV1 = "",
    required String scriptId,
    required this.isEnabled,
    required this.state,
    required this.configuration,
    required this.dependees,
    required this.status,
    required this.lastError,
    required String name,
    required String migratedFrom,
    this.trigger,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        assert(scriptId.isEmpty || Validators.isValidScriptId(scriptId),
            '"$scriptId" is not a valid `scriptId`'),
        assert(migratedFrom.isEmpty || Validators.isValidIdV1(migratedFrom),
            '"$migratedFrom" is not a valid `migratedFrom`'),
        assert(name.isEmpty || Validators.isValidName(name),
            "`name` must be between 1 and 32 characters (inclusive)"),
        _scriptId = scriptId,
        _originalScriptId = scriptId,
        _originalIsEnabled = isEnabled,
        _originalConfiguration = Map<String, dynamic>.from(configuration),
        _name = name,
        _originalName = name,
        _migratedFrom = migratedFrom,
        _originalMigratedFrom = migratedFrom,
        _originalTrigger =
            trigger == null ? null : Map<String, dynamic>.from(trigger);

  /// Creates a [BehaviorInstance] object from the JSON response to a GET
  /// request.
  factory BehaviorInstance.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    List<Map<String, dynamic>> dependeeMaps =
        List<Map<String, dynamic>>.from(data[ApiFields.dependees] ?? []);

    return BehaviorInstance(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      scriptId: data[ApiFields.scriptId] ?? "",
      isEnabled: data[ApiFields.isEnabled] ?? false,
      state: Map<String, dynamic>.from(data[ApiFields.state] ?? {}),
      configuration:
          Map<String, dynamic>.from(data[ApiFields.configuration] ?? {}),
      dependees: dependeeMaps
          .map((dependeeMap) => BehaviorInstanceDependee.fromJson(dependeeMap))
          .toList(),
      status: data[ApiFields.status] ?? "",
      lastError: data[ApiFields.lastError] ?? "",
      name: Map<String, dynamic>.from(
              data[ApiFields.metadata] ?? {})[ApiFields.name] ??
          "",
      migratedFrom: data[ApiFields.migratedFrom] ?? "",
      trigger: data[ApiFields.trigger] == null
          ? null
          : Map<String, dynamic>.from(data[ApiFields.trigger]),
    );
  }

  /// Creates an empty [BehaviorInstance] object.
  BehaviorInstance.empty()
      : idV1 = "",
        _scriptId = "",
        isEnabled = false,
        state = {},
        configuration = {},
        dependees = [],
        status = "",
        lastError = "",
        _name = "",
        _migratedFrom = "",
        trigger = {},
        _originalScriptId = "",
        _originalIsEnabled = false,
        _originalConfiguration = {},
        _originalName = "",
        _originalMigratedFrom = "",
        _originalTrigger = {},
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  String _scriptId;

  /// Identifier to ScriptDefinition.
  ///
  /// Regex pattern `^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$`
  ///
  /// Throws [InvalidIdException] if `scriptId` is set to a string that does not
  /// match the regex pattern.
  String get scriptId => _scriptId;
  set scriptId(String scriptId) {
    if (Validators.isValidScriptId(scriptId)) {
      _scriptId = scriptId;
    } else {
      throw InvalidIdException.withValue(scriptId);
    }
  }

  /// The value of [scriptId] when this object was instantiated.
  String _originalScriptId;

  /// Whether or not this script is enabled.
  bool isEnabled;

  /// The value of [isEnabled] when this object was instantiated.
  bool _originalIsEnabled;

  /// Script instance state.
  ///
  /// This read-only property is according to ScriptDefinition.state_schema JSON
  /// schema.
  final Map<String, dynamic> state;

  /// Script configuration.
  ///
  /// This property is validated using ScriptDefinition.configuration_schema
  /// JSON schema.
  Map<String, dynamic> configuration;

  /// The value of [configuration] when this object was instantiated.
  Map<String, dynamic> _originalConfiguration;

  /// Represents all resources which this instance depends on.
  final List<BehaviorInstanceDependee> dependees;

  /// Returns a list of the targets as [Resource] objects.
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if a
  /// target can not be found on the [hueNetwork], or if the target's
  /// [ResourceType] cannot be found on the [hueNetwork].
  List<Resource> get targetsAsResources {
    List<Relative> targets =
        dependees.map((dependee) => dependee.target).toList();

    return getRelativesAsResources(targets);
  }

  /// Script status.
  ///
  /// If the script is in the errored state then check errors for more details
  /// about the error.
  ///
  /// one of: initializing, running, disabled, errored
  final String status;

  /// The last error that happened while executing this script.
  final String lastError;

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

  String _migratedFrom;

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  ///
  /// Throws [InvalidIdException] if `scriptId` is set to a string that does not
  /// match the regex pattern.
  String get migratedFrom => _migratedFrom;
  set migratedFrom(String migratedFrom) {
    if (Validators.isValidIdV1(migratedFrom)) {
      _migratedFrom = migratedFrom;
    } else {
      throw InvalidIdException.withValue(migratedFrom);
    }
  }

  /// The value of [migratedFrom] when this object was instantiated.
  String _originalMigratedFrom;

  /// Action that needs to be taken by this script instance.
  ///
  /// This property is validated using ScriptDefinition.trigger_schema JSON
  /// schema.
  Map<String, dynamic>? trigger;

  /// The value of [trigger] when this object was instantiated.
  Map<String, dynamic>? _originalTrigger;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    _originalScriptId = scriptId;
    _originalIsEnabled = isEnabled;
    _originalConfiguration = Map<String, dynamic>.from(configuration);
    _originalName = name;
    _originalMigratedFrom = migratedFrom;
    _originalTrigger =
        trigger == null ? null : Map<String, dynamic>.from(trigger!);
    super.refreshOriginals();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [trigger] is nullable, it is defaulted to an empty map in this
  /// method. If left as an empty map, its current value in this
  /// [BehaviorInstance] object will be used. This way, if it is `null`, the
  /// program will know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  BehaviorInstance copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    String? scriptId,
    bool? isEnabled,
    Map<String, dynamic>? state,
    Map<String, dynamic>? configuration,
    List<BehaviorInstanceDependee>? dependees,
    String? status,
    String? lastError,
    String? name,
    String? migratedFrom,
    Map<String, dynamic>? trigger = const {},
    bool copyOriginalValues = true,
  }) {
    BehaviorInstance toReturn = BehaviorInstance(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      scriptId:
          copyOriginalValues ? _originalScriptId : (scriptId ?? this.scriptId),
      isEnabled: copyOriginalValues
          ? _originalIsEnabled
          : (isEnabled ?? this.isEnabled),
      state: state ?? Map<String, dynamic>.from(this.state),
      configuration: copyOriginalValues
          ? Map<String, dynamic>.from(_originalConfiguration)
          : (configuration ?? Map<String, dynamic>.from(this.configuration)),
      dependees: dependees ??
          this.dependees.map((dependee) => dependee.copyWith()).toList(),
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      name: copyOriginalValues ? _originalName : (name ?? this.name),
      migratedFrom: copyOriginalValues
          ? _originalMigratedFrom
          : (migratedFrom ?? this.migratedFrom),
      trigger: copyOriginalValues
          ? _originalTrigger == null
              ? null
              : Map<String, dynamic>.from(_originalTrigger!)
          : (trigger == null || trigger.isNotEmpty
              ? trigger
              : (this.trigger == null
                  ? null
                  : Map<String, dynamic>.from(this.trigger!))),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.scriptId = scriptId ?? this.scriptId;
      toReturn.isEnabled = isEnabled ?? this.isEnabled;
      toReturn.configuration =
          configuration ?? Map<String, dynamic>.from(this.configuration);
      toReturn.name = name ?? this.name;
      toReturn.migratedFrom = migratedFrom ?? this.migratedFrom;
      toReturn.trigger = trigger == null || trigger.isNotEmpty
          ? trigger
          : (this.trigger == null
              ? null
              : Map<String, dynamic>.from(this.trigger!));
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
  ///
  /// Throws [InvalidIdException] if [scriptId] or [migratedFrom] are not valid
  /// and `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    /// Validate data.
    if (!identical(optimizeFor, OptimizeFor.dontOptimize)) {
      if (!Validators.isValidName(name)) {
        if (!identical(optimizeFor, OptimizeFor.put) || name != _originalName) {
          throw InvalidNameException.withValue(name);
        }
      }

      if (identical(optimizeFor, OptimizeFor.post)) {
        if (!Validators.isValidScriptId(scriptId)) {
          throw InvalidIdException.withValue(scriptId);
        }

        if (!Validators.isValidIdV1(migratedFrom)) {
          throw InvalidIdException.withValue(migratedFrom);
        }
      }
    }

    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (type != originalType) {
        toReturn[ApiFields.type] = type.value;
      }

      if (isEnabled != _originalIsEnabled) {
        toReturn[ApiFields.isEnabled] = isEnabled;
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(configuration, _originalConfiguration)) {
        toReturn[ApiFields.configuration] = configuration;
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(trigger, _originalTrigger)) {
        toReturn[ApiFields.trigger] = trigger;
      }

      if (name != _originalName) {
        toReturn[ApiFields.metadata] = {ApiFields.name: name};
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
        ApiFields.isEnabled: isEnabled,
        ApiFields.configuration: configuration,
        ApiFields.trigger: trigger,
        ApiFields.metadata: {ApiFields.name: name},
      };
    }

    // POST
    if (identical(optimizeFor, OptimizeFor.post)) {
      return {
        ApiFields.type: type,
        ApiFields.scriptId: scriptId,
        ApiFields.isEnabled: isEnabled,
        ApiFields.configuration: configuration,
        ApiFields.metadata: {ApiFields.name: name},
        ApiFields.migratedFrom: migratedFrom,
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.scriptId: scriptId,
      ApiFields.isEnabled: isEnabled,
      ApiFields.state: state,
      ApiFields.configuration: configuration,
      ApiFields.dependees: dependees
          .map((dependee) => dependee.toJson(optimizeFor: optimizeFor))
          .toList(),
      ApiFields.status: status,
      ApiFields.lastError: lastError,
      ApiFields.metadata: {ApiFields.name: name},
      ApiFields.migratedFrom: migratedFrom,
      ApiFields.trigger: trigger,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is BehaviorInstance &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.scriptId == scriptId &&
        other.isEnabled == isEnabled &&
        const DeepCollectionEquality.unordered().equals(other.state, state) &&
        const DeepCollectionEquality.unordered()
            .equals(other.configuration, configuration) &&
        const DeepCollectionEquality.unordered()
            .equals(other.dependees, dependees) &&
        other.status == status &&
        other.lastError == lastError &&
        other.name == name &&
        other.migratedFrom == migratedFrom &&
        const DeepCollectionEquality.unordered().equals(other.trigger, trigger);
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        scriptId,
        isEnabled,
        MiscTools.hashAllUnorderedMap(state),
        MiscTools.hashAllUnorderedMap(configuration),
        Object.hashAllUnordered(dependees),
        status,
        lastError,
        name,
        migratedFrom,
        (trigger == null ? null : MiscTools.hashAllUnorderedMap(trigger!)),
      );

  @override
  String toString() =>
      "Instance of 'BehaviorInstance' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
