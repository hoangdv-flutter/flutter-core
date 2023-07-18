import 'package:flutter/material.dart';
import 'package:flutter_core/ext/context.dart';
import 'package:flutter_core/util/crash_log.dart';


abstract class BaseScreenState<S extends StatefulWidget> extends State<S> {
  Future<bool> onBackPressed(BuildContext context) async {
    // if (ModalRoute.of(context)?.settings.name == runtimeType.toString()) {
    //   context.popScreen();
    //   return false;
    // }
    context.popScreen();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    CrashlyticsLogger.logError(runtimeType.toString());
    return WillPopScope(
        onWillPop: () {
          return onBackPressed(context);
        },
        child: onBuild(context));
  }

  Widget onBuild(BuildContext context);
}

abstract class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  Future<bool> onBackPressed(BuildContext context) async {
    // if (ModalRoute.of(context)?.settings.name == runtimeType.toString()) {
    //   context.popScreen();
    //   return false;
    // }
    context.valid?.popScreen();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    CrashlyticsLogger.logError(runtimeType.toString());
    return WillPopScope(
        onWillPop: () {
          return onBackPressed(context);
        },
        child: onBuild(context));
  }

  Widget onBuild(BuildContext context);
}

class ScreenTemplate extends StatelessWidget {
  final Widget child;

  final List<Widget> additionBackground;

  const ScreenTemplate(
      {Key? key, required this.child, this.additionBackground = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ...additionBackground,
      SafeArea(child: child),
    ]);
  }
}
