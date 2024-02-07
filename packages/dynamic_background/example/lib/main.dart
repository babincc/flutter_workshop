import 'package:dynamic_background/dynamic_background.dart';
import 'package:dynamic_background/utils/color_tools.dart';
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
  final List<Color> colors = [
    Colors.black,
    Colors.white,
    Colors.brown,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    colors.sortColors();

    return Scaffold(
      body: DynamicBg(
        // painterData: ScrollerPainterData(
        //   // direction: ScrollDirection.top2Bottom,
        //   // direction: ScrollDirection.bottom2Top,
        //   // direction: ScrollDirection.left2Right,
        //   backgroundColor: Colors.greenAccent.shade200,
        //   color: Colors.red,
        //   // color: Colors.greenAccent.shade400,
        //   // shape: ScrollerShape.diamonds,
        //   // shapeWidth: 55.0,
        //   // spaceBetweenShapes: 0.0,
        //   // fadeEdges: false,
        //   shapeOffset: ScrollerShapeOffset.shiftAndMesh,
        // ),
        painterData: FaderPainterData(
          behavior: FaderBehavior.sortedOrder,
          colors: colors,
        ),
        // child: const Center(
        //   child: Text(
        //     'Dynamic Background!',
        //     style: TextStyle(
        //       fontSize: 32,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: colors
                .map((e) => Container(
                      width: 55,
                      height: 55,
                      color: e,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
