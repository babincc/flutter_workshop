enum WaveGravityDirection {
  /// This makes the space below the sine wave be considered the bottom of the
  /// wave.
  ///
  /// This means, the space below the sine wave will be colored with the color
  /// of the wave.
  down,

  /// This makes the space above the sine wave be considered the bottom of the
  /// wave.
  ///
  /// This means, the space above the sine wave will be colored with the color
  /// of the wave.
  up,

  /// This makes the space to the left of the sine wave be considered the bottom
  /// of the wave.
  ///
  /// This means, the space to the left of the sine wave will be colored with
  /// the color of the wave.
  left,

  /// This makes the space to the right of the sine wave be considered the
  /// bottom of the wave.
  ///
  /// This means, the space to the right of the sine wave will be colored with
  /// the color of the wave.
  right;
}
