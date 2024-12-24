part of 'exts.dart';

extension DoubleExt on double {
  double surroundWithRange(double minNum, double maxNum) {
    return max(minNum, min(maxNum, this));
  }
}
