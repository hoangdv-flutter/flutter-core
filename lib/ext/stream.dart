import 'dart:async';

import 'package:rxdart/rxdart.dart';

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
  void addSafety(T value) {
    if (!isClosed) {
      sink.add(value);
    }
  }
  void addErrorSafety(Object value, [StackTrace? stackTrace]) {
    if (!isClosed) {
      addError(value, stackTrace);
    }
  }
}
