part of 'presenter.dart';

class BaseChangeNotifier extends ChangeNotifier {
  @protected
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
