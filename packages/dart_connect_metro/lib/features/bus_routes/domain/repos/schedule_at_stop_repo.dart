import 'package:dart_connect_metro/features/bus_routes/domain/models/schedule_at_stop/schedule_at_stop.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/services/schedule_at_stop_service.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Fetches the schedule for a specific stop.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `date` is the date for which to retrieve the schedule at the stop. If
/// omitted, the current date will be used.
Future<ScheduleAtStop> fetchScheduleAtStop(
  String apiKey, {
  required String stopId,
  DateTime? date,
}) async =>
    await ScheduleAtStopService.fetchScheduleAtStop(
      apiKey,
      stopId: stopId,
      date: date?.toWmataStringDateOnly(),
    );
