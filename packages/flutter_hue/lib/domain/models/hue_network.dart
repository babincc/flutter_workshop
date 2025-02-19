import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/behavior_instance/behavior_instance.dart';
import 'package:flutter_hue/domain/models/behavior_script/behavior_script.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/bridge/bridge_extensions.dart';
import 'package:flutter_hue/domain/models/bridge_home/bridge_home.dart';
import 'package:flutter_hue/domain/models/button/button.dart';
import 'package:flutter_hue/domain/models/device/device.dart';
import 'package:flutter_hue/domain/models/device_power/device_power.dart';
import 'package:flutter_hue/domain/models/entertainment/entertainment.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration.dart';
import 'package:flutter_hue/domain/models/failed_resource.dart';
import 'package:flutter_hue/domain/models/geofence_client/geofence_client.dart';
import 'package:flutter_hue/domain/models/geolocation/geolocation.dart';
import 'package:flutter_hue/domain/models/grouped_light/grouped_light.dart';
import 'package:flutter_hue/domain/models/homekit/homekit.dart';
import 'package:flutter_hue/domain/models/light/light.dart';
import 'package:flutter_hue/domain/models/light_level/light_level.dart';
import 'package:flutter_hue/domain/models/matter/matter.dart';
import 'package:flutter_hue/domain/models/matter_fabric/matter_fabric.dart';
import 'package:flutter_hue/domain/models/motion/motion.dart';
import 'package:flutter_hue/domain/models/relative_rotary/relative_rotary.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/room/room.dart';
import 'package:flutter_hue/domain/models/scene/scene.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene.dart';
import 'package:flutter_hue/domain/models/temperature/temperature.dart';
import 'package:flutter_hue/domain/models/zgp_connectivity/zgp_connectivity.dart';
import 'package:flutter_hue/domain/models/zigbee_connectivity/zigbee_connectivity.dart';
import 'package:flutter_hue/domain/models/zigbee_device_discovery/zigbee_device_discovery.dart';
import 'package:flutter_hue/domain/models/zone/zone.dart';
import 'package:flutter_hue/domain/repos/hue_http_repo.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';

class HueNetwork {
  HueNetwork({required List<Bridge> bridges})
      : assert(!bridges.map((bridge) => bridge.ipAddress).contains(null),
            "All bridges must have an IP address"),
        assert(!bridges.map((bridge) => bridge.applicationKey).contains(null),
            "All bridges must have an application key"),
        _bridges = bridges;

  List<Bridge> _bridges;

  /// All of the bridges the user's device has access to on the network.
  ///
  /// When setting this value, it will throw an [Exception] if any of the
  /// bridges do not have an IP address or an application key.
  List<Bridge> get bridges => List<Bridge>.unmodifiable(_bridges);
  set bridges(List<Bridge> bridges) {
    for (Bridge bridge in bridges) {
      if (bridge.ipAddress == null) {
        throw Exception("All bridges must have an IP address");
      }

      if (bridge.applicationKey == null) {
        throw Exception("All bridges must have an application key");
      }
    }

    _bridges = bridges;
  }

  /// Adds a `bridge` to the [bridges] list.
  ///
  /// Returns `true` if the `bridge` was added to the list.
  ///
  /// If the `bridge` does not have an IP address, it will not be added to the
  /// list, and `false` will be returned.
  bool addBridge(Bridge bridge) {
    if (bridge.ipAddress == null || bridge.applicationKey == null) {
      return false;
    }

    bridge.hueNetwork = this;

    _bridges.add(bridge);

    return true;
  }

  /// Adds a `bridge` to the [bridges] list.
  ///
  /// Returns `true` if the `bridge` was added to the list.
  ///
  /// If the `bridge` does not have an IP address, it will not be added to the
  /// list, and `false` will be returned.
  @Deprecated("Use [addBridge] instead")
  bool addPoint(Bridge bridge) => addBridge(bridge);

  /// Removes a `bridge` from the [bridges] list.
  ///
  /// Returns `true` if `bridge` was in the list, `false` otherwise.
  bool removeBridge(Bridge bridge) => _bridges.remove(bridge);

  /// Removes a `bridge` from the [bridges] list.
  ///
  /// Returns `true` if `bridge` was in the list, `false` otherwise.
  @Deprecated("Use [removeBridge] instead")
  bool removePoint(Bridge bridge) => removeBridge(bridge);

  /// A single list that contains all of the resource lists.
  ///
  /// This list and all of the lists within it are unmodifiable.
  List<List<Resource>> get resources => List.unmodifiable([
        behaviorInstances,
        behaviorScripts,
        bridgeHomes,
        buttons,
        devices,
        devicePowers,
        entertainments,
        entertainmentConfigurations,
        geofenceClients,
        geolocations,
        groupedLights,
        homekits,
        lights,
        lightLevels,
        matters,
        matterFabrics,
        motions,
        relativeRotaries,
        rooms,
        scenes,
        smartScenes,
        temperatures,
        zgpConnectivities,
        zigbeeConnectivities,
        zigbeeDeviceDiscoveries,
        zones,
      ]);

  final List<BehaviorInstance> _behaviorInstances = [];

  /// All of the [BehaviorInstance] objects on the network that the user's
  /// device has permission to access.
  ///
  /// This list is unmodifiable.
  List<BehaviorInstance> get behaviorInstances =>
      List.unmodifiable(_behaviorInstances);

  final List<BehaviorScript> _behaviorScripts = [];

  /// All of the [BehaviorScript] objects on the network that the user's device
  /// has permission to access.
  ///
  /// This list is unmodifiable.
  List<BehaviorScript> get behaviorScripts =>
      List.unmodifiable(_behaviorScripts);

  final List<BridgeHome> _bridgeHomes = [];

  /// All of the [BridgeHome] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<BridgeHome> get bridgeHomes => List.unmodifiable(_bridgeHomes);

  final List<Button> _buttons = [];

  /// All of the [Button] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Button> get buttons => List.unmodifiable(_buttons);

  final List<Device> _devices = [];

  /// All of the [Device] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Device> get devices => List.unmodifiable(_devices);

  final List<DevicePower> _devicePowers = [];

  /// All of the [DevicePower] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<DevicePower> get devicePowers => List.unmodifiable(_devicePowers);

  final List<Entertainment> _entertainments = [];

  /// All of the [Entertainment] objects on the network that the user's device
  /// has permission to access.
  ///
  /// This list is unmodifiable.
  List<Entertainment> get entertainments => List.unmodifiable(_entertainments);

  final List<EntertainmentConfiguration> _entertainmentConfigurations = [];

  /// All of the [EntertainmentConfiguration] objects on the network that the
  /// user's device has permission to access.
  ///
  /// This list is unmodifiable.
  List<EntertainmentConfiguration> get entertainmentConfigurations =>
      List.unmodifiable(_entertainmentConfigurations);

  final List<GeofenceClient> _geofenceClients = [];

  /// All of the [GeofenceClient] objects on the network that the user's device
  /// has permission to access.
  ///
  /// This list is unmodifiable.
  List<GeofenceClient> get geofenceClients =>
      List.unmodifiable(_geofenceClients);

  final List<Geolocation> _geolocations = [];

  /// All of the [Geolocation] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Geolocation> get geolocations => List.unmodifiable(_geolocations);

  final List<GroupedLight> _groupedLights = [];

  /// All of the [GroupedLight] objects on the network that the user's device
  /// has permission to access.
  ///
  /// This list is unmodifiable.
  List<GroupedLight> get groupedLights => List.unmodifiable(_groupedLights);

  final List<Homekit> _homekits = [];

  /// All of the [Homekit] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Homekit> get homekits => List.unmodifiable(_homekits);

  final List<Light> _lights = [];

  /// All of the [Light] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Light> get lights => List.unmodifiable(_lights);

  final List<LightLevel> _lightLevels = [];

  /// All of the [LightLevel] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<LightLevel> get lightLevels => List.unmodifiable(_lightLevels);

  final List<Matter> _matters = [];

  /// All of the [Matter] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Matter> get matters => List.unmodifiable(_matters);

  final List<MatterFabric> _matterFabrics = [];

  /// All of the [MatterFabric] objects on the network that the user's device
  /// has permission to access.
  ///
  /// This list is unmodifiable.
  List<MatterFabric> get matterFabrics => List.unmodifiable(_matterFabrics);

  final List<Motion> _motions = [];

  /// All of the [Motion] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Motion> get motions => List.unmodifiable(_motions);

  final List<RelativeRotary> _relativeRotaries = [];

  /// All of the [RelativeRotary] objects on the network that the user's device
  /// has permission to access.
  ///
  /// This list is unmodifiable.
  List<RelativeRotary> get relativeRotaries =>
      List.unmodifiable(_relativeRotaries);

  final List<Room> _rooms = [];

  /// All of the [Room] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Room> get rooms => List.unmodifiable(_rooms);

  final List<Scene> _scenes = [];

  /// All of the [Scene] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Scene> get scenes => List.unmodifiable(_scenes);

  final List<SmartScene> _smartScenes = [];

  /// All of the [SmartScene] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<SmartScene> get smartScenes => List.unmodifiable(_smartScenes);

  final List<Temperature> _temperatures = [];

  /// All of the [Temperature] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Temperature> get temperatures => List.unmodifiable(_temperatures);

  final List<ZgpConnectivity> _zgpConnectivities = [];

  /// All of the [ZgpConnectivity] objects on the network that the user's device
  /// has permission to access.
  ///
  /// This list is unmodifiable.
  List<ZgpConnectivity> get zgpConnectivities =>
      List.unmodifiable(_zgpConnectivities);

  final List<ZigbeeConnectivity> _zigbeeConnectivities = [];

  /// All of the [ZigbeeConnectivity] objects on the network that the user's
  /// device has permission to access.
  ///
  /// This list is unmodifiable.
  List<ZigbeeConnectivity> get zigbeeConnectivities =>
      List.unmodifiable(_zigbeeConnectivities);

  final List<ZigbeeDeviceDiscovery> _zigbeeDeviceDiscoveries = [];

  /// All of the [ZigbeeDeviceDiscovery] objects on the network that the user's
  /// device has permission to access.
  ///
  /// This list is unmodifiable.
  List<ZigbeeDeviceDiscovery> get zigbeeDeviceDiscoveries =>
      List.unmodifiable(_zigbeeDeviceDiscoveries);

  final List<Zone> _zones = [];

  /// All of the [Zone] objects on the network that the user's device has
  /// permission to access.
  ///
  /// This list is unmodifiable.
  List<Zone> get zones => List.unmodifiable(_zones);

  final List<FailedResource> _failedFetches = [];

  /// All of the resources that failed to be fetched.
  ///
  /// Each [FailedResource] object contains an 'error' property that describes
  /// why the fetch failed.
  ///
  /// You can easily check if there are any failed fetches by calling
  /// [hasFailedFetches].
  ///
  /// Try calling [fetchAllFailed] to fetch all of the failed fetches.
  ///
  /// This list is unmodifiable, but it can be cleared with
  /// [clearFailedFetches].
  List<FailedResource> get failedFetches => List.unmodifiable(_failedFetches);

  /// Whether or not there are any failed fetches.
  bool get hasFailedFetches => _failedFetches.isNotEmpty;

  /// Adds a [FailedResource] to the [failedFetches] list.
  ///
  /// If the [FailedResource] is a duplicate of another [FailedResource] in the
  /// list, the duplicate will be removed, and the new [FailedResource] will be
  /// added.
  void _addFailedFetch(FailedResource failedResource) {
    final List<FailedResource> duplicates = _failedFetches
        .where((resource) =>
            resource.id == failedResource.id &&
            identical(resource.type, failedResource.type))
        .toList();

    for (final FailedResource duplicate in duplicates) {
      _failedFetches.remove(duplicate);
    }

    _failedFetches.add(failedResource);
  }

  /// Removes all of the failed fetches.
  void clearFailedFetches() => _failedFetches.clear();

  /// Fetch all of the Philip's Hue devices on the network that this device has
  /// permission to fetch.
  ///
  /// `bridges` If you only want to fetch resources from a specific bridge or
  /// bridges, you can provide a list of bridges. If this parameter is null, all
  /// bridges will be checked. If any of the bridges in the list are not already
  /// associated with this [HueNetwork], they will be ignored.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If this method fails to fetch a resource with an error, the resource will
  /// be added to the [failedFetches] list.
  Future<void> fetchAll({
    List<Bridge>? bridges,
    String Function(String ciphertext)? decrypter,
  }) async {
    final List<Bridge> bridgesToCheck;
    if (bridges == null) {
      bridgesToCheck = this.bridges;
    } else {
      bridgesToCheck = [];

      for (final Bridge bridge in bridges) {
        if (this.bridges.contains(bridge)) {
          bridgesToCheck.add(bridge);
        }
      }
    }

    if (bridgesToCheck.isEmpty) return;

    /// A map of all of the resource types on each bridge.
    ///
    /// No need to make calls for types the bridge doesn't have.
    final Map<Bridge, Set<ResourceType>> resourceTypesByBridge = {};

    for (final Bridge bridge in bridgesToCheck) {
      resourceTypesByBridge[bridge] = {};

      // Fetch all of the resource types on the bridge.
      final Map<String, dynamic>? dataMap;
      try {
        dataMap = await HueHttpRepo.get(
          bridgeIpAddr: bridge.ipAddress!,
          applicationKey: bridge.applicationKey!,
          resourceType: null,
          decrypter: decrypter,
        );
      } catch (e) {
        _addFailedFetch(
          FailedResource(
            id: '',
            type: ResourceType.device,
            bridge: bridge,
            error: ErrorType.unknown,
            additionalInfo: e.toString(),
          ),
        );
        continue;
      }

      if (dataMap == null) continue;

      /// Abbreviated raw data maps for the bridge's resources.
      List<Map<String, dynamic>>? abbrDataList =
          MiscTools.extractDataList(dataMap);

      // This would mean there is no useful data in the list.
      if (abbrDataList == null) continue;

      for (final Map<String, dynamic> rawMap in abbrDataList) {
        final ResourceType type =
            ResourceType.fromString(rawMap[ApiFields.type]);

        resourceTypesByBridge[bridge]!.add(type);
      }
    }

    // Go through all of the resource types on each bridge, and fetch all of
    // the resources of that type on the bridge.
    for (ResourceType type in ResourceType.values) {
      final List<Bridge> bridgesWithResourceType = [];

      for (final Bridge bridge in bridgesToCheck) {
        if (resourceTypesByBridge[bridge]!.contains(type)) {
          bridgesWithResourceType.add(bridge);
        }
      }

      if (bridgesWithResourceType.isEmpty) continue;

      await fetchAllType(type, decrypter: decrypter);
    }
  }

  /// Fetch all of the Philip's Hue devices on the network that this device has
  /// permission to fetch which failed to be fetched in the last fetch.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If this method fails to fetch a resource with an error, the resource will
  /// be added back to the [failedFetches] list.
  Future<void> fetchAllFailed({
    String Function(String ciphertext)? decrypter,
  }) async {
    for (final ResourceType type in ResourceType.values) {
      fetchAllFailedType(type, decrypter: decrypter);
    }
  }

  /// Fetch all of the Philip's Hue devices of the given `type` on the network
  /// that this device has permission to fetch which failed to be fetched in the
  /// last fetch.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If this method fails to fetch a resource with an error, the resource will
  /// be added back to the [failedFetches] list.
  Future<void> fetchAllFailedType(
    ResourceType type, {
    String Function(String ciphertext)? decrypter,
  }) async {
    final List<FailedResource> failedResources = [];

    for (final FailedResource resource in _failedFetches) {
      if (identical(resource.type, type)) {
        failedResources.add(resource);
      }
    }

    if (failedResources.isEmpty) return;

    // Fetch the resources that failed.
    for (final FailedResource resource in failedResources) {
      _failedFetches.remove(resource);

      await fetch(
        resourceId: resource.id,
        type: type,
        bridge: resource.bridge,
        decrypter: decrypter,
      );
    }
  }

  /// Fetch all of the Philip's Hue devices of the given `type` on the network
  /// that this device has permission to fetch.
  ///
  /// `bridges` If you only want to fetch resources from a specific bridge or
  /// bridges, you can provide a list of bridges. If this parameter is null, all
  /// bridges will be checked. If any of the bridges in the list are not already
  /// associated with this [HueNetwork], they will be ignored.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If this method fails to fetch a resource with an error, the resource will
  /// be added to the [failedFetches] list.
  Future<void> fetchAllType(
    ResourceType type, {
    List<Bridge>? bridges,
    String Function(String ciphertext)? decrypter,
  }) async {
    final List<Bridge> bridgesToCheck;
    if (bridges == null) {
      bridgesToCheck = this.bridges;
    } else {
      bridgesToCheck = [];

      for (final Bridge bridge in bridges) {
        if (this.bridges.contains(bridge)) {
          bridgesToCheck.add(bridge);
        }
      }
    }

    if (bridgesToCheck.isEmpty) return;

    // Eliminate the possibility of duplicates.
    final List<Resource>? resourceList = _getListType(type);
    if (resourceList == null) return;
    if (const DeepCollectionEquality.unordered()
        .equals(this.bridges, bridgesToCheck)) {
      resourceList.clear();
    } else {
      final List<Resource> resourcesToRemove = [];
      for (final Resource resource in resourceList) {
        if (resource.bridge != null &&
            bridgesToCheck.contains(resource.bridge)) {
          resourcesToRemove.add(resource);
        }
      }
      for (final Resource resource in resourcesToRemove) {
        resourceList.remove(resource);
      }
    }

    // Go through each bridge.
    for (Bridge bridge in bridgesToCheck) {
      final Map<String, dynamic>? dataMap;
      try {
        dataMap = await HueHttpRepo.get(
          bridgeIpAddr: bridge.ipAddress!,
          applicationKey: bridge.applicationKey!,
          resourceType: type,
          decrypter: decrypter,
        );
      } catch (e) {
        _addFailedFetch(
          FailedResource(
            id: '',
            type: type,
            bridge: bridge,
            error: ErrorType.typeNotFound,
            additionalInfo: e.toString(),
          ),
        );
        continue;
      }

      // This would mean there was an error in the GET request.
      if (dataMap == null) continue;

      /// Abbreviated raw data maps for all of the resources of the current
      /// type.
      List<Map<String, dynamic>>? abbrDataList =
          MiscTools.extractDataList(dataMap);

      // This would mean there is no useful data in the list.
      if (abbrDataList == null) continue;

      for (final Map<String, dynamic> rawMap in abbrDataList) {
        _mapToObject(type, bridge, rawMap);
      }
    }
  }

  /// Fetches the resource with the given `resourceId` and `type` from the
  /// network.
  ///
  /// If you know which bridge the resource is on, you can provide the `bridge`
  /// parameter to speed up the process.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If this method fails to fetch the resource with an error, the resource
  /// will be added to the [failedFetches] list.
  Future<void> fetch({
    required String resourceId,
    required ResourceType type,
    Bridge? bridge,
    String Function(String ciphertext)? decrypter,
  }) async {
    final List<Bridge> bridgesToCheck;
    if (bridge == null) {
      bridgesToCheck = bridges;
    } else {
      bridgesToCheck = [bridge];
    }

    bool found = false;

    for (final Bridge bridge in bridgesToCheck) {
      final Map<String, dynamic>? data;
      try {
        data = await HueHttpRepo.get(
          bridgeIpAddr: bridge.ipAddress!,
          applicationKey: bridge.applicationKey!,
          resourceType: type,
          pathToResource: resourceId,
          decrypter: decrypter,
        );
      } catch (e) {
        _addFailedFetch(
          FailedResource(
            id: resourceId,
            type: type,
            bridge: bridge,
            error: ErrorType.unknown,
            additionalInfo: e.toString(),
          ),
        );
        continue;
      }

      if (data == null) return;

      // This means the resource is not on this bridge.
      if (data.toString().contains('Not Found')) continue;

      found = true;

      _mapToObject(type, bridge, data);
    }

    if (!found) {
      _addFailedFetch(
        FailedResource(
          id: resourceId,
          type: type,
          bridge: bridge,
          error: ErrorType.notFound,
        ),
      );
    }
  }

  /// Takes the given `data` map and creates an object from it based on the given
  /// `type`.
  void _mapToObject(
    ResourceType type,
    Bridge bridge,
    Map<String, dynamic> data,
  ) {
    try {
      switch (type) {
        case ResourceType.device:
          _devices.add(Device.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.bridgeHome:
          _bridgeHomes.add(BridgeHome.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.room:
          _rooms.add(Room.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.zone:
          _zones.add(Zone.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.light:
          _lights.add(Light.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.button:
          _buttons.add(Button.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.relativeRotary:
          _relativeRotaries.add(RelativeRotary.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.temperature:
          _temperatures.add(Temperature.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.lightLevel:
          _lightLevels.add(LightLevel.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.motion:
          _motions.add(Motion.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.entertainment:
          _entertainments.add(Entertainment.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.groupedLight:
          _groupedLights.add(GroupedLight.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.devicePower:
          _devicePowers.add(DevicePower.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.zigbeeConnectivity:
          _zigbeeConnectivities.add(ZigbeeConnectivity.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.zgpConnectivity:
          _zgpConnectivities.add(ZgpConnectivity.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.zigbeeDeviceDiscovery:
          _zigbeeDeviceDiscoveries.add(ZigbeeDeviceDiscovery.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.homekit:
          _homekits.add(Homekit.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.matter:
          _matters.add(Matter.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.matterFabric:
          _matterFabrics.add(MatterFabric.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.scene:
          _scenes.add(Scene.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.entertainmentConfiguration:
          _entertainmentConfigurations
              .add(EntertainmentConfiguration.fromJson(data)
                ..bridge = bridge
                ..hueNetwork = this);
          break;
        case ResourceType.behaviorScript:
          _behaviorScripts.add(BehaviorScript.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.behaviorInstance:
          _behaviorInstances.add(BehaviorInstance.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.geofenceClient:
          _geofenceClients.add(GeofenceClient.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.geolocation:
          _geolocations.add(Geolocation.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        case ResourceType.smartScene:
          _smartScenes.add(SmartScene.fromJson(data)
            ..bridge = bridge
            ..hueNetwork = this);
          break;
        default:
        // Do nothing
      }
    } catch (e) {
      final String? id = data[ApiFields.id] as String?;

      _addFailedFetch(
        FailedResource(
          id: id ?? '',
          type: type,
          bridge: bridge,
          error: ErrorType.dataCorrupted,
          additionalInfo: e.toString(),
          json: data,
        ),
      );
    }
  }

  /// Returns the resource list that goes with the given `type`.
  List<Resource>? getListType(ResourceType type) {
    switch (type) {
      case ResourceType.device:
        return devices;
      case ResourceType.bridgeHome:
        return bridgeHomes;
      case ResourceType.room:
        return rooms;
      case ResourceType.zone:
        return zones;
      case ResourceType.light:
        return lights;
      case ResourceType.button:
        return buttons;
      case ResourceType.relativeRotary:
        return relativeRotaries;
      case ResourceType.temperature:
        return temperatures;
      case ResourceType.lightLevel:
        return lightLevels;
      case ResourceType.motion:
        return motions;
      case ResourceType.entertainment:
        return entertainments;
      case ResourceType.groupedLight:
        return groupedLights;
      case ResourceType.devicePower:
        return devicePowers;
      case ResourceType.zigbeeConnectivity:
        return zigbeeConnectivities;
      case ResourceType.zgpConnectivity:
        return zgpConnectivities;
      case ResourceType.zigbeeDeviceDiscovery:
        return zigbeeDeviceDiscoveries;
      case ResourceType.homekit:
        return homekits;
      case ResourceType.matter:
        return matters;
      case ResourceType.matterFabric:
        return matterFabrics;
      case ResourceType.scene:
        return scenes;
      case ResourceType.entertainmentConfiguration:
        return entertainmentConfigurations;
      case ResourceType.behaviorScript:
        return behaviorScripts;
      case ResourceType.behaviorInstance:
        return behaviorInstances;
      case ResourceType.geofenceClient:
        return geofenceClients;
      case ResourceType.geolocation:
        return geolocations;
      case ResourceType.smartScene:
        return smartScenes;
      default:
        return null;
    }
  }

  /// Returns the private resource list that goes with the given `type`.
  List<Resource>? _getListType(ResourceType type) {
    switch (type) {
      case ResourceType.device:
        return _devices;
      case ResourceType.bridgeHome:
        return _bridgeHomes;
      case ResourceType.room:
        return _rooms;
      case ResourceType.zone:
        return _zones;
      case ResourceType.light:
        return _lights;
      case ResourceType.button:
        return _buttons;
      case ResourceType.relativeRotary:
        return _relativeRotaries;
      case ResourceType.temperature:
        return _temperatures;
      case ResourceType.lightLevel:
        return _lightLevels;
      case ResourceType.motion:
        return _motions;
      case ResourceType.entertainment:
        return _entertainments;
      case ResourceType.groupedLight:
        return _groupedLights;
      case ResourceType.devicePower:
        return _devicePowers;
      case ResourceType.zigbeeConnectivity:
        return _zigbeeConnectivities;
      case ResourceType.zgpConnectivity:
        return _zgpConnectivities;
      case ResourceType.zigbeeDeviceDiscovery:
        return _zigbeeDeviceDiscoveries;
      case ResourceType.homekit:
        return _homekits;
      case ResourceType.matter:
        return _matters;
      case ResourceType.matterFabric:
        return _matterFabrics;
      case ResourceType.scene:
        return _scenes;
      case ResourceType.entertainmentConfiguration:
        return _entertainmentConfigurations;
      case ResourceType.behaviorScript:
        return _behaviorScripts;
      case ResourceType.behaviorInstance:
        return _behaviorInstances;
      case ResourceType.geofenceClient:
        return _geofenceClients;
      case ResourceType.geolocation:
        return _geolocations;
      case ResourceType.smartScene:
        return _smartScenes;
      default:
        return null;
    }
  }

  /// Sends a PUT request to the bridge for each resource in the list.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// NOTE: This method will not send a PUT request for a resource that has a
  /// null `bridge` property.
  Future<void> put({String Function(String ciphertext)? decrypter}) async {
    List<List<Resource>> nonPuttableResources = [
      bridgeHomes,
      behaviorScripts,
      matterFabrics,
    ];

    for (List<Resource> resourceList in resources) {
      if (nonPuttableResources.contains(resourceList)) continue;

      for (Resource resource in resourceList) {
        // Skip resources that don't have an update.
        if (!resource.hasUpdate) continue;

        Map<String, dynamic> data = resource.toJson();

        if (data.isEmpty) continue;

        if (resource.bridge != null) {
          await resource.bridge!.put(resource, decrypter: decrypter);
        }
      }
    }
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();

    buffer.write("[");
    for (List<Resource> resList in resources) {
      buffer.write("[");
      for (Resource res in resList) {
        buffer.write(JsonTool.writeJson(
            res.toJson(optimizeFor: OptimizeFor.dontOptimize)));
        if (res != resList.last) {
          buffer.write(",");
        }
      }
      buffer.write("]");

      if (resList != resources.last) {
        buffer.write(",");
      }
    }
    buffer.write("]");

    return buffer.toString();
  }
}
