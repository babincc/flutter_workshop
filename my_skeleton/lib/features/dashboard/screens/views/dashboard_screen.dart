import 'package:flutter/material.dart';
import 'package:my_skeleton/widgets/views/my_drawer_menu.dart';
import 'package:my_skeleton/widgets/views/my_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(),
      drawer: const MyDrawerMenu(),
      builder: (context) => const Column(
        children: [
          Text("Howdy"),
        ],
      ),
    );
  }
}
