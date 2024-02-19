// @author Christian Babin
// @version 1.0.1
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

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding;

    if (padEdges) {
      if (appBar == null) {
        padding = const EdgeInsets.all(MyMeasurements.distanceFromEdge);
      } else {
        padding = const EdgeInsets.fromLTRB(
          MyMeasurements.distanceFromEdge,
          0.0,
          MyMeasurements.distanceFromEdge,
          MyMeasurements.distanceFromEdge,
        );
      }
    } else {
      padding = EdgeInsets.zero;
    }

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: _buildLayout(context),
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
