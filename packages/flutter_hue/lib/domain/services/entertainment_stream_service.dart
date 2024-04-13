import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dtls2/dtls2.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/repos/token_repo.dart';
import 'package:flutter_hue/domain/services/hue_http_client.dart';

class EntertainmentStreamService {
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
  }) async {
    print('START HANDSHAKE METHOD');

    final String? bridgeIpAddr = bridge.ipAddress;
    final String? clientKey = bridge.clientKey;
    final String? appKey = bridge.applicationKey;

    print('Checking null values...');

    if (bridgeIpAddr == null) return false;
    if (clientKey == null) return false;
    if (appKey == null) return false;

    print('No null values!');

    print('Fetching app ID...');

    final String? appId = await _fetchAppId(bridgeIpAddr, appKey, decrypter);

    if (appId == null) return false;

    print('App ID fetched!');

    print('Creating client context...');

    final DtlsClientContext clientContext = DtlsClientContext(
      verify: true,
      withTrustedRoots: true,
      ciphers: 'TLS_PSK_WITH_AES_128_GCM_SHA256',
      pskCredentialsCallback: (_) {
        print('creating credentials...');

        final credentials = PskCredentials(
          identity: Uint8List.fromList(utf8.encode(appId)),
          preSharedKey: Uint8List.fromList(utf8.encode(clientKey)),
        );

        print('credentials created!');

        return credentials;
      },
    );

    print('Client context created!');

    print('Binding to DTLS client...');

    final DtlsClient dtlsClient;
    try {
      dtlsClient = await DtlsClient.bind('::', 0);
    } catch (e) {
      print('FAILED TO BIND:');
      print(e);

      return false;
    }

    print('DTLS client bound!');

    print('Attempting DTLS handshake...');

    final DtlsConnection connection;
    try {
      connection = await dtlsClient.connect(
        InternetAddress(bridgeIpAddr),
        2100,
        clientContext,
        timeout: const Duration(seconds: 5),
      );
    } catch (e) {
      print('FAILED TO CONNECT:');
      print(e);

      await dtlsClient.close();
      return false;
    }

    print('DTLS handshake successful!');

    int count = 0;

    connection.listen(
      (dataGram) async {
        print('Result vvvvv');
        print(utf8.decode(dataGram.data));

        if (count == 6) {
          await dtlsClient.close();
        }

        count++;
      },
    );

    print('END HANDSHAKE METHOD');

    // connection.send(Uint8List.fromList(utf8.encode('Hello World')));

    return true;
  }

  /// Fetches the application ID from the bridge.
  ///
  /// Returns `null` if the request fails.
  ///
  /// `bridgeIpAddr` is the IP address of the target bridge.
  ///
  /// `appKey` is the key associated with this devices in the bridge's
  /// whitelist.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  static Future<String?> _fetchAppId(
    String bridgeIpAddr,
    String appKey,
    String Function(String)? decrypter,
  ) async {
    final Map<String, String>? response = await HueHttpClient.getHeaders(
      url: 'https://$bridgeIpAddr/auth/v1',
      applicationKey: appKey,
      token: null,
    ).timeout(
      const Duration(seconds: 1),
      onTimeout: () async {
        String? token = await TokenRepo.fetchToken(decrypter: decrypter);

        return await HueHttpClient.getHeaders(
          url: 'https://api.meethue.com/route/auth/v1',
          applicationKey: appKey,
          token: token,
        );
      },
    );

    if (response == null) return null;

    return response['hue-application-id'];
  }
}
