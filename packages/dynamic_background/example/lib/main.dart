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
        duration: const Duration(seconds: 45),
        // painterData: PrebuiltPainters.chocolate, // Try a prebuilt painter
        painterData: ScrollerPainterData(
          direction: ScrollDirection.left2Right,
          shape: ScrollerShape.circles,
          backgroundColor: ColorSchemes.gentlePurpleBg,
          color: ColorSchemes.gentlePurpleFg,
          shapeWidth: 24.0,
          spaceBetweenShapes: 24.0,
          fadeEdges: true,
          shapeOffset: ScrollerShapeOffset.shiftAndMesh,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 25),
              Expanded(child: Image.asset('assets/images/logo.png')),
              const SizedBox(width: 25),
            ],
          ),
        ),
      ),
    );
  }
}
