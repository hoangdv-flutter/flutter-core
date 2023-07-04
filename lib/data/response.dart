class Response<T> {
  final T? value;

  final Object? exception;

  bool get isSuccess => value != null;

  Response.success(this.value) : exception = null;

  Response.failed(this.exception) : value = null;

}
