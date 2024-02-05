abstract class PainterData {
  const PainterData({required this.type});

  final PainterType type;
}

enum PainterType {
  scroller,
  dropper,
  fader,
}
