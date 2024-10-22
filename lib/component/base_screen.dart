import 'dart:io';

import 'package:flutter/material.dart';

import '../core.dart';

part 'navigation/base_screen_mixin.dart';

abstract class BaseScreenState<S extends StatefulWidget> extends BaseState<S>
    with BaseScreenMixin {
  Future<bool> onBackPressed(BuildContext context) async {
    context.popScreen();
    return false;
  }

  void onBackPressedIOS() {}

  @override
  Widget build(BuildContext context) {
    CrashlyticsLogger.logError(runtimeType.toString());
    return PopScope(
        onPopInvokedWithResult: (didPop, result) async {
          if (Platform.isIOS && didPop) {
            onBackPressedIOS();
            return;
          }
          if (didPop) return;
          final r = await onBackPressed(context);
          if (r && !context.mounted) {
            context.popScreen();
          }
        },
        canPop: canPop,
        child: onBuild(context));
  }

  Widget onBuild(BuildContext context);
}

abstract class BaseScreen extends StatelessWidget with BaseScreenMixin {
  const BaseScreen({super.key});

  Future<bool> onBackPressed(BuildContext context) async {
    context.valid?.popScreen();
    return false;
  }

  void onBackPressedIOS(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: canPop,
        onPopInvokedWithResult: (didPop, result) async {
          if (Platform.isIOS && didPop) {
            onBackPressedIOS(context);
            return;
          }
          if (didPop) return;
          final r = await onBackPressed(context);
          if (r && !context.mounted) {
            context.popScreen();
          }
        },
        child: onBuild(context));
  }

  Widget onBuild(BuildContext context);
}

class ScreenTemplate extends StatelessWidget {
  final Widget child;

  final List<Widget> additionBackground;

  final Color backgroundColor;

  const ScreenTemplate(
      {Key? key,
      required this.child,
      this.additionBackground = const [],
      this.backgroundColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: Container(
          color: backgroundColor,
        ),
      ),
      ...additionBackground,
      SafeArea(child: child),
    ]);
  }
}
