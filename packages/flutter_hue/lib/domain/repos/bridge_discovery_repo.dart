import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/constants/folders.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/repos/hue_http_repo.dart';
import 'package:flutter_hue/domain/repos/local_storage_repo.dart';
import 'package:flutter_hue/domain/services/bridge_discovery_service.dart';
import 'package:flutter_hue/domain/services/hue_http_client.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/my_file_explorer_sdk/my_file_explorer_sdk.dart';
// import 'package:universal_html/html.dart' as html;

/// This is the way to communicate with Flutter Hue Bridge services.
class BridgeDiscoveryRepo {
  /// The name of the file that stores the state secret.
  ///
  /// This allows a secret key to be generated and saved so the user can leave
  /// the app and come back and still have the same secret key.
  static const String stateSecretFile = "fh_ss_validator";

  /// Searches the network for Philips Hue bridges.
  ///
  /// Returns a list of all of their IP addresses.
  ///
  /// If saved bridges are not saved to the default folder, provide their
  /// location with `savedBridgesDir`.
  ///
  /// `decrypter` When the bridge data is read from local storage, it is
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  static Future<List<String>> discoverBridges({
    Directory? savedBridgesDir,
    bool writeToLocal = true,
    String Function(String ciphertext)? decrypter,
  }) async {
    /// The bridges already saved to this device.
    List<Bridge> savedBridges;

    if (kIsWeb) {
      // cookies instead of local storage (not yet implemented)
      savedBridges = [];
    } else {
      savedBridges = await fetchSavedBridges(
        decrypter: decrypter,
        directory: savedBridgesDir,
      );
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
  /// `encrypter` When the bridge is written to local storage, it is encrypted.
  /// This parameter allows you to provide your own encryption method. This will
  /// be used in addition to the default encryption method. This will be
  /// performed after the default encryption method.
  ///
  /// If the pairing fails, this method returns `null`.
  static Future<Bridge?> firstContact({
    required String bridgeIpAddr,
    Directory? savedBridgesDir,
    bool writeToLocal = true,
    DiscoveryTimeoutController? controller,
    String Function(String plaintext)? encrypter,
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
          if (counter > timeoutController.timeoutSeconds) return false;

          // Cancel if called to do so, early.
          if (timeoutController.cancelDiscovery) {
            timeoutController.cancelDiscovery = false;
            return false;
          }

          response = await HueHttpClient.post(
            url: "https://$bridgeIpAddr/api",
            applicationKey: null,
            token: null,
            body: body,
          );

          if (response == null || response!.isEmpty) return true;

          try {
            if (response!.containsKey(ApiFields.error)) {
              return response![ApiFields.error][ApiFields.description] ==
                  "link button not pressed";
            } else {
              appKey = response![ApiFields.success][ApiFields.username];
              return appKey == null || appKey!.isEmpty;
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
      _writeLocalBridge(
        bridge,
        encrypter: encrypter,
        savedBridgesDir: savedBridgesDir,
      );
    }

    return bridge;
  }

  /// This method allows the user to grant access to the app to allow it to
  /// connect to their bridge.
  ///
  /// This is step 1. Step 2 is [TokenRepo.fetchRemoteToken].
  ///
  /// `clientId` Identifies the client that is making the request. The value
  /// passed in this parameter must exactly match the value you receive from
  /// hue.
  ///
  /// `redirectUri` This parameter must exactly match the one configured in your
  /// hue developer account.
  ///
  /// `deviceName` The device name should be the name of the app or device
  /// accessing the remote API. The `deviceName` is used in the user’s “My Apps”
  /// overview in the Hue Account (visualized as: “<appName> on <deviceName>”).
  ///
  /// `state` Provides any state that might be useful to your application upon
  /// receipt of the response. The Hue Authorization Server round-trips this
  /// parameter, so your application receives the same value it sent. To
  /// mitigate against cross-site request forgery (CSRF), a long (30+ digit),
  /// random number is prepended to `state`. When the response is received from
  /// Hue, it is recommended that you compare the string returned from this
  /// method, to the one that is returned from Hue.
  ///
  /// `encrypter` When the state value is stored locally, it is encrypted. This
  /// parameter allows you to provide your own encryption method. This will be
  /// used in addition to the default encryption method. This will be performed
  /// before the default encryption method.
  ///
  /// Returns the `state` value that is sent with the GET request. This is
  /// prepended with the long, random number. Between the random number and the
  /// provided `state` will be a - (dash).
  static Future<String> remoteAuthRequest({
    required String clientId,
    required String redirectUri,
    String? deviceName,
    String? state,
    String Function(String plaintext)? encrypter,
  }) async {
    final StringBuffer urlBuffer =
        StringBuffer("https://api.meethue.com/v2/oauth2/authorize?");
    final StringBuffer stateBuffer = StringBuffer();

    // Generate a random code verifier.
    final String codeVerifier = base64Url
        .encode(List.generate(32, (index) => MiscTools.randInt(0, 255)));

    // Calculate the code challenge using SHA-256.
    final String codeChallenge =
        base64Url.encode(sha256.convert(utf8.encode(codeVerifier)).bytes);

    // Write the URI.
    urlBuffer.write("${ApiFields.clientId}=$clientId");
    urlBuffer.write("&${ApiFields.responseType}=code");
    urlBuffer.write("&${ApiFields.codeChallengeMethod}=S256");
    urlBuffer.write("&${ApiFields.codeChallenge}=$codeChallenge");
    urlBuffer.write("&${ApiFields.state}=");
    stateBuffer.write(MiscTools.randInt(1, 123).toString());
    for (int i = 0; i < MiscTools.randInt(30, 44); i++) {
      stateBuffer.write(MiscTools.randInt(0, 123).toString());
    }
    urlBuffer.write(stateBuffer.toString());
    if (state != null && state.isNotEmpty) {
      urlBuffer.write("-$state");
    }
    urlBuffer.write("&${ApiFields.redirectUri}=$redirectUri");
    if (deviceName != null && deviceName.isNotEmpty) {
      urlBuffer.write("&${ApiFields.deviceName}=$deviceName");
    }

    // Write the state secret to local storage.
    await LocalStorageRepo.write(
      content: stateBuffer.toString(),
      folder: Folder.tmp,
      fileName: stateSecretFile,
      encrypter: encrypter,
    );

    // Call the service.
    await BridgeDiscoveryService.remoteAuthRequest(url: urlBuffer.toString());

    return stateBuffer.toString();
  }

  /// Writes the `bridge` data to local storage.
  ///
  /// `encrypter` When the bridge data is stored locally, it is encrypted. This
  /// parameter allows you to provide your own encryption method. This will be
  /// used in addition to the default encryption method. This will be performed
  /// before the default encryption method.
  ///
  /// `savedBridgesDir` The directory where the bridge data will be saved. If
  /// this is not provided, the default directory will be used.
  static Future<void> _writeLocalBridge(
    Bridge bridge, {
    String Function(String plaintext)? encrypter,
    Directory? savedBridgesDir,
  }) async {
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
        LocalStorageRepo.encrypt(
          JsonTool.writeJson(
            bridge.toJson(optimizeFor: OptimizeFor.dontOptimize),
          ),
          encrypter,
        ),
      );
    }
  }

  /// Fetch all of the bridges already saved to the user's device.
  ///
  /// `decrypter` When the bridge data is read from local storage, it is
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// `directory` The directory where the bridge data will be saved. If this is
  /// not provided, the default directory will be used.
  ///
  /// If the bridges are not saved to the default folder location, provide their
  /// location with `directory`.
  static Future<List<Bridge>> fetchSavedBridges({
    String Function(String ciphertext)? decrypter,
    Directory? directory,
  }) async {
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
        String fileContents = LocalStorageRepo.decrypt(
              bridgeFile.readAsStringSync(),
              decrypter,
            ) ??
            "";

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
  /// Range for `timeoutSeconds` is 0 to 30 (inclusive).
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
