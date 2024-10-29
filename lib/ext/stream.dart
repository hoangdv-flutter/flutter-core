part of 'exts.dart';

extension StreamExt<T> on StreamController<T> {
  void addSafety(T value) {
    if (!isClosed) {
      add(value);
    }
  }

  void addErrorSafety(Object value, [StackTrace? stackTrace]) {
    if (!isClosed) {
      addError(value, stackTrace);
    }
  }
}

extension BSExt<T> on BehaviorSubject<T> {
  bool addSafety(T newValue, {bool allowDuplicate = false}) {
    final ableToAdd = !isClosed && (newValue != valueOrNull || allowDuplicate);
    if (ableToAdd) {
      sink.add(newValue);
    }
    return ableToAdd;
  }

  void addErrorSafety(Object value, [StackTrace? stackTrace]) {
    if (!isClosed) {
      addError(value, stackTrace);
    }
  }
}
