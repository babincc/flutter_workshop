import 'package:flutter/material.dart';

extension ColorListTools on List<Color> {
  void sortColors() {
    sort(
      (a, b) => HSVColor.fromColor(a).hue.compareTo(HSVColor.fromColor(b).hue),
    );
  }
}
