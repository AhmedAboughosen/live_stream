enum Status { error, success, none }

class StreamState<T> {
  final T? state;
  final Object? error;

  StreamState({
    this.state,
    this.error,
  });

  Status currentState() => state == null
      ? Status.error
      : error == null
          ? Status.success
          : Status.none;
}
