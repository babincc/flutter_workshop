import 'package:dynamic_background/utils/math_tools.dart';

enum LavaDirection {
  /// North
  n(90.0),

  /// North-Northeast
  nne(67.5),

  /// Northeast
  ne(45.0),

  /// East-Northeast
  ene(22.5),

  /// East
  e(0.0),

  /// East-Southeast
  ese(337.5),

  /// Southeast
  se(315.0),

  /// South-Southeast
  sse(292.5),

  /// South
  s(270.0),

  /// South-Southwest
  ssw(247.5),

  /// Southwest
  sw(225.0),

  /// West-Southwest
  wsw(202.5),

  /// West
  w(180.0),

  /// West-Northwest
  wnw(157.5),

  /// Northwest
  nw(135.0),

  /// North-Northwest
  nnw(112.5);

  const LavaDirection(this.degrees);

  final double degrees;

  bool get _chooseChaos => randInt(0, 10) >= 8;

  /// Returns the direction to bounce off a wall.
  ///
  /// If `vertical` is `true`, the wall is vertical; otherwise, the wall is
  /// horizontal.
  LavaDirection bounceOffWall(bool vertical) {
    final double newAngle =
        vertical ? (180.0 - degrees) % 360 : (-degrees) % 360;

    final LavaDirection newDirection = LavaDirection.values.firstWhere(
      (dir) => dir.degrees == newAngle,
      orElse: () => opposite,
    );

    if (_chooseChaos) return newDirection._neighbor;

    return newDirection;
  }

  /// Returns the opposite direction of this direction.
  LavaDirection get opposite {
    if (_chooseChaos) return _chaoticOpposite;

    switch (this) {
      case LavaDirection.n:
        return LavaDirection.s;
      case LavaDirection.nne:
        return LavaDirection.ssw;
      case LavaDirection.ne:
        return LavaDirection.sw;
      case LavaDirection.ene:
        return LavaDirection.wsw;
      case LavaDirection.e:
        return LavaDirection.w;
      case LavaDirection.ese:
        return LavaDirection.wnw;
      case LavaDirection.se:
        return LavaDirection.nw;
      case LavaDirection.sse:
        return LavaDirection.nnw;
      case LavaDirection.s:
        return LavaDirection.n;
      case LavaDirection.ssw:
        return LavaDirection.nne;
      case LavaDirection.sw:
        return LavaDirection.ne;
      case LavaDirection.wsw:
        return LavaDirection.ene;
      case LavaDirection.w:
        return LavaDirection.e;
      case LavaDirection.wnw:
        return LavaDirection.ese;
      case LavaDirection.nw:
        return LavaDirection.se;
      case LavaDirection.nnw:
        return LavaDirection.sse;
    }
  }

  LavaDirection get _chaoticOpposite {
    final bool clockwise = randInt(0, 1) == 0;

    switch (this) {
      case LavaDirection.n:
        return clockwise ? LavaDirection.ssw : LavaDirection.sse;
      case LavaDirection.nne:
        return clockwise ? LavaDirection.sw : LavaDirection.s;
      case LavaDirection.ne:
        return clockwise ? LavaDirection.wsw : LavaDirection.ssw;
      case LavaDirection.ene:
        return clockwise ? LavaDirection.w : LavaDirection.sw;
      case LavaDirection.e:
        return clockwise ? LavaDirection.wnw : LavaDirection.wsw;
      case LavaDirection.ese:
        return clockwise ? LavaDirection.nw : LavaDirection.w;
      case LavaDirection.se:
        return clockwise ? LavaDirection.nnw : LavaDirection.wnw;
      case LavaDirection.sse:
        return clockwise ? LavaDirection.n : LavaDirection.nw;
      case LavaDirection.s:
        return clockwise ? LavaDirection.nne : LavaDirection.nnw;
      case LavaDirection.ssw:
        return clockwise ? LavaDirection.ne : LavaDirection.n;
      case LavaDirection.sw:
        return clockwise ? LavaDirection.ene : LavaDirection.nne;
      case LavaDirection.wsw:
        return clockwise ? LavaDirection.e : LavaDirection.ne;
      case LavaDirection.w:
        return clockwise ? LavaDirection.ese : LavaDirection.ene;
      case LavaDirection.wnw:
        return clockwise ? LavaDirection.se : LavaDirection.e;
      case LavaDirection.nw:
        return clockwise ? LavaDirection.sse : LavaDirection.ese;
      case LavaDirection.nnw:
        return clockwise ? LavaDirection.s : LavaDirection.se;
    }
  }

  LavaDirection get _neighbor {
    final bool clockwise = randInt(0, 1) == 0;

    switch (this) {
      case LavaDirection.n:
        return clockwise ? LavaDirection.nne : LavaDirection.nnw;
      case LavaDirection.nne:
        return clockwise ? LavaDirection.ne : LavaDirection.n;
      case LavaDirection.ne:
        return clockwise ? LavaDirection.ene : LavaDirection.nne;
      case LavaDirection.ene:
        return clockwise ? LavaDirection.e : LavaDirection.ne;
      case LavaDirection.e:
        return clockwise ? LavaDirection.ese : LavaDirection.ene;
      case LavaDirection.ese:
        return clockwise ? LavaDirection.se : LavaDirection.e;
      case LavaDirection.se:
        return clockwise ? LavaDirection.sse : LavaDirection.ese;
      case LavaDirection.sse:
        return clockwise ? LavaDirection.s : LavaDirection.se;
      case LavaDirection.s:
        return clockwise ? LavaDirection.ssw : LavaDirection.sse;
      case LavaDirection.ssw:
        return clockwise ? LavaDirection.sw : LavaDirection.s;
      case LavaDirection.sw:
        return clockwise ? LavaDirection.wsw : LavaDirection.ssw;
      case LavaDirection.wsw:
        return clockwise ? LavaDirection.w : LavaDirection.sw;
      case LavaDirection.w:
        return clockwise ? LavaDirection.wnw : LavaDirection.wsw;
      case LavaDirection.wnw:
        return clockwise ? LavaDirection.nw : LavaDirection.w;
      case LavaDirection.nw:
        return clockwise ? LavaDirection.nnw : LavaDirection.wnw;
      case LavaDirection.nnw:
        return clockwise ? LavaDirection.n : LavaDirection.nw;
    }
  }
}
