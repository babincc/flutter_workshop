/// The type of supported resource.
enum ResourceType {
  device("device"),
  bridgeHome("bridge_home"),
  room("room"),
  zone("zone"),
  light("light"),
  button("button"),
  relativeRotary("relative_rotary"),
  temperature("temperature"),
  lightLevel("light_level"),
  motion("motion"),
  entertainment("entertainment"),
  groupedLight("grouped_light"),
  devicePower("device_power"),
  zigbeeBridgeConnectivity("zigbee_bridge_connectivity"),
  zigbeeConnectivity("zigbee_connectivity"),
  zgpConnectivity("zgp_connectivity"),
  bridge("bridge"),
  zigbeeDeviceDiscovery("zigbee_device_discovery"),
  homekit("homekit"),
  matter("matter"),
  matterFabric("matter_fabric"),
  scene("scene"),
  entertainmentConfiguration("entertainment_configuration"),
  publicImage("public_image"),
  authV1("auth_v1"),
  behaviorScript("behavior_script"),
  behaviorInstance("behavior_instance"),
  geofence("geofence"),
  geofenceClient("geofence_client"),
  geolocation("geolocation"),
  smartScene("smart_scene");

  const ResourceType(this.value);

  /// The string representation of this [ResourceType].
  final String value;

  /// Get a [ResourceType] from a given string `value`.
  static ResourceType fromString(String value) {
    return values.firstWhere(
      (type) => type.value == value,
      orElse: () => device,
    );
  }
}
