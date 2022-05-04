import 'package:flutter/material.dart';
import 'package:my_skeleton/screens/components/my_safe_area.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact"),
      ),
      body: const MySafeArea(
        child: Text("Howdy!"),
      ),
    );
  }
}
