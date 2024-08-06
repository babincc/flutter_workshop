// @author Christian Babin
// @version 2.0.0
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

  GlobalKey<_LoadingIndicatorState>? _widgetKey;

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

        _widgetKey = GlobalKey<_LoadingIndicatorState>();

        return Material(
          key: _key,
          color: backgroundColor,
          child: InkWell(
            mouseCursor: SystemMouseCursors.wait,
            child: Center(
              child: _LoadingIndicator(
                key: _widgetKey,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Whether or not the overlay can be closed or in other words, is currently
  /// showing.
  Future<bool> _canClose() async {
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
    if (!_dialogContext!.mounted) return false;

    if (_key == null) return false;
    if (_key!.currentContext == null) return false;
    if (!_key!.currentContext!.mounted) return false;

    if (_widgetKey == null) return false;
    if (_widgetKey!.currentContext == null) return false;
    if (!_widgetKey!.currentContext!.mounted) return false;

    return true;
  }

  /// Closes the loading overlay.
  ///
  /// Returns true if the overlay was closed successfully; otherwise, false.
  Future<bool> close() async {
    if (_closed) return true;

    final bool canClose = await _canClose();

    if (!canClose) return false;

    Navigator.of(_dialogContext!).pop();
    _dialogContext = null;
    _key = null;
    _closed = true;

    return true;
  }

  /// Closes the loading overlay with a custom message.
  ///
  /// Displays the given `child` widget instead of the default circular progress
  /// indicator. The overlay will close after the given `duration`.
  ///
  /// Default `duration` is 1.5 seconds.
  ///
  /// Returns true if the overlay was closed successfully; otherwise, false.
  Future<bool> closeWithCustomMessage({
    Duration? duration,
    required Widget child,
  }) async {
    if (_closed) return true;

    final bool canClose = await _canClose();

    if (!canClose) return false;

    _LoadingIndicator.updateChild(key: _widgetKey!, child: child);

    await Future.delayed(duration ?? const Duration(milliseconds: 1500));

    return await close();
  }

  /// Closes the loading overlay with a success message.
  ///
  /// Displays a check mark icon and the text 'Success' in the overlay. The
  /// overlay will close after the given `duration`.
  ///
  /// Default `color` is green.
  ///
  /// Default `duration` is 1.5 seconds.
  ///
  /// Returns true if the overlay was closed successfully; otherwise, false.
  Future<bool> closeWithSuccess({Color? color, Duration? duration}) async {
    const Color defaultColor = Color.fromRGBO(19, 114, 8, 1.0);

    return await closeWithCustomMessage(
      duration: duration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: color ?? defaultColor,
            size: 50.0,
          ),
          Text(
            'Success',
            style: TextStyle(
              fontSize: 20.0,
              color: color ?? defaultColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Closes the loading overlay with a failure message.
  ///
  /// Displays an exclamation mark icon and the text 'Failed' in the overlay.
  /// The overlay will close after the given `duration`.
  ///
  /// Default `color` is red.
  ///
  /// Default `duration` is 1.5 seconds.
  ///
  /// Returns true if the overlay was closed successfully; otherwise, false.
  Future<bool> closeWithFailure({Color? color, Duration? duration}) async {
    const Color defaultColor = Color.fromRGBO(114, 8, 8, 1.0);

    return await closeWithCustomMessage(
      duration: duration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error,
            color: color ?? defaultColor,
            size: 50.0,
          ),
          Text(
            'Failed',
            style: TextStyle(
              fontSize: 20.0,
              color: color ?? defaultColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// This custom class allows for the indicator widget to be changed after the
/// widget has been built.
class _LoadingIndicator extends StatefulWidget {
  const _LoadingIndicator({super.key, required this.child});

  final Widget child;

  /// This method allows the error text to be set manually from outside of this
  /// widget.
  static void updateChild({
    required GlobalKey<_LoadingIndicatorState> key,
    required Widget child,
  }) {
    if (key.currentState != null && key.currentState!.mounted) {
      key.currentState!.updateChild(child);
    }
  }

  @override
  State<_LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator> {
  late Widget child;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    try {
      // Check to see if the child has been initialized.
      child;
    } catch (e) {
      // If not, initialize the child.
      child = widget.child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }

  void updateChild(Widget newChild) {
    if (mounted) {
      setState(() {
        child = newChild;
      });
    }
  }
}
