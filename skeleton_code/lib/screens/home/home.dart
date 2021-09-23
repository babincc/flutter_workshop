import 'package:flutter/material.dart';
import 'package:skeleton_code/theme/my_spacing.dart';

/// This file is the homepage of the app. This is where the user will be when
/// the app is first launched.
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MySpacing.DistanceFromEdge),
          child: Text("Howdy!"),
        ),
      ),
    );
  }
}
