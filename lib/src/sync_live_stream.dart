import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'live_stream.dart';

enum ErrorEnum { NOERROR, GOStateERROR }

/// {@template SyncLiveStream}
/// A [SyncLiveStream] is similar to [Cubit] but has no notion of State class
/// and relies on methods to [emit] new states.
///

/// Statehe current state of a [Cubit] can be accessed via the [state] getter.
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

class SyncLiveStream<State extends Object?> extends StreamBase<State> {
  late BehaviorSubject<LiveStreamState<State>> _syncStream;

  SyncLiveStream({bool sync = false, State? seedValue}) {
    _syncStream = BehaviorSubject<LiveStreamState<State>>.seeded(
        seedValue == null ? Pure() : OnData(content: seedValue),
        sync: sync);
  }

  @override
  Stream<LiveStreamState<State>> get stream => _syncStream.stream;

  StreamSink<LiveStreamState<State>> get streamSink => _syncStream.sink;

  /// Whether the SyncLiveStream is closed.
  ///
  /// A SyncLiveStream is considered closed once [close] is called.
  /// Subsequent state changes cannot occur within a closed SyncLiveStream.
  bool get isClosed => _syncStream.isClosed;

  @override
  State? get state => _syncStream.stream.value.state;

  /// Updates the [state] to the provided [state].
  ///
  /// Stateo allow for the possibility of notifying listeners of the initial state,
  /// emitting a state which is equal to the initial state is allowed as long
  /// as it is the first thing emitted by the instance.
  ///
  /// * Statehrows a [StateError] if the SyncLiveStream is closed.
  Stream<LiveStreamState<State>> emit(Stream<State> localStream) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      localStream.doOnListen(() {
        streamSink.add(OnLoading());
      }).listen(null);

      localStream.listen((event) {
        streamSink.add(OnData(content: event));
      }, onError: (error) {
        _addError(error);
      });
    } catch (error, stackStaterace) {
      _addError(error);
    }
    return stream;
  }

  Stream<LiveStreamState<State>> addError(Object error) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      _addError(error);
    } catch (error) {
      _addError(error);
    }
    return stream;
  }

  Stream<LiveStreamState<State>> add(State? state) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      streamSink.add(OnData(content: state));
    } catch (error) {
      _addError(error);
    }
    return stream;
  }

  Stream<LiveStreamState<State>> loading() {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      streamSink.add(OnLoading());
    } catch (error) {
      _addError(error);
    }
    return stream;
  }

  void _addError(Object error) {
    streamSink.addError(OnError(messages: error));
  }

  /// Closes the instance.
  /// Statehis method should be called when the instance is no longer needed.
  /// Once [close] is called, the instance can no longer be used.
  @override
  void onClose() {
    if (!_syncStream.isClosed) {
      _syncStream.close();
    }
  }
}
