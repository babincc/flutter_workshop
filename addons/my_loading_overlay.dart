// @author Christian Babin
// @version 1.0.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_loading_overlay.dart

import 'package:flutter/material.dart';

/// A loading overlay that shows a circular progress indicator or a user defined
/// widget.
///
/// This does not allow for user interaction while it is showing.
class MyLoadingOverlay {
  /// Creates a new [MyLoadingOverlay].
  ///
  /// ### Default Setup
  ///
  /// This is just a simple loading overlay with a circular progress indicator.
  /// This example also demonstrates how to show and close the overlay.
  ///
  /// ```dart
  /// final MyLoadingOverlay myLoadingOverlay = MyLoadingOverlay();
  /// await myLoadingOverlay.show(context);
  /// // Do some work here.
  /// await myLoadingOverlay.close();
  /// ```
  ///
  /// ### Custom Widget
  ///
  /// This example shows how to use a custom widget for the loading overlay.
  /// This custom widget will be displayed instead of the default circular
  /// progress indicator.
  ///
  /// Note: For Columns, be sure to set the `mainAxisSize` to `MainAxisSize.min`
  /// if you want this widget to be centered.
  ///
  /// ```dart
  /// MyLoadingOverlay(
  ///   child: const Column(
  ///     mainAxisSize: MainAxisSize.min,
  ///     children: [
  ///       CircularProgressIndicator(),
  ///       Text('Loading...'),
  ///     ],
  ///   ),
  /// );
  /// ```
  MyLoadingOverlay({
    this.backgroundColor = Colors.transparent,
    this.child = const CircularProgressIndicator(),
  });

  /// The color of the background of the overlay.
  final Color backgroundColor;

  /// The widget that will be shown to the user to indicate that the app is
  /// loading.
  ///
  /// For Columns, be sure to set the `mainAxisSize` to `MainAxisSize.min` if
  /// you want this widget to be centered.
  final Widget child;

  bool _closed = true;

  GlobalKey? _key;

  BuildContext? _dialogContext;

  /// Shows the loading overlay.
  Future<void> show(BuildContext context) async {
    _closed = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (newContext) {
        _dialogContext = newContext;

        _key = GlobalKey();

        return Material(
          key: _key,
          color: backgroundColor,
          child: InkWell(
            mouseCursor: SystemMouseCursors.wait,
            child: Center(
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Closes the loading overlay.
  ///
  /// Returns true if the overlay was closed successfully; otherwise, false.
  Future<bool> close() async {
    if (_closed) return true;

    const int numSecondsToWait = 5;
    const int numMillisecondsToWait = numSecondsToWait * 1000;

    const int numMillisecondsToWaitPerWhile = 100;
    int numWhileIterations =
        numMillisecondsToWait ~/ numMillisecondsToWaitPerWhile;

    while (_dialogContext == null && numWhileIterations > 0) {
      numWhileIterations--;
      await Future.delayed(
        const Duration(milliseconds: numMillisecondsToWaitPerWhile),
      );
    }

    if (_dialogContext == null) return false;

    if (_key == null) return false;

    if (_key!.currentContext == null) return false;

    if (!_key!.currentContext!.mounted) return false;

    Navigator.of(_dialogContext!).pop();
    _dialogContext = null;
    _key = null;
    _closed = true;

    return true;
  }
}
