import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/painter.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter_data/painter_data.dart';
import 'package:flutter/material.dart';

class DynamicBg extends StatefulWidget {
  const DynamicBg({
    super.key,
    required this.painterData,
    this.duration = const Duration(seconds: 30),
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
      duration: widget.duration,
    )..repeat(reverse: false);

    painter = widget.painterData.getPainter(animationController);
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
