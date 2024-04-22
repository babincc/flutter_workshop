// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_channel/entertainment_configuration_channel.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_location.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_metadata.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_stream_proxy.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_bundle.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_controller.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// The configuration settings for an entertainment resource.
class EntertainmentConfiguration extends Resource {
  /// Creates a [EntertainmentConfiguration] object.
  EntertainmentConfiguration({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.metadata,
    this.name = "",
    required this.configurationType,
    required this.status,
    required this.activeStreamer,
    required this.streamProxy,
    required this.channels,
    required this.locations,
    required this.lightServices,
    this.action,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        assert(name.isEmpty || Validators.isValidName(name),
            "`name` must be between 1 and 32 characters (inclusive)"),
        _originalMetadata = metadata,
        _originalConfigurationType = configurationType,
        _originalAction = action,
        _originalStreamProxy = streamProxy.copyWith(),
        _originalLocations =
            locations.map((location) => location.copyWith()).toList();

  /// Creates a [EntertainmentConfiguration] object from the JSON response to a
  /// GET request.
  factory EntertainmentConfiguration.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    final Map<String, dynamic> locations =
        Map<String, dynamic>.from(data[ApiFields.locations] ?? {});

    final List<dynamic>? serviceLocations =
        locations[ApiFields.serviceLocations];

    return EntertainmentConfiguration(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      metadata: EntertainmentConfigurationMetadata.fromJson(
          Map<String, dynamic>.from(data[ApiFields.metadata] ?? {})),
      name: data[ApiFields.name] ?? "",
      configurationType: data[ApiFields.configurationType] ?? "",
      status: data[ApiFields.status] ?? "",
      activeStreamer: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.activeStreamer] ?? {})),
      streamProxy: EntertainmentConfigurationStreamProxy.fromJson(
          Map<String, dynamic>.from(data[ApiFields.streamProxy] ?? {})),
      channels: (data[ApiFields.channels] as List<dynamic>?)
              ?.map((channelMap) => EntertainmentConfigurationChannel.fromJson(
                  Map<String, dynamic>.from(channelMap)))
              .toList() ??
          [],
      locations: serviceLocations
              ?.map((locationMap) =>
                  EntertainmentConfigurationLocation.fromJson(
                      Map<String, dynamic>.from(locationMap)))
              .toList() ??
          [],
      lightServices: (data[ApiFields.lightServices] as List<dynamic>?)
              ?.map((lightServiceMap) =>
                  Relative.fromJson(Map<String, dynamic>.from(lightServiceMap)))
              .toList() ??
          [],
      action: data[ApiFields.action],
    );
  }

  /// Creates an empty [EntertainmentConfiguration] object.
  EntertainmentConfiguration.empty()
      : idV1 = "",
        metadata = EntertainmentConfigurationMetadata.empty(),
        _originalMetadata = EntertainmentConfigurationMetadata.empty(),
        name = "",
        configurationType = "",
        _originalConfigurationType = "",
        status = "",
        activeStreamer = Relative.empty(),
        streamProxy = EntertainmentConfigurationStreamProxy.empty(),
        _originalStreamProxy = EntertainmentConfigurationStreamProxy.empty(),
        channels = [],
        locations = [],
        _originalLocations = [],
        lightServices = [],
        _originalAction = null,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// The metadata for this entertainment configuration.
  EntertainmentConfigurationMetadata metadata;

  /// The value of [metadata] when this object was instantiated.
  EntertainmentConfigurationMetadata _originalMetadata;

  /// Human readable name of a resource.
  ///
  /// Length: 1 - 32 chars
  @Deprecated("Use metadata.name")
  final String name;

  /// Defines for which type of application this channel assignment was
  /// optimized for:
  ///
  /// * "screen": Channels are organized around content from a screen
  /// * "monitor": Channels are organized around content from one or several
  /// monitors
  /// * "music": Channels are organized for music synchronization
  /// * "3dspace: Channels are organized to provide 3d spacial effects
  /// * "other": General use case
  String configurationType;

  /// The value of [configurationType] when this object was instantiated.
  String _originalConfigurationType;

  /// Read only field reporting if the stream is active or not
  ///
  /// one of: active, inactive
  final String status;

  /// Expected value is of a ResourceIdentifier of the type auth_v1 i.e. an
  /// application id, only available if status is active
  final Relative activeStreamer;

  /// Returns a [Resource] object that represents the [activeStreamer] of this
  /// [Resource].
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if the
  /// [activeStreamer] cannot be found on the [hueNetwork], or if the
  /// [activeStreamer]'s [ResourceType] cannot be found on the [hueNetwork].
  Resource get activeStreamerAsResource =>
      getRelativeAsResource(activeStreamer);

  /// The proxy for this entertainment configuration stream.
  EntertainmentConfigurationStreamProxy streamProxy;

  /// The value of [streamProxy] when this object was instantiated.
  EntertainmentConfigurationStreamProxy _originalStreamProxy;

  /// Returns a proxy nodes as a [Resource] object.
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if the
  /// node can not be found on the [hueNetwork], or if the node's [ResourceType]
  /// cannot be found on the [hueNetwork].
  Resource get proxyNodeAsResource => getRelativeAsResource(streamProxy.node);

  /// Holds the channels. Each channel groups segments of one or different
  /// light.
  final List<EntertainmentConfigurationChannel> channels;

  /// Returns a list of the channel members as [Resource] objects.
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if a
  /// member can not be found on the [hueNetwork], or if the member's
  /// [ResourceType] cannot be found on the [hueNetwork].
  List<Resource> get channelMemberServicesAsResources {
    List<Relative> members = [];

    for (EntertainmentConfigurationChannel channel in channels) {
      members.addAll(channel.members.map((member) => member.service).toList());
    }

    return getRelativesAsResources(members);
  }

  /// Entertainment services of the lights that are in the zone have locations.
  List<EntertainmentConfigurationLocation> locations;

  /// The value of [locations] when this object was instantiated.
  List<EntertainmentConfigurationLocation> _originalLocations;

  /// Returns a list of the location services as [Resource] objects.
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if a
  /// service can not be found on the [hueNetwork], or if the service's
  /// [ResourceType] cannot be found on the [hueNetwork].
  List<Resource> get locationServicesAsResources {
    List<Relative> services =
        locations.map((location) => location.service).toList();

    return getRelativesAsResources(services);
  }

  /// List of light services that belong to this entertainment configuration.
  @Deprecated("resolve via entertainment services in locations object")
  final List<Relative> lightServices;

  /// Returns a list of the [lightServices] as [Resource] objects.
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if a
  /// service can not be found on the [hueNetwork], or if the service's
  /// [ResourceType] cannot be found on the [hueNetwork].
  @Deprecated("resolve via entertainment services in locations object")
  List<Resource> get lightServicesAsResources =>
      getRelativesAsResources(lightServices);

  /// If status is:
  ///
  /// * "inactive" -> write "start" to start streaming. Writing start when it's
  /// already active does not change the ownership of the streaming.
  /// * "active" -> write "stop" to end the current streaming. In order to start
  /// streaming when other application is already streaming first write "stop"
  /// and then "start"
  String? action;

  /// The value of [action] when this object was instantiated.
  String? _originalAction;

  /// Handles the entertainment stream.
  final EntertainmentStreamController _entertainmentStream =
      EntertainmentStreamController();

  /// Start streaming for `this` entertainment configuration.
  ///
  /// The `bridge` parameter is the bridge to establish the handshake with.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  Future<bool> startStreaming(
    Bridge bridge, {
    String Function(String ciphertext)? decrypter,
  }) async =>
      await _entertainmentStream.startStreaming(
        bridge,
        id,
        decrypter: decrypter,
      );

  /// Stop streaming for `this` entertainment configuration.
  ///
  /// The `bridge` parameter is the bridge to establish the handshake with.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  Future<bool> stopStreaming(
    Bridge bridge, {
    String Function(String ciphertext)? decrypter,
  }) async =>
      _entertainmentStream.stopStreaming(
        bridge,
        id,
        decrypter: decrypter,
      );

  /// The current length of the queue.
  ///
  /// This is the number of packets that are waiting to be sent to the bridge.
  ///
  /// This is used to see if the queue is getting backed up. If so, you can call
  /// [replaceStreamQueue] to replace the queue with a new packet.
  int get queueLength => _entertainmentStream.queueLength;

  /// Adds a packet to the stream queue.
  void addToStreamQueue(EntertainmentStreamBundle packet) =>
      _entertainmentStream.addToQueue(packet);

  /// Adds a list of packets to the stream queue.
  void addAllToStreamQueue(List<EntertainmentStreamBundle> packets) =>
      _entertainmentStream.addAllToQueue(packets);

  /// Replaces the stream queue with the packets provided.
  void replaceStreamQueue(List<EntertainmentStreamBundle> packets) =>
      _entertainmentStream.replaceQueue(packets);

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    metadata.refreshOriginals();
    _originalMetadata = metadata.copyWith();
    _originalConfigurationType = configurationType;
    streamProxy.refreshOriginals();
    _originalStreamProxy = streamProxy.copyWith();
    _originalLocations = locations.map((location) {
      location.refreshOriginals();
      return location.copyWith();
    }).toList();
    _originalAction = action;
    super.refreshOriginals();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [action] is nullable, it is defaulted to an empty string in this
  /// method. If left as an empty string, its current value in this
  /// [EntertainmentConfiguration] object will be used. This way, if it is
  /// `null`, the program will know that it is intentionally being set to
  /// `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  EntertainmentConfiguration copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    EntertainmentConfigurationMetadata? metadata,
    String? name,
    String? configurationType,
    String? status,
    Relative? activeStreamer,
    EntertainmentConfigurationStreamProxy? streamProxy,
    List<EntertainmentConfigurationChannel>? channels,
    List<EntertainmentConfigurationLocation>? locations,
    List<Relative>? lightServices,
    String? action = "",
    bool copyOriginalValues = true,
  }) {
    EntertainmentConfiguration toReturn = EntertainmentConfiguration(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      metadata: copyOriginalValues
          ? _originalMetadata.copyWith(copyOriginalValues: copyOriginalValues)
          : (metadata ??
              this.metadata.copyWith(copyOriginalValues: copyOriginalValues)),
      name: name ?? this.name,
      configurationType: copyOriginalValues
          ? _originalConfigurationType
          : (configurationType ?? this.configurationType),
      status: status ?? this.status,
      activeStreamer: activeStreamer ?? this.activeStreamer,
      streamProxy: copyOriginalValues
          ? _originalStreamProxy
          : (streamProxy ?? this.streamProxy),
      channels: channels ??
          this.channels.map((channel) => channel.copyWith()).toList(),
      locations: copyOriginalValues
          ? _originalLocations
          : (locations ??
              this.locations.map((location) => location.copyWith()).toList()),
      lightServices: lightServices ??
          this
              .lightServices
              .map((lightService) => lightService.copyWith())
              .toList(),
      action: copyOriginalValues
          ? _originalAction
          : (action == null || action.isNotEmpty ? action : this.action),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.metadata = metadata ??
          this.metadata.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.configurationType = configurationType ?? this.configurationType;
      toReturn.streamProxy = streamProxy ?? this.streamProxy;
      toReturn.locations = locations ??
          this.locations.map((location) => location.copyWith()).toList();
      toReturn.action =
          action == null || action.isNotEmpty ? action : this.action;
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
  /// Throws [InvalidNameException] if [metadata.name] doesn't have a length of
  /// 1 - 32 (inclusive) and `optimizeFor` is not set to
  /// [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (type != originalType) {
        toReturn[ApiFields.type] = type.value;
      }

      if (metadata != _originalMetadata) {
        toReturn[ApiFields.metadata] =
            metadata.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (configurationType != _originalConfigurationType) {
        toReturn[ApiFields.configurationType] = configurationType;
      }

      if (action != _originalAction) {
        toReturn[ApiFields.action] = action;
      }

      if (streamProxy != _originalStreamProxy) {
        toReturn[ApiFields.streamProxy] = streamProxy;
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(locations, _originalLocations)) {
        toReturn[ApiFields.locations] = {
          ApiFields.serviceLocations: locations
              .map((location) =>
                  location.toJson(optimizeFor: OptimizeFor.putFull))
              .toList()
        };
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
        ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
        ApiFields.configurationType: configurationType,
        ApiFields.action: action,
        ApiFields.streamProxy: streamProxy.toJson(optimizeFor: optimizeFor),
        ApiFields.locations: {
          ApiFields.serviceLocations: locations
              .map((location) =>
                  location.toJson(optimizeFor: OptimizeFor.putFull))
              .toList(),
        },
      };
    }

    // POST
    if (identical(optimizeFor, OptimizeFor.post)) {
      return {
        ApiFields.type: type.value,
        ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
        ApiFields.configurationType: configurationType,
        ApiFields.streamProxy: streamProxy.toJson(optimizeFor: optimizeFor),
        ApiFields.locations: {
          ApiFields.serviceLocations: locations
              .map((location) => location.toJson(optimizeFor: optimizeFor))
              .toList(),
        },
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
      ApiFields.name: name,
      ApiFields.configurationType: configurationType,
      ApiFields.status: status,
      ApiFields.activeStreamer: activeStreamer.toJson(optimizeFor: optimizeFor),
      ApiFields.streamProxy: streamProxy.toJson(optimizeFor: optimizeFor),
      ApiFields.channels: channels
          .map((channel) => channel.toJson(optimizeFor: optimizeFor))
          .toList(),
      ApiFields.locations: {
        ApiFields.serviceLocations: locations
            .map((location) => location.toJson(optimizeFor: optimizeFor))
            .toList(),
      },
      ApiFields.lightServices: lightServices
          .map((lightService) => lightService.toJson(optimizeFor: optimizeFor))
          .toList(),
      ApiFields.action: action,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is EntertainmentConfiguration &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.metadata == metadata &&
        other.name == name &&
        other.configurationType == configurationType &&
        other.status == status &&
        other.activeStreamer == activeStreamer &&
        other.streamProxy == streamProxy &&
        const DeepCollectionEquality.unordered()
            .equals(other.channels, channels) &&
        const DeepCollectionEquality.unordered()
            .equals(other.locations, locations) &&
        const DeepCollectionEquality.unordered()
            .equals(other.lightServices, lightServices) &&
        other.action == action;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        metadata,
        name,
        configurationType,
        status,
        activeStreamer,
        streamProxy,
        Object.hashAllUnordered(channels),
        Object.hashAllUnordered(locations),
        Object.hashAllUnordered(lightServices),
        action,
      );

  @override
  String toString() =>
      "Instance of 'EntertainmentConfiguration' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
