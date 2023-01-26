import 'package:flutter/material.dart';
import 'package:my_skeleton/widgets/my_safe_area.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
      ),
      body: const MySafeArea(
        child: Text("Howdy!"),
      ),
    );
  }
}
