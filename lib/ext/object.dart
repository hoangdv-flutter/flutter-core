extension ObjectExt<T extends Object> on T {
  T? takeIf({required bool Function(T value) condition}) {
    if (condition(this)) {
      return this;
    }
    return null;
  }

  T also({required Function(T value) call}) {
    call(this);
    return this;
  }

  K let<K>({required K Function(T value) call}) {
    return call(this);
  }
}
