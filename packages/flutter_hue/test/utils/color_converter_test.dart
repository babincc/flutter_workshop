import 'dart:ui';

import 'package:flutter_hue/flutter_hue.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "xy to",
    () {
      const List<double> xy1 = [0.0000000001, 0.0000000001];
      const List<double> xy2 = [0.5, 0.5];
      const List<double> xy3 = [1.0, 1.0];
      const List<double> xy4 = [0.0000000001, 1.0];
      const List<double> xy5 = [1.0, 0.0000000001];
      const List<double> xy6 = [0.23178, 0.54689];

      test(
        "rgb",
        () {
          expect(
            ColorConverter.xy2rgb(xy1[0], xy1[1]),
            [0, 64, 255],
          );
          expect(
            ColorConverter.xy2rgb(xy2[0], xy2[1]),
            [255, 222, 0],
          );
          expect(
            ColorConverter.xy2rgb(xy3[0], xy3[1]),
            [255, 202, 0],
          );
          expect(
            ColorConverter.xy2rgb(xy4[0], xy4[1]),
            [0, 255, 0],
          );
          expect(
            ColorConverter.xy2rgb(xy5[0], xy5[1]),
            [255, 0, 60],
          );
          expect(
            ColorConverter.xy2rgb(xy6[0], xy6[1]),
            [118, 255, 132],
          );
        },
      );

      test(
        "hsv",
        () {
          expect(
            ColorConverter.xy2hsv(xy1[0], xy1[1]),
            [225.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.xy2hsv(xy2[0], xy2[1]),
            [52.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.xy2hsv(xy3[0], xy3[1]),
            [48.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.xy2hsv(xy4[0], xy4[1]),
            [120.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.xy2hsv(xy5[0], xy5[1]),
            [346.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.xy2hsv(xy6[0], xy6[1]),
            [126.0, 0.5372549019607843, 1.0],
          );
        },
      );

      test(
        "hex",
        () {
          expect(
            ColorConverter.xy2hex(xy1[0], xy1[1]),
            "ff0040ff",
          );
          expect(
            ColorConverter.xy2hex(xy2[0], xy2[1]),
            "ffffde00",
          );
          expect(
            ColorConverter.xy2hex(xy3[0], xy3[1]),
            "ffffca00",
          );
          expect(
            ColorConverter.xy2hex(xy4[0], xy4[1]),
            "ff00ff00",
          );
          expect(
            ColorConverter.xy2hex(xy5[0], xy5[1]),
            "ffff003c",
          );
          expect(
            ColorConverter.xy2hex(xy6[0], xy6[1]),
            "ff76ff84",
          );
        },
      );

      test(
        "hsl",
        () {
          expect(
            ColorConverter.xy2hsl(xy1[0], xy1[1]),
            [225.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.xy2hsl(xy2[0], xy2[1]),
            [52.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.xy2hsl(xy3[0], xy3[1]),
            [48.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.xy2hsl(xy4[0], xy4[1]),
            [120.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.xy2hsl(xy5[0], xy5[1]),
            [346.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.xy2hsl(xy6[0], xy6[1]),
            [126.0, 1.0, 0.7313725490196079],
          );
        },
      );

      test(
        "color",
        () {
          expect(
            ColorConverter.xy2color(xy1[0], xy1[1]),
            const Color(0xff0040ff),
          );
          expect(
            ColorConverter.xy2color(xy2[0], xy2[1]),
            const Color(0xffffde00),
          );
          expect(
            ColorConverter.xy2color(xy3[0], xy3[1]),
            const Color(0xffffca00),
          );
          expect(
            ColorConverter.xy2color(xy4[0], xy4[1]),
            const Color(0xff00ff00),
          );
          expect(
            ColorConverter.xy2color(xy5[0], xy5[1]),
            const Color(0xffff003c),
          );
          expect(
            ColorConverter.xy2color(xy6[0], xy6[1]),
            const Color(0xff76ff84),
          );
        },
      );

      test(
        "int",
        () {
          expect(
            ColorConverter.xy2int(xy1[0], xy1[1]),
            4278206719,
          );
          expect(
            ColorConverter.xy2int(xy2[0], xy2[1]),
            4294958592,
          );
          expect(
            ColorConverter.xy2int(xy3[0], xy3[1]),
            4294953472,
          );
          expect(
            ColorConverter.xy2int(xy4[0], xy4[1]),
            4278255360,
          );
          expect(
            ColorConverter.xy2int(xy5[0], xy5[1]),
            4294901820,
          );
          expect(
            ColorConverter.xy2int(xy6[0], xy6[1]),
            4285988740,
          );
        },
      );
    },
  );

  group(
    "rgb to",
    () {
      const List<int> rgb1 = [255, 0, 0];
      const List<int> rgb2 = [0, 255, 0];
      const List<int> rgb3 = [0, 0, 255];
      const List<int> rgb4 = [128, 128, 128];
      const List<int> rgb5 = [0, 0, 0];
      const List<int> rgb6 = [255, 255, 255];
      const List<int> rgb7 = [138, 72, 136];

      test(
        "xy",
        () {
          expect(
            ColorConverter.rgb2xy(rgb1[0], rgb1[1], rgb1[2]),
            [0.6400744994567747, 0.32997051063169336, 0.2126],
          );
          expect(
            ColorConverter.rgb2xy(rgb2[0], rgb2[1], rgb2[2]),
            [0.3, 0.6, 0.7152],
          );
          expect(
            ColorConverter.rgb2xy(rgb3[0], rgb3[1], rgb3[2]),
            [0.1500166223404255, 0.060006648936170214, 0.0722],
          );
          expect(
            ColorConverter.rgb2xy(rgb4[0], rgb4[1], rgb4[2]),
            [0.3127159072215825, 0.3290014805066622, 0.21586050011389923],
          );
          expect(
            ColorConverter.rgb2xy(rgb5[0], rgb5[1], rgb5[2]),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.rgb2xy(rgb6[0], rgb6[1], rgb6[2]),
            [0.3127159072215825, 0.3290014805066623, 1.0],
          );
          expect(
            ColorConverter.rgb2xy(rgb7[0], rgb7[1], rgb7[2]),
            [0.3209554122773742, 0.21993715851681886, 0.1181557673818057],
          );
        },
      );

      test(
        "hsv",
        () {
          expect(
            ColorConverter.rgb2hsv(rgb1[0], rgb1[1], rgb1[2]),
            [0.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.rgb2hsv(rgb2[0], rgb2[1], rgb2[2]),
            [120.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.rgb2hsv(rgb3[0], rgb3[1], rgb3[2]),
            [240.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.rgb2hsv(rgb4[0], rgb4[1], rgb4[2]),
            [0.0, 0.0, 0.5019607843137255],
          );
          expect(
            ColorConverter.rgb2hsv(rgb5[0], rgb5[1], rgb5[2]),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.rgb2hsv(rgb6[0], rgb6[1], rgb6[2]),
            [0.0, 0.0, 1.0],
          );
          expect(
            ColorConverter.rgb2hsv(rgb7[0], rgb7[1], rgb7[2]),
            [302.0, 0.47826086956521735, 0.5411764705882353],
          );
        },
      );

      test(
        "hex",
        () {
          expect(
            ColorConverter.rgb2hex(rgb1[0], rgb1[1], rgb1[2]),
            "ffff0000",
          );
          expect(
            ColorConverter.rgb2hex(rgb2[0], rgb2[1], rgb2[2]),
            "ff00ff00",
          );
          expect(
            ColorConverter.rgb2hex(rgb3[0], rgb3[1], rgb3[2]),
            "ff0000ff",
          );
          expect(
            ColorConverter.rgb2hex(rgb4[0], rgb4[1], rgb4[2]),
            "ff808080",
          );
          expect(
            ColorConverter.rgb2hex(rgb5[0], rgb5[1], rgb5[2]),
            "ff000000",
          );
          expect(
            ColorConverter.rgb2hex(rgb6[0], rgb6[1], rgb6[2]),
            "ffffffff",
          );
          expect(
            ColorConverter.rgb2hex(rgb7[0], rgb7[1], rgb7[2]),
            "ff8a4888",
          );
        },
      );

      test(
        "hsl",
        () {
          expect(
            ColorConverter.rgb2hsl(rgb1[0], rgb1[1], rgb1[2]),
            [0.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.rgb2hsl(rgb2[0], rgb2[1], rgb2[2]),
            [120.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.rgb2hsl(rgb3[0], rgb3[1], rgb3[2]),
            [240.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.rgb2hsl(rgb4[0], rgb4[1], rgb4[2]),
            [0.0, 0.0, 0.5019607843137255],
          );
          expect(
            ColorConverter.rgb2hsl(rgb5[0], rgb5[1], rgb5[2]),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.rgb2hsl(rgb6[0], rgb6[1], rgb6[2]),
            [0.0, 0.0, 1.0],
          );
          expect(
            ColorConverter.rgb2hsl(rgb7[0], rgb7[1], rgb7[2]),
            [302.0, 0.3142857142857143, 0.4117647058823529],
          );
        },
      );

      test(
        "color",
        () {
          expect(
            ColorConverter.rgb2color(rgb1[0], rgb1[1], rgb1[2]),
            const Color(0xffff0000),
          );
          expect(
            ColorConverter.rgb2color(rgb2[0], rgb2[1], rgb2[2]),
            const Color(0xff00ff00),
          );
          expect(
            ColorConverter.rgb2color(rgb3[0], rgb3[1], rgb3[2]),
            const Color(0xff0000ff),
          );
          expect(
            ColorConverter.rgb2color(rgb4[0], rgb4[1], rgb4[2]),
            const Color(0xff808080),
          );
          expect(
            ColorConverter.rgb2color(rgb5[0], rgb5[1], rgb5[2]),
            const Color(0xff000000),
          );
          expect(
            ColorConverter.rgb2color(rgb6[0], rgb6[1], rgb6[2]),
            const Color(0xffffffff),
          );
          expect(
            ColorConverter.rgb2color(rgb7[0], rgb7[1], rgb7[2]),
            const Color(0xff8a4888),
          );
        },
      );

      test(
        "int",
        () {
          expect(
            ColorConverter.rgb2int(rgb1[0], rgb1[1], rgb1[2]),
            4294901760,
          );
          expect(
            ColorConverter.rgb2int(rgb2[0], rgb2[1], rgb2[2]),
            4278255360,
          );
          expect(
            ColorConverter.rgb2int(rgb3[0], rgb3[1], rgb3[2]),
            4278190335,
          );
          expect(
            ColorConverter.rgb2int(rgb4[0], rgb4[1], rgb4[2]),
            4286611584,
          );
          expect(
            ColorConverter.rgb2int(rgb5[0], rgb5[1], rgb5[2]),
            4278190080,
          );
          expect(
            ColorConverter.rgb2int(rgb6[0], rgb6[1], rgb6[2]),
            4294967295,
          );
          expect(
            ColorConverter.rgb2int(rgb7[0], rgb7[1], rgb7[2]),
            4287252616,
          );
        },
      );
    },
  );

  group(
    "hsv to",
    () {
      const List<double> hsv1 = [0.0, 1.0, 1.0];
      const List<double> hsv2 = [120.0, 1.0, 1.0];
      const List<double> hsv3 = [240.0, 1.0, 1.0];
      const List<double> hsv4 = [0.0, 0.0, 0.5019607843137255];
      const List<double> hsv5 = [0.0, 0.0, 0.0];
      const List<double> hsv6 = [0.0, 0.0, 1.0];
      const List<double> hsv7 = [
        302.0,
        0.47826086956521735,
        0.5411764705882353
      ];

      test(
        "xy",
        () {
          expect(
            ColorConverter.hsv2xy(hsv1[0].toInt(), hsv1[1], hsv1[2]),
            [0.6400744994567747, 0.32997051063169336, 0.2126],
          );
          expect(
            ColorConverter.hsv2xy(hsv2[0].toInt(), hsv2[1], hsv2[2]),
            [0.3, 0.6, 0.7152],
          );
          expect(
            ColorConverter.hsv2xy(hsv3[0].toInt(), hsv3[1], hsv3[2]),
            [0.1500166223404255, 0.060006648936170214, 0.0722],
          );
          expect(
            ColorConverter.hsv2xy(hsv4[0].toInt(), hsv4[1], hsv4[2]),
            [0.3127159072215825, 0.3290014805066622, 0.21586050011389923],
          );
          expect(
            ColorConverter.hsv2xy(hsv5[0].toInt(), hsv5[1], hsv5[2]),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.hsv2xy(hsv6[0].toInt(), hsv6[1], hsv6[2]),
            [0.3127159072215825, 0.3290014805066623, 1.0],
          );
          expect(
            ColorConverter.hsv2xy(hsv7[0].toInt(), hsv7[1], hsv7[2]),
            [0.3209554122773742, 0.21993715851681886, 0.1181557673818057],
          );
        },
      );

      test(
        "rgb",
        () {
          expect(
            ColorConverter.hsv2rgb(hsv1[0].toInt(), hsv1[1], hsv1[2]),
            [255, 0, 0],
          );
          expect(
            ColorConverter.hsv2rgb(hsv2[0].toInt(), hsv2[1], hsv2[2]),
            [0, 255, 0],
          );
          expect(
            ColorConverter.hsv2rgb(hsv3[0].toInt(), hsv3[1], hsv3[2]),
            [0, 0, 255],
          );
          expect(
            ColorConverter.hsv2rgb(hsv4[0].toInt(), hsv4[1], hsv4[2]),
            [128, 128, 128],
          );
          expect(
            ColorConverter.hsv2rgb(hsv5[0].toInt(), hsv5[1], hsv5[2]),
            [0, 0, 0],
          );
          expect(
            ColorConverter.hsv2rgb(hsv6[0].toInt(), hsv6[1], hsv6[2]),
            [255, 255, 255],
          );
          expect(
            ColorConverter.hsv2rgb(hsv7[0].toInt(), hsv7[1], hsv7[2]),
            [138, 72, 136],
          );
        },
      );

      test(
        "hex",
        () {
          expect(
            ColorConverter.hsv2hex(hsv1[0].toInt(), hsv1[1], hsv1[2]),
            "ffff0000",
          );
          expect(
            ColorConverter.hsv2hex(hsv2[0].toInt(), hsv2[1], hsv2[2]),
            "ff00ff00",
          );
          expect(
            ColorConverter.hsv2hex(hsv3[0].toInt(), hsv3[1], hsv3[2]),
            "ff0000ff",
          );
          expect(
            ColorConverter.hsv2hex(hsv4[0].toInt(), hsv4[1], hsv4[2]),
            "ff808080",
          );
          expect(
            ColorConverter.hsv2hex(hsv5[0].toInt(), hsv5[1], hsv5[2]),
            "ff000000",
          );
          expect(
            ColorConverter.hsv2hex(hsv6[0].toInt(), hsv6[1], hsv6[2]),
            "ffffffff",
          );
          expect(
            ColorConverter.hsv2hex(hsv7[0].toInt(), hsv7[1], hsv7[2]),
            "ff8a4888",
          );
        },
      );

      test(
        "hsl",
        () {
          expect(
            ColorConverter.hsv2hsl(hsv1[0].toInt(), hsv1[1], hsv1[2]),
            [0.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.hsv2hsl(hsv2[0].toInt(), hsv2[1], hsv2[2]),
            [120.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.hsv2hsl(hsv3[0].toInt(), hsv3[1], hsv3[2]),
            [240.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.hsv2hsl(hsv4[0].toInt(), hsv4[1], hsv4[2]),
            [0.0, 0.0, 0.5019607843137255],
          );
          expect(
            ColorConverter.hsv2hsl(hsv5[0].toInt(), hsv5[1], hsv5[2]),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.hsv2hsl(hsv6[0].toInt(), hsv6[1], hsv6[2]),
            [0.0, 0.0, 1.0],
          );
          expect(
            ColorConverter.hsv2hsl(hsv7[0].toInt(), hsv7[1], hsv7[2]),
            [302.0, 0.3142857142857143, 0.4117647058823529],
          );
        },
      );

      test(
        "color",
        () {
          expect(
            ColorConverter.hsv2color(hsv1[0].toInt(), hsv1[1], hsv1[2]),
            const Color(0xffff0000),
          );
          expect(
            ColorConverter.hsv2color(hsv2[0].toInt(), hsv2[1], hsv2[2]),
            const Color(0xff00ff00),
          );
          expect(
            ColorConverter.hsv2color(hsv3[0].toInt(), hsv3[1], hsv3[2]),
            const Color(0xff0000ff),
          );
          expect(
            ColorConverter.hsv2color(hsv4[0].toInt(), hsv4[1], hsv4[2]),
            const Color(0xff808080),
          );
          expect(
            ColorConverter.hsv2color(hsv5[0].toInt(), hsv5[1], hsv5[2]),
            const Color(0xff000000),
          );
          expect(
            ColorConverter.hsv2color(hsv6[0].toInt(), hsv6[1], hsv6[2]),
            const Color(0xffffffff),
          );
          expect(
            ColorConverter.hsv2color(hsv7[0].toInt(), hsv7[1], hsv7[2]),
            const Color(0xff8a4888),
          );
        },
      );

      test(
        "int",
        () {
          expect(
            ColorConverter.hsv2int(hsv1[0].toInt(), hsv1[1], hsv1[2]),
            4294901760,
          );
          expect(
            ColorConverter.hsv2int(hsv2[0].toInt(), hsv2[1], hsv2[2]),
            4278255360,
          );
          expect(
            ColorConverter.hsv2int(hsv3[0].toInt(), hsv3[1], hsv3[2]),
            4278190335,
          );
          expect(
            ColorConverter.hsv2int(hsv4[0].toInt(), hsv4[1], hsv4[2]),
            4286611584,
          );
          expect(
            ColorConverter.hsv2int(hsv5[0].toInt(), hsv5[1], hsv5[2]),
            4278190080,
          );
          expect(
            ColorConverter.hsv2int(hsv6[0].toInt(), hsv6[1], hsv6[2]),
            4294967295,
          );
          expect(
            ColorConverter.hsv2int(hsv7[0].toInt(), hsv7[1], hsv7[2]),
            4287252616,
          );
        },
      );
    },
  );

  group(
    "hex to",
    () {
      const String hex1 = "ffff0000";
      const String hex2 = "ff00ff00";
      const String hex3 = "ff0000ff";
      const String hex4 = "ff808080";
      const String hex5 = "ff000000";
      const String hex6 = "ffffffff";
      const String hex7 = "ff8a4888";

      test(
        "xy",
        () {
          expect(
            ColorConverter.hex2xy(hex1),
            [0.6400744994567747, 0.32997051063169336, 0.2126],
          );
          expect(
            ColorConverter.hex2xy(hex2),
            [0.3, 0.6, 0.7152],
          );
          expect(
            ColorConverter.hex2xy(hex3),
            [0.1500166223404255, 0.060006648936170214, 0.0722],
          );
          expect(
            ColorConverter.hex2xy(hex4),
            [0.3127159072215825, 0.3290014805066622, 0.21586050011389923],
          );
          expect(
            ColorConverter.hex2xy(hex5),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.hex2xy(hex6),
            [0.3127159072215825, 0.3290014805066623, 1.0],
          );
          expect(
            ColorConverter.hex2xy(hex7),
            [0.3209554122773742, 0.21993715851681886, 0.1181557673818057],
          );
        },
      );

      test(
        "rgb",
        () {
          expect(
            ColorConverter.hex2rgb(hex1),
            [255, 0, 0],
          );
          expect(
            ColorConverter.hex2rgb(hex2),
            [0, 255, 0],
          );
          expect(
            ColorConverter.hex2rgb(hex3),
            [0, 0, 255],
          );
          expect(
            ColorConverter.hex2rgb(hex4),
            [128, 128, 128],
          );
          expect(
            ColorConverter.hex2rgb(hex5),
            [0, 0, 0],
          );
          expect(
            ColorConverter.hex2rgb(hex6),
            [255, 255, 255],
          );
          expect(
            ColorConverter.hex2rgb(hex7),
            [138, 72, 136],
          );
        },
      );

      test(
        "hsv",
        () {
          expect(
            ColorConverter.hex2hsv(hex1),
            [0.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.hex2hsv(hex2),
            [120.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.hex2hsv(hex3),
            [240.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.hex2hsv(hex4),
            [0.0, 0.0, 0.5019607843137255],
          );
          expect(
            ColorConverter.hex2hsv(hex5),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.hex2hsv(hex6),
            [0.0, 0.0, 1.0],
          );
          expect(
            ColorConverter.hex2hsv(hex7),
            [302.0, 0.47826086956521735, 0.5411764705882353],
          );
        },
      );

      test(
        "hsl",
        () {
          expect(
            ColorConverter.hex2hsl(hex1),
            [0.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.hex2hsl(hex2),
            [120.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.hex2hsl(hex3),
            [240.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.hex2hsl(hex4),
            [0.0, 0.0, 0.5019607843137255],
          );
          expect(
            ColorConverter.hex2hsl(hex5),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.hex2hsl(hex6),
            [0.0, 0.0, 1.0],
          );
          expect(
            ColorConverter.hex2hsl(hex7),
            [302.0, 0.3142857142857143, 0.4117647058823529],
          );
        },
      );

      test(
        "color",
        () {
          expect(
            ColorConverter.hex2color(hex1),
            const Color(0xffff0000),
          );
          expect(
            ColorConverter.hex2color(hex2),
            const Color(0xff00ff00),
          );
          expect(
            ColorConverter.hex2color(hex3),
            const Color(0xff0000ff),
          );
          expect(
            ColorConverter.hex2color(hex4),
            const Color(0xff808080),
          );
          expect(
            ColorConverter.hex2color(hex5),
            const Color(0xff000000),
          );
          expect(
            ColorConverter.hex2color(hex6),
            const Color(0xffffffff),
          );
          expect(
            ColorConverter.hex2color(hex7),
            const Color(0xff8a4888),
          );
        },
      );

      test(
        "int",
        () {
          expect(
            ColorConverter.hex2int(hex1),
            4294901760,
          );
          expect(
            ColorConverter.hex2int(hex2),
            4278255360,
          );
          expect(
            ColorConverter.hex2int(hex3),
            4278190335,
          );
          expect(
            ColorConverter.hex2int(hex4),
            4286611584,
          );
          expect(
            ColorConverter.hex2int(hex5),
            4278190080,
          );
          expect(
            ColorConverter.hex2int(hex6),
            4294967295,
          );
          expect(
            ColorConverter.hex2int(hex7),
            4287252616,
          );
        },
      );
    },
  );

  group(
    "hsl to",
    () {
      const List<double> hsl1 = [0.0, 1.0, 0.5];
      const List<double> hsl2 = [120.0, 1.0, 0.5];
      const List<double> hsl3 = [240.0, 1.0, 0.5];
      const List<double> hsl4 = [0.0, 0.0, 0.5019607843137255];
      const List<double> hsl5 = [0.0, 0.0, 0.0];
      const List<double> hsl6 = [0.0, 0.0, 1.0];
      const List<double> hsl7 = [302.0, 0.3142857142857143, 0.4117647058823529];

      test(
        "xy",
        () {
          expect(
            ColorConverter.hsl2xy(hsl1[0].toInt(), hsl1[1], hsl1[2]),
            [0.6400744994567747, 0.32997051063169336, 0.2126],
          );
          expect(
            ColorConverter.hsl2xy(hsl2[0].toInt(), hsl2[1], hsl2[2]),
            [0.3, 0.6, 0.7152],
          );
          expect(
            ColorConverter.hsl2xy(hsl3[0].toInt(), hsl3[1], hsl3[2]),
            [0.1500166223404255, 0.060006648936170214, 0.0722],
          );
          expect(
            ColorConverter.hsl2xy(hsl4[0].toInt(), hsl4[1], hsl4[2]),
            [0.3127159072215825, 0.3290014805066622, 0.21586050011389923],
          );
          expect(
            ColorConverter.hsl2xy(hsl5[0].toInt(), hsl5[1], hsl5[2]),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.hsl2xy(hsl6[0].toInt(), hsl6[1], hsl6[2]),
            [0.3127159072215825, 0.3290014805066623, 1.0],
          );
          expect(
            ColorConverter.hsl2xy(hsl7[0].toInt(), hsl7[1], hsl7[2]),
            [0.3209554122773742, 0.21993715851681886, 0.1181557673818057],
          );
        },
      );

      test(
        "rgb",
        () {
          expect(
            ColorConverter.hsl2rgb(hsl1[0].toInt(), hsl1[1], hsl1[2]),
            [255, 0, 0],
          );
          expect(
            ColorConverter.hsl2rgb(hsl2[0].toInt(), hsl2[1], hsl2[2]),
            [0, 255, 0],
          );
          expect(
            ColorConverter.hsl2rgb(hsl3[0].toInt(), hsl3[1], hsl3[2]),
            [0, 0, 255],
          );
          expect(
            ColorConverter.hsl2rgb(hsl4[0].toInt(), hsl4[1], hsl4[2]),
            [128, 128, 128],
          );
          expect(
            ColorConverter.hsl2rgb(hsl5[0].toInt(), hsl5[1], hsl5[2]),
            [0, 0, 0],
          );
          expect(
            ColorConverter.hsl2rgb(hsl6[0].toInt(), hsl6[1], hsl6[2]),
            [255, 255, 255],
          );
          expect(
            ColorConverter.hsl2rgb(hsl7[0].toInt(), hsl7[1], hsl7[2]),
            [138, 72, 136],
          );
        },
      );

      test(
        "hsv",
        () {
          expect(
            ColorConverter.hsl2hsv(hsl1[0].toInt(), hsl1[1], hsl1[2]),
            [0.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.hsl2hsv(hsl2[0].toInt(), hsl2[1], hsl2[2]),
            [120.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.hsl2hsv(hsl3[0].toInt(), hsl3[1], hsl3[2]),
            [240.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.hsl2hsv(hsl4[0].toInt(), hsl4[1], hsl4[2]),
            [0.0, 0.0, 0.5019607843137255],
          );
          expect(
            ColorConverter.hsl2hsv(hsl5[0].toInt(), hsl5[1], hsl5[2]),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.hsl2hsv(hsl6[0].toInt(), hsl6[1], hsl6[2]),
            [0.0, 0.0, 1.0],
          );
          expect(
            ColorConverter.hsl2hsv(hsl7[0].toInt(), hsl7[1], hsl7[2]),
            [302.0, 0.47826086956521735, 0.5411764705882353],
          );
        },
      );

      test(
        "hex",
        () {
          expect(
            ColorConverter.hsl2hex(hsl1[0].toInt(), hsl1[1], hsl1[2]),
            "ffff0000",
          );
          expect(
            ColorConverter.hsl2hex(hsl2[0].toInt(), hsl2[1], hsl2[2]),
            "ff00ff00",
          );
          expect(
            ColorConverter.hsl2hex(hsl3[0].toInt(), hsl3[1], hsl3[2]),
            "ff0000ff",
          );
          expect(
            ColorConverter.hsl2hex(hsl4[0].toInt(), hsl4[1], hsl4[2]),
            "ff808080",
          );
          expect(
            ColorConverter.hsl2hex(hsl5[0].toInt(), hsl5[1], hsl5[2]),
            "ff000000",
          );
          expect(
            ColorConverter.hsl2hex(hsl6[0].toInt(), hsl6[1], hsl6[2]),
            "ffffffff",
          );
          expect(
            ColorConverter.hsl2hex(hsl7[0].toInt(), hsl7[1], hsl7[2]),
            "ff8a4888",
          );
        },
      );

      test(
        "color",
        () {
          expect(
            ColorConverter.hsl2color(hsl1[0].toInt(), hsl1[1], hsl1[2]),
            const Color(0xffff0000),
          );
          expect(
            ColorConverter.hsl2color(hsl2[0].toInt(), hsl2[1], hsl2[2]),
            const Color(0xff00ff00),
          );
          expect(
            ColorConverter.hsl2color(hsl3[0].toInt(), hsl3[1], hsl3[2]),
            const Color(0xff0000ff),
          );
          expect(
            ColorConverter.hsl2color(hsl4[0].toInt(), hsl4[1], hsl4[2]),
            const Color(0xff808080),
          );
          expect(
            ColorConverter.hsl2color(hsl5[0].toInt(), hsl5[1], hsl5[2]),
            const Color(0xff000000),
          );
          expect(
            ColorConverter.hsl2color(hsl6[0].toInt(), hsl6[1], hsl6[2]),
            const Color(0xffffffff),
          );
          expect(
            ColorConverter.hsl2color(hsl7[0].toInt(), hsl7[1], hsl7[2]),
            const Color(0xff8a4888),
          );
        },
      );

      test(
        "int",
        () {
          expect(
            ColorConverter.hsl2int(hsl1[0].toInt(), hsl1[1], hsl1[2]),
            4294901760,
          );
          expect(
            ColorConverter.hsl2int(hsl2[0].toInt(), hsl2[1], hsl2[2]),
            4278255360,
          );
          expect(
            ColorConverter.hsl2int(hsl3[0].toInt(), hsl3[1], hsl3[2]),
            4278190335,
          );
          expect(
            ColorConverter.hsl2int(hsl4[0].toInt(), hsl4[1], hsl4[2]),
            4286611584,
          );
          expect(
            ColorConverter.hsl2int(hsl5[0].toInt(), hsl5[1], hsl5[2]),
            4278190080,
          );
          expect(
            ColorConverter.hsl2int(hsl6[0].toInt(), hsl6[1], hsl6[2]),
            4294967295,
          );
          expect(
            ColorConverter.hsl2int(hsl7[0].toInt(), hsl7[1], hsl7[2]),
            4287252616,
          );
        },
      );
    },
  );

  group(
    "color to",
    () {
      const Color color1 = Color(0xffff0000);
      const Color color2 = Color(0xff00ff00);
      const Color color3 = Color(0xff0000ff);
      const Color color4 = Color(0xff808080);
      const Color color5 = Color(0xff000000);
      const Color color6 = Color(0xffffffff);
      const Color color7 = Color(0xff8a4888);

      test(
        "xy",
        () {
          expect(
            ColorConverter.color2xy(color1),
            [0.6400744994567747, 0.32997051063169336, 0.2126],
          );
          expect(
            ColorConverter.color2xy(color2),
            [0.3, 0.6, 0.7152],
          );
          expect(
            ColorConverter.color2xy(color3),
            [0.1500166223404255, 0.060006648936170214, 0.0722],
          );
          expect(
            ColorConverter.color2xy(color4),
            [0.3127159072215825, 0.3290014805066622, 0.21586050011389923],
          );
          expect(
            ColorConverter.color2xy(color5),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.color2xy(color6),
            [0.3127159072215825, 0.3290014805066623, 1.0],
          );
          expect(
            ColorConverter.color2xy(color7),
            [0.3209554122773742, 0.21993715851681886, 0.1181557673818057],
          );
        },
      );

      test(
        "rgb",
        () {
          expect(
            ColorConverter.color2rgb(color1),
            [255, 0, 0],
          );
          expect(
            ColorConverter.color2rgb(color2),
            [0, 255, 0],
          );
          expect(
            ColorConverter.color2rgb(color3),
            [0, 0, 255],
          );
          expect(
            ColorConverter.color2rgb(color4),
            [128, 128, 128],
          );
          expect(
            ColorConverter.color2rgb(color5),
            [0, 0, 0],
          );
          expect(
            ColorConverter.color2rgb(color6),
            [255, 255, 255],
          );
          expect(
            ColorConverter.color2rgb(color7),
            [138, 72, 136],
          );
        },
      );

      test(
        "hsv",
        () {
          expect(
            ColorConverter.color2hsv(color1),
            [0.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.color2hsv(color2),
            [120.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.color2hsv(color3),
            [240.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.color2hsv(color4),
            [0.0, 0.0, 0.5019607843137255],
          );
          expect(
            ColorConverter.color2hsv(color5),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.color2hsv(color6),
            [0.0, 0.0, 1.0],
          );
          expect(
            ColorConverter.color2hsv(color7),
            [302.0, 0.47826086956521735, 0.5411764705882353],
          );
        },
      );

      test(
        "hex",
        () {
          expect(
            ColorConverter.color2hex(color1),
            "ffff0000",
          );
          expect(
            ColorConverter.color2hex(color2),
            "ff00ff00",
          );
          expect(
            ColorConverter.color2hex(color3),
            "ff0000ff",
          );
          expect(
            ColorConverter.color2hex(color4),
            "ff808080",
          );
          expect(
            ColorConverter.color2hex(color5),
            "ff000000",
          );
          expect(
            ColorConverter.color2hex(color6),
            "ffffffff",
          );
          expect(
            ColorConverter.color2hex(color7),
            "ff8a4888",
          );
        },
      );

      test(
        "hsl",
        () {
          expect(
            ColorConverter.color2hsl(color1),
            [0.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.color2hsl(color2),
            [120.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.color2hsl(color3),
            [240.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.color2hsl(color4),
            [0.0, 0.0, 0.5019607843137255],
          );
          expect(
            ColorConverter.color2hsl(color5),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.color2hsl(color6),
            [0.0, 0.0, 1.0],
          );
          expect(
            ColorConverter.color2hsl(color7),
            [302.0, 0.3142857142857143, 0.4117647058823529],
          );
        },
      );

      test(
        "int",
        () {
          expect(
            ColorConverter.color2int(color1),
            4294901760,
          );
          expect(
            ColorConverter.color2int(color2),
            4278255360,
          );
          expect(
            ColorConverter.color2int(color3),
            4278190335,
          );
          expect(
            ColorConverter.color2int(color4),
            4286611584,
          );
          expect(
            ColorConverter.color2int(color5),
            4278190080,
          );
          expect(
            ColorConverter.color2int(color6),
            4294967295,
          );
          expect(
            ColorConverter.color2int(color7),
            4287252616,
          );
        },
      );

      group(
        "extensions",
        () {
          test(
            "xy",
            () {
              expect(
                color1.toXy(),
                [0.6400744994567747, 0.32997051063169336, 0.2126],
              );
              expect(
                color2.toXy(),
                [0.3, 0.6, 0.7152],
              );
              expect(
                color3.toXy(),
                [0.1500166223404255, 0.060006648936170214, 0.0722],
              );
              expect(
                color4.toXy(),
                [0.3127159072215825, 0.3290014805066622, 0.21586050011389923],
              );
              expect(
                color5.toXy(),
                [0.0, 0.0, 0.0],
              );
              expect(
                color6.toXy(),
                [0.3127159072215825, 0.3290014805066623, 1.0],
              );
              expect(
                color7.toXy(),
                [0.3209554122773742, 0.21993715851681886, 0.1181557673818057],
              );
            },
          );

          test(
            "rgb",
            () {
              expect(
                color1.toRgb(),
                [255, 0, 0],
              );
              expect(
                color2.toRgb(),
                [0, 255, 0],
              );
              expect(
                color3.toRgb(),
                [0, 0, 255],
              );
              expect(
                color4.toRgb(),
                [128, 128, 128],
              );
              expect(
                color5.toRgb(),
                [0, 0, 0],
              );
              expect(
                color6.toRgb(),
                [255, 255, 255],
              );
              expect(
                color7.toRgb(),
                [138, 72, 136],
              );
            },
          );

          test(
            "hsv",
            () {
              expect(
                color1.toHsv(),
                [0.0, 1.0, 1.0],
              );
              expect(
                color2.toHsv(),
                [120.0, 1.0, 1.0],
              );
              expect(
                color3.toHsv(),
                [240.0, 1.0, 1.0],
              );
              expect(
                color4.toHsv(),
                [0.0, 0.0, 0.5019607843137255],
              );
              expect(
                color5.toHsv(),
                [0.0, 0.0, 0.0],
              );
              expect(
                color6.toHsv(),
                [0.0, 0.0, 1.0],
              );
              expect(
                color7.toHsv(),
                [302.0, 0.47826086956521735, 0.5411764705882353],
              );
            },
          );

          test(
            "hex",
            () {
              expect(
                color1.toHex(),
                "ffff0000",
              );
              expect(
                color2.toHex(),
                "ff00ff00",
              );
              expect(
                color3.toHex(),
                "ff0000ff",
              );
              expect(
                color4.toHex(),
                "ff808080",
              );
              expect(
                color5.toHex(),
                "ff000000",
              );
              expect(
                color6.toHex(),
                "ffffffff",
              );
              expect(
                color7.toHex(),
                "ff8a4888",
              );
            },
          );

          test(
            "hsl",
            () {
              expect(
                color1.toHsl(),
                [0.0, 1.0, 0.5],
              );
              expect(
                color2.toHsl(),
                [120.0, 1.0, 0.5],
              );
              expect(
                color3.toHsl(),
                [240.0, 1.0, 0.5],
              );
              expect(
                color4.toHsl(),
                [0.0, 0.0, 0.5019607843137255],
              );
              expect(
                color5.toHsl(),
                [0.0, 0.0, 0.0],
              );
              expect(
                color6.toHsl(),
                [0.0, 0.0, 1.0],
              );
              expect(
                color7.toHsl(),
                [302.0, 0.3142857142857143, 0.4117647058823529],
              );
            },
          );

          test(
            "int",
            () {
              expect(
                color1.toInt(),
                4294901760,
              );
              expect(
                color2.toInt(),
                4278255360,
              );
              expect(
                color3.toInt(),
                4278190335,
              );
              expect(
                color4.toInt(),
                4286611584,
              );
              expect(
                color5.toInt(),
                4278190080,
              );
              expect(
                color6.toInt(),
                4294967295,
              );
              expect(
                color7.toInt(),
                4287252616,
              );
            },
          );
        },
      );
    },
  );

  group(
    "int to",
    () {
      const int int1 = 4294901760;
      const int int2 = 4278255360;
      const int int3 = 4278190335;
      const int int4 = 4286611584;
      const int int5 = 4278190080;
      const int int6 = 4294967295;
      const int int7 = 4287252616;

      test(
        "xy",
        () {
          expect(
            ColorConverter.int2xy(int1),
            [0.6400744994567747, 0.32997051063169336, 0.2126],
          );
          expect(
            ColorConverter.int2xy(int2),
            [0.3, 0.6, 0.7152],
          );
          expect(
            ColorConverter.int2xy(int3),
            [0.1500166223404255, 0.060006648936170214, 0.0722],
          );
          expect(
            ColorConverter.int2xy(int4),
            [0.3127159072215825, 0.3290014805066622, 0.21586050011389923],
          );
          expect(
            ColorConverter.int2xy(int5),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.int2xy(int6),
            [0.3127159072215825, 0.3290014805066623, 1.0],
          );
          expect(
            ColorConverter.int2xy(int7),
            [0.3209554122773742, 0.21993715851681886, 0.1181557673818057],
          );
        },
      );

      test(
        "rgb",
        () {
          expect(
            ColorConverter.int2rgb(int1),
            [255, 0, 0],
          );
          expect(
            ColorConverter.int2rgb(int2),
            [0, 255, 0],
          );
          expect(
            ColorConverter.int2rgb(int3),
            [0, 0, 255],
          );
          expect(
            ColorConverter.int2rgb(int4),
            [128, 128, 128],
          );
          expect(
            ColorConverter.int2rgb(int5),
            [0, 0, 0],
          );
          expect(
            ColorConverter.int2rgb(int6),
            [255, 255, 255],
          );
          expect(
            ColorConverter.int2rgb(int7),
            [138, 72, 136],
          );
        },
      );

      test(
        "hsv",
        () {
          expect(
            ColorConverter.int2hsv(int1),
            [0.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.int2hsv(int2),
            [120.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.int2hsv(int3),
            [240.0, 1.0, 1.0],
          );
          expect(
            ColorConverter.int2hsv(int4),
            [0.0, 0.0, 0.5019607843137255],
          );
          expect(
            ColorConverter.int2hsv(int5),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.int2hsv(int6),
            [0.0, 0.0, 1.0],
          );
          expect(
            ColorConverter.int2hsv(int7),
            [302.0, 0.47826086956521735, 0.5411764705882353],
          );
        },
      );

      test(
        "hex",
        () {
          expect(
            ColorConverter.int2hex(int1),
            "ffff0000",
          );
          expect(
            ColorConverter.int2hex(int2),
            "ff00ff00",
          );
          expect(
            ColorConverter.int2hex(int3),
            "ff0000ff",
          );
          expect(
            ColorConverter.int2hex(int4),
            "ff808080",
          );
          expect(
            ColorConverter.int2hex(int5),
            "ff000000",
          );
          expect(
            ColorConverter.int2hex(int6),
            "ffffffff",
          );
          expect(
            ColorConverter.int2hex(int7),
            "ff8a4888",
          );
        },
      );

      test(
        "hsl",
        () {
          expect(
            ColorConverter.int2hsl(int1),
            [0.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.int2hsl(int2),
            [120.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.int2hsl(int3),
            [240.0, 1.0, 0.5],
          );
          expect(
            ColorConverter.int2hsl(int4),
            [0.0, 0.0, 0.5019607843137255],
          );
          expect(
            ColorConverter.int2hsl(int5),
            [0.0, 0.0, 0.0],
          );
          expect(
            ColorConverter.int2hsl(int6),
            [0.0, 0.0, 1.0],
          );
          expect(
            ColorConverter.int2hsl(int7),
            [302.0, 0.3142857142857143, 0.4117647058823529],
          );
        },
      );

      test(
        "color",
        () {
          expect(
            ColorConverter.int2color(int1),
            const Color(0xffff0000),
          );
          expect(
            ColorConverter.int2color(int2),
            const Color(0xff00ff00),
          );
          expect(
            ColorConverter.int2color(int3),
            const Color(0xff0000ff),
          );
          expect(
            ColorConverter.int2color(int4),
            const Color(0xff808080),
          );
          expect(
            ColorConverter.int2color(int5),
            const Color(0xff000000),
          );
          expect(
            ColorConverter.int2color(int6),
            const Color(0xffffffff),
          );
          expect(
            ColorConverter.int2color(int7),
            const Color(0xff8a4888),
          );
        },
      );
    },
  );
}
