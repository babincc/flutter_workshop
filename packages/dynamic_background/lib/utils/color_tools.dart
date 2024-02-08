import 'package:flutter/material.dart';

/// Extension for sorting a list of colors.
extension ColorListSorter on List<Color> {
  /// Sorts colors based on their saturation.
  ///
  /// Less saturated colors will be at the beginning of the list.
  void sortColors() {
    sort(
      (a, b) => HSVColor.fromColor(a)
          .saturation
          .compareTo(HSVColor.fromColor(b).saturation),
    );
  }

  /// Sorts colors based on their hue.
  void sortColorsIntoRainbow() {
    sort(
      (a, b) {
        int toReturn =
            HSVColor.fromColor(a).hue.compareTo(HSVColor.fromColor(b).hue);

        if (toReturn == 0) {
          toReturn = HSVColor.fromColor(a)
              .saturation
              .compareTo(HSVColor.fromColor(b).saturation);
        }

        return toReturn;
      },
    );
  }
}
