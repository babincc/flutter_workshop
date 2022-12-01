import 'package:flutter/material.dart';
import 'package:my_skeleton/screens/components/my_drawer_menu.dart';
import 'package:my_skeleton/screens/components/my_safe_area.dart';
import 'package:my_skeleton/screens/components/my_search_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MySearchBar(),
      ),
      drawer: const MyDrawerMenu(),
      body: MySafeArea(
        child: Column(
          children: const [
            Text("Howdy"),
          ],
        ),
      ),
    );
  }
}
