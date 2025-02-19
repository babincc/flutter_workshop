import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:example/stream_demos/stream_demos_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hue/flutter_hue.dart';
import 'package:radio_group_v2/radio_group_v2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // TODO: Replace with your client ID
  static const String clientId = '[clientId]';

  // TODO: Replace with your client secret
  static const String clientSecret = '[clientSecret]';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(
        clientId: clientId,
        clientSecret: clientSecret,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.clientId,
    required this.clientSecret,
  });

  final String clientId;

  final String clientSecret;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double padding = 15.0;

  /// Whether or not the page is loading some async action.
  bool isLoading = false;

  /// The IP address of the bridges on the network.
  final List<String> bridgeIps = [];

  /// Bridges that have already been connected to in the past.
  final List<Bridge> oldBridges = [];

  /// Controls the radio group of bridge IP addresses.
  final RadioGroupController<String> ipGroupController = RadioGroupController();

  /// Controls the radio group of old bridges.
  final RadioGroupController<Bridge> oldBridgeGroupController =
      RadioGroupController();

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

  /// Watches for deep links.
  late final StreamSubscription deepLinkStream;

  @override
  void initState() {
    super.initState();

    deepLinkStream = AppLinks().uriLinkStream.listen(
      (Uri? uri) {
        if (uri == null) return;

        final int start = uri.toString().indexOf('?');
        String queryParams = uri.toString().substring(start);
        Uri truncatedUri = Uri.parse(queryParams);

        try {
          final String? pkce = truncatedUri.queryParameters[ApiFields.pkce];
          final String? code = truncatedUri.queryParameters[ApiFields.code];
          final String? resState =
              truncatedUri.queryParameters[ApiFields.state];

          // Handle Flutter Hue deep link
          if (pkce != null && code != null && resState != null) {
            String stateSecret;
            if (resState.contains('-')) {
              stateSecret = resState.substring(0, resState.indexOf('-'));
            } else {
              stateSecret = resState;
            }

            TokenRepo.fetchRemoteToken(
              clientId: widget.clientId,
              clientSecret: widget.clientSecret,
              pkce: pkce,
              code: code,
              stateSecret: stateSecret,
              decrypter: (ciphertext) =>
                  ciphertext.substring(4, ciphertext.length - 4),
            );
          }
        } catch (_) {
          // Do nothing
        }
      },
    );

    // Initialize Flutter Hue and keep all of the locally stored data up to
    // date.
    FlutterHueMaintenanceRepo.maintain(
      clientId: widget.clientId,
      clientSecret: widget.clientSecret,
      redirectUri: 'flutterhue://auth',
      deviceName: 'TestDevice',
      stateEncrypter: (plaintext) => 'abcd${plaintext}1234',
    );

    // Fetch all of the bridges that have been connected to in the past.
    BridgeDiscoveryRepo.fetchSavedBridges().then(
      (bridges) {
        if (bridges.isNotEmpty) {
          setState(() {
            oldBridges.clear();
            oldBridges.addAll(bridges);
            bridge = oldBridges.first;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    deepLinkStream.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: doSomething,
          icon: const Icon(Icons.science),
        ),
        title: const Text('Flutter Hue'),
        actions: isLoading
            ? [
                const Padding(
                  padding: EdgeInsets.only(right: padding),
                  child: Row(
                    children: [
                      Text('Loading... '),
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

              sectionHeader('Getting Started'),

              // DISCOVER BRIDGES
              Visibility(
                visible: oldBridges.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Previously connected bridge'
                          '${oldBridges.length == 1 ? '' : 's'}'),
                      RadioGroup(
                        controller: oldBridgeGroupController,
                        values: oldBridges,
                        indexOfDefault: oldBridges.isEmpty ? -1 : 0,
                        orientation: RadioGroupOrientation.horizontal,
                        onChanged: (value) {
                          setState(() {
                            ipGroupController.setValueSilently(null);
                            bridge = value;
                            hueNetwork = null;
                            light = null;
                          });
                        },
                        labelBuilder: (value) => Text(value.ipAddress ?? ''),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: padding * 2),

              ElevatedButton(
                onPressed: discoverBridges,
                child: const Text('Discover Bridges'),
              ),
              Visibility(
                visible: bridgeIps.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Found ${bridgeIps.length} bridge IP'
                          '${bridgeIps.length == 1 ? '' : 's'}'),
                      RadioGroup(
                        controller: ipGroupController,
                        values: bridgeIps,
                        indexOfDefault:
                            (bridgeIps.isEmpty || oldBridges.isNotEmpty)
                                ? -1
                                : 0,
                        orientation: RadioGroupOrientation.horizontal,
                        onChanged: (value) {
                          setState(() {
                            oldBridgeGroupController.setValueSilently(null);
                            bridge = null;
                            hueNetwork = null;
                            light = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: padding * 2),

              // FIRST CONTACT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: ((ipGroupController.myRadioGroupKey == null ||
                                    ipGroupController.value == null) &&
                                (oldBridgeGroupController.myRadioGroupKey !=
                                        null &&
                                    oldBridgeGroupController.value != null)) ||
                            bridgeIps.isEmpty
                        ? null
                        : () => firstContact(),
                    child: const Text('First Contact'),
                  ),
                  const SizedBox(width: 11),
                  ElevatedButton(
                    onPressed: onContactCancel,
                    child: const Text('Cancel'),
                  ),
                ],
              ),

              Visibility(
                visible: onContactCancel != null,
                maintainAnimation: true,
                maintainState: true,
                maintainSize: true,
                child: const Text(
                  'Press the button on your bridge.\n'
                  'You have 25 seconds.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: padding * 2),

              // ESTABLISH REMOTE CONTACT
              ElevatedButton(
                onPressed: bridge == null ? null : remoteContact,
                child: const Text('Establish Remote Contact'),
              ),

              const SizedBox(height: padding * 2),

              sectionHeader('Reading Data'),

              // FETCH NETWORK
              ElevatedButton(
                onPressed: bridge == null ? null : fetchNetwork,
                child: const Text('Fetch Network'),
              ),

              const SizedBox(height: padding * 2),

              // FETCH BRIDGE
              ElevatedButton(
                onPressed: bridge == null ? null : fetchBridge,
                child: const Text('Fetch Bridge'),
              ),

              const SizedBox(height: padding * 2),

              // FETCH LIGHT
              ElevatedButton(
                onPressed: bridge == null ? null : fetchLight,
                child: const Text('Fetch Light'),
              ),

              const SizedBox(height: padding * 2),

              sectionHeader('Writing Data'),

              // IDENTIFY LIGHT
              ElevatedButton(
                onPressed: light == null ? null : identifyLight,
                child: const Text('Identify Light'),
              ),

              const SizedBox(height: padding * 2),

              // TOGGLE LIGHT ON/OFF
              ElevatedButton(
                onPressed: light == null ? null : toggleLight,
                child: const Text('Toggle Light on/off'),
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
                      onPressed: light == null ? null : () => colorLight('red'),
                      child: const Text('Red'),
                    ),

                    // GREEN
                    ElevatedButton(
                      onPressed:
                          light == null ? null : () => colorLight('green'),
                      child: const Text('Green'),
                    ),

                    // BLUE
                    ElevatedButton(
                      onPressed:
                          light == null ? null : () => colorLight('blue'),
                      child: const Text('Blue'),
                    ),

                    // WHITE
                    ElevatedButton(
                      onPressed:
                          light == null ? null : () => colorLight('white'),
                      child: const Text('White'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: padding * 2),

              sectionHeader(
                'Entertainment Streaming',
                GestureDetector(
                  onTap: (hueNetwork == null || !isStreaming)
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return StreamDemosScreen(
                                  entertainmentConfiguration: hueNetwork!
                                      .entertainmentConfigurations.first,
                                );
                              },
                            ),
                          );
                        },
                  child: Text(
                    'more >',
                    style: TextStyle(
                      color: (hueNetwork == null || !isStreaming)
                          ? Colors.grey
                          : Colors.blue,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // STREAM 1
                    ElevatedButton(
                      onPressed:
                          hueNetwork == null ? null : () => startStreaming(1),
                      child: const Text('Stream 1'),
                    ),

                    // STREAM 2
                    ElevatedButton(
                      onPressed:
                          hueNetwork == null ? null : () => startStreaming(2),
                      child: const Text('Stream 2'),
                    ),

                    // STREAM 3
                    ElevatedButton(
                      onPressed:
                          hueNetwork == null ? null : () => startStreaming(3),
                      child: const Text('Stream 3'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: padding * 2),

              // STOP STREAMING
              ElevatedButton(
                onPressed:
                    (hueNetwork == null || !isStreaming) ? null : stopStreaming,
                child: const Text('Stop Streaming'),
              ),

              const SizedBox(height: padding),
            ],
          ),
        ),
      ),
    );
  }

  /// The titles and dividers that separate each group of buttons.
  Widget sectionHeader(String title, [Widget? actionBtn]) {
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
            if (actionBtn != null) const Spacer(),
            if (actionBtn != null) actionBtn,
            if (actionBtn != null) const SizedBox(width: padding),
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
          title: const Text('Bridge IP'),
          content: SingleChildScrollView(
            child: ListBody(
              children: bridgeIps.map((ip) => Text(ip)).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> doSomething() async {
    setState(() {
      isLoading = true;
    });

    // ignore: avoid_print
    print('Doing something...');

    // TODO: You can do your experiments easily here.

    // ignore: avoid_print
    print('Done!');

    setState(() {
      isLoading = false;
    });
  }

  /// Searches the network for bridges.
  ///
  /// If any are found, their IP addresses are placed in the [bridgeIps] list.
  Future<void> discoverBridges() async {
    setState(() {
      isLoading = true;
    });

    List<DiscoveredBridge> bridges =
        await BridgeDiscoveryRepo.discoverBridges();

    setState(() {
      bridgeIps.clear();
      bridgeIps.addAll(bridges.map((e) => e.ipAddress));
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
      bridgeIpAddr: ipGroupController.value ?? bridgeIps.first,
      controller: timeoutController,
    );

    setState(() {
      onContactCancel = null;
      isLoading = false;
    });
  }

  /// Establishes remote contact with the bridge.
  Future<void> remoteContact() async {
    setState(() {
      isLoading = true;
    });

    await BridgeDiscoveryRepo.remoteAuthRequest(
      clientId: widget.clientId,
      redirectUri: 'flutterhue://auth',
      deviceName: 'TestDevice',
      encrypter: (plaintext) => 'abcd${plaintext}1234',
    );

    setState(() {
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

    if (hueNetwork?.hasFailedFetches == true) {
      // ignore: avoid_print
      print('WARNING — Failed to fetch all resources');
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

      // Shows a way to display the info in these objects.
      // log('Bridge Json - ${JsonTool.writeJson(res?.first ?? {})}');
      // log('Bridge Object - ${JsonTool.writeJson(myBridge.toJson(optimizeFor: OptimizeFor.dontOptimize))}');
    } catch (_) {
      // res list was empty
    }

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

    lightDevice.identifyAction = 'identify';

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

    if (color == 'red') {
      x = 0.6718;
      y = 0.3184;
    } else if (color == 'green') {
      x = 0.2487;
      y = 0.6923;
    } else if (color == 'blue') {
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

  /// Whether or not the entertainment streaming process is currently active.
  bool get isStreaming =>
      _isStreamingPattern1 || _isStreamingPattern2 || _isStreamingPattern3;

  /// Starts the entertainment streaming process.
  ///
  /// The `pattern` parameter determines which pattern to use. The patterns are
  /// as follows:
  /// * `1`: Toggle 1 light between red and blue colors.
  /// * `2`: Gently fade 1 light between red and blue colors.
  /// * `3`: Toggles 2 lights between white and off, as if the light is jumping
  ///         back and forth between the two lights.
  Future<void> startStreaming(int pattern) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (!isStreaming) {
        final bool didStart = await hueNetwork!
            .entertainmentConfigurations.first
            .startStreaming(bridge!);

        if (!didStart) throw 'Failed to start stream';
      }

      // Clear out the stream queue before starting a new stream.
      hueNetwork!.entertainmentConfigurations.first.flushStreamQueue();

      if (pattern == 1) {
        await _startStreaming1();
      } else if (pattern == 2) {
        await _startStreaming2();
      } else if (pattern == 3) {
        await _startStreaming3();
      } else {
        // ignore: avoid_print
        print('Invalid pattern');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error starting stream: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  /// Whether or not the entertainment streaming process is currently active and
  /// using pattern 1.
  bool _isStreamingPattern1 = false;

  /// Starts the entertainment streaming process, with streaming pattern 1.
  ///
  /// Toggle 1 light between red and blue colors.
  ///
  /// This should cause one light to alternate between red and blue.
  ///
  /// The light will stay red or blue for 500ms then switch. This will
  /// happen for 5 seconds, then it should stop on blue.
  ///
  /// Since blue is the last state, it will still be streaming blue so
  /// the bridge doesn't drop the connection due to inactivity.
  Future<void> _startStreaming1() async {
    _isStreamingPattern1 = true;
    _isStreamingPattern2 = false;
    _isStreamingPattern3 = false;

    final ColorXy red = ColorXy.fromRgb(255, 0, 0, 1.0);
    final ColorXy blue = ColorXy.fromRgb(0, 0, 255, 1.0);

    final EntertainmentStreamCommand command1 = EntertainmentStreamCommand(
      channel: 0,
      color: red,
      waitAfterAnimation: const Duration(milliseconds: 500),
    );

    final EntertainmentStreamCommand command2 = EntertainmentStreamCommand(
      channel: 0,
      color: blue,
      waitAfterAnimation: const Duration(milliseconds: 500),
    );

    for (int i = 0; i < 5; i++) {
      // IMPORTANT NOTE: The copy method is used here to ensure that the
      // same command isn't added to the queue multiple times. If the
      // same command is added multiple times, the bridge will only
      // execute the command once.
      hueNetwork!.entertainmentConfigurations.first.addAllToStreamQueue(
        [command1.copy(), command2.copy()],
      );
    }
  }

  /// Whether or not the entertainment streaming process is currently active and
  /// using pattern 2.
  bool _isStreamingPattern2 = false;

  /// Starts the entertainment streaming process, with streaming pattern 2.
  ///
  /// Gently fade 1 light between red and blue colors.
  ///
  /// This should cause one light to fade between red and blue.
  ///
  /// The light will fade from red to blue over 500ms, then fade back to red
  /// over 500ms. This will happen for 5 seconds, then it should stop on blue.
  ///
  /// Since blue is the last state, it will still be streaming blue so
  /// the bridge doesn't drop the connection due to inactivity.
  Future<void> _startStreaming2() async {
    _isStreamingPattern1 = false;
    _isStreamingPattern2 = true;
    _isStreamingPattern3 = false;

    final ColorXy red = ColorXy.fromRgb(255, 0, 0, 1.0);
    final ColorXy blue = ColorXy.fromRgb(0, 0, 255, 1.0);

    final EntertainmentStreamCommand command1 = EntertainmentStreamCommand(
      channel: 0,
      color: red,
      animationDuration: const Duration(milliseconds: 500),
      animationType: AnimationType.ease,
    );

    final EntertainmentStreamCommand command2 = EntertainmentStreamCommand(
      channel: 0,
      color: blue,
      animationDuration: const Duration(milliseconds: 500),
      animationType: AnimationType.ease,
    );

    // This should cause one lights to alternate between red and blue.
    //
    // They will stay red or blue for 500ms then switch. This will
    // happen for 5 seconds, then it should stop on blue.
    //
    // Since blue is the last state, it will still be streaming blue so
    // the bridge doesn't drop the connection due to inactivity.
    for (int i = 0; i < 5; i++) {
      // IMPORTANT NOTE: The copy method is used here to ensure that the
      // same command isn't added to the queue multiple times. If the
      // same command is added multiple times, the bridge will only
      // execute the command once.
      hueNetwork!.entertainmentConfigurations.first.addAllToStreamQueue(
        [command1.copy(), command2.copy()],
      );
    }
  }

  /// Whether or not the entertainment streaming process is currently active and
  /// using pattern 3.
  bool _isStreamingPattern3 = false;

  /// Starts the entertainment streaming process, with streaming pattern 3.
  ///
  /// Toggles 2 lights between white and off, as if the light is jumping back
  /// and forth between the two lights.
  ///
  /// One light will stay white for 500ms, then turn off for 500ms. The other
  /// light will do the opposite. This will happen continuously until the user
  /// stops the stream.
  Future<void> _startStreaming3() async {
    _isStreamingPattern1 = false;
    _isStreamingPattern2 = false;
    _isStreamingPattern3 = true;

    final ColorXy white = ColorXy.fromRgb(255, 255, 255, 0.5);
    final ColorXy off = ColorXy.fromRgb(0, 0, 0, 0.0);

    // Continuously alternate between white and off for 500ms each.
    Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        // Turn the timer off when the user stops the stream.
        if (!_isStreamingPattern3) {
          timer.cancel();
          return;
        }

        hueNetwork!.entertainmentConfigurations.first.addAllToStreamQueue(
          [
            EntertainmentStreamCommand(
              channel: 0,
              color: (timer.tick - 1) % 2 == 0 ? white : off,
              waitAfterAnimation: const Duration(milliseconds: 500),
            ),
            EntertainmentStreamCommand(
              channel: 1,
              color: (timer.tick - 1) % 2 == 0 ? off : white,
              waitAfterAnimation: const Duration(milliseconds: 500),
            ),
          ],
        );
      },
    );
  }

  /// Stops the entertainment streaming process.
  Future<void> stopStreaming() async {
    setState(() {
      isLoading = true;
    });

    bool isStreaming = this.isStreaming;

    try {
      await hueNetwork!.entertainmentConfigurations.first
          .stopStreaming(bridge!)
          .then(
        (value) {
          if (value) {
            isStreaming = false;
          }
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error stopping stream: $e');
    }

    setState(() {
      if (!isStreaming) {
        _isStreamingPattern1 = false;
        _isStreamingPattern2 = false;
        _isStreamingPattern3 = false;
      }
      isLoading = false;
    });
  }
}
