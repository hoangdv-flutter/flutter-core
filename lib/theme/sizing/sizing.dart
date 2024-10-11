import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_core/core.dart';

part 'device.dart';

class Sizing {
  Sizing._();

  static var screenWidth = .0;
  static var screenHeight = .0;
  static var pixelRatio = 1.0;
  static var aspectRatio = 1.0;

  static init(BuildContext context) {
    MediaQuery.of(context).let(call: (value) {
      screenWidth = value.size.width;
      screenHeight = value.size.height;
      pixelRatio = value.devicePixelRatio;
      aspectRatio =
          min(screenWidth, screenHeight) / max(screenWidth, screenHeight);
    });
  }
}

extension SizingExt on num {
  double get w => Sizing.screenWidth * this / 100;
  double get h => Sizing.screenHeight * this / 100;
  double get p => min(Sizing.screenHeight, Sizing.screenWidth) * this / 100;
  double get sp =>
      this *
      (((h + w) + (Sizing.pixelRatio * Sizing.aspectRatio)) / 2.08) /
      100;
}
