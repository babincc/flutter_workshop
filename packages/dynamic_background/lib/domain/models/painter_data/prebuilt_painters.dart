import 'package:dynamic_background/domain/enums/fader_behavior.dart';
import 'package:dynamic_background/domain/enums/scroll_direction.dart';
import 'package:dynamic_background/domain/enums/scroller_shape.dart';
import 'package:dynamic_background/domain/enums/scroller_shape_offset.dart';
import 'package:dynamic_background/domain/enums/wave_direction.dart';
import 'package:dynamic_background/domain/enums/wave_gravity_direction.dart';
import 'package:dynamic_background/domain/models/color_schemes.dart';
import 'package:dynamic_background/domain/models/painter_data/fader_painter_data.dart';
import 'package:dynamic_background/domain/models/painter_data/scroller_painter_data.dart';
import 'package:dynamic_background/domain/models/painter_data/wave_painter_data.dart';
import 'package:dynamic_background/domain/models/wave.dart';
import 'package:dynamic_background/utils/platform_tools.dart';
import 'package:dynamic_background/widgets/views/dynamic_bg.dart';
import 'package:flutter/material.dart';

/// Prebuilt painters for use with the [DynamicBg] widget.
class PrebuiltPainters {
  /// Pale brown argyle pattern scrolling from left to right, giving '30s vibes.
  ///
  /// Recommended duration: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get argyle30s => ScrollerPainterData(
        direction: ScrollDirection.left2Right,
        shape: ScrollerShape.squares,
        backgroundColor: ColorSchemes.gentleBrownBg,
        color: ColorSchemes.gentleBrownFg,
        shapeWidth: 55.0,
        spaceBetweenShapes: 0.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.none,
      );

  /// A set of green waves that come together to form what looks like the
  /// electron cloud of an atom.
  ///
  /// Recommended duration: 30 seconds
  ///
  /// Recommended for light mode.
  static WavePainterData get atomicRings => WavePainterData(
        waves: [
          Wave(
            direction: WaveDirection.right2Left,
            gravityDirection: WaveGravityDirection.down,
            amplitude: 500.0,
            frequency: 1,
            phase: 0.0,
            offset: 0.5,
            useScaledOffset: true,
            color: Colors.transparent,
            lineColor: ColorSchemes.gentleGreenBg,
            lineThickness: 2.0,
          ),
          Wave(
            direction: WaveDirection.right2Left,
            gravityDirection: WaveGravityDirection.down,
            amplitude: 500.0,
            frequency: 1,
            phase: 0.1,
            offset: 0.5,
            useScaledOffset: true,
            color: Colors.transparent,
            lineColor: ColorSchemes.gentleGreenBg,
            lineThickness: 2.0,
          ),
          Wave(
            direction: WaveDirection.right2Left,
            gravityDirection: WaveGravityDirection.down,
            amplitude: 500.0,
            frequency: 1,
            phase: 0.2,
            offset: 0.5,
            useScaledOffset: true,
            color: Colors.transparent,
            lineColor: ColorSchemes.gentleGreenBg,
            lineThickness: 2.0,
          ),
          Wave(
            direction: WaveDirection.right2Left,
            gravityDirection: WaveGravityDirection.down,
            amplitude: 500.0,
            frequency: 1,
            phase: 0.3,
            offset: 0.5,
            useScaledOffset: true,
            color: Colors.transparent,
            lineColor: ColorSchemes.gentleGreenBg,
            lineThickness: 2.0,
          ),
          Wave(
            direction: WaveDirection.right2Left,
            gravityDirection: WaveGravityDirection.down,
            amplitude: 500.0,
            frequency: 1,
            phase: 0.4,
            offset: 0.5,
            useScaledOffset: true,
            color: Colors.transparent,
            lineColor: ColorSchemes.gentleGreenBg,
            lineThickness: 2.0,
          ),
          Wave(
            direction: WaveDirection.right2Left,
            gravityDirection: WaveGravityDirection.down,
            amplitude: 500.0,
            frequency: 1,
            phase: 0.5,
            offset: 0.5,
            useScaledOffset: true,
            color: Colors.transparent,
            lineColor: ColorSchemes.gentleGreenBg,
            lineThickness: 2.0,
          ),
          Wave(
            direction: WaveDirection.right2Left,
            gravityDirection: WaveGravityDirection.down,
            amplitude: 500.0,
            frequency: 1,
            phase: 0.6,
            offset: 0.5,
            useScaledOffset: true,
            color: Colors.transparent,
            lineColor: ColorSchemes.gentleGreenBg,
            lineThickness: 2.0,
          ),
          Wave(
            direction: WaveDirection.right2Left,
            gravityDirection: WaveGravityDirection.down,
            amplitude: 500.0,
            frequency: 1,
            phase: 0.7,
            offset: 0.5,
            useScaledOffset: true,
            color: Colors.transparent,
            lineColor: ColorSchemes.gentleGreenBg,
            lineThickness: 2.0,
          ),
          Wave(
            direction: WaveDirection.right2Left,
            gravityDirection: WaveGravityDirection.down,
            amplitude: 500.0,
            frequency: 1,
            phase: 0.8,
            offset: 0.5,
            useScaledOffset: true,
            color: Colors.transparent,
            lineColor: ColorSchemes.gentleGreenBg,
            lineThickness: 2.0,
          ),
          Wave(
            direction: WaveDirection.right2Left,
            gravityDirection: WaveGravityDirection.down,
            amplitude: 500.0,
            frequency: 1,
            phase: 0.9,
            offset: 0.5,
            useScaledOffset: true,
            color: Colors.transparent,
            lineColor: ColorSchemes.gentleGreenBg,
            lineThickness: 2.0,
          ),
        ],
      );

  /// Red and white diagonal stripes scrolling from bottom to top like a candy
  /// cane.
  ///
  /// Recommended duration: 30 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get candyCane => ScrollerPainterData(
        direction: ScrollDirection.bottom2Top,
        shape: ScrollerShape.stripesDiagonalBackward,
        backgroundColor: ColorSchemes.gentleWhiteBg,
        color: ColorSchemes.gentleRedFg,
        shapeWidth: 90.0,
        spaceBetweenShapes: 90.0,
        fadeEdges: false,
      );

  /// Brown squares scrolling from left to right on a darker brown background.
  ///
  /// Recommended duration: 45 seconds
  ///
  /// Recommended for dark mode.
  static ScrollerPainterData get chocolate => ScrollerPainterData(
        direction: ScrollDirection.left2Right,
        shape: ScrollerShape.squares,
        backgroundColor: ColorSchemes.vibrantBrownBg,
        color: ColorSchemes.vibrantBrownFg,
        shapeWidth: 50.0,
        spaceBetweenShapes: 25.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shiftAndMesh,
      );

  /// Icy blue diamonds raining down from the top of the screen on a pale blue
  /// background.
  ///
  /// Recommended duration: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get diamondRain => ScrollerPainterData(
        direction: ScrollDirection.top2Bottom,
        shape: ScrollerShape.diamonds,
        backgroundColor: ColorSchemes.icyBlueBg,
        color: ColorSchemes.icyBlueFg,
        shapeWidth: 24.0,
        spaceBetweenShapes: 24.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shift,
      );

  /// Dark colors subtly fading in and out.
  ///
  /// Recommended duration: 30 seconds
  ///
  /// Recommended for dark mode.
  static FaderPainterData get dynamicDark => FaderPainterData(
        behavior: FaderBehavior.random,
        colors: ColorSchemes.vibrantBlack,
      );

  /// Light colors subtly fading in and out.
  ///
  /// Recommended duration: 30 seconds
  ///
  /// Recommended for light mode.
  static FaderPainterData get dynamicLight => FaderPainterData(
        behavior: FaderBehavior.random,
        colors: ColorSchemes.gentleWhite,
      );

  /// Green circles scrolling from bottom to top on a pale green background, like
  /// bubbles in a wiggly plate of jello.
  ///
  /// Recommended duration: 45 seconds
  ///
  /// Recommended for dark mode.
  static ScrollerPainterData get jello => ScrollerPainterData(
        direction: ScrollDirection.bottom2Top,
        shape: ScrollerShape.circles,
        backgroundColor: ColorSchemes.vibrantGreenBg,
        color: ColorSchemes.vibrantGreenFg,
        shapeWidth: 25.0,
        spaceBetweenShapes: 50.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shiftAndMesh,
      );

  /// Purple stripes scrolling from top to bottom on a pale purple background,
  /// like the rungs of a ladder passing by as you climb.
  ///
  /// Recommended duration: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get ladderClimb => ScrollerPainterData(
        direction: ScrollDirection.top2Bottom,
        shape: ScrollerShape.stripes,
        backgroundColor: ColorSchemes.gentlePurpleBg,
        color: ColorSchemes.gentlePurpleFg,
        shapeWidth: 50.0,
        spaceBetweenShapes: 150.0,
        fadeEdges: true,
      );

  /// Yellow circles scrolling from left to right on a pale yellow background,
  /// like lemons in the sunshine.
  ///
  /// Recommended duration: 30 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get lemonSunshine => ScrollerPainterData(
        direction: ScrollDirection.left2Right,
        shape: ScrollerShape.circles,
        backgroundColor: ColorSchemes.gentleYellowBg,
        color: ColorSchemes.gentleYellowFg,
        shapeWidth: 24.0,
        spaceBetweenShapes: 24.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shift,
      );

  /// Translucent white waves splashing like milk in a glass.
  ///
  /// Recommended duration: 100 seconds
  ///
  /// Recommended for dark mode.
  static WavePainterData milkWaves = WavePainterData(
    waves: [
      Wave(
        direction: WaveDirection.right2Left,
        gravityDirection: WaveGravityDirection.down,
        amplitude: 80.0,
        frequency: 24,
        offset: 0.80,
        useScaledOffset: true,
        color: ColorSchemes.gentleWhiteBg.withAlpha(128),
        lineColor: null,
        lineThickness: 1.0,
      ),
      Wave(
        direction: WaveDirection.right2Left,
        gravityDirection: WaveGravityDirection.down,
        amplitude: 80.0,
        frequency: 16,
        phase: 0.5,
        offset: 0.83,
        useScaledOffset: true,
        color: ColorSchemes.gentleWhiteBg.withAlpha(128),
        lineColor: null,
        lineThickness: 1.0,
      ),
      Wave(
        direction: WaveDirection.right2Left,
        gravityDirection: WaveGravityDirection.down,
        amplitude: 40.0,
        frequency: 19,
        phase: 0.3,
        offset: 0.87,
        useScaledOffset: true,
        color: ColorSchemes.gentleWhiteBg.withAlpha(128),
        lineColor: null,
        lineThickness: 1.0,
      ),
    ],
  );

  /// Very pale red and white stripes scrolling from right to left, giving the
  /// impression of an American flag waving in the wind.
  ///
  /// Recommended duration: 100 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get patriotic => const ScrollerPainterData(
        direction: ScrollDirection.right2Left,
        shape: ScrollerShape.stripes,
        backgroundColor: Color.fromRGBO(235, 234, 217, 1.0),
        color: Color.fromRGBO(189, 141, 144, 1),
        shapeWidth: 40.0,
        spaceBetweenShapes: 40.0,
        fadeEdges: false,
        shapeOffset: ScrollerShapeOffset.shift,
      );

  /// Light grey circles scrolling from bottom to top on a pale white background,
  /// like bubbles in a glass of Sprite.
  ///
  /// Recommended duration: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get sprite => ScrollerPainterData(
        direction: ScrollDirection.bottom2Top,
        shape: ScrollerShape.circles,
        backgroundColor: ColorSchemes.gentleWhiteBg,
        color: ColorSchemes.gentleWhiteFg,
        shapeWidth: 25.0,
        spaceBetweenShapes: 50.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shiftAndMesh,
      );

  /// Red circles scrolling from right to left on a pale red background, like
  /// seeds on a rotating strawberry.
  ///
  /// Recommended duration: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get strawberrySlide => ScrollerPainterData(
        direction: ScrollDirection.left2Right,
        shape: ScrollerShape.circles,
        backgroundColor: ColorSchemes.gentleRedBg,
        color: ColorSchemes.gentleRedFg,
        shapeWidth: 24.0,
        spaceBetweenShapes: 24.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shift,
      );

  /// Brown circles scrolling from left to right on a pale yellow background,
  /// looking like sunflowers.
  ///
  /// Recommended duration: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get sunflower => ScrollerPainterData(
        direction: ScrollDirection.left2Right,
        shape: ScrollerShape.circles,
        backgroundColor: ColorSchemes.gentleYellowBg,
        color: ColorSchemes.gentleBrownFg,
        shapeWidth: 25.0,
        spaceBetweenShapes: 50.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shift,
      );

  /// A ColorSchemes.gentle sunrise with yellow circles rising from the bottom of the screen on
  /// a yellow-orange background.
  ///
  /// Recommended duration: 90 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get sunRise => ScrollerPainterData(
        direction: ScrollDirection.bottom2Top,
        shape: ScrollerShape.circles,
        backgroundColor: ColorSchemes.vibrantYellowBg,
        color: ColorSchemes.vibrantYellowFg,
        shapeWidth: screenSize.width,
        spaceBetweenShapes: 0.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.none,
      );

  /// A ColorSchemes.gentle sunset with orange circles sinking from the top of the screen on a
  /// yellow-orange background.
  ///
  /// Recommended duration: 90 seconds
  ///
  /// Recommended for dark mode.
  static ScrollerPainterData get sunSet => ScrollerPainterData(
        direction: ScrollDirection.top2Bottom,
        shape: ScrollerShape.circles,
        backgroundColor: ColorSchemes.vibrantYellowBg,
        color: ColorSchemes.vibrantOrangeFg,
        shapeWidth: screenSize.width,
        spaceBetweenShapes: 0.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.none,
      );

  /// A ColorSchemes.gentle fade of blue colors, giving the impression of a cold winter wind
  /// blowing through the screen.
  ///
  /// Recommended duration: 15 seconds
  ///
  /// Recommended for light mode.
  static FaderPainterData get winterWind => FaderPainterData(
        behavior: FaderBehavior.breathe,
        colors: ColorSchemes.gentleBlue,
      );
}
