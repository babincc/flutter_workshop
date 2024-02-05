import 'package:dynamic_background/dynamic_background.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DynamicBg(
          painterData: ScrollerPainterData(
            // direction: ScrollDirection.top2Bottom,
            // direction: ScrollDirection.left2Right,
            backgroundColor: Colors.greenAccent.shade200,
            color: Colors.red,
            shape: ScrollerShape.stripes,
            shapeWidth: 55.0,
            // fadeEdges: false,
          ),
          child: const Center(
            child: Text(
              'Dynamic Background!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
