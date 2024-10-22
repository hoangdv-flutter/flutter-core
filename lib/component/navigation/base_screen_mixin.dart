part of '../base_screen.dart';

mixin BaseScreenMixin {
  bool get canPop => Platform.isIOS;
}
