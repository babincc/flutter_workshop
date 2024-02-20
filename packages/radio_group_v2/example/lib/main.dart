import 'package:flutter/material.dart';
import 'package:radio_group_v2/radio_group_v2.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// The currently selected value of the vertical radio group.
  ///
  /// This one is obtained automatically, thanks to the onChange() method.
  String verticalValAutomatic = "";

  /// The currently selected value of the vertical radio group.
  ///
  /// This one is obtained by clicking the "Fetch Selected" button under the
  /// vertical radio group.
  String verticalValRequested = "";

  /// The currently selected value of the horizontal radio group.
  ///
  /// This one is obtained automatically, thanks to the onChange() method.
  String horizontalValAutomatic = "";

  /// The currently selected value of the horizontal radio group.
  ///
  /// This one is obtained by clicking the "Fetch Selected" button under the
  /// horizontal radio group.
  String horizontalValRequested = "";

  /// The controller for the vertical radio group.
  final RadioGroupController verticalGroupController = RadioGroupController();

  /// The controller for the horizontal radio group.
  final RadioGroupController horizontalGroupController = RadioGroupController();

  /// The values for the vertical radio group.
  final List<String> verticalValues = [
    "String 1",
    "String 2",
    "String 3",
    "String 4",
    "String 5",
  ];

  /// The values for the horizontal radio group.
  final List<Text> horizontalValues = [
    const Text("Widget 1"),
    const Text("Widget 2"),
    const Text("Widget 3"),
    const Text("Widget 4"),
    const Text("Widget 5"),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Radio Group"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  selectedValBoard(verticalValAutomatic, verticalValRequested),
                  IntrinsicWidth(
                    child: RadioGroup(
                      controller: verticalGroupController,
                      values: verticalValues,
                      onChanged: (newValue) => setState(() {
                        verticalValAutomatic = newValue.toString();
                      }),
                      decoration: const RadioGroupDecoration(
                        labelStyle: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  actionButtons(RadioGroupId.vertical),
                  const Divider(
                    height: 50.0,
                  ),
                  selectedValBoard(
                      horizontalValAutomatic, horizontalValRequested),
                  RadioGroup(
                    controller: horizontalGroupController,
                    values: horizontalValues,
                    orientation: RadioGroupOrientation.horizontal,
                    indexOfDefault: 0,
                    onChanged: (newValue) => setState(() {
                      horizontalValAutomatic = newValue.toString();
                    }),
                  ),
                  actionButtons(RadioGroupId.horizontal),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// This method builds the section at the top of each radio group that shows
  /// which button is selected.
  ///
  /// This shows of the ability to be able to get the selected value in two
  /// different ways.
  Padding selectedValBoard(String automatic, String requested) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.5),
      child: Column(
        children: [
          const Text("Selected Value"),
          IntrinsicHeight(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        const Text("onChange():"),
                        Text(automatic),
                      ],
                    ),
                  ],
                ),
              ),
              const VerticalDivider(
                color: Colors.black,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Text("\"Fetch Selected\" btn:"),
                        Text(requested),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  /// The buttons used to demo the radio groups.
  Padding actionButtons(RadioGroupId radioGroupId) {
    /// Make the buttons blue.
    ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.pressed)
            ? Colors.blueAccent
            : Colors.blue,
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );

    /// Make the button text white.
    TextStyle textStyle = const TextStyle(
      color: Colors.white,
    );

    /// Either the [verticalGroupController] or the [horizontalGroupController]
    /// depending on which radio group we are working with at the moment.
    RadioGroupController radioGroupController;
    if (radioGroupId == RadioGroupId.vertical) {
      radioGroupController = verticalGroupController;
    } else {
      radioGroupController = horizontalGroupController;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  radioGroupController.value = null;
                },
                style: buttonStyle,
                child: Text(
                  "Select None",
                  style: textStyle,
                ),
              ),
              const SizedBox(
                width: 12.5,
              ),
              TextButton(
                onPressed: () {
                  if (radioGroupId == RadioGroupId.vertical) {
                    radioGroupController.value = verticalValues.last;
                  } else {
                    radioGroupController.value = horizontalValues.last;
                  }
                },
                style: buttonStyle,
                child: Text(
                  "Select Last",
                  style: textStyle,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12.5,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (radioGroupId == RadioGroupId.vertical) {
                  verticalValRequested = radioGroupController.value.toString();
                } else {
                  horizontalValRequested =
                      radioGroupController.value.toString();
                }
              });
            },
            style: buttonStyle,
            child: Text(
              "Fetch Selected",
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}

/// This is how this example code will know if we are talking about the vertical
/// radio group example or the horizontal radio group example.
enum RadioGroupId {
  /// The vertical radio group example.
  vertical,

  /// The horizontal radio group example.
  horizontal,
}
