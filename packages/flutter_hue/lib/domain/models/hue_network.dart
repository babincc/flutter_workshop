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
  /// Throws [Exception] if any of the bridges do not have an IP address or an
  /// application key.
  List<Bridge> get bridges => _bridges;
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
  List<List<Resource>> get resources => [
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
      ];

  /// All of the [BehaviorInstance] objects on the network that the user's
  /// device has permission to access.
  List<BehaviorInstance> behaviorInstances = [];

  /// All of the [BehaviorScript] objects on the network that the user's device
  /// has permission to access.
  List<BehaviorScript> behaviorScripts = [];

  /// All of the [BridgeHome] objects on the network that the user's device has
  /// permission to access.
  List<BridgeHome> bridgeHomes = [];

  /// All of the [Button] objects on the network that the user's device has
  /// permission to access.
  List<Button> buttons = [];

  /// All of the [Device] objects on the network that the user's device has
  /// permission to access.
  List<Device> devices = [];

  /// All of the [DevicePower] objects on the network that the user's device has
  /// permission to access.
  List<DevicePower> devicePowers = [];

  /// All of the [Entertainment] objects on the network that the user's device
  /// has permission to access.
  List<Entertainment> entertainments = [];

  /// All of the [EntertainmentConfiguration] objects on the network that the
  /// user's device has permission to access.
  List<EntertainmentConfiguration> entertainmentConfigurations = [];

  /// All of the [GeofenceClient] objects on the network that the user's device
  /// has permission to access.
  List<GeofenceClient> geofenceClients = [];

  /// All of the [Geolocation] objects on the network that the user's device has
  /// permission to access.
  List<Geolocation> geolocations = [];

  /// All of the [GroupedLight] objects on the network that the user's device
  /// has permission to access.
  List<GroupedLight> groupedLights = [];

  /// All of the [Homekit] objects on the network that the user's device has
  /// permission to access.
  List<Homekit> homekits = [];

  /// All of the [Light] objects on the network that the user's device has
  /// permission to access.
  List<Light> lights = [];

  /// All of the [LightLevel] objects on the network that the user's device has
  /// permission to access.
  List<LightLevel> lightLevels = [];

  /// All of the [Matter] objects on the network that the user's device has
  /// permission to access.
  List<Matter> matters = [];

  /// All of the [MatterFabric] objects on the network that the user's device
  /// has permission to access.
  List<MatterFabric> matterFabrics = [];

  /// All of the [Motion] objects on the network that the user's device has
  /// permission to access.
  List<Motion> motions = [];

  /// All of the [RelativeRotary] objects on the network that the user's device
  /// has permission to access.
  List<RelativeRotary> relativeRotaries = [];

  /// All of the [Room] objects on the network that the user's device has
  /// permission to access.
  List<Room> rooms = [];

  /// All of the [Scene] objects on the network that the user's device has
  /// permission to access.
  List<Scene> scenes = [];

  /// All of the [SmartScene] objects on the network that the user's device has
  /// permission to access.
  List<SmartScene> smartScenes = [];

  /// All of the [Temperature] objects on the network that the user's device has
  /// permission to access.
  List<Temperature> temperatures = [];

  /// All of the [ZgpConnectivity] objects on the network that the user's device
  /// has permission to access.
  List<ZgpConnectivity> zgpConnectivities = [];

  /// All of the [ZigbeeConnectivity] objects on the network that the user's
  /// device has permission to access.
  List<ZigbeeConnectivity> zigbeeConnectivities = [];

  /// All of the [ZigbeeDeviceDiscovery] objects on the network that the user's
  /// device has permission to access.
  List<ZigbeeDeviceDiscovery> zigbeeDeviceDiscoveries = [];

  /// All of the [Zone] objects on the network that the user's device has
  /// permission to access.
  List<Zone> zones = [];

  /// Fetch all of the Philip's Hue devices on the network that this device has
  /// permission to fetch.
  Future<void> fetchAll() async {
    // Go through all of the resource types on each bridge, and fetch all of
    // the resources of that type on the bridge.
    for (ResourceType type in ResourceType.values) {
      await fetchAllType(type);
    }
  }

  /// Fetch all of the Philip's Hue devices of the given `type` on the network
  /// that this device has permission to fetch.
  Future<void> fetchAllType(ResourceType type) async {
    // Eliminate the possibility of duplicates.
    List<Resource>? resourceList = _getListType(type);
    if (resourceList == null) return;
    resourceList.clear();

    // Go through each bridge.
    for (Bridge bridge in bridges) {
      Map<String, dynamic>? dataMap = await HueHttpRepo.get(
        bridgeIpAddr: bridge.ipAddress!,
        applicationKey: bridge.applicationKey!,
        resourceType: type,
      );

      // This would mean there was an error in the GET request.
      if (dataMap == null) continue;

      /// Abbreviated raw data maps for all of the resources of the current
      /// type.
      List<Map<String, dynamic>>? abbrDataList =
          MiscTools.extractDataList(dataMap);

      // This would mean there is no useful data in the list.
      if (abbrDataList == null) continue;

      List<String?> ids = abbrDataList
          .map((rawMap) => rawMap[ApiFields.id] as String?)
          .toList();

      for (String? id in ids) {
        if (id == null) continue;

        Map<String, dynamic>? data = await HueHttpRepo.get(
          bridgeIpAddr: bridge.ipAddress!,
          applicationKey: bridge.applicationKey!,
          resourceType: type,
          pathToResource: id,
        );

        if (data == null) continue;

        switch (type) {
          case ResourceType.device:
            devices.add(Device.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.bridgeHome:
            bridgeHomes.add(BridgeHome.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.room:
            rooms.add(Room.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.zone:
            zones.add(Zone.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.light:
            lights.add(Light.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.button:
            buttons.add(Button.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.relativeRotary:
            relativeRotaries
                .add(RelativeRotary.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.temperature:
            temperatures.add(Temperature.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.lightLevel:
            lightLevels.add(LightLevel.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.motion:
            motions.add(Motion.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.entertainment:
            entertainments.add(Entertainment.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.groupedLight:
            groupedLights.add(GroupedLight.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.devicePower:
            devicePowers.add(DevicePower.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.zigbeeConnectivity:
            zigbeeConnectivities
                .add(ZigbeeConnectivity.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.zgpConnectivity:
            zgpConnectivities
                .add(ZgpConnectivity.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.zigbeeDeviceDiscovery:
            zigbeeDeviceDiscoveries
                .add(ZigbeeDeviceDiscovery.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.homekit:
            homekits.add(Homekit.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.matter:
            matters.add(Matter.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.matterFabric:
            matterFabrics.add(MatterFabric.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.scene:
            scenes.add(Scene.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.entertainmentConfiguration:
            entertainmentConfigurations.add(
                EntertainmentConfiguration.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.behaviorScript:
            behaviorScripts.add(BehaviorScript.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.behaviorInstance:
            behaviorInstances
                .add(BehaviorInstance.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.geofenceClient:
            geofenceClients.add(GeofenceClient.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.geolocation:
            geolocations.add(Geolocation.fromJson(data)..bridge = bridge);
            break;
          case ResourceType.smartScene:
            smartScenes.add(SmartScene.fromJson(data)..bridge = bridge);
            break;
          default:
          // Do nothing
        }
      }
    }
  }

  /// Returns the resource list that goes with the given `type`.
  List<Resource>? _getListType(ResourceType type) {
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

  /// Sends a PUT request to the bridge for each resource in the list.
  ///
  /// NOTE: This method will not send a PUT request for a resource that has a
  /// null `bridge` property.
  Future<void> put() async {
    List<List<Resource>> nonPuttableResources = [
      bridgeHomes,
      behaviorScripts,
      matterFabrics,
    ];

    for (List<Resource> resourceList in resources) {
      if (nonPuttableResources.contains(resourceList)) continue;

      for (Resource resource in resourceList) {
        Map<String, dynamic> data = resource.toJson();

        if (data.isEmpty) continue;

        if (resource.bridge != null) {
          await resource.bridge!.put(resource);
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
