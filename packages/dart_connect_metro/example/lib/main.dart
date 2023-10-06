import 'package:dart_connect_metro/dart_connect_metro.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

late final String apiKey;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // For this demo to work, you will need to create an assets folder and put a
  // file called api_key.key in it. The file should contain your API key with
  // no spaces or new lines.
  apiKey = await rootBundle.loadString('assets/api_key.key');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Connect Metro Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // The station codes for the example route. Normally, you would get these
  // programmatically.
  static const String federalTriangleCode = 'D01';
  static const String rosslynCode = 'C05';

  /// The future that will fetch the station to station information.
  final Future<List<StationToStation>> stationToStationFuture =
      fetchStationToStation(
    apiKey,
    startStationCode: federalTriangleCode,
    destinationStationCode: rosslynCode,
  );

  /// The future that will fetch the path information.
  final Future<Path> pathFuture = fetchPath(
    apiKey,
    startStationCode: federalTriangleCode,
    destinationStationCode: rosslynCode,
  );

  /// The future that will fetch the next train information.
  final Future<List<NextTrain>> nextTrainFuture = fetchNextTrains(
    apiKey,
    stationCodes: [federalTriangleCode],
  );

  /// The future that will fetch the rail incidents.
  final Future<List<RailIncident>> incidentFuture = fetchRailIncidents(apiKey);

  /// The future that will fetch the elevator and escalator incidents at the
  /// start station.
  final Future<List<AdaIncident>> adaIncidencesFuture1 = fetchAdaIncidents(
    apiKey,
    stationCode: federalTriangleCode,
  );

  /// The future that will fetch the elevator and escalator incidents at the
  /// destination station.
  final Future<List<AdaIncident>> adaIncidencesFuture2 = fetchAdaIncidents(
    apiKey,
    stationCode: rosslynCode,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dart Connect Metro Demo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ROUTE INFO - hard coded for cleaner example
              _routeInfo(),

              const SizedBox(height: 40.0),

              // TIME
              _time(),

              const SizedBox(height: 15.0),

              // COST
              _cost(),

              const SizedBox(height: 15.0),

              // INCIDENTS
              _incidents(context),

              const SizedBox(height: 15.0),

              // LINE
              _route(),
            ],
          ),
        ),
      ),
    );
  }

  /// Show the start and end destinations for the example route.
  Widget _routeInfo() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // CURRENT STATION
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_outlined),
              Text(
                'Current Station',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Federal Triangle'),
            ],
          ),
        ),

        // RIGHT ARROWS
        Icon(Icons.keyboard_double_arrow_right_outlined),

        // DESTINATION STATION
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.not_listed_location_outlined),
              Text(
                'Destination Station',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Rosslyn'),
            ],
          ),
        ),
      ],
    );
  }

  /// Show the time for the example route.
  Widget _time() {
    return _myContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // DEPART
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ICON
                const Icon(Icons.departure_board_outlined, size: 30.0),

                const SizedBox(height: 9.0),

                // DEPARTURE TIME
                FutureBuilder(
                  future: Future.wait([
                    pathFuture,
                    nextTrainFuture,
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data is List) {
                        // Get the values of the futures.
                        final Path? path = snapshot.data?[0] as Path?;
                        final List<NextTrain>? nextTrains =
                            snapshot.data?[1] as List<NextTrain>?;

                        // Verify values are not null.
                        if (path != null && nextTrains != null) {
                          return _getTimeText(path, nextTrains);
                        }
                      }

                      return const Text('Error!');
                    } else if (snapshot.hasError) {
                      return const Text('Error!');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),

          const Text('to'),

          // ARRIVE
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ICON
                const Icon(Icons.access_time_outlined, size: 30.0),

                const SizedBox(height: 9.0),

                // ARRIVAL TIME
                FutureBuilder(
                  future: Future.wait([
                    stationToStationFuture,
                    pathFuture,
                    nextTrainFuture,
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data is List) {
                        // Get the values of the futures
                        final List<StationToStation>? stationToStation =
                            snapshot.data?[0] as List<StationToStation>?;
                        final Path? path = snapshot.data?[1] as Path?;
                        final List<NextTrain>? nextTrains =
                            snapshot.data?[2] as List<NextTrain>?;

                        // Verify values are not null
                        if (stationToStation != null &&
                            path != null &&
                            nextTrains != null) {
                          return _getTimeText(
                            path,
                            nextTrains,
                            stationToStation,
                          );
                        }
                      }

                      return const Text('Error!');
                    } else if (snapshot.hasError) {
                      return const Text('Error!');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show the cost for the example route.
  Widget _cost() {
    /// Formats the fare cost to be in US dollars.
    final NumberFormat dollarAmount = NumberFormat('#,##0.00', 'en_US');

    return _myContainer(
      child: FutureBuilder(
        future: Future.wait([
          stationToStationFuture,
          pathFuture,
          nextTrainFuture,
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data is List) {
              // Get the values of the futures.
              final List<StationToStation>? stationToStation =
                  snapshot.data?[0] as List<StationToStation>?;
              final Path? path = snapshot.data?[1] as Path?;
              final List<NextTrain>? nextTrains =
                  snapshot.data?[2] as List<NextTrain>?;

              // Verify values are not null.
              if (path != null &&
                  nextTrains != null &&
                  stationToStation != null) {
                /// Get the time that the next train will arrive to pick you
                /// up.
                final Time time = _getTime(path, nextTrains);

                /// Get the cost of the trip.
                final double cost = stationToStation.first.railFare
                    .fareAtTime(time.toDateTime());

                /// Get the cost of the trip for a senior citizen.
                final double seniorCost =
                    stationToStation.first.railFare.seniorCitizen;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NORMAL FARE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // DOLLAR AMOUNT
                        Text(
                          '\$${dollarAmount.format(cost)}',
                          style: const TextStyle(fontSize: 20.0),
                        ),

                        const SizedBox(width: 3.0),

                        // FARE label
                        const Text('Fare'),
                      ],
                    ),

                    const SizedBox(height: 5.0),

                    // SENIOR/DISABLED FARE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // DOLLAR AMOUNT
                        Text('\$${dollarAmount.format(seniorCost)}'),

                        const SizedBox(width: 5.0),

                        // FARE label
                        const Text('Fare (Senior/Disabled)'),
                      ],
                    ),
                  ],
                );
              }
            }

            return const Text('Error!');
          } else if (snapshot.hasError) {
            return const Text('Error!');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  /// Show any incidents for the example route.
  ///
  /// This is dynamic; so, sometimes, there may be no incidents.
  Widget _incidents(BuildContext context) {
    return _myContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // INCIDENTS label
              const Text(
                'Incidences',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              // HANDICAP button
              InkWell(
                onTap: () => _showHandicapAlert(context),
                child: const Icon(Icons.wheelchair_pickup_outlined),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          FutureBuilder(
            future: Future.wait([incidentFuture, pathFuture]),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data is List) {
                  // Get the values of the futures.
                  final List<RailIncident>? railIncidents =
                      snapshot.data?[0] as List<RailIncident>?;
                  final Path? path = snapshot.data?[1] as Path?;

                  // Verify values are not null.
                  if (path != null && railIncidents != null) {
                    // Get line code to match with incidents.
                    final String lineCode = path.items.first.lineCode;

                    /// The incidents that affect the example route.
                    final List<RailIncident> relevantIncidents = railIncidents
                        .where((incident) =>
                            incident.affectedLines.contains(lineCode))
                        .toList();

                    if (relevantIncidents.isEmpty) {
                      return const Center(
                        child: Text('No incidents for this route.'),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (RailIncident incident in relevantIncidents)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // INCIDENT TYPE
                              Text(
                                incident.incidentType,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 3.0),

                              // INCIDENT DESCRIPTION
                              Text(incident.description),

                              const SizedBox(height: 10.0),
                            ],
                          ),
                      ],
                    );
                  }
                }

                return const Text('Error!');
              } else if (snapshot.hasError) {
                return const Text('Error!');
              }
              return const CircularProgressIndicator();
            }),
          ),
        ],
      ),
    );
  }

  /// Show the line for the example route.
  Widget _route() {
    return _myContainer(
      child: FutureBuilder(
        future: pathFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data is Path) {
              final Path path = snapshot.data as Path;

              // Get line code to match with incidents.
              final String lineCode = path.items.first.lineCode;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$lineCode Line',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0, width: double.maxFinite),
                  for (PathItem pathItem
                      in path.items.sublist(0, path.items.length - 1))
                    Column(
                      children: [
                        // INCIDENT DESCRIPTION
                        Text(pathItem.stationName),

                        const SizedBox(height: 5.0),

                        const Center(
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 15,
                          ),
                        ),

                        const SizedBox(height: 5.0),
                      ],
                    ),
                  Center(
                    child: Text(path.items.last.stationName),
                  ),
                ],
              );
            }

            return const Text('Error!');
          } else if (snapshot.hasError) {
            return const Text('Error!');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  /// The light grey boxes that divide sections of the UI.
  Widget _myContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color.fromRGBO(240, 240, 245, 1.0),
      ),
      padding: const EdgeInsets.all(10.5),
      child: child,
    );
  }

  /// Get the time that the next train will arrive to pick you up.
  Time _getTime(Path path, List<NextTrain> nextTrains,
      [List<StationToStation>? stationToStation]) {
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

    // Create Time object for easier string manipulation.
    final Time time = Time.fromDateTime(nextTrainTime);

    if (stationToStation != null) {
      for (StationToStation station in stationToStation) {
        time.add(Duration(minutes: station.travelTimeMinutes));
      }
    }

    return time;
  }

  /// Get the time that the next train will arrive to pick you up.
  Widget _getTimeText(Path path, List<NextTrain> nextTrains,
      [List<StationToStation>? stationToStation]) {
    final Time time = _getTime(path, nextTrains, stationToStation);

    return Text(
      '${time.timeStr_12h}${time.hour < 12 ? '' : ' pm'}',
      style: const TextStyle(fontSize: 20.0),
    );
  }

  void _showHandicapAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Handicap Incidents'),
          content: FutureBuilder(
            future: Future.wait([
              adaIncidencesFuture1,
              adaIncidencesFuture2,
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data is List) {
                  // Get the values of the futures.
                  final List<AdaIncident>? incidentList1 = snapshot.data?[0];
                  final List<AdaIncident>? incidentList2 = snapshot.data?[1];

                  // Verify values are not null.
                  if (incidentList1 != null && incidentList2 != null) {
                    if (incidentList1.isEmpty && incidentList2.isEmpty) {
                      return const Text('No handicap incidents for the '
                          'stations in your route.');
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // STATION NAME
                        if (incidentList1.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 9.0),
                            child: Text(
                              incidentList1.first.stationName,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        // INCIDENTS
                        for (AdaIncident incident in incidentList1)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // INCIDENT TYPE
                              Text(
                                incident.unitType.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 3.0),

                              // INCIDENT DESCRIPTION
                              Text(incident.locationDescription),

                              const SizedBox(height: 10.0),
                            ],
                          ),

                        const SizedBox(height: 25.0),

                        // STATION NAME
                        if (incidentList2.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 9.0),
                            child: Text(
                              incidentList2.first.stationName,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        // INCIDENTS
                        for (AdaIncident incident in incidentList2)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // INCIDENT TYPE
                              Text(
                                incident.unitType.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 3.0),

                              // INCIDENT DESCRIPTION
                              Text(incident.locationDescription),

                              const SizedBox(height: 10.0),
                            ],
                          ),
                      ],
                    );
                  }
                }

                return const Text('Error!');
              } else if (snapshot.hasError) {
                return const Text('Error!');
              }
              return const CircularProgressIndicator();
            },
          ),
        );
      },
    );
  }
}
