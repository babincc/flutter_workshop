import 'package:flutter/material.dart';
import 'package:my_skeleton/widgets/my_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      builder: (context) => const Text("Howdy!"),
    );
  }
}
