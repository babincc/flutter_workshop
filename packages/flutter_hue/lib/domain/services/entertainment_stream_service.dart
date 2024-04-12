import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dtls2/dtls2.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/repos/hue_http_repo.dart';

class EntertainmentStreamService {
  static Future<void> establishDtlsHandshake(Bridge bridge) async {
    if (bridge.ipAddress == null) return;
    if (bridge.clientKey == null) return;

    final DtlsClientContext clientContext = DtlsClientContext(
      verify: true,
      withTrustedRoots: true,
      ciphers: 'TLS_PSK_WITH_AES_128_GCM_SHA256',
      pskCredentialsCallback: (identityHint) {
        return PskCredentials(
          identity: Uint8List.fromList(utf8.encode(HueHttpRepo.deviceType)),
          preSharedKey: Uint8List.fromList(utf8.encode(bridge.clientKey!)),
        );
      },
    );

    print('step 1');

    final DtlsClient dtlsClient = await DtlsClient.bind('::', 0);

    print('step 2');

    final DtlsConnection connection;
    try {
      connection = await dtlsClient.connect(
        InternetAddress(bridge.ipAddress!),
        2100,
        clientContext,
        timeout: const Duration(seconds: 5),
      );
    } catch (e) {
      print(e);

      await dtlsClient.close();
      return;
    }

    print('step 3');

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

    print('step 4');

    // connection.send(Uint8List.fromList(utf8.encode('Hello World')));
  }
}
