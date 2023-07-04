import 'package:flutter/cupertino.dart';
import 'package:flutter_core/base_stateful.dart';
import 'package:flutter_core/ext/context.dart';

mixin BaseDialog {}

abstract class BaseDialogStateless extends StatelessWidget with BaseDialog {
  final BuildContext rootContext;

  const BaseDialogStateless({super.key, required this.rootContext});

  dismiss<T>({T? result, bool ignoreAds = true}) {
    rootContext.popScreen(result: result);
  }

  dismissDialog<T>({T? result, bool ignoreAds = true}) {
    rootContext.popScreen(result: result);
  }
}

abstract class BaseDialogStateful extends StatefulWidget with BaseDialog {
  final BuildContext? rootContext;

  const BaseDialogStateful({super.key, this.rootContext});
}

abstract class DialogState<D extends BaseDialogStateful> extends BaseState<D> {
  @protected
  var available = true;

  dismiss<T>({T? result, bool ignoreAds = true}) {
    if (!available || !context.mounted) return;
    available = false;
    // DialogManager.dismissDialogWindow(ignoreAds: ignoreAds);
    context.popScreen(result: result);
  }

  dismissDialog<T>({T? result, bool ignoreAds = true}) {
    if (!available || !context.mounted) return;
    available = false;
    context.popScreen(result: result);
  }
}
