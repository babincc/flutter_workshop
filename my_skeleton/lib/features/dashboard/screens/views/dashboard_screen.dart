import 'package:flutter/material.dart';
import 'package:my_skeleton/widgets/my_drawer_menu.dart';
import 'package:my_skeleton/widgets/my_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(),
      drawer: const MyDrawerMenu(),
      builder: (context) => Column(
        children: const [
          Text("Howdy"),
        ],
      ),
    );
  }
}
