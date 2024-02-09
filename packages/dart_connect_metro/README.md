# Dart Connect Metro

<img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/logos/dart_connect_metro_logo.png" alt="Dart Connect Metro Logo" height="250">

**D**art **C**onnect Metro is a valuable resource for developers looking to integrate data from the Washington DC Metro system into their applications. This SDK provides convenient access to essential information, including real-time updates and schedules, allowing developers to enhance the functionality and user experience of their DC Metro-related apps.

<img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/demos/dart_connect_metro_image.png" alt="Two screenshots from the demo showing what data from the SDK could look like" height="450">

## Installation

In the `pubspec.yaml` of your project, add the following dependency:

```yaml
dependencies:
  dart_connect_metro: ^0.1.2
```

Import it to each file you use it in:

```dart
import 'package:dart_connect_metro/dart_connect_metro.dart';
```

## Getting Started

### Generate Your API Keys

You will need to generate custom API keys for your program on the Washington
Metropolitan Area Transit Authority (WMATA) website.

First, create an account <a href="https://developer.wmata.com/signup">here</a>.

Next, go to the <a href="https://developer.wmata.com/Products">products</a> page
and subscribe (the default tier is free).

Finally, go to your <a href="https://developer.wmata.com/developer">profile</a>
page to see your API keys.

## Usage

### Example 1 - Trip Cost

This example shows how to get the cost of a trip. There is some nuance to be aware of; there is a normal fare and a senior/disabled citizen fare. The normal fare is further broken down into peak/non-peak hours.

```dart
// The station codes for the example route. Normally, you would get these
// programmatically.
static const String federalTriangleCode = 'D01';
static const String rosslynCode = 'C05';

/// Fetch the station to station information.
List<StationToStation> stationToStation =
	await fetchStationToStation(
		apiKey,
		startStationCode: federalTriangleCode,
		destinationStationCode: rosslynCode,
	);

/// Get the cost of the trip.
final double cost = stationToStation.first.railFare.currentFare;

/// Get the cost of the trip for a senior citizen.
final double seniorCost = stationToStation.first.railFare.seniorCitizen;
```

### Example 2 - Stations on Path

This example shows how to get the names of all the stations on a route.

```dart
/// Fetch the path information.
Path path = await fetchPath(
	apiKey,
	startStationCode: federalTriangleCode,
	destinationStationCode: rosslynCode,
);

List<String> stationNames = [];

for(Path pathItem in path.items) {
	stationNames.add(pathItem.stationName);
}
```

### Example 3 - Departure and Arrival Times

This example shows how to find the next departure and arrival times for a route going from one station to another.

```dart
/// Fetch the station to station information.
List<StationToStation> stationToStation =
	await fetchStationToStation(
		apiKey,
		startStationCode: federalTriangleCode,
		destinationStationCode: rosslynCode,
	);

/// Fetch the path information.
Path path = await fetchPath(
	apiKey,
	startStationCode: federalTriangleCode,
	destinationStationCode: rosslynCode,
);

/// Fetch the next train information.
List<NextTrain> nextTrain = await fetchNextTrains(
	apiKey,
	stationCodes: [federalTriangleCode],
);

// Get line code to match with next train.
final String lineCode = path.items.first.lineCode;

// Get the next train for the line.
late final NextTrain nextTrain;
for (NextTrain train in nextTrains) {
	if (train.line == lineCode) {
		nextTrain = train;
		break;
	}
}

// Get the time of the next train.
final DateTime nextTrainTime =
DateTime.now().add(Duration(minutes: nextTrain.minutesAway ?? 0));

/// The time when the train will arrive to pick you up to start your trip.
final Time departureTime = Time.fromDateTime(nextTrainTime);

/// The time when you will arrive at your destination station.
final Time arrivalTime = Time.fromDateTime(nextTrainTime);

// Add the minutes of the journey to get arrival time.
for (StationToStation station in stationToStation) {
	arrivalTime.add(Duration(minutes: station.travelTimeMinutes));
}
```

For more examples, view the example project that comes in this package.

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
