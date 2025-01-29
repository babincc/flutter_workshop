/// The behavior of the fader.
enum FaderBehavior {
  /// The colors will cycle in the order they were set when the
  /// [FaderPainterData] object was initiated.
  specifiedOrder,

  /// The colors will be sorted and cycle in the order of the sorted list.
  sortedOrder,

  /// The colors will be sorted in reverse and cycle in the order of the
  /// reverse sorted list.
  reverseSortedOrder,

  /// The colors will cycle randomly, like a playlist on shuffle.
  random,

  /// The colors will cycle in such a way to imitate breathing.
  breathe,

  /// The colors will cycle in such a way to imitate a heartbeat.
  pulse;
}
