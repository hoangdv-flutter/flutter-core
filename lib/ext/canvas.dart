part of 'exts.dart';

extension RectExt on Rect {
  bool containsRect(Rect other) {
    return other.right < right &&
        other.left > left &&
        other.top > top &&
        other.bottom < bottom;
  }
}

extension OffsetExt on Offset {
  double angleWith(Offset other) {
    return acos((dx * other.dx + dy * other.dy) / (distance * other.distance));
  }

  Offset rotate(double radians) {
    final cosV = cos(radians);
    final sinV = sin(radians);
    return Offset(cosV * dx - sinV * dy, sinV * dx + cosV * dy);
  }
}
