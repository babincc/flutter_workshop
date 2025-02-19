import 'dart:convert';

import 'package:flutter_hue/domain/models/bridge/discovered_bridge.dart';
import 'package:http/http.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:url_launcher/url_launcher.dart';

/// The Flutter Hue Bridge services.
///
/// It is advised that you use [BridgeDiscoveryRepo] instead of this class.
class BridgeDiscoveryService {
  /// Searches the network for bridges using mDNS.
  static Future<List<DiscoveredBridge>> discoverBridgesMdns() async {
    final List<DiscoveredBridge> bridges = [];

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

          final String target = srv.target;

          final String rawIdFromMdns;
          if (target.contains('.')) {
            rawIdFromMdns = target.substring(0, target.indexOf('.'));
          } else {
            rawIdFromMdns = target;
          }

          bridges.add(
            DiscoveredBridge.fromMdns(
              rawIdFromMdns: rawIdFromMdns,
              ipAddress: ip.address.address,
            ),
          );
        }
      }
    }

    client.stop();

    return bridges;
  }

  /// Searches the network for bridges using the endpoint method.
  static Future<List<DiscoveredBridge>> discoverBridgesEndpoint() async {
    final List<DiscoveredBridge> bridges = [];

    final Client client = Client();

    Response response =
        await client.get(Uri.parse("https://discovery.meethue.com"));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(
        jsonDecode(response.body).map(
          (result) => Map<String, dynamic>.from(result),
        ),
      );

      for (Map<String, dynamic> result in results) {
        try {
          final String rawIdFromEndpoint = result["id"];
          final String ipAddress = result["internalipaddress"];

          bridges.add(
            DiscoveredBridge.fromEndpoint(
              rawIdFromEndpoint: rawIdFromEndpoint,
              ipAddress: ipAddress,
            ),
          );
        } catch (e) {
          continue;
        }
      }
    }

    return bridges;
  }

  /// Lets the user authorize the app to access the bridge remotely.
  ///
  /// This is step 1. Step 2 is [TokenService.fetchRemoteToken].
  static Future<void> remoteAuthRequest({
    required String url,
  }) async {
    final Uri uri = Uri.parse(url);

    if (!await canLaunchUrl(uri)) return;

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
