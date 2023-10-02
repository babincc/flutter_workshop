import 'package:dart_connect_metro/features/rail_station_info/domain/models/line.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/services/lines_service.dart';

/// Fetches the metro rail lines.
///
/// `apiKey` is your API key for the WMATA API.
Future<List<Line>> fetchLines(String apiKey) async =>
    await LinesService.fetchLines(apiKey);
