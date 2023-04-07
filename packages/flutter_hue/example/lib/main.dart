import 'package:flutter/material.dart';
import 'package:flutter_hue/flutter_hue.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const double padding = 15.0;

  /// Whether or not the page is loading some async action.
  bool isLoading = false;

  /// The IP address of the bridges on the network.
  final List<String> bridgeIps = [];

  /// Controls the bridge discovery process.
  final DiscoveryTimeoutController timeoutController =
      DiscoveryTimeoutController(timeoutSeconds: 25);

  /// Cancels the "first contact" action.
  VoidCallback? onContactCancel;

  /// The bridge that [firstContact] decided to connect with.
  Bridge? bridge;

  /// All of the Philips Hue resources connected to [bridge].
  HueNetwork? hueNetwork;

  /// The light that is being worked with in the "writing data" section.
  Light? light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Flutter Hue"),
            actions: isLoading
                ? [
                    Padding(
                      padding: const EdgeInsets.only(right: padding),
                      child: Row(
                        children: const [
                          Text("Loading... "),
                          Icon(Icons.query_builder),
                        ],
                      ),
                    ),
                  ]
                : null,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: padding),

                  sectionHeader("Getting Started"),

                  // DISCOVER BRIDGES
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: discoverBridges,
                        child: const Text("Discover Bridges"),
                      ),
                      Visibility(
                        visible: bridgeIps.isNotEmpty,
                        child: TextButton(
                          onPressed: () => showIps(context),
                          child: Text("Found ${bridgeIps.length} bridge IP"
                              "${bridgeIps.length == 1 ? "" : "s"}"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: padding * 2),

                  // FIRST CONTACT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            bridgeIps.isEmpty ? null : () => firstContact(),
                        child: const Text("First Contact"),
                      ),
                      const SizedBox(width: 11),
                      ElevatedButton(
                        onPressed: onContactCancel,
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),

                  const SizedBox(height: padding * 2),

                  sectionHeader("Reading Data"),

                  // FETCH NETWORK
                  ElevatedButton(
                    onPressed: bridge == null ? null : fetchNetwork,
                    child: const Text("Fetch Network"),
                  ),

                  const SizedBox(height: padding * 2),

                  // FETCH BRIDGE
                  ElevatedButton(
                    onPressed: bridge == null ? null : fetchBridge,
                    child: const Text("Fetch Bridge"),
                  ),

                  const SizedBox(height: padding * 2),

                  // FETCH LIGHT
                  ElevatedButton(
                    onPressed: bridge == null ? null : fetchLight,
                    child: const Text("Fetch Light"),
                  ),

                  const SizedBox(height: padding * 2),

                  sectionHeader("Writing Data"),

                  // IDENTIFY LIGHT
                  ElevatedButton(
                    onPressed: light == null ? null : identifyLight,
                    child: const Text("Identify Light"),
                  ),

                  const SizedBox(height: padding * 2),

                  // TOGGLE LIGHT ON/OFF
                  ElevatedButton(
                    onPressed: light == null ? null : toggleLight,
                    child: const Text("Toggle Light on/off"),
                  ),

                  const SizedBox(height: padding * 2),

                  // LIGHT COLORS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // RED
                        ElevatedButton(
                          onPressed:
                              light == null ? null : () => colorLight("red"),
                          child: const Text("Red"),
                        ),

                        // GREEN
                        ElevatedButton(
                          onPressed:
                              light == null ? null : () => colorLight("green"),
                          child: const Text("Green"),
                        ),

                        // BLUE
                        ElevatedButton(
                          onPressed:
                              light == null ? null : () => colorLight("blue"),
                          child: const Text("Blue"),
                        ),

                        // WHITE
                        ElevatedButton(
                          onPressed:
                              light == null ? null : () => colorLight("white"),
                          child: const Text("White"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: padding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The titles and dividers that separate each group of buttons.
  Widget sectionHeader(String title) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: padding),
            Text(
              title,
              style: const TextStyle(
                fontSize: padding,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Divider(thickness: 2.0),
        ),
      ],
    );
  }

  /// Show the IP addresses of the bridges that have been found on the network.
  void showIps(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bridge IP"),
          content: SingleChildScrollView(
            child: ListBody(
              children: bridgeIps.map((ip) => Text(ip)).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Searches the network for bridges.
  ///
  /// If any are found, their IP addresses are placed in the [bridgeIps] list.
  Future<void> discoverBridges() async {
    setState(() {
      isLoading = true;
    });

    List<String> bridges = await BridgeDiscoveryRepo.discoverBridges();

    setState(() {
      bridgeIps.addAll(bridges);
      isLoading = false;
    });
  }

  /// For the simplicity of this demo, this method only looks at the first
  /// bridge from the [bridgeIps] list.
  ///
  /// It attempts to establish contact with the bridge. This is when the user
  /// needs to press the button on their bridge.
  Future<void> firstContact() async {
    setState(() {
      onContactCancel = () => timeoutController.cancelDiscovery = true;
      isLoading = true;
    });

    bridge = await BridgeDiscoveryRepo.firstContact(
      bridgeIpAddr: bridgeIps.first,
      controller: timeoutController,
    );

    setState(() {
      onContactCancel = null;
      isLoading = false;
    });
  }

  /// Fetches all of the resources that are attached to [bridge].
  Future<void> fetchNetwork() async {
    setState(() {
      isLoading = true;
    });

    hueNetwork = HueNetwork(bridges: [bridge!]);

    await hueNetwork?.fetchAll();

    try {
      light = hueNetwork!.lights.first;
    } catch (_) {
      // Do nothing
    }

    setState(() {
      isLoading = false;
    });
  }

  /// This does nothing for the demo other than to show the code that is used to
  /// fetch a bridge object from JSON.
  Future<void> fetchBridge() async {
    setState(() {
      isLoading = true;
    });

    final List<Map<String, dynamic>>? res =
        await bridge!.getResource(ResourceType.bridge);

    try {
      // ignore: unused_local_variable
      Bridge myBridge = Bridge.fromJson(res?.first ?? {});
    } catch (_) {
      // res list was empty
    }

    // Shows a way to display the info in these objects.
    // log("Bridge Json - ${JsonTool.writeJson(res ?? {})}");
    // log("Bridge Object - ${JsonTool.writeJson(bridge.toJson(optimizeFor: OptimizeFor.dontOptimize))}");

    setState(() {
      isLoading = false;
    });
  }

  /// This does nothing for the demo other than to show the code that is used to
  /// fetch a light object from JSON.
  Future<void> fetchLight() async {
    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic>? res =
        (await bridge!.getResource(ResourceType.light))?.first;

    // ignore: unused_local_variable
    Light light = Light.fromJson(res ?? {});

    setState(() {
      isLoading = false;
    });
  }

  /// Causes the light to "breath" to let the user know which light they are
  /// working with.
  Future<void> identifyLight() async {
    setState(() {
      isLoading = true;
    });

    Device lightDevice;

    try {
      lightDevice = hueNetwork!.devices
          // ignore: deprecated_member_use
          .firstWhere((device) => device.metadata.name == light!.metadata.name);
    } catch (_) {
      return;
    }

    lightDevice.identifyAction = "identify";

    await bridge!.put(lightDevice);

    setState(() {
      isLoading = false;
    });
  }

  /// Toggles [light] on and off.
  Future<void> toggleLight() async {
    setState(() {
      isLoading = true;
    });

    bool isOn = light!.isOn;

    light!.on.isOn = !isOn;

    await bridge!.put(light!);

    setState(() {
      isLoading = false;
    });
  }

  /// Changes the color of [light].
  Future<void> colorLight(String color) async {
    setState(() {
      isLoading = true;
    });

    double x;
    double y;

    if (color == "red") {
      x = 0.6718;
      y = 0.3184;
    } else if (color == "green") {
      x = 0.2487;
      y = 0.6923;
    } else if (color == "blue") {
      x = 0.1121;
      y = 0.1139;
    } else {
      x = 0.3127;
      y = 0.3127;
    }

    light = light!
        .copyWith(color: light!.color.copyWith(xy: LightColorXy(x: x, y: y)));

    await bridge!.put(light!);

    setState(() {
      isLoading = false;
    });
  }
}
