import 'package:flutter/material.dart';
import 'package:flutter_core/base_dialog.dart';

class DialogWindow extends BaseDialogStateful {
  final Widget? child;

  const DialogWindow({this.child, Key? key}) : super(key: key);

  @override
  State<DialogWindow> createState() => DialogWindowsState();
}

class DialogWindowsState extends DialogState<DialogWindow> {
  Widget? _child;

  void switchChild(Widget? widget) {
    setState(() {
      _child = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: _child ?? widget.child,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
