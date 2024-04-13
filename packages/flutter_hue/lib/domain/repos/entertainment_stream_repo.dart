import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/services/entertainment_stream_service.dart';

class EntertainmentStreamRepo {
  /// Establish a DTLS handshake with the bridge.
  ///
  /// Returns `true` if the handshake was successful, `false` otherwise.
  ///
  /// The `bridge` parameter is the bridge to establish the handshake with.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  static Future<bool> establishDtlsHandshake({
    required Bridge bridge,
    String Function(String)? decrypter,
  }) async =>
      EntertainmentStreamService.establishDtlsHandshake(
        bridge: bridge,
        decrypter: decrypter,
      );
}
