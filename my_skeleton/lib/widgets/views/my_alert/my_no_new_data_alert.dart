import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';

class MyNoNewDataAlert extends StatelessWidget {
  /// This alert is shown when the user tries to submit a form and there is no
  /// new data.
  ///
  /// This lets the user know their submission did not go through, but it wasn't
  /// because of a system failure.
  const MyNoNewDataAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = MyThemeProvider.of(context).colors.warning;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info, color: color, size: MyMeasurements.alertIconSize),
        Text(
          'No New Data To Submit',
          style: TextStyle(
            fontSize: MyMeasurements.alertFontSize,
            color: color,
          ),
        ),
      ],
    );
  }
}
