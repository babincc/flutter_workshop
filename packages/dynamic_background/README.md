# Dynamic Background

<img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/logos/dynamic_background_logo.png" alt="A blue and black logo for Dynamic BG" width="275">

Dynamic Background is a Flutter package that transforms your app's background into a captivating canvas of animated elements. Whether you prefer sleek stripes, mesmerizing gradients, or playful shapes, Dynamic Background provides an easy-to-use solution to breathe life into your UI. This versatile package offers customizable options to suit any design aesthetic, effortlessly elevating your app's visual appeal. Take your Flutter development to the next level with Dynamic Background – where stunning visuals meet effortless implementation for an immersive and visually striking app interface.

<img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/demos/dynamic_background_demo_1.gif" alt="Four examples of different animated backgrounds." width="650">

<img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/demos/dynamic_background_demo_2.gif" alt="Four examples of different animated backgrounds." width="650">

## Installation

In the `pubspec.yaml` of your project, add the following dependency:

```yaml
dependencies:
  dynamic_background: ^0.1.3
```

Import it to each file you use it in:

```dart
import 'package:dynamic_background/dynamic_background.dart';
```

## Usage

### Example 1 - Simple circles scrolling

This example shows how to set up an animated background that shows blue circles scrolling from right to left on a pale blue background.

Note: The colors being used are provided with this package.

```dart
DynamicBg(
  painterData: ScrollerPainterData(
    shape: ScrollerShape.circles,
    backgroundColor: ColorSchemes.gentleBlueBg,
    color: ColorSchemes.gentleBlueFg,
    shapeOffset: ScrollerShapeOffset.shiftAndMesh,
  ),
  child: yourPageHere(),
),
```

### Example 2 - Simple blue fader

This example shows how to set up an animated background that fades gently and randomly between different shades of blue.

Note: The colors being used are provided with this package.

```dart
DynamicBg(
  painterData: FaderPainterData(
    behavior: FaderBehavior.random,
    colors: ColorSchemes.gentleBlue,
  ),
  child: yourPageHere(),
),
```

### Example 3 - Prebuilt backgrounds

This example shows how to use prebuilt backgrounds.

This example also show the use of a custom duration. The prebuilt backgrounds give suggestions in their comments on how best to use them; this includes duration and platform brightness.

```dart
DynamicBg(
  duration: const Duration(seconds: 45),
  painterData: PrebuiltPainters.chocolate,
  child: yourPageHere(),
),
```

### Example 4 - Modify prebuilt backgrounds

This example shows how to modify prebuilt backgrounds to best fit your needs.

The `copyWith` method can also be used on your own custom backgrounds.

```dart
DynamicBg(
  duration: const Duration(seconds: 45),
  painterData: PrebuiltPainters.chocolate.copyWith(
    backgroundColor: ColorSchemes.gentleYellowBg,
  ),
  child: yourPageHere(),
),
```

### Example 5 - Stack backgrounds

This example shows how to stack backgrounds for interesting new effects.

```dart
DynamicBg(
  painterData: ScrollerPainterData(
    direction: ScrollDirection.left2Right,
    backgroundColor: ColorSchemes.gentleWhiteBg,
    color: ColorSchemes.gentleBlackFg,
    shapeOffset: ScrollerShapeOffset.shiftAndMesh,
  ),
  child: DynamicBg(
    duration: const Duration(seconds: 45),
    painterData: ScrollerPainterData(
      backgroundColor: Colors.transparent,
      color: ColorSchemes.vibrantBlackFg,
      shapeWidth: 28.0,
      spaceBetweenShapes: 55.0,
      shapeOffset: ScrollerShapeOffset.shiftAndMesh,
    ),
    child: yourPageHere(),
  ),
),
```

<hr>

<h3 align="center">If you found this helpful, please consider donating. Thanks!</h3>
<p align="center">
  <a href="https://www.buymeacoffee.com/babincc" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/buy_me_a_coffee_logo.png" alt="buy me a coffee" height="45">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://paypal.me/cssbabin" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/pay_pal_logo.png" alt="paypal" height="45">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://venmo.com/u/babincc" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/venmo_logo.png" alt="venmo" height="45">
  </a>
</p>
<br><br>
