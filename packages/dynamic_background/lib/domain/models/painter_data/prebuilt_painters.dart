import 'package:dynamic_background/domain/models/color_schemes.dart';
import 'package:dynamic_background/domain/models/painter_data/fader_painter_data.dart';
import 'package:dynamic_background/domain/models/painter_data/scroller_painter_data.dart';
import 'package:dynamic_background/utils/platform_tools.dart';
import 'package:dynamic_background/widgets/views/dynamic_bg.dart';
import 'package:flutter/material.dart';

/// Prebuilt painters for use with the [DynamicBg] widget.
class PrebuiltPainters {
  /// Pale brown argyle pattern scrolling from left to right, giving '30s vibes.
  ///
  /// Recommended delay: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get argyle30s => ScrollerPainterData(
        direction: ScrollDirection.left2Right,
        shape: ScrollerShape.squares,
        backgroundColor: gentleBrownBg,
        color: gentleBrownFg,
        shapeWidth: 55.0,
        spaceBetweenShapes: 0.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.none,
      );

  /// Brown squares scrolling from left to right on a darker brown background.
  ///
  /// Recommended delay: 45 seconds
  ///
  /// Recommended for dark mode.
  static ScrollerPainterData get chocolate => ScrollerPainterData(
        direction: ScrollDirection.left2Right,
        shape: ScrollerShape.squares,
        backgroundColor: vibrantBrownBg,
        color: vibrantBrownFg,
        shapeWidth: 50.0,
        spaceBetweenShapes: 25.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shiftAndMesh,
      );

  /// Icy blue diamonds raining down from the top of the screen on a pale blue
  /// background.
  ///
  /// Recommended delay: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get diamondRain => ScrollerPainterData(
        direction: ScrollDirection.top2Bottom,
        shape: ScrollerShape.diamonds,
        backgroundColor: icyBlueBg,
        color: icyBlueFg,
        shapeWidth: 24.0,
        spaceBetweenShapes: 24.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shift,
      );

  /// Green circles scrolling from bottom to top on a pale green background, like
  /// bubbles in a wiggly plate of jello.
  ///
  /// Recommended delay: 45 seconds
  ///
  /// Recommended for dark mode.
  static ScrollerPainterData get jello => ScrollerPainterData(
        direction: ScrollDirection.bottom2Top,
        shape: ScrollerShape.circles,
        backgroundColor: vibrantGreenBg,
        color: vibrantGreenFg,
        shapeWidth: 25.0,
        spaceBetweenShapes: 50.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shiftAndMesh,
      );

  /// Yellow circles scrolling from left to right on a pale yellow background,
  /// like lemons in the sunshine.
  ///
  /// Recommended delay: 30 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get lemonSunshine => ScrollerPainterData(
        direction: ScrollDirection.left2Right,
        shape: ScrollerShape.circles,
        backgroundColor: gentleYellowBg,
        color: gentleYellowFg,
        shapeWidth: 24.0,
        spaceBetweenShapes: 24.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shift,
      );

  /// Very pale red and white stripes scrolling from right to left, giving the
  /// impression of an American flag waving in the wind.
  ///
  /// Recommended delay: 100 seconds
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
  /// Recommended delay: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get sprite => ScrollerPainterData(
        direction: ScrollDirection.bottom2Top,
        shape: ScrollerShape.circles,
        backgroundColor: gentleWhiteBg,
        color: gentleWhiteFg,
        shapeWidth: 25.0,
        spaceBetweenShapes: 50.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shiftAndMesh,
      );

  /// Red circles scrolling from right to left on a pale red background, like
  /// seeds on a rotating strawberry.
  ///
  /// Recommended delay: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get strawberrySlide => ScrollerPainterData(
        direction: ScrollDirection.left2Right,
        shape: ScrollerShape.circles,
        backgroundColor: gentleRedBg,
        color: gentleRedFg,
        shapeWidth: 24.0,
        spaceBetweenShapes: 24.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shift,
      );

  /// Brown circles scrolling from left to right on a pale yellow background,
  /// looking like sunflowers.
  ///
  /// Recommended delay: 45 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get sunflower => ScrollerPainterData(
        direction: ScrollDirection.left2Right,
        shape: ScrollerShape.circles,
        backgroundColor: gentleYellowBg,
        color: gentleBrownFg,
        shapeWidth: 25.0,
        spaceBetweenShapes: 50.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.shift,
      );

  /// A gentle sunrise with yellow circles rising from the bottom of the screen on
  /// a yellow-orange background.
  ///
  /// Recommended delay: 90 seconds
  ///
  /// Recommended for light mode.
  static ScrollerPainterData get sunRise => ScrollerPainterData(
        direction: ScrollDirection.bottom2Top,
        shape: ScrollerShape.circles,
        backgroundColor: vibrantYellowBg,
        color: vibrantYellowFg,
        shapeWidth: screenSize.width,
        spaceBetweenShapes: 0.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.none,
      );

  /// A gentle sunset with orange circles sinking from the top of the screen on a
  /// yellow-orange background.
  ///
  /// Recommended delay: 90 seconds
  ///
  /// Recommended for dark mode.
  static ScrollerPainterData get sunSet => ScrollerPainterData(
        direction: ScrollDirection.top2Bottom,
        shape: ScrollerShape.circles,
        backgroundColor: vibrantYellowBg,
        color: vibrantOrangeFg,
        shapeWidth: screenSize.width,
        spaceBetweenShapes: 0.0,
        fadeEdges: true,
        shapeOffset: ScrollerShapeOffset.none,
      );

  /// A gentle fade of blue colors, giving the impression of a cold winter wind
  /// blowing through the screen.
  ///
  /// Recommended delay: 15 seconds
  ///
  /// Recommended for light mode.
  static FaderPainterData get winterWind => FaderPainterData(
        behavior: FaderBehavior.breathe,
        colors: gentleBlue,
      );

  /// Dark colors subtly fading in and out.
  ///
  /// Recommended delay: 30 seconds
  ///
  /// Recommended for dark mode.
  static FaderPainterData get dynamicDark => FaderPainterData(
        behavior: FaderBehavior.random,
        colors: vibrantBlack,
      );

  /// Light colors subtly fading in and out.
  ///
  /// Recommended delay: 30 seconds
  ///
  /// Recommended for light mode.
  static FaderPainterData get dynamicLight => FaderPainterData(
        behavior: FaderBehavior.random,
        colors: gentleWhite,
      );
}
