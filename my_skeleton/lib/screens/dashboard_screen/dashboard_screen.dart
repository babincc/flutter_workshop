import 'package:flutter/material.dart';
import 'package:my_skeleton/screens/components/my_safe_area.dart';
import 'package:my_skeleton/screens/components/my_settings_menu.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dashboard"),
        actions: const [
          MySettingsMenu(),
        ],
      ),
      body: const MySafeArea(
        child: Text("Howdy!"),
      ),
    );
  }
}
