/// How to align the shapes that will be scrolling.
enum ScrollerShapeOffset {
  /// No offset.
  ///
  /// The shapes will form a perfect grid.
  none,

  /// The shapes will be offset, and form a diagonal grid.
  shift,

  /// Similar to [shift]; however, the shapes will also be moved closer
  /// together along the plane perpendicular to the direction of movement.
  shiftAndMesh;
}
