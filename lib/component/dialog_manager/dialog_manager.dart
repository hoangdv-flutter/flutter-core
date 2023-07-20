import 'package:flutter/material.dart';
import 'package:flutter_core/component/dialog_manager/dialog_window.dart';

class DialogManager {
  static Future<T> showDialogWindow<T>(
      {required BuildContext context, required Widget dialogContent}) async {
    return await showDialog(
      context: context,
      builder: (context) => DialogWindow(child: dialogContent),
    );
  }
}
