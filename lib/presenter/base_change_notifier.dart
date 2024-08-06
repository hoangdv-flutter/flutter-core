part of 'presenter.dart';

class BaseChangeNotifier extends ChangeNotifier {
  @protected
  bool disposed = false;

  @override
  void dispose() {
    debugPrint("disposed $runtimeType");
    disposed = true;
    super.dispose();
  }
}
