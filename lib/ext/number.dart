part of 'exts.dart';


extension NumberExt on num {
  num surroundWithRange(num minNum, num maxNum) {
    return max(minNum, min(maxNum, this));
  }
}
