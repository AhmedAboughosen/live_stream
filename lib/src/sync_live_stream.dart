import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'live_state.dart';
import 'live_stream.dart';

/// Enum representing the status of a form at any given point in time.
enum FormzStatus {
  /// The form has not been touched.
  pure,

  /// The form has been completely validated.
  valid,

  /// The form contains one or more invalid inputs.
  invalid,

  /// The form is in the process of being submitted.
  submissionInProgress,

  /// The form has been submitted successfully.
  submissionSuccess,

  /// The form submission failed.
  submissionFailure,

  /// The form submission has been canceled.
  submissionCanceled
}

enum ErrorEnum { NOERROR, GOTERROR }

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

class SyncLiveStream<T> extends StreamBase<T> {
  late BehaviorSubject<LiveStreamState<T>> _syncStream;

  SyncLiveStream({bool sync = false}) {
    _syncStream = BehaviorSubject<LiveStreamState<T>>(sync: sync);
  }

  @override
  ValueStream<LiveStreamState<T>> get listener => _syncStream.stream;

  StreamSink<LiveStreamState<T>> get streamSink => _syncStream.sink;

  /// Whether the SyncLiveStream is closed.
  ///
  /// A SyncLiveStream is considered closed once [close] is called.
  /// Subsequent state changes cannot occur within a closed SyncLiveStream.
  bool get isClosed => _syncStream.isClosed;

  // @override
  // Object? get error => (_syncStream.errorOrNull == null ||
  //         _syncStream.errorOrNull == ErrorEnum.NOERROR)
  //     ? null
  //     : _syncStream.error;
  //
  // @override
  // bool get hasError => (_syncStream.errorOrNull == null ||
  //     _syncStream.errorOrNull == ErrorEnum.NOERROR);
  //
  // @override
  // bool get hasState => _syncStream.hasValue;
  //
  // @override
  // StreamState<T>? get state => _syncStream.valueOrNull;

  FormzStatus status = FormzStatus.pure;

  void updateStatus(FormzStatus formzStatus) {
    status = formzStatus;
  }

  /// Updates the [state] to the provided [state].
  ///
  /// To allow for the possibility of notifying listeners of the initial state,
  /// emitting a state which is equal to the initial state is allowed as long
  /// as it is the first thing emitted by the instance.
  ///
  /// * Throws a [StateError] if the SyncLiveStream is closed.
  ValueStream<LiveStreamState<T>> emit(Stream<T> localStream) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      streamSink.add(OnLoading());

      localStream.listen((event) {
        streamSink.add(OnData(content: event));
      }, onError: (error) {
        _addError(error);
      });
    } catch (error, stackTrace) {
      _addError(error);
    }
    return listener;
  }


  void _addError(Object error){
    streamSink.addError(OnError(messages: error));
  }

  ValueStream<LiveStreamState<T>> addError(Object error) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      _addError(error);
    } catch (error) {
      _addError(error);
    }
    return listener;
  }

  ValueStream<LiveStreamState<T>> addNewState(T? state) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      streamSink.add(OnData(content: state));
    } catch (error) {
      _addError(error);
    }
    return listener;
  }

  ValueStream<LiveStreamState<T>> onLoading() {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }

    try {
      streamSink.add(OnLoading());
    } catch (error) {
      _addError(error);
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
