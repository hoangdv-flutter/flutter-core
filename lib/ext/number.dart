import 'dart:math' as math;

extension NumberExt on num {
  num surroundWithRange(num min, num max) {
    return math.max(min, math.min(max, this));
  }
}
