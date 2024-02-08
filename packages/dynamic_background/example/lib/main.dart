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
    final gBlack = gentleBlack..sortColors();
    final gWhite = gentleWhite..sortColors();
    final gBrown = gentleBrown..sortColors();
    final gRed = gentleRed..sortColors();
    final gOrange = gentleOrange..sortColors();
    final gYellow = gentleYellow..sortColors();
    final gGreen = gentleGreen..sortColors();
    final gBlue = gentleBlue..sortColors();
    final gPurple = gentlePurple..sortColors();

    final vBlack = vibrantBlack..sortColors();
    final vWhite = vibrantWhite..sortColors();
    final vBrown = vibrantBrown..sortColors();
    final vRed = vibrantRed..sortColors();
    final vOrange = vibrantOrange..sortColors();
    final vYellow = vibrantYellow..sortColors();
    final vGreen = vibrantGreen..sortColors();
    final vBlue = vibrantBlue..sortColors();
    final vPurple = vibrantPurple..sortColors();

    return Scaffold(
      body: DynamicBg(
        duration: const Duration(seconds: 45),
        painterData: PrebuiltPainters.argyle80s,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: gBlack
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: gWhite
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: gBrown
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: gRed
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: gOrange
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: gYellow
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: gGreen
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: gBlue
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: gPurple
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: vBlack
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: vWhite
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: vBrown
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: vRed
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: vOrange
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: vYellow
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: vGreen
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: vBlue
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: vPurple
                        .map((e) => Container(
                              width: 30,
                              height: 30,
                              color: e,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
