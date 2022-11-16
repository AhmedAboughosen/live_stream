


abstract class LiveStreamState<T> {
  bool isOnLoading() => this is OnLoading<T>;

  bool isOnData() => this is OnData<T>;

  bool isOnError() => this is OnError<T>;

  T? get state => (this as OnData<T>).content;

  Object get error => (this as OnError<T>).messages;
}

class OnData<T> extends LiveStreamState<T> {
  final T? content;

  OnData({
    this.content,
  });
}

class OnLoading<T> extends LiveStreamState<T> {
  OnLoading();
}

class OnError<T> extends LiveStreamState<T> {
  final Object messages;

  OnError({required this.messages});
}
