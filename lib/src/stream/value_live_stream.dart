import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../live_stream.dart';


class ValueLiveStream<State> extends StreamBase<State> {
  late BehaviorSubject<State> _syncStream;

  ValueLiveStream({bool sync = false, State? seedValue}) {
    if (seedValue == null) _syncStream = BehaviorSubject<State>(sync: sync);
    _syncStream = BehaviorSubject<State>.seeded(seedValue as State, sync: sync);
  }

  @override
  Stream<State> get stream => _syncStream.stream;

  StreamSink<State?> get _streamSink => _syncStream.sink;

  /// Whether the ValueStream is closed.
  ///
  /// A ValueStream is considered closed once [close] is called.
  /// Subsequent state changes cannot occur within a closed ValueStream.
  bool get isClosed => _syncStream.isClosed;

  State? get state => _syncStream.stream.value;

  /// update state of current value stream.
  void update(State? state) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      _streamSink.add(state);
    } catch (error) {
      rethrow;
    }
  }

  /// Closes the instance.
  /// This method should be called when the instance is no longer needed.
  /// Once [close] is called, the instance can no longer be used.
  @override
  void onClose() {
    if (!_syncStream.isClosed) {
      _syncStream.close();
    }
  }
}
