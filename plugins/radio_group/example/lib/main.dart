import 'package:flutter/material.dart';
import 'package:radio_group/radio_group.dart';

void main() {
  runApp(App());
}

/// This is how this example code will know if we are talking about the vertical
/// radio group example or the horizontal radio group example.
enum RadioGroupId {
  /// The vertical radio group example.
  Vertical,

  /// The horizontal radio group example.
  Horizontal,
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
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
  RadioGroupController verticalGroupController = RadioGroupController();

  /// The controller for the horizontal radio group.
  RadioGroupController horizontalGroupController = RadioGroupController();

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
    Text("Widget 1"),
    Text("Widget 2"),
    Text("Widget 3"),
    Text("Widget 4"),
    Text("Widget 5"),
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
                      decoration: RadioGroupDecoration(
                        labelStyle: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  actionButtons(RadioGroupId.Vertical),
                  Divider(
                    height: 50.0,
                  ),
                  selectedValBoard(
                      horizontalValAutomatic, horizontalValRequested),
                  RadioGroup(
                    controller: horizontalGroupController,
                    values: horizontalValues,
                    orientation: RadioGroupOrientation.Horizontal,
                    indexOfDefault: 0,
                    onChanged: (newValue) => setState(() {
                      horizontalValAutomatic = newValue.toString();
                    }),
                  ),
                  actionButtons(RadioGroupId.Horizontal),
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
          Text("Selected Value"),
          IntrinsicHeight(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text("onChange():"),
                        Text(automatic),
                      ],
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                color: Colors.black,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text("\"Fetch Selected\" btn:"),
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
        EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );

    /// Make the button text white.
    TextStyle textStyle = TextStyle(
      color: Colors.white,
    );

    /// Either the [verticalGroupController] or the [horizontalGroupController]
    /// depending on which radio group we are working with at the moment.
    RadioGroupController radioGroupController;
    if (radioGroupId == RadioGroupId.Vertical) {
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
                child: Text(
                  "Select None",
                  style: textStyle,
                ),
                style: buttonStyle,
              ),
              SizedBox(
                width: 12.5,
              ),
              TextButton(
                onPressed: () {
                  if (radioGroupId == RadioGroupId.Vertical) {
                    radioGroupController.value = verticalValues.last;
                  } else {
                    radioGroupController.value = horizontalValues.last;
                  }
                },
                child: Text(
                  "Select Last",
                  style: textStyle,
                ),
                style: buttonStyle,
              ),
            ],
          ),
          SizedBox(
            height: 12.5,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (radioGroupId == RadioGroupId.Vertical) {
                  verticalValRequested = radioGroupController.value.toString();
                } else {
                  horizontalValRequested =
                      radioGroupController.value.toString();
                }
              });
            },
            child: Text(
              "Fetch Selected",
              style: textStyle,
            ),
            style: buttonStyle,
          ),
        ],
      ),
    );
  }
}
