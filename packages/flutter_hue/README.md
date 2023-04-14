# Flutter Hue

<img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/logos/flutter_hue_logo.png" alt="Flutter Hue logo" height="110" width="110">

An SDK designed for the Flutter framework that enables developers to easily integrate Philips Hue smart devices into their applications.

Note: This SDK uses Philips Hue's new API v2.

With Flutter Hue, developers can easily discover Hue bridges on the network, establish communication with them, and manipulate their connected devices. All of this is shown in the examples below. Also shown is how to chang the color of lights and turning them on and off.

## Features

Shown in this demo gif:

1. Discover bridges on the network
2. Establish connection with the bridges
3. Discover the devices that are connected to the bridges
4. Identify a light (used to let the user know what light they are configuring)
5. Toggle a light on and off
6. Change the color of a light

![A gif demonstrating Flutter Hue in action.](https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/demos/flutter_hue_demo.gif)

## Installation

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
 flutter_hue: ^1.0.0
```

Import it to each file you use it in:

 ```dart
 import 'package:flutter_hue/flutter_hue.dart';
 ```

## Usage

### Establishing Remote Connection

Without doing this, your app will only be able to communicate with Philips Hue bridges that are on the same network as the user's device. This section will show you how to establish a remote connection with a bridge; that way, it can be controlled from anywhere in the world.

Due to the length of these instructions, they have been placed in their own document, [here](https://github.com/babincc/flutter_workshop/blob/master/packages/flutter_hue/remote_connection_instructions.md).

Once you have completed the steps in the above document, you will be able to communicate with a bridge remotely using the same steps as all of the examples below.

### Example 1

This example shows how to get a list of all of the IP addresses of the Philips Hue bridges on the network.

``` dart
List<String> bridgeIps = await BridgeDiscoveryRepo.discoverBridges();
```

### Example 2

This example shows how to establish first contact with a bridge on a device. This is what causes the bridge to create an application key for the user's device. 

Warning: Any device with this key will have access to the bridge. It is meant to be kept secret.

``` dart
Bridge myBridge = await BridgeDiscoveryRepo.firstContact(
  bridgeIpAddr: 192.168.1.1, // Get IP in example 1
  controller: timeoutController,
);
```

### Example 3

This example shows how to find every Philips Hue device on the network. 

Note: This is only for devices that are connected to a bridge that the user's device has access to (see example 2).

``` dart
// Create the network object
// Get the bridges in example 2
HueNetwork myHueNetwork = HueNetwork(bridges: [bridge1, bridge2]);

// Populate the network object
await hueNetwork.fetchAll();
```

### Example 4

This example shows how to change the color of a light.

``` dart
// Get a light to change the color of.
// Hue Network can be found in example 3
Light myLight = myHueNetwork.lights.first;

// Set a new color that you want to change the light to
myLight = myLight
	.copyWith(
		color: myLight.color.copyWith(
			xy: LightColorXy(x: 0.6718, y: 0.3184),
		),
	);

// Send the PUT request to change the color of the light.
await bridge.put(myLight);
```

### Example 5

This example shows how to turn multiple lights on and off.

``` dart
// Figure out which group is the one you want
// Get network from example 3
Relative myRelative = myHueNetwork
	.rooms
	.first
	.services
	.firstWhere((service) => 
		service.type == ResourceType.groupedLight);

// Get the group who's ID was just found
GroupedLight myGroupedLight = myHueNetwork.groupedLights.firstWhere(
  (groupedLight) => groupedLight.id == myRelative.id,
);

// Toggle the on/off state
myGroupedLight.on.isOn = !myGroupedLight.on.isOn;

// PUT the new state
myBridge.put(myGroupedLight);
```

<hr>

<h3 align="center">If you found this helpful, please consider donating. Thanks!</h3>
<p align="center">
  <a href="https://www.buymeacoffee.com/babincc" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/buy_me_a_coffee_logo.png" alt="buy me a coffee" height="45">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://paypal.me/cssbabin" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/pay_pal_logo.png" alt="paypal" height="45">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://venmo.com/u/babincc" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/venmo_logo.png" alt="venmo" height="45">
  </a>
</p>
<br><br>
