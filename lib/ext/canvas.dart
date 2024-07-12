part of 'exts.dart';

extension RectExt on Rect {
  bool containsRect(Rect other) {
    return other.right < right &&
        other.left > left &&
        other.top > top &&
        other.bottom < bottom;
  }
}
