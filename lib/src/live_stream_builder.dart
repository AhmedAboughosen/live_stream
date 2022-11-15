import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_stream/src/live_stream_listener.dart';
import 'package:live_stream/src/live_stream_provider.dart';
import 'package:nested/nested.dart';
import 'package:stream_bloc/src/stream_base.dart';

import 'live_stream_base.dart';

/// Signature for the `builder` function which takes the `BuildContext` and
/// [state] and is responsible for returning a widget which is to be rendered.
/// This is analogous to the `builder` function in [StreamBuilder].
typedef LiveStreamWidgetBuilder<S> = Widget Function(
    BuildContext context, S state);

/// {@template live_stream_listener}
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

class LiveStreamBuilder<B extends LiveStreamBase, S>
    extends LiveStreamBuilderBase<B, S> {
  const LiveStreamBuilder({
    Key? key,
    required this.builder,
    B? liveStream,
    Widget? child,
    required StreamBase<S> state,
  }) : super(key: key, child: child, liveStream: liveStream, state: state);

  /// The [builder] function which will be invoked on each widget build.
  /// The [builder] takes the `BuildContext` and current `state` and
  /// must return a widget.
  /// This is analogous to the [builder] function in [StreamBuilder].
  final LiveStreamWidgetBuilder<S> builder;

  @override
  Widget build(BuildContext context, S state) => builder(context, state);
}

/// {@template bive_stream_listener_Base}
/// Base class for widgets that listen to state changes in a specified [Stream].
///
/// A [LiveStreamBuilderBase] is stateful and maintains the state subscription.
/// The type of the state and what happens with each state change
/// is defined by sub-classes.
/// {@endtemplate}
abstract class LiveStreamBuilderBase<B extends LiveStreamBase, S>
    extends SingleChildStatefulWidget {
  /// {@macro bloc_listener_base}
  const LiveStreamBuilderBase({
    Key? key,
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

  /// The [state] will be listened to.
  /// Whenever the [state]'s `state` changes, [listener] will be invoked.
  final StreamBase<S> state;

  /// Returns a widget based on the `BuildContext` and current [state].
  Widget build(BuildContext context, S state);

  @override
  SingleChildState<LiveStreamBuilderBase<B, S>> createState() =>
      _LiveStreamBuilderBaseState<B, S>();
}

class _LiveStreamBuilderBaseState<B extends LiveStreamBase, S>
    extends SingleChildState<LiveStreamBuilderBase<B, S>> {
  StreamSubscription<S>? _subscription;
  late B _liveStream;
  late S _state;

  @override
  void initState() {
    super.initState();
    _liveStream = widget.liveStream ?? (LiveStreamProvider.of<B>(context));
    _state = widget.state.state;
  }

  @override
  void didUpdateWidget(LiveStreamBuilderBase<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLiveStream =
        oldWidget.liveStream ?? (LiveStreamProvider.of<B>(context));
    final currentLiveStream = widget.liveStream ?? oldLiveStream;
    if (oldLiveStream != currentLiveStream) {
      if (_subscription != null) {
        _liveStream = currentLiveStream;
        _state = widget.state.state;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final liveStream = widget.liveStream ?? (LiveStreamProvider.of<B>(context));
    if (_liveStream != liveStream) {
      if (_subscription != null) {
        _liveStream = liveStream;
        _state = widget.state.state;
      }
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '''${widget.runtimeType} used outside of MultiLiveStreamListener must specify a child''',
    );

    return LiveStreamListener<B, S>(
      liveStream: _liveStream,
      listener: (context, state) => setState(() => _state = state),
      state: widget.state,
      child: widget.build(context, _state),
    );
  }
}
