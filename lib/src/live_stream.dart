import 'package:rxdart/rxdart.dart';

enum Status { error, success, none }

/// A [Streamable] that provides synchronous access to the current [state].
abstract class StateStreamable<State>  {

}



/// An object that provides access to a stream of states over time.
abstract class StreamBase<State extends Object?> {
  void onClose();

  /// The current [stream] of states.
  Stream get stream;

  /// The current [state].
  State? get state;
}


class StreamState<State extends Object> {
  final State? state;
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


abstract class LiveStreamState<State> extends  StateStreamable<State>{
  bool isOnLoading() => this is OnLoading<State>;

  bool isOnData() => this is OnData<State>;

  bool isOnError() => this is OnError<State>;

  State? get state => (this as OnData<State>).content;

  Object get error => (this as OnError<State>).messages;
}

class OnData<State> extends LiveStreamState<State> {
  final State? content;

  OnData({
    this.content,
  });
}

class OnLoading<State> extends LiveStreamState<State> {
  OnLoading();
}


class Pure<State> extends LiveStreamState<State> {
  Pure();
}

class OnError<State> extends LiveStreamState<State> {
  final Object messages;

  OnError({required this.messages});
}
