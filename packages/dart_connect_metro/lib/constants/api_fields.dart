/// This file contains the names of all of the json field names as they appear
/// in WMATA's code.
///
/// This is done to prevent typos in code. By referring to these constant
/// strings, there won't be a chance of misspelling any of the names in other
/// parts of the code. This also allows for name changes on WMATA's side without
/// having to change the name in several places in the code here.
class ApiFields {
  static const String busIncidents = "BusIncidents";

  static const String busPositions = "BusPositions";

  static const String dateTime = "DateTime";

  static const String description = "Description";

  static const String dateUpdated = "DateUpdated";

  static const String deviationMinutes = "Deviation";

  static const String direction = "DirectionText";

  static const String directionNum = "DirectionNum";

  static const String direction0 = "Direction0";

  static const String direction1 = "Direction1";

  static const String endTime = "EndTime";

  static const String incidentId = "IncidentID";

  static const String incidentType = "IncidentType";

  static const String latitude = "Lat";

  static const String lineDescription = "LineDescription";

  static const String longitude = "Lon";

  static const String name = "Name";

  static const String routeId = "RouteID";

  static const String routes = "Routes";

  static const String routesAffected = "RoutesAffected";

  static const String scheduleArrivals = "ScheduleArrivals";

  static const String scheduleTime = "ScheduleTime";

  static const String seqNum = "SeqNum";

  static const String shape = "Shape";

  static const String startTime = "StartTime";

  static const String stop = "Stop";

  static const String stopId = "StopID";

  static const String stops = "Stops";

  static const String stopTimes = "StopTimes";

  static const String time = "Time";

  static const String tripDirection = "TripDirectionText";

  static const String tripEndTime = "TripEndTime";

  static const String tripHeadsign = "TripHeadsign";

  static const String tripId = "TripID";

  static const String tripStartTime = "TripStartTime";

  static const String vehicleId = "VehicleID";
}
