// @author Christian Babin
// @version 1.2.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_scaffold.dart

import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';

class MyScaffold extends StatelessWidget {
  /// Creates a custom scaffold.
  ///
  /// This scaffold is a group of foundational widgets, put together to
  /// eliminate boilerplate and make the code cleaner. Since almost every screen
  /// and page is built with these at their core, it has been placed in one
  /// convenient widget.
  ///
  /// [Scaffold] > [SafeArea] > [Padding]
  const MyScaffold({
    super.key,
    required this.builder,
    this.appBar,
    this.drawer,
    this.isCentered = true,
    this.padEdges = true,
    this.padBottom = true,
    this.padTop = true,
    this.backgroundColor,
    this.onPopInvoked,
  });

  /// The app bar of this scaffold.
  final PreferredSizeWidget? appBar;

  /// The pop out drawer of this scaffold.
  final Widget? drawer;

  /// The body of this scaffold.
  final WidgetBuilder builder;

  /// Whether or not the contents of this scaffold should be centered on the
  /// screen.
  final bool isCentered;

  /// Whether or not the preset padding will be applied to the edges of the
  /// screen.
  final bool padEdges;

  /// Whether or not the preset padding will be applied to the bottom of the
  /// screen.
  final bool padBottom;

  /// Whether or not the preset padding will be applied to the top of the
  /// screen.
  final bool padTop;

  /// The background color of this scaffold.
  final Color? backgroundColor;

  /// A callback that is invoked when the back button is pressed.
  ///
  /// If this callback returns `true`, the pop will be invoked; otherwise, if
  /// it returns `false`, the pop will be canceled.
  final Future<bool> Function()? onPopInvoked;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = EdgeInsets.fromLTRB(
      padEdges ? MyMeasurements.distanceFromEdge : 0.0,
      appBar == null ? (padTop ? MyMeasurements.distanceFromEdge : 0.0) : 0.0,
      padEdges ? MyMeasurements.distanceFromEdge : 0.0,
      padBottom ? MyMeasurements.distanceFromEdge : 0.0,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        if (onPopInvoked == null) {
          Navigator.of(context).pop();
        } else {
          final NavigatorState navigator = Navigator.of(context);

          await onPopInvoked!().then(
            (canPop) {
              if (canPop && navigator.mounted) {
                navigator.pop();
              }
            },
          );
        }
      },
      child: Scaffold(
        appBar: appBar,
        drawer: drawer,
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: padding,
            child: _buildLayout(context),
          ),
        ),
      ),
    );
  }

  /// This method lays out the given [child] based on [isCentered].
  Widget _buildLayout(BuildContext context) {
    if (isCentered) {
      return Center(
        child: builder(context),
      );
    }

    return builder(context);
  }
}
