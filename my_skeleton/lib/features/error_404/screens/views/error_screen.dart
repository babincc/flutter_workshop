import 'package:flutter/material.dart';
import 'package:my_skeleton/widgets/views/my_scaffold.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      builder: (context) => const Text('Error!'),
    );
  }
}
