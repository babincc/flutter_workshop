import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/painter.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/scroller_painter.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter_data/painter_data.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter_data/scroller_painter_data.dart';
import 'package:flutter/material.dart';

class DynamicBg extends StatefulWidget {
  const DynamicBg({
    super.key,
    required this.painterData,
    this.duration = const Duration(seconds: 25),
    this.child,
  });

  final PainterData painterData;

  final Duration duration;

  final Widget? child;

  @override
  State<DynamicBg> createState() => _DynamicBgState();
}

class _DynamicBgState extends State<DynamicBg>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  late final Painter painter;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: widget.duration, // Adjust the duration as needed
    )..repeat(reverse: false);

    try {
      switch (widget.painterData.type) {
        case PainterType.scroller:
          painter = ScrollerPainter(
            animation: animationController,
            data: widget.painterData as ScrollerPainterData,
          );
          break;
        case PainterType.dropper:
          // TODO
          break;
        case PainterType.fader:
          // TODO
          break;
      }
    } catch (e) {
      // TODO maybe custom exception
      throw Exception('Invalid painter data');
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: painter,
      child: Stack(
        children: [
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
          widget.child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
