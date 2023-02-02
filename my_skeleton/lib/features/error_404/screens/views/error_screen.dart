import 'package:flutter/material.dart';
import 'package:my_skeleton/widgets/my_scaffold.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      child: Text("Error!"),
    );
  }
}
