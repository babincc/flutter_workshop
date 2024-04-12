import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/services/entertainment_stream_service.dart';

class EntertainmentStreamRepo {
  static Future<void> establishDtlsHandshake(Bridge bridge) async =>
      EntertainmentStreamService.establishDtlsHandshake(bridge);
}
