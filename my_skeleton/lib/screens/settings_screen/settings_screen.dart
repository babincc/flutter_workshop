import 'package:flutter/material.dart';
import 'package:my_skeleton/screens/components/my_safe_area.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: const MySafeArea(
        child: Text("Howdy!"),
      ),
    );
  }
}
