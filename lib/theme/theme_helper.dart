import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setSystemUIColor(Color color,
    {SystemUiOverlayStyle theme = SystemUiOverlayStyle.dark,
    List<SystemUiOverlay>? overlays}) {
  SystemChrome.setSystemUIOverlayStyle(theme.copyWith(
      statusBarColor: color,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarDividerColor: Colors.white));
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: overlays ?? [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
}
