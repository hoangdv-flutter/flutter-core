part of 'exts.dart';

extension ContextExt on BuildContext {
  Future<dynamic> pushDialog(Widget widget) async {
    await Navigator.push(
        this,
        PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                widget));
  }

  Future<dynamic> pushScreen<T>(Route<T> route,
      {bool isReplacement = false}) async {
    final completer = Completer<dynamic>();
    try {
      final r = isReplacement
          ? await Navigator.pushReplacement(this, route)
          : await Navigator.push(this, route);
      completer.complete(r);
    } catch (e) {
      completer.complete(Response.failed(e));
    }
    return await completer.future;
  }

  popScreen<T extends Object?>({T? result}) async {
    try {
      if (Navigator.canPop(this)) {
        Navigator.pop(this, result);
      }
    } catch (e) {
      debugPrint("popScreen ${e.toString()}");
    }
  }

  Offset get globalPosition {
    RenderBox renderBox = findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size get renderSize {
    final renderBox = findRenderObject() as RenderBox?;
    return renderBox?.size ?? Size.zero;
  }

  RelativeRect get widgetGlobalPosition {
    RenderBox renderBox = findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    Rect rect = Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
    return RelativeRect.fromSize(rect, renderBox.size);
  }

  BuildContext? get valid => takeIf(
        condition: (p0) => p0.mounted,
      );

  bool get available => valid != null;

  void showSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

  T? argument<T>() {
    final arg = ModalRoute.of(this)?.settings.arguments;
    if (arg is T) {
      return arg;
    }
    return null;
  }
}
