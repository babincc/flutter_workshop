import 'package:flutter/material.dart';

class ColorSchemes {
// --------------------------------- BLACK ---------------------------------- //

  static List<Color> get gentleBlack => [
        gentleBlackBg,
        gentleBlackFg,
        const Color.fromRGBO(82, 82, 82, 1),
      ];
  static Color get gentleBlackBg => const Color.fromRGBO(117, 117, 117, 1);
  static Color get gentleBlackFg => const Color.fromRGBO(100, 100, 100, 1);

  static List<Color> get vibrantBlack => [
        const Color.fromRGBO(43, 42, 42, 1.0),
        vibrantBlackFg,
        vibrantBlackBg,
      ];
  static Color get vibrantBlackBg => const Color.fromRGBO(34, 33, 33, 1.0);
  static Color get vibrantBlackFg => const Color.fromRGBO(39, 35, 35, 1.0);

// --------------------------------- WHITE ---------------------------------- //

  static List<Color> get gentleWhite => [
        gentleWhiteBg,
        gentleWhiteFg,
        const Color.fromRGBO(225, 225, 225, 1.0),
      ];
  static Color get gentleWhiteBg => const Color.fromRGBO(245, 245, 245, 1.0);
  static Color get gentleWhiteFg => const Color.fromRGBO(235, 235, 235, 1.0);

  static List<Color> get vibrantWhite => [
        const Color.fromRGBO(234, 234, 234, 1.0),
        vibrantWhiteFg,
        vibrantWhiteBg,
      ];
  static Color get vibrantWhiteBg => const Color.fromRGBO(217, 217, 217, 1.0);
  static Color get vibrantWhiteFg => const Color.fromRGBO(224, 224, 224, 1.0);

// --------------------------------- BROWN ---------------------------------- //

  static List<Color> get gentleBrown => [
        gentleBrownBg,
        gentleBrownFg,
        const Color.fromRGBO(151, 120, 109, 1),
      ];
  static Color get gentleBrownBg => const Color.fromRGBO(188, 170, 164, 1);
  static Color get gentleBrownFg => const Color.fromRGBO(161, 136, 127, 1);

  static List<Color> get vibrantBrown => [
        const Color.fromRGBO(93, 64, 55, 1),
        vibrantBrownFg,
        vibrantBrownBg,
      ];
  static Color get vibrantBrownBg => const Color.fromRGBO(62, 39, 35, 1);
  static Color get vibrantBrownFg => const Color.fromRGBO(78, 52, 46, 1);

// ---------------------------------- RED ----------------------------------- //

  static List<Color> get gentleRed => [
        gentleRedBg,
        gentleRedFg,
        const Color.fromRGBO(229, 98, 95, 1),
      ];
  static Color get gentleRedBg => const Color.fromRGBO(239, 154, 154, 1);
  static Color get gentleRedFg => const Color.fromRGBO(229, 115, 115, 1);

  static List<Color> get vibrantRed => [
        const Color.fromRGBO(211, 47, 47, 1),
        vibrantRedFg,
        vibrantRedBg,
      ];
  static Color get vibrantRedBg => const Color.fromRGBO(183, 28, 28, 1);
  static Color get vibrantRedFg => const Color.fromRGBO(198, 40, 40, 1);

// --------------------------------- ORANGE --------------------------------- //

  static List<Color> get gentleOrange => [
        gentleOrangeBg,
        gentleOrangeFg,
        const Color.fromRGBO(255, 180, 52, 1),
      ];
  static Color get gentleOrangeBg => const Color.fromRGBO(255, 204, 128, 1);
  static Color get gentleOrangeFg => const Color.fromRGBO(255, 190, 85, 1);

  static List<Color> get vibrantOrange => [
        const Color.fromRGBO(245, 124, 0, 1),
        vibrantOrangeFg,
        vibrantOrangeBg,
      ];
  static Color get vibrantOrangeBg => const Color.fromRGBO(220, 95, 0, 1);
  static Color get vibrantOrangeFg => const Color.fromRGBO(239, 108, 0, 1);

// --------------------------------- YELLOW --------------------------------- //

  static List<Color> get gentleYellow => [
        gentleYellowBg,
        gentleYellowFg,
        const Color.fromRGBO(255, 238, 94, 1),
      ];
  static Color get gentleYellowBg => const Color.fromRGBO(255, 245, 157, 1);
  static Color get gentleYellowFg => const Color.fromRGBO(255, 241, 118, 1);

  static List<Color> get vibrantYellow => [
        const Color.fromRGBO(245, 238, 100, 1),
        vibrantYellowFg,
        vibrantYellowBg,
      ];
  static Color get vibrantYellowBg => const Color.fromRGBO(255, 198, 27, 1);
  static Color get vibrantYellowFg => const Color.fromRGBO(250, 220, 76, 1);

// --------------------------------- GREEN ---------------------------------- //

  static List<Color> get gentleGreen => [
        gentleGreenBg,
        gentleGreenFg,
        const Color.fromRGBO(115, 192, 119, 1),
      ];
  static Color get gentleGreenBg => const Color.fromRGBO(165, 214, 167, 1);
  static Color get gentleGreenFg => const Color.fromRGBO(129, 199, 132, 1);

  static List<Color> get vibrantGreen => [
        const Color.fromRGBO(56, 142, 60, 1),
        vibrantGreenFg,
        vibrantGreenBg,
      ];
  static Color get vibrantGreenBg => const Color.fromRGBO(36, 115, 40, 1);
  static Color get vibrantGreenFg => const Color.fromRGBO(46, 125, 50, 1);

// ---------------------------------- BLUE ---------------------------------- //

  static List<Color> get gentleBlue => [
        gentleBlueBg,
        gentleBlueFg,
        const Color.fromRGBO(70, 171, 245, 1),
      ];
  static Color get gentleBlueBg => const Color.fromRGBO(144, 202, 249, 1);
  static Color get gentleBlueFg => const Color.fromRGBO(100, 181, 246, 1);

  static List<Color> get icyBlue => [
        icyBlueBg,
        icyBlueFg,
        const Color.fromRGBO(129, 247, 255, 1.0),
      ];
  static Color get icyBlueBg => const Color.fromRGBO(227, 253, 255, 1.0);
  static Color get icyBlueFg => const Color.fromRGBO(209, 247, 255, 1.0);

  static List<Color> get vibrantBlue => [
        const Color.fromRGBO(25, 118, 208, 1),
        vibrantBlueFg,
        vibrantBlueBg,
      ];
  static Color get vibrantBlueBg => const Color.fromRGBO(13, 71, 165, 1);
  static Color get vibrantBlueFg => const Color.fromRGBO(21, 101, 192, 1);

// --------------------------------- PURPLE --------------------------------- //

  static List<Color> get gentlePurple => [
        gentlePurpleBg,
        gentlePurpleFg,
        const Color.fromRGBO(155, 98, 190, 1),
      ];
  static Color get gentlePurpleBg => const Color.fromRGBO(190, 147, 216, 1);
  static Color get gentlePurpleFg => const Color.fromRGBO(170, 124, 200, 1);

  static List<Color> get vibrantPurple => [
        const Color.fromRGBO(123, 31, 162, 1),
        vibrantPurpleFg,
        vibrantPurpleBg,
      ];
  static Color get vibrantPurpleBg => const Color.fromRGBO(89, 25, 143, 1);
  static Color get vibrantPurpleFg => const Color.fromRGBO(106, 27, 154, 1);
}
