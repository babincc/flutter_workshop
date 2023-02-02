import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/theme/my_spacing.dart';

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
    Key? key,
    required this.builder,
    this.appBar,
    this.drawer,
    this.isCentered = true,
  }) : super(key: key);

  /// The app bar of this scaffold.
  final PreferredSizeWidget? appBar;

  /// The pop out drawer of this scaffold.
  final Widget? drawer;

  /// The body of this scaffold.
  final Widget Function(BuildContext) builder;

  /// Whether or not the contents of this scaffold should be centered on the
  /// screen.
  final bool isCentered;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MySpacing.distanceFromEdge),
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
