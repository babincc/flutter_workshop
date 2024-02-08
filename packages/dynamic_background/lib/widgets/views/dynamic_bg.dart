import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter_data/painter_data.dart';
import 'package:dynamic_background/domain/models/painter_data/prebuilt_painters.dart';
import 'package:flutter/material.dart';

/// A widget that draws a dynamic background with a child widget on top of it.
class DynamicBg extends StatefulWidget {
  /// Creates a [DynamicBg] widget.
  ///
  /// This is an animated widget that can be used to make a dynamic background
  /// with a child widget on top of it.
  const DynamicBg({
    super.key,
    required this.painterData,
    this.duration = const Duration(seconds: 30),
    this.child,
  });

  /// The blueprints for drawing the background.
  ///
  /// You can use the [PrebuiltPainters] class to get prebuilt painters.
  final PainterData painterData;

  /// The duration of the animation.
  final Duration duration;

  /// The child widget to be drawn on top of the background.
  final Widget? child;

  @override
  State<DynamicBg> createState() => _DynamicBgState();
}

class _DynamicBgState extends State<DynamicBg>
    with SingleTickerProviderStateMixin {
  /// Used to control the animation.
  ///
  /// This is initialized in the [initState] method.
  late final AnimationController animationController;

  /// The painter that will be used to draw the background.
  ///
  /// This is what reads the blueprints from the [PainterData] and draws the
  /// background.
  ///
  /// This is initialized in the [initState] method.
  late final Painter painter;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller.
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: false);

    // Initialize the painter.
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
          // Sized box opens the screen to the full size of the parent so the
          // child has access to the full screen, but doesn't need to use it
          // all, and the background can still be seen.
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),

          // The body of the app that will be placed on top of the background.
          widget.child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
