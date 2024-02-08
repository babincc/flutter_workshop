import 'dart:ui';

import 'package:flutter/material.dart';

/// Returns the size of the screen in logical pixels, without the need for a
/// [BuildContext].
Size get screenSize {
  final FlutterView view = PlatformDispatcher.instance.views.first;

  final double physicalWidth = view.physicalSize.width;
  final double physicalHeight = view.physicalSize.height;

  final double devicePixelRatio = view.devicePixelRatio;

  final double screenWidth = physicalWidth / devicePixelRatio;
  final double screenHeight = physicalHeight / devicePixelRatio;

  return Size(screenWidth, screenHeight);
}
