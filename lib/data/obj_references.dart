class ObjectReference<T> {
  T? value;

  ObjectReference(this.value);

  void clearReferences() => value = null;
}
