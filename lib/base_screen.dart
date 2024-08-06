import 'package:flutter/material.dart';

import 'core.dart';

abstract class BaseScreenState<S extends StatefulWidget> extends BaseState<S> {
  Future<bool> onBackPressed(BuildContext context) async {
    context.popScreen();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    CrashlyticsLogger.logError(runtimeType.toString());
    return PopScope(
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final r = await onBackPressed(context);
          if (r && mounted) {
            context.popScreen();
          }
        },
        canPop: false,
        child: onBuild(context));
  }

  Widget onBuild(BuildContext context);
}

abstract class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  Future<bool> onBackPressed(BuildContext context) async {
    context.valid?.popScreen();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    CrashlyticsLogger.logError(runtimeType.toString());
    // return PopScope(
    //     canPop: false,
    //     onPopInvoked: (didPop) async {
    //       if (didPop) return;
    //       final r = await onBackPressed(context);
    //       if (r && !context.mounted) {
    //         context.popScreen();
    //       }
    //     },
    //     child: onBuild(context));

    return onBuild(context);
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
