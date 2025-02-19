import 'package:flutter_hue/flutter_hue.dart';

/// This class contains the pre-programmed commands for the song "Back in Black"
/// by AC/DC.
class BackInBlack {
  static List<EntertainmentStreamCommand> get commands => [
        ..._getDrums(),
        ..._getGuitar(),
        ..._getVocals(),
      ];

  static const int _drumsChannel = 0;
  static const int _guitarChannel1 = 1;
  static const int _guitarChannel2 = 3;
  static const int _vocalsChannel = 2;

  static List<EntertainmentStreamCommand> _getDrums() {
    int timeMillis = 0;
    int durationMillis = 0;

    final List<EntertainmentStreamCommand> commands = [];

    durationMillis = 100 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 300 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 0.3),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 800 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 950 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 0.3),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 1450 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 1650 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 0.3),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 2150 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 2300 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 0.3),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 2800 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 3000 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 0.3),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 3500 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 3650 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 0.3),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 4150 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 4300 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 0.1),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 4825 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 4975 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 0.1),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 5465 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 6145 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 6450 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 6815 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 7100 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 7450 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 7775 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 8100 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 8450 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 8775 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 9150 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 9450 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 9650 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 10115 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 10400 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 10750 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 11050 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 11425 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 11650 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 12075 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 12350 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 12750 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 13050 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 13425 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 13650 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 14075 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 14250 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 14560 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 14750 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 15050 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 15250 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 15525 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 15690 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 16025 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 16325 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 16650 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 16975 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 17325 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 17550 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 17975 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 18300 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 18650 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 18900 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 19315 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 19650 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 19975 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 20150 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 20650 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 20850 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 21275 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 21550 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 21975 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 22300 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 22650 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 22925 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 23325 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 23625 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 23985 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 24250 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 24670 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 24845 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 25150 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 25325 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 25625 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 25815 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 26110 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 26250 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 26575 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 26850 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    durationMillis = 27250 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: ColorXy.fromRgb(255, 255, 255, 1.0),
      ),
    );

    durationMillis = 27855 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _drumsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    return commands;
  }

  static List<EntertainmentStreamCommand> _getGuitar() {
    int timeMillis1 = 0;
    int durationMillis1 = 0;
    int timeMillis2 = 0;
    int durationMillis2 = 0;

    final List<EntertainmentStreamCommand> commands = [];

    durationMillis1 = 5475 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 5475 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 6450 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 6450 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 6800 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 6800 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 7775 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 7775 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 8115 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 8115 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 9650 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 9800 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 9970 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 10175 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 10300 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 10300 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 10615 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 10615 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 10765 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 10765 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 11755 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 11755 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 12100 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 12100 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 13075 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 13075 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 13440 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 13440 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 14065 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 14250 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 14555 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 14750 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 15065 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 15250 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 15550 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 15700 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 16030 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 16030 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 16990 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 16990 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 17350 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 17350 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 18315 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 18315 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 18650 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 18650 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 20150 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 20350 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 20545 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 20650 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 20850 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 20850 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 21025 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 21025 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 0.5),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 21325 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 21325 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 22315 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 22315 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 22660 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 22660 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 23650 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 23650 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 24000 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 24000 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 24650 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 24850 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 25150 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 25325 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 25645 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 25815 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 26115 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 26250 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 26615 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 26615 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 27550 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 27550 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: ColorXy.fromRgb(31, 17, 158, 1.0),
      ),
    );

    durationMillis1 = 27855 - timeMillis1;
    timeMillis1 += durationMillis1;
    durationMillis2 = 27855 - timeMillis2;
    timeMillis2 += durationMillis2;

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel1,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis1),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _guitarChannel2,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis2),
      ),
    );

    return commands;
  }

  static List<EntertainmentStreamCommand> _getVocals() {
    int timeMillis = 0;
    int durationMillis = 0;

    final List<EntertainmentStreamCommand> commands = [];

    durationMillis = 26575 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _vocalsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        waitAfterAnimation: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _vocalsChannel,
        color: ColorXy.fromRgb(55, 139, 184, 1.0),
      ),
    );

    durationMillis = 26775 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _vocalsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _vocalsChannel,
        color: ColorXy.fromRgb(55, 139, 184, 1.0),
      ),
    );

    durationMillis = 27145 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _vocalsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    commands.add(
      EntertainmentStreamCommand(
        channel: _vocalsChannel,
        color: ColorXy.fromRgb(55, 139, 184, 1.0),
      ),
    );

    durationMillis = 27855 - timeMillis;
    timeMillis += durationMillis;

    commands.add(
      EntertainmentStreamCommand(
        channel: _vocalsChannel,
        color: const ColorXy(0.0, 0.0, 0.0),
        animationType: AnimationType.ease,
        animationDuration: Duration(milliseconds: durationMillis),
      ),
    );

    return commands;
  }
}
