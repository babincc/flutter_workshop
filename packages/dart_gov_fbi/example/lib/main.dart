import 'dart:math';

import 'package:dart_gov_fbi/dart_gov_fbi.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// The future that fetches the wanted persons.
  final Future wantedPersonsFuture = fetchWantedPersons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DartGov FBI Demo'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: wantedPersonsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null &&
                snapshot.data is WantedPersonResultSet) {
              // Get the values of the future.
              final WantedPersonResultSet results =
                  snapshot.data as WantedPersonResultSet;

              if (results.wantedPersons != null &&
                  results.wantedPersons!.isNotEmpty) {
                const int min = 0;
                final int max = results.wantedPersons!.length - 1;
                final int index = Random().nextInt((max + 1) - min) + min;

                // Get a random wanted person.
                final WantedPerson person = results.wantedPersons![index];

                return _wantedPoster(context, person);
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

  /// The randomly generated wanted poster.
  Widget _wantedPoster(BuildContext context, WantedPerson person) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // HEADER
          _header(context),

          const SizedBox(height: 15),

          // NAME
          Text(
            person.title ?? '',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.red,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 15),

          // DESCRIPTION
          Text(
            person.description ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.red,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 15),

          // IMAGE
          _image(context, person.images),

          const Text(
            'DESCRIPTION',
            style: TextStyle(
              color: Colors.red,
            ),
          ),

          // TABLE
          // TODO
        ],
      ),
    );
  }

  /// The red header with the FBI logo and title.
  Widget _header(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // LOGO
          Image.asset(
            'assets/images/fbi_logo.png',
            height: 75,
          ),

          const SizedBox(width: 10),

          // TITLE
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WANTED',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                Text(
                  'BY THE FBI',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The image(s) of the wanted person.
  Widget _image(BuildContext context, List<FbiImage>? images) {
    if (images == null || images.isEmpty) {
      return const SizedBox();
    }

    List<Image> imageWidgets = [];

    for (int i = 0; i < min(3, images.length); i++) {
      imageWidgets.add(Image.network(
        images[i].thumbUrl ?? '',
        height: 125,
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: imageWidgets,
      ),
    );
  }
}
