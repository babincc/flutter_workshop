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
  final Future wantedPersonsFuture = fetchWantedPersons(
    page: Random().nextInt(10) + 1,
  );

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
                final int max = results.wantedPersons!.length - 1;
                final int index = Random().nextInt(max + 1);

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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.red,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 15),

          // DESCRIPTION
          Text(
            person.description ?? '',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 15),

          // IMAGE
          _image(context, person.images),

          // TABLE
          _infoBlock('DESCRIPTION', _table(context, person)),

          // REWARD
          _infoBlock('REWARD', person.rewardText),

          // REMARKS
          _infoBlock('REMARKS', person.remarks),

          // CAUTION
          _infoBlock('CAUTION', person.caution),

          // DETAILS
          _infoBlock('DETAILS', person.details),
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

  /// Each information block with a title and information.
  Widget _infoBlock(String title, dynamic value) {
    Widget valueWidget;

    if (value is Widget) {
      valueWidget = value;
    } else if (value is String) {
      valueWidget = _infoBlockText(value);
    } else if (value is List<String>) {
      valueWidget = _infoBlockText(value.join(', '));
    } else {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                ),
          ),
          const SizedBox(height: 5),
          valueWidget,
        ],
      ),
    );
  }

  /// A helper method for [_infoBlock] to create a text widget.
  Widget _infoBlockText(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  /// The table that contains information about the wanted person.
  Widget _table(BuildContext context, WantedPerson person) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ALIASES
        _tableCell(
          context,
          'Aliases',
          person.aliases?.join(', ') ?? '',
        ),

        // BIRTH DATE
        _tableCell(
          context,
          'Date(s) of Birth Used',
          person.datesOfBirthUsed?.join(', ') ?? '',
          false,
        ),

        // BIRTH PLACE
        _tableCell(
          context,
          'Place of Birth',
          person.placeOfBirth ?? '',
        ),

        // HAIR
        _tableCell(
          context,
          'Hair',
          person.hairColor ?? '',
          false,
        ),

        // EYES
        _tableCell(
          context,
          'Eyes',
          person.eyeColor ?? '',
        ),

        // HEIGHT
        _tableCell(
          context,
          'Height',
          person.heightFeetText ?? '',
          false,
        ),

        // WEIGHT
        _tableCell(
          context,
          'Weight',
          person.weightLbsText ?? '',
        ),

        // SEX
        _tableCell(
          context,
          'Sex',
          person.sex ?? '',
          false,
        ),

        // RACE
        _tableCell(
          context,
          'Race',
          person.race ?? '',
        ),

        // NATIONALITY
        _tableCell(
          context,
          'Nationality',
          person.nationality ?? '',
          false,
        ),

        // SCARS AND MARKS
        _tableCell(
          context,
          'Scars and Marks',
          person.scarsAndMarks ?? '',
        ),
      ],
    );
  }

  /// A helper method for [_table] to create a table cell.
  Widget _tableCell(BuildContext context, String title, String value,
      [bool isGrey = true]) {
    return Container(
      color: isGrey ? Colors.grey[300] : null,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            '$title: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          // VALUE
          Flexible(
            child: Text(
              value,
              softWrap: true,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
