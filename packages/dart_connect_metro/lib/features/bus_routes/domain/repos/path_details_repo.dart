import 'package:dart_connect_metro/features/bus_routes/domain/models/path_details/path_details.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/services/path_details_service.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Fetches path details for a specific route.
///
/// `apiKey` is your API key for the WMATA API.
///
/// `routeId` is the base route name as shown on the bus. Note that the base
/// route name could also refer to any variant, so a RouteID of 10A could
/// refer to 10A, 10Av1, 10Av2, etc.
///
/// `date` is the date for which to retrieve the path details. If omitted, the
/// current date will be used.
Future<PathDetails> fetchPathDetails(
  String apiKey, {
  required String routeId,
  DateTime? date,
}) async =>
    await PathDetailsService.fetchPathDetails(
      apiKey,
      routeId: routeId,
      date: date?.toWmataStringDateOnly(),
    );
