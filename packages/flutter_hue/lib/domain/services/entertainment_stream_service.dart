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
    final String? bridgeIpAddr = bridge.ipAddress;
    final String? clientKey = bridge.clientKey;
    final String? appKey = bridge.applicationKey;

    if (bridgeIpAddr == null) return false;
    if (clientKey == null) return false;
    if (appKey == null) return false;

    final String? appId = await _fetchAppId(bridgeIpAddr, appKey, decrypter);

    if (appId == null) return false;

    final DtlsClientContext clientContext = DtlsClientContext(
      // verify: true,
      // withTrustedRoots: true,
      // ciphers: 'TLS_PSK_WITH_AES_128_GCM_SHA256',
      // ciphers: 'PSK-AES128-GCM-SHA256',
      ciphers: 'PSK_WITH_AES_128_GCM_SHA256',
      pskCredentialsCallback: (_) {
        return PskCredentials(
          identity: Uint8List.fromList(utf8.encode(appId)),
          preSharedKey: Uint8List.fromList(utf8.encode(clientKey)),
        );
      },
    );

    List<String>? possibleIpAddresses = await _fetchIpAddr();

    if (possibleIpAddresses == null) return false;

    DtlsClient? dtlsClient;
    DtlsConnection? connection;
    for (String ipAddress in possibleIpAddresses) {
      try {
        dtlsClient = await DtlsClient.bind(ipAddress, 0);
      } catch (e) {
        continue;
      }

      print('Attempting DTLS handshake...');

      try {
        connection = await dtlsClient.connect(
          InternetAddress(bridgeIpAddr),
          2100,
          clientContext,
          timeout: const Duration(seconds: 5),
        );

        break;
      } catch (e) {
        print('FAILED TO CONNECT:');
        print(e);

        await dtlsClient.close();
        continue;
      }
    }

    if (dtlsClient == null) return false;
    if (connection == null) return false;

    print('DTLS handshake successful!');

    int count = 0;

    connection.listen(
      (dataGram) async {
        print('Result vvvvv');
        print(utf8.decode(dataGram.data));

        if (count == 6) {
          await dtlsClient!.close();
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

  /// Fetches a list of IP addresses for the user's device.
  ///
  /// Returns `null` if the request fails.
  static Future<List<String>?> _fetchIpAddr() async {
    try {
      List<NetworkInterface> networkInterfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      final List<String> possibleIpAddresses = [];

      for (NetworkInterface interface in networkInterfaces) {
        for (InternetAddress addr in interface.addresses) {
          if (addr.address.isNotEmpty) {
            possibleIpAddresses.add(addr.address);
          }
        }
      }

      if (possibleIpAddresses.isEmpty) return null;

      return possibleIpAddresses;
    } catch (e) {
      return null;
    }
  }
}
