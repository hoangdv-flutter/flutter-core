import 'dart:ui';

import 'package:flutter_core/theme/color/color_light.dart';

class ColorDark extends ColorLight {
  @override
  Color get colorBlack => const Color(0xFFFFFFFF);

  @override
  Color get colorWhite => const Color(0xFF000000);

  @override
  Color get colorGrey => const Color(0xFFD4D4D4);
}
