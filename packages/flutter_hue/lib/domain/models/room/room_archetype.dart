/// Room archetype.
enum RoomArchetype {
  livingRoom("living_room"),
  kitchen("kitchen"),
  dining("dining"),
  bedroom("bedroom"),
  kidsBedroom("kids_bedroom"),
  bathroom("bathroom"),
  nursery("nursery"),
  recreation("recreation"),
  office("office"),
  gym("gym"),
  hallway("hallway"),
  toilet("toilet"),
  frontDoor("front_door"),
  garage("garage"),
  terrace("terrace"),
  garden("garden"),
  driveway("driveway"),
  carport("carport"),
  home("home"),
  downstairs("downstairs"),
  upstairs("upstairs"),
  topFloor("top_floor"),
  attic("attic"),
  guestRoom("guest_room"),
  staircase("staircase"),
  lounge("lounge"),
  manCave("man_cave"),
  computer("computer"),
  studio("studio"),
  music("music"),
  tv("tv"),
  reading("reading"),
  closet("closet"),
  storage("storage"),
  laundryRoom("laundry_room"),
  balcony("balcony"),
  porch("porch"),
  barbecue("barbecue"),
  pool("pool"),
  other("other");

  const RoomArchetype(this.value);

  /// The string representation of this [RoomArchetype].
  final String value;

  /// Get a [RoomArchetype] from a given string `value`.
  static RoomArchetype fromString(String value) {
    return values.firstWhere(
      (archetype) => archetype.value == value,
      orElse: () => other,
    );
  }
}
