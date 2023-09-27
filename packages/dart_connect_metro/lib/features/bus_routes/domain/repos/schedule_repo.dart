import 'package:dart_connect_metro/features/bus_routes/domain/models/schedule/schedule.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/services/schedule_service.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Fetches the schedule for a route.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `routeId` is the base route name as shown on the bus. Note that the base
/// route name could also refer to any variant, so a RouteID of 10A could
/// refer to 10A, 10Av1, 10Av2, etc.
///
/// `date` is the date for which to retrieve the schedule. If omitted, the
/// current date will be used.
///
/// `includingVariations` is whether or not to include variations if a base
/// route is specified in `routeId`. For example, if B30 is specified and
/// `includingVariations` is set to `true`, data for all variations of B30, such
/// as B30v1, B30v2, etc., will be returned.
Future<Schedule> fetchSchedule(
  String apiKey, {
  required String routeId,
  DateTime? date,
  bool? includingVariations,
}) async =>
    await ScheduleService.fetchSchedule(
      apiKey,
      routeId: routeId,
      date: date?.toWmataStringDateOnly(),
      includingVariations: includingVariations,
    );
