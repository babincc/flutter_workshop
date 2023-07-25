import 'package:flutter/material.dart';
import 'package:n_dimensional_array/n_dimensional_array.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('n-Dimensional Array Demo'),
      ),
      body: const Center(
        child: Text('Howdy!'),
      ),
    );
  }
}
