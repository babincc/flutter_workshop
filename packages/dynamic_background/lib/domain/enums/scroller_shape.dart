/// The shapes that will be scrolling across the screen.
enum ScrollerShape {
  /// The shapes will be circles.
  circles,

  /// The shapes will be diamonds.
  diamonds,

  /// The shapes will be squares.
  squares,

  /// The shapes will be stripes.
  ///
  /// These will be vertical stripes if the direction is left2Right or
  /// right2Left, and horizontal stripes if the direction is top2Bottom or
  /// bottom2Top.
  stripes,

  /// The shapes will be diagonal stripes, leaning backward.
  ///
  /// This is like a backslash `\`.
  stripesDiagonalBackward,

  /// The shapes will be diagonal stripes, leaning forward.
  ///
  /// This is like a forward slash `/`.
  stripesDiagonalForward;
}
