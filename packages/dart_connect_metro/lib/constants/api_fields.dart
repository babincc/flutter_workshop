/// This file contains the names of all of the json field names as they appear
/// in WMATA's code.
///
/// This is done to prevent typos in code. By referring to these constant
/// strings, there won't be a chance of misspelling any of the names in other
/// parts of the code. This also allows for name changes on WMATA's side without
/// having to change the name in several places in the code here.
class ApiFields {
  static const String busPositions = "BusPositions";

  static const String dateTime = "DateTime";

  static const String deviationMinutes = "Deviation";

  static const String direction = "DirectionText";

  static const String latitude = "Lat";

  static const String longitude = "Lon";

  static const String routeId = "RouteID";

  static const String tripEndTime = "TripEndTime";

  static const String tripHeadsign = "TripHeadsign";

  static const String tripId = "TripID";

  static const String tripStartTime = "TripStartTime";

  static const String vehicleId = "VehicleID";
}
