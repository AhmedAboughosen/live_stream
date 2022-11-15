import 'dart:async';

import 'package:live_stream/src/state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_bloc/src/stream_base.dart';

/// {@template SyncLiveStream}
/// A [SyncLiveStream] is similar to [Cubit] but has no notion of State class
/// and relies on methods to [emit] new states.
///

/// The current state of a [Cubit] can be accessed via the [state] getter.
///
/// ```dart
/// class CounterCubit extends Cubit<int> {
///   CounterCubit() : super(0);
///
///   void increment() => emit(state + 1);
/// }
/// ```
///
/// {@endtemplate}
class SyncLiveStream<T> extends StreamBase<State<T>> {
  late BehaviorSubject<State<T>> _syncStream;

  SyncLiveStream({bool sync = false}) {
    _syncStream = BehaviorSubject<State<T>>(sync: sync);
  }

  @override
  ValueStream<State<T>> get listener => _syncStream.stream;

  StreamSink<State<T>> get streamSink => _syncStream.sink;

  /// Whether the SyncLiveStream is closed.
  ///
  /// A SyncLiveStream is considered closed once [close] is called.
  /// Subsequent state changes cannot occur within a closed SyncLiveStream.
  @override
  bool get isClosed => _syncStream.isClosed;

  /// Updates the [state] to the provided [state].
  ///
  /// To allow for the possibility of notifying listeners of the initial state,
  /// emitting a state which is equal to the initial state is allowed as long
  /// as it is the first thing emitted by the instance.
  ///
  /// * Throws a [StateError] if the SyncLiveStream is closed.
  ValueStream<State<T>> emit(Stream<T> localStream) {
    try {
      if (isClosed) {
        throw StateError('Cannot emit new states after calling close');
      }

      localStream.doOnListen(() {
        streamSink.add(OnLoading());
      });

      localStream.listen((event) {
        streamSink.add(OnData<T>(content: event));
      });

      localStream.doOnError((error, stacktrace) {
        return streamSink.add(OnError<T>(messages: error));
      });
    } catch (error, stackTrace) {
      streamSink.add(OnError<T>(messages: error));
    }
    return listener;
  }

  ValueStream<State<T>> addError(Object error) {
    try {
      if (isClosed) {
        throw StateError('Cannot emit new states after calling close');
      }

      streamSink.add(OnError<T>(messages: error));
    } catch (error) {
      streamSink.add(OnError<T>(messages: error));
    }
    return listener;
  }

  ValueStream<State<T>> addNewState(T? state) {
    try {
      if (isClosed) {
        throw StateError('Cannot emit new states after calling close');
      }

      streamSink.add(OnData<T>(content: state));
    } catch (error) {
      streamSink.add(OnError<T>(messages: error));
    }
    return listener;
  }

  ValueStream<State<T>> onLoading() {
    try {
      if (isClosed) {
        throw StateError('Cannot emit new states after calling close');
      }

      streamSink.add(OnLoading<T>());
    } catch (error) {
      streamSink.add(OnError<T>(messages: error));
    }
    return listener;
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
