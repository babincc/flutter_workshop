import 'dart:convert';

import 'package:http/http.dart';
import 'package:multicast_dns/multicast_dns.dart';

/// The Flutter Hue Bridge services.
///
/// It is advised that you use [BridgeDiscoveryRepo] instead of this class.
class BridgeDiscoveryService {
  /// Searches the network for bridges using mDNS.
  static Future<List<String>> discoverBridgesMdns() async {
    List<String> bridges = [];

    final Set<String> discoveredPtr = {};
    final Set<SrvResourceRecord> discoveredSvr = {};
    final Set<IPAddressResourceRecord> discoveredIp = {};

    final MDnsClient client = MDnsClient();

    await client.start();

    await for (final PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer("_hue._tcp.local"))) {
      if (!discoveredPtr.add(ptr.domainName)) continue;

      await for (final SrvResourceRecord srv
          in client.lookup<SrvResourceRecord>(
              ResourceRecordQuery.service(ptr.domainName))) {
        if (!discoveredSvr.add(srv)) continue;

        await for (final IPAddressResourceRecord ip
            in client.lookup<IPAddressResourceRecord>(
                ResourceRecordQuery.addressIPv4(srv.target))) {
          if (!discoveredIp.add(ip)) continue;

          bridges.add(ip.address.address);
        }
      }
    }

    client.stop();

    return bridges;
  }

  /// Searches the network for bridges using the endpoint method.
  static Future<List<String>> discoverBridgesEndpoint() async {
    List<String> bridges = [];

    Client client = Client();

    Response response =
        await client.get(Uri.parse("https://discovery.meethue.com"));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(
        jsonDecode(response.body).map(
          (result) => Map<String, dynamic>.from(result),
        ),
      );

      for (Map<String, dynamic> result in results) {
        bridges.add(result["internalipaddress"]);
      }
    }

    return bridges;
  }
}
