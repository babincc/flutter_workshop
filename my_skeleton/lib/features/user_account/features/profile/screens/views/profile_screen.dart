import 'package:flutter/material.dart';
import 'package:my_skeleton/widgets/views/my_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
