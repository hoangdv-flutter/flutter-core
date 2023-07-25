import 'package:flutter/services.dart';

setSystemUIColor(Color color,
    {SystemUiOverlayStyle theme = SystemUiOverlayStyle.dark}) {
  SystemChrome.setSystemUIOverlayStyle(theme.copyWith(
      statusBarColor: color,
      systemNavigationBarColor: color,
      systemNavigationBarDividerColor: color));
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,
    ],
  );
}