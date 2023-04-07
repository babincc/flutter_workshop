import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/constants/folders.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/repos/hue_http_repo.dart';
import 'package:flutter_hue/domain/services/bridge_discovery_service.dart';
import 'package:flutter_hue/domain/services/hue_http_client.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/my_file_explorer_sdk/my_file_explorer_sdk.dart';
// import 'package:universal_html/html.dart' as html;

/// This is the way to communicate with Flutter Hue Bridge services.
class BridgeDiscoveryRepo {
  /// Searches the network for Philips Hue bridges.
  ///
  /// Returns a list of all of their IP addresses.
  ///
  /// If saved bridges are not saved to the default folder, provide their
  /// location with `savedBridgesDir`.
  static Future<List<String>> discoverBridges(
      {Directory? savedBridgesDir, bool writeToLocal = true}) async {
    /// The bridges already saved to this device.
    List<Bridge> savedBridges;

    if (kIsWeb) {
      // cookies instead of local storage (not yet implemented)
      savedBridges = [];
    } else {
      savedBridges = await fetchSavedBridges(savedBridgesDir);
    }

    /// Bridges found using MDNS.
    List<String> bridgesFromMdns;
    if (kIsWeb) {
      // mDNS does not work on web.
      bridgesFromMdns = [];
    } else {
      bridgesFromMdns = await BridgeDiscoveryService.discoverBridgesMdns();
    }

    /// Bridges found using the endpoint method.
    List<String> bridgesFromEndpoint =
        await BridgeDiscoveryService.discoverBridgesEndpoint();

    // Remove duplicates from the two search methods.
    Set<String> uniqueValues = {};
    uniqueValues.addAll(bridgesFromMdns);
    uniqueValues.addAll(bridgesFromEndpoint);

    if (savedBridges.isEmpty) return uniqueValues.toList();

    List<String> ipAddresses = [];

    // Remove the bridges that are already saved to the device from the search
    // results.
    for (String ip in uniqueValues) {
      for (Bridge bridge in savedBridges) {
        if (bridge.ipAddress == null || bridge.ipAddress != ip) {
          ipAddresses.add(ip);
        }
      }
    }

    // Keep locally saved bridges up to date.
    if (writeToLocal) {
      for (String ip in ipAddresses) {
        // This will go through each of the bridges who's IP address have just
        // been collected and tries to connect to them. If there is a successful
        // connection, then this isn't the first time contact has been made with
        // the bridge. In this case, the file will be overridden with the new IP
        // address.
        await firstContact(
          bridgeIpAddr: ip,
          savedBridgesDir: savedBridgesDir,
          writeToLocal: writeToLocal,
          controller: DiscoveryTimeoutController(timeoutSeconds: 1),
        );
      }
    }

    return ipAddresses;
  }

  /// Initiates the first contact between this device and the given bridge.
  ///
  /// Once this method has been called, the user will have 10 seconds by
  /// default, or how ever many have been set in `controller`, to press the
  /// button on their bridge to confirm they have physical access to it.
  ///
  /// In the event of a successful pairing, this method returns a bridge object
  /// that represents the bridge it just connected to. Before it returns the
  /// bridge, if `writeToLocal` is `true`, it will write it to local storage to
  /// be saved for later.
  ///
  /// If writing saved bridges to a non-default location, provide that location
  /// with `savedBridgesDir`.
  ///
  /// `controller` gives more control over this process. It lets you decide how
  /// many seconds the user has to press the button on their bridge. It also
  /// gives the ability to cancel the discovery process at any time.
  ///
  /// If the pairing fails, this method returns `null`.
  static Future<Bridge?> firstContact({
    required String bridgeIpAddr,
    Directory? savedBridgesDir,
    bool writeToLocal = true,
    DiscoveryTimeoutController? controller,
  }) async {
    final DiscoveryTimeoutController timeoutController =
        controller ?? DiscoveryTimeoutController();

    Map<String, dynamic>? response;

    /// Used as the suffix of this device's name in the bridge whitelist.
    String device;
    if (kIsWeb) {
      device = "web";
    } else {
      switch (Platform.operatingSystem) {
        case "android":
        case "fuchsia":
        case "linux":
          device = Platform.operatingSystem;
          break;
        case "ios":
          device = "iPhone";
          break;
        case "macos":
          device = "mac";
          break;
        case "windows":
          device = "pc";
          break;
        default:
          device = "device";
      }
    }

    String? appKey;

    String body =
        JsonTool.writeJson({ApiFields.deviceType: "FlutterHue#$device"});

    // Try for [timeoutSeconds] to connect with the bridge.
    int counter = 0;
    await Future.doWhile(
      () => Future.delayed(const Duration(seconds: 1)).then(
        (value) async {
          counter++;

          // Timeout after [timeoutSeconds].
          if (counter >= timeoutController.timeoutSeconds) return false;

          // Cancel if called to do so, early.
          if (timeoutController.cancelDiscovery) {
            timeoutController.cancelDiscovery = false;
            return false;
          }

          response = await HueHttpClient.post(
            url: "https://$bridgeIpAddr/api",
            applicationKey: null,
            body: body,
          );

          if (response == null || response!.isEmpty) return true;

          try {
            if (response!.containsKey(ApiFields.error)) {
              return response![ApiFields.error][ApiFields.description] ==
                  "link button not pressed";
            } else {
              appKey = response![ApiFields.success]["username"];
              return appKey!.isEmpty;
            }
          } catch (_) {
            return true;
          }
        },
      ),
    );

    if (appKey == null) return null;

    // Upon successful connection, get the bridge details.
    Map<String, dynamic>? bridgeJson = await HueHttpRepo.get(
      bridgeIpAddr: bridgeIpAddr,
      applicationKey: appKey!,
      resourceType: ResourceType.bridge,
    );

    if (bridgeJson == null) return null;

    Bridge bridge = Bridge.fromJson(bridgeJson);
    bridge = bridge.copyWith(ipAddress: bridgeIpAddr, applicationKey: appKey);

    if (bridge.id.isEmpty) return null;

    // Save the bridge locally.
    if (writeToLocal) {
      _writeLocalBridge(bridge, savedBridgesDir);
    }

    return bridge;
  }

  /// Writes the `bridge` data to local storage.
  static Future<void> _writeLocalBridge(Bridge bridge,
      [Directory? savedBridgesDir]) async {
    if (kIsWeb) {
      // cookies instead of local storage (not yet implemented)
    } else {
      Directory dir = savedBridgesDir ??
          Directory(await MyFileExplorerSDK.createPath(
            localDir: LocalDir.appSupportDir,
            subPath: Folders.bridgesSubPath,
          ));

      String filePath =
          MyFileExplorerSDK.getNewNameWithPath(dir.path, "${bridge.id}.json");

      File(filePath).writeAsStringSync(
        JsonTool.writeJson(
          bridge.toJson(optimizeFor: OptimizeFor.dontOptimize),
        ),
      );
    }
  }

  /// Fetch all of the bridges already saved to the user's device.
  ///
  /// If the bridges are not saved to the default folder location, provide their
  /// location with `directory`.
  static Future<List<Bridge>> fetchSavedBridges([Directory? directory]) async {
    List<Bridge> bridges = [];

    if (kIsWeb) {
      // cookies instead of local storage (not yet implemented)
    } else {
      final Directory dir = directory ??
          Directory(
            await MyFileExplorerSDK.createPath(
              localDir: LocalDir.appSupportDir,
              subPath: Folders.bridgesSubPath,
            ),
          );

      /// Create the directory if it does not exist.
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
        return [];
      }

      // Get the bridge files from the directory.
      final List<FileSystemEntity> entities = await dir.list().toList();
      final List<File> bridgeFiles = entities
          .whereType<File>()
          .where((file) =>
              MyFileExplorerSDK.tryParseFileExt(file.path)?.toLowerCase() ==
              ".json")
          .toList();

      /// Parse the bridge files into [Bridge] objects.
      for (File bridgeFile in bridgeFiles) {
        String fileContents = bridgeFile.readAsStringSync();

        Map<String, dynamic> bridgeJson = JsonTool.readJson(fileContents);

        bridges.add(Bridge.fromJson(bridgeJson));
      }
    }

    return bridges;
  }
}

/// Gives more control over the bridge discovery process.
class DiscoveryTimeoutController {
  /// Creates a [DiscoveryTimeoutController].
  ///
  ///
  DiscoveryTimeoutController({
    this.timeoutSeconds = 10,
  }) : assert(timeoutSeconds >= 0 && timeoutSeconds <= 30,
            "`timeoutSeconds` must be between 0 and 30 (inclusive)");

  /// How many seconds the user has to press the button on their bridge before
  /// the process times out.
  int timeoutSeconds;

  /// `true` if the bridge discovery process needs to be canceled.
  bool cancelDiscovery = false;
}
