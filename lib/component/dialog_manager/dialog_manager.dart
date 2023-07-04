import 'package:flutter/material.dart';
import 'package:flutter_core/component/dialog_manager/dialog_window.dart';

class DialogManager {
  static Future<void> showDialogWindow(
      {required BuildContext context, required Widget dialogContent}) async {
    await showDialog(
      context: context,
      builder: (context) => DialogWindow(child: dialogContent),
    );
  }
}
