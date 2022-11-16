import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_stream/src/live_stream_provider.dart';
import 'package:live_stream/src/stream_state.dart';
import 'package:nested/nested.dart';

import 'live_stream.dart';
import 'live_stream_base.dart';

/// Signature for the `builder` function which takes the `BuildContext` and
/// [state] and is responsible for returning a VOID which is to be rendered.
/// This is analogous to the `builder` function in [StreamBuilder].
typedef StreamWidgetListener<S> = void Function(
    BuildContext context, StreamState<S?> state);

/// {@template bloc_listener}
/// Takes a [StreamWidgetListener] and an optional [liveStream] and [SyncLiveStream] invokes
/// the [listener] in response to `state` changes in the [SyncLiveStream].
/// It should be used for functionality that needs to occur only in response to
/// a `state` change such as navigation, showing a `SnackBar`, showing
/// a `Dialog`, etc...
/// The [listener] is guaranteed to only be called once for each `state` change
/// unlike the `builder` in `BlocBuilder`.
///
/// If the [SyncLiveStream] parameter is omitted, [LiveStreamListener]
///
/// ```dart
/// LiveStreamListener(
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   child: Container(),
/// )
/// ```
/// Only specify the [LiveStream] if you wish to provide a [bloc] that is otherwise
/// not accessible via [LiveStreamProvider] and the current `BuildContext`.
///
/// ```dart
/// LiveStreamListener(
///   liveStream: LiveStreamA,
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   child: Container(),
/// )
/// ```
/// {@endtemplate}
///

class LiveStreamListener<B extends LiveStreamBase, S>
    extends LiveStreamListenerBase<B, S> {
  const LiveStreamListener({
    Key? key,
    required StreamWidgetListener<S> listener,
    B? liveStream,
    Widget? child,
    required StreamBase<S?> state,
  }) : super(
            key: key,
            child: child,
            listener: listener,
            liveStream: liveStream,
            state: state);
}

/// {@template bive_stream_listener_Base}
/// Base class for widgets that listen to state changes in a specified [Stream].
///
/// A [LiveStreamListenerBase] is stateful and maintains the state subscription.
/// The type of the state and what happens with each state change
/// is defined by sub-classes.
/// {@endtemplate}
abstract class LiveStreamListenerBase<B extends LiveStreamBase, S>
    extends SingleChildStatefulWidget {
  /// {@macro bloc_listener_base}
  const LiveStreamListenerBase({
    Key? key,
    required this.listener,
    this.liveStream,
    this.child,
    required this.state,
  }) : super(key: key, child: child);

  /// The widget which will be rendered as a descendant of the
  /// [LiveStreamListenerBase].
  final Widget? child;

  /// The [liveStream] whose `state` will be listened to.
  /// Whenever the [stream]'s `state` changes, [listener] will be invoked.
  final B? liveStream;

  /// The [BlocWidgetListener] which will be called on every `state` change.
  /// This [listener] should be used for any code which needs to execute
  /// in response to a `state` change.
  final StreamWidgetListener<S> listener;

  /// The [state] will be listened to.
  /// Whenever the [state]'s `state` changes, [listener] will be invoked.
  final StreamBase<S?> state;

  @override
  SingleChildState<LiveStreamListenerBase<B, S>> createState() =>
      _LiveStreamListenerBaseState<B, S>();
}

class _LiveStreamListenerBaseState<B extends LiveStreamBase, S>
    extends SingleChildState<LiveStreamListenerBase<B, S>> {
  StreamSubscription? _subscription;
  late B _liveStream;
  late StreamBase<S?> _previousState;

  @override
  void initState() {
    super.initState();
    _liveStream = widget.liveStream ?? (LiveStreamProvider.of<B>(context));
    _previousState = widget.state;
    _subscribe();
  }

  @override
  void didUpdateWidget(LiveStreamListenerBase<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLiveStream =
        oldWidget.liveStream ?? (LiveStreamProvider.of<B>(context));
    final currentLiveStream = widget.liveStream ?? oldLiveStream;
    if (oldLiveStream != currentLiveStream) {
      if (_subscription != null) {
        _unsubscribe();
        _liveStream = currentLiveStream;
        _previousState = widget.state;
      }
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final liveStream = widget.liveStream ?? (LiveStreamProvider.of<B>(context));
    if (_liveStream != liveStream) {
      if (_subscription != null) {
        _unsubscribe();
        _liveStream = liveStream;
        _previousState = widget.state;
      }
      _subscribe();
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '''${widget.runtimeType} used outside of MultiLiveStreamListener must specify a child''',
    );

    return child!;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscription = (widget.state.listener.listen((newState) {
      widget.listener(context, StreamState(state: newState, error: null));
      // _previousState = state;
    }));

    _subscription?.onError((error) {
      widget.listener(context, StreamState(state: null, error: error));
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
