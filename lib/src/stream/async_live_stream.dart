import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../live_stream.dart';


class AsyncLiveStream<State extends Object?> extends StreamBase<State> {
  late BehaviorSubject<AsyncState<State>> _asyncStream;

  AsyncLiveStream({bool sync = false, State? seedValue}) {
    _asyncStream = BehaviorSubject<AsyncState<State>>.seeded(
        seedValue == null ? Pure() : OnData(content: seedValue),
        sync: sync);
  }

  @override
  Stream<AsyncState<State>> get stream => _asyncStream.stream;

  StreamSink<AsyncState<State>> get _streamSink => _asyncStream.sink;

  /// Whether the SyncLiveStream is closed.
  ///
  /// A SyncLiveStream is considered closed once [close] is called.
  /// Subsequent state changes cannot occur within a closed SyncLiveStream.
  bool get isClosed => _asyncStream.isClosed;

  AsyncState<State> get state => _asyncStream.stream.value;

  /// Updates the [state] to the provided [state].
  ///this  method  will emit [state] on Loading  when listen to local stream then emit [state] on Error or on Date based on Stream
  ///first
  /// To allow for the possibility of notifying listeners of the initial state,
  /// emitting a state which is equal to the initial state is allowed as long
  /// as it is the first thing emitted by the instance.
  ///return [stream] to handle [error] or [state] if have.
  /// * Throws a [StateError] if the LiveStream is closed.
  Stream<AsyncState<State>> emit(Stream<State> localStream) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {

      localStream.doOnListen(() {
        _streamSink.add(OnLoading());
      }).listen(null);

      localStream.listen((event) {
        _streamSink.add(OnData(content: event));
      }, onError: (error) {
        _addError(error);
      });
    } catch (error, stackStaterace) {
      _addError(error);
      rethrow;
    }
    return stream;
  }

  /// Reports an [error] which triggers [onError] with an optional [StackTrace].
  Stream<AsyncState<State>> addError(Object error) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      _addError(error);
    } catch (error) {
      _addError(error);
      rethrow;
    }
    return stream;
  }

  /// Reports an [state] which triggers [onData].
  Stream<AsyncState<State>> add(State? state) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      _streamSink.add(OnData(content: state));
    } catch (error) {
      _addError(error);
      rethrow;
    }
    return stream;
  }

  /// Reports an [state] which triggers [onLoading].
  Stream<AsyncState<State>> loading() {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      _streamSink.add(OnLoading());
    } catch (error) {
      _addError(error);
      rethrow;
    }
    return stream;
  }

  void _addError(Object error) {
    _streamSink.addError(OnError(messages: error));
  }

  /// Closes the instance.
  /// This method should be called when the instance is no longer needed.
  /// Once [close] is called, the instance can no longer be used.
  @override
  void onClose() {
    if (!_asyncStream.isClosed) {
      _asyncStream.close();
    }
  }
}
