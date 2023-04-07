enum DeviceArchetype {
  bridgeV2("bridge_v2"),
  unknownArchetype("unknown_archetype"),
  classicBulb("classic_bulb"),
  sultanBulb("sultan_bulb"),
  floodBulb("flood_bulb"),
  spotBulb("spot_bulb"),
  candleBulb("candle_bulb"),
  lusterBulb("luster_bulb"),
  pendantRound("pendant_round"),
  pendantLong("pendant_long"),
  ceilingRound("ceiling_round"),
  ceilingSquare("ceiling_square"),
  floorShade("floor_shade"),
  floorLantern("floor_lantern"),
  tableShade("table_shade"),
  recessedCeiling("recessed_ceiling"),
  recessedFloor("recessed_floor"),
  singleSpot("single_spot"),
  doubleSpot("double_spot"),
  tableWash("table_wash"),
  wallLantern("wall_lantern"),
  wallShade("wall_shade"),
  flexibleLamp("flexible_lamp"),
  groundSpot("ground_spot"),
  wallSpot("wall_spot"),
  plug("plug"),
  hueGo("hue_go"),
  hueLightstrip("hue_lightstrip"),
  hueIris("hue_iris"),
  hueBloom("hue_bloom"),
  bollard("bollard"),
  wallWasher("wall_washer"),
  huePlay("hue_play"),
  vintageBulb("vintage_bulb"),
  vintageCandleBulb("vintage_candle_bulb"),
  ellipseBulb("ellipse_bulb"),
  triangleBulb("triangle_bulb"),
  smallGlobeBulb("small_globe_bulb"),
  largeGlobeBulb("large_globe_bulb"),
  edisonBulb("edison_bulb"),
  christmasTree("christmas_tree"),
  stringLight("string_light"),
  hueCentris("hue_centris"),
  hueLightstripTv("hue_lightstrip_tv"),
  hueLightstripPc("hue_lightstrip_pc"),
  hueTube("hue_tube"),
  hueSigne("hue_signe"),
  pendantSpot("pendant_spot"),
  ceilingHorizontal("ceiling_horizontal"),
  ceilingTube("ceiling_tube");

  const DeviceArchetype(this.value);

  /// The string representation of this [DeviceArchetype].
  final String value;

  /// Get a [DeviceArchetype] from a given string `value`.
  static DeviceArchetype fromString(String value) {
    return values.firstWhere(
      (archetype) => archetype.value == value,
      orElse: () => unknownArchetype,
    );
  }
}
