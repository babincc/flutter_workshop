import 'dart:convert';
import 'dart:io';

import 'package:dtls2/dtls2.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/dtls_data.dart';
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
    required DtlsData dtlsData,
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

    List<int> clientKeyBytes = [];
    for (int i = 0; i < clientKey.length; i += 2) {
      String hex = clientKey.substring(i, i + 2);
      clientKeyBytes.add(int.parse(hex, radix: 16));
    }

    final DtlsClientContext clientContext = DtlsClientContext(
      verify: true,
      withTrustedRoots: true,
      ciphers: 'PSK-AES128-GCM-SHA256',
      pskCredentialsCallback: (_) {
        return PskCredentials(
          identity: utf8.encode(appId),
          preSharedKey: clientKeyBytes,
        );
      },
    );

    List<String>? possibleIpAddresses = await _fetchIpAddr();

    if (possibleIpAddresses == null) return false;

    // Flush out old connection data.
    await dtlsData.tryDispose();

    for (String ipAddress in possibleIpAddresses) {
      try {
        dtlsData.dtlsClient = await DtlsClient.bind(ipAddress, 0);
      } catch (e) {
        continue;
      }

      try {
        dtlsData.connection = await dtlsData.dtlsClient!.connect(
          InternetAddress(bridgeIpAddr),
          2100,
          clientContext,
          timeout: const Duration(seconds: 5),
        );

        break;
      } catch (e) {
        await dtlsData.tryCloseClient();

        continue;
      }
    }

    if (dtlsData.dtlsClient == null) return false;

    if (dtlsData.connection == null) {
      await dtlsData.tryCloseClient();

      return false;
    }

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
