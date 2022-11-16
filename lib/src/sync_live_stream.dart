import 'dart:async';

import 'package:live_stream_base/live_stream.dart';
import 'package:rxdart/rxdart.dart';

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
  late BehaviorSubject<T?> _syncStream;

  SyncLiveStream({bool sync = false}) {
    _syncStream = BehaviorSubject<T>(sync: sync);
  }

  @override
  ValueStream<T?> get listener => _syncStream.stream;

  StreamSink<T?> get streamSink => _syncStream.sink;

  /// Whether the SyncLiveStream is closed.
  ///
  /// A SyncLiveStream is considered closed once [close] is called.
  /// Subsequent state changes cannot occur within a closed SyncLiveStream.
  bool get isClosed => _syncStream.isClosed;

  @override
  Object? get error =>
      (_syncStream.errorOrNull == null || _syncStream.errorOrNull == ErrorEnum.NOERROR) ? null : _syncStream.error;

  @override
  bool get hasError =>  (_syncStream.errorOrNull == null || _syncStream.errorOrNull == ErrorEnum.NOERROR) ;

  @override
  bool get hasState => _syncStream.hasValue;

  @override
  T? get state => _syncStream.valueOrNull;

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
  ValueStream<T?> emit(Stream<T> localStream) {
    try {
      if (isClosed) {
        throw StateError('Cannot emit new states after calling close');
      }

      localStream.doOnListen(() {
        updateStatus(FormzStatus.submissionInProgress);
        streamSink.add(null);
        streamSink.addError(ErrorEnum.NOERROR);
      });

      localStream.listen((event) {
        updateStatus(FormzStatus.submissionSuccess);
        streamSink.add(event);
        streamSink.addError(ErrorEnum.NOERROR);
      });

      localStream.doOnError((error, stacktrace) {
        updateStatus(FormzStatus.submissionFailure);
        streamSink.addError(error);
        streamSink.add(null);
      });
    } catch (error, stackTrace) {
      updateStatus(FormzStatus.submissionFailure);
      streamSink.addError(error);
      streamSink.add(null);
    }
    return listener;
  }

  ValueStream<T?> addError(Object error) {
    try {
      if (isClosed) {
        throw StateError('Cannot emit new states after calling close');
      }

      updateStatus(FormzStatus.submissionFailure);
      streamSink.addError(error);
      streamSink.add(null);
    } catch (error) {
      updateStatus(FormzStatus.submissionFailure);
      streamSink.addError(error);
      streamSink.add(null);
    }
    return listener;
  }

  ValueStream<T?> addNewState(T? state) {
    try {
      if (isClosed) {
        throw StateError('Cannot emit new states after calling close');
      }

      updateStatus(FormzStatus.submissionSuccess);
      streamSink.add(state);
      streamSink.addError(ErrorEnum.NOERROR);
    } catch (error) {
      updateStatus(FormzStatus.submissionFailure);
      streamSink.addError(error);
      streamSink.add(null);
    }
    return listener;
  }

  ValueStream<T?> onLoading() {
    try {
      if (isClosed) {
        throw StateError('Cannot emit new states after calling close');
      }

      updateStatus(FormzStatus.submissionInProgress);
      streamSink.add(null);
      streamSink.addError(ErrorEnum.NOERROR);
    } catch (error) {
      updateStatus(FormzStatus.submissionFailure);
      streamSink.addError(error);
      streamSink.add(null);
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
