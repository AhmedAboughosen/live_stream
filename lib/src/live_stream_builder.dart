import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_stream/src/live_stream_listener.dart';
import 'package:live_stream/src/live_stream_provider.dart';
import 'package:nested/nested.dart';

import '../../live_stream.dart';
import 'live_stream.dart';

/// Signature for the `builder` function which takes the `BuildContext` and
/// [state] and is responsible for returning a widget which is to be rendered.
/// This is analogous to the `builder` function in [StreamBuilder].
typedef StreamWidgetBuilder = Widget Function(
    BuildContext context, ValueListenable state);

/// {@template live_stream_builder}
/// [LiveStreamBuilder] handles building a widget in response to new `states`.
/// [LiveStreamBuilder] is analogous to [StreamBuilder] but has simplified API to
/// reduce the amount of boilerplate code needed as well as [LiveStream]-specific
/// performance improvements.

/// Please refer to [LiveStreamListener] if you want to "do" anything in response to
/// `state` changes such as navigation, showing a dialog, etc...
///

/// ```dart
/// LiveStreamListener(
///   listener: (context, state) {
///     // do stuff here based on LiveStream's state
///   },
///   child: Container(),
/// )
/// ```
/// Only specify the [SyncLiveStream] if you wish to provide a [SyncLiveStream] that is otherwise
/// not accessible via [LiveStreamProvider] and the current `BuildContext`.
///
/// ```dart
/// LiveStreamBuilder(
///   liveStream: LiveStreamA,
///   listener: (context, state) {
///     // do stuff here based on LiveStream's state
///   },
///   child: Container(),
/// )
/// ```
/// {@endtemplate}
///

class LiveStreamBuilder<B extends LiveStream, S>
    extends LiveStreamBuilderBase<B, S> {
  const LiveStreamBuilder({
    Key? key,
    required this.builder,
    B? liveStream,
    required Object propertyKey,
  }) : super(key: key, liveStream: liveStream, propertyKey: propertyKey);

  /// The [builder] function which will be invoked on each widget build.
  /// The [builder] takes the `BuildContext` and current `state` and
  /// must return a widget.
  /// This is analogous to the [builder] function in [StreamBuilder].
  final StreamWidgetBuilder builder;

  @override
  Widget build(BuildContext context, ValueListenable state) =>
      builder(context, state);
}

/// {@template live_stream_listener_Base}
/// Base class for widgets that listen to state changes in a specified [Stream].
///
/// A [LiveStreamBuilderBase] is stateful and maintains the state subscription.
/// The type of the state and what happens with each state change
/// is defined by sub-classes.
/// {@endtemplate}
abstract class LiveStreamBuilderBase<B extends LiveStream, S>
    extends SingleChildStatefulWidget {
  /// {@macro live_stream_listener_base}
  const LiveStreamBuilderBase({
    Key? key,
    this.liveStream,
    required this.propertyKey,
  }) : super(key: key);

  /// The [liveStream] whose `state` will be listened to.
  /// Whenever the [stream]'s `state` changes, [listener] will be invoked.
  final B? liveStream;

  /// The [propertyKey] will be mapping  properties.
  final Object propertyKey;

  /// Returns a widget based on the `BuildContext` and current [state].
  Widget build(BuildContext context, ValueListenable state);

  @override
  SingleChildState<LiveStreamBuilderBase<B, S>> createState() =>
      _LiveStreamBuilderBaseState<B, S>();
}

class _LiveStreamBuilderBaseState<B extends LiveStream, S>
    extends SingleChildState<LiveStreamBuilderBase<B, S>> {
  late B _liveStream;
  late ValueListenable _liveStreamState;
  late StreamBase<S> _previousStream;

  @override
  void initState() {
    super.initState();
    _liveStream = widget.liveStream ?? (LiveStreamProvider.of<B>(context));
    _previousStream = _liveStream.getProperty(widget.propertyKey);

    if (_previousStream.isAsyncLiveStream()) {
      _liveStreamState =
          ValueListenable(value: _previousStream.asyncLiveStream().state);
    }

    if (_previousStream.isValueLiveStream()) {
      _liveStreamState =
          ValueListenable(value: _previousStream.valueLiveStream().state);
    }
  }

  @override
  void didUpdateWidget(LiveStreamBuilderBase<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLiveStream =
        oldWidget.liveStream ?? (LiveStreamProvider.of<B>(context));
    final currentLiveStream = widget.liveStream ?? oldLiveStream;

    if (oldLiveStream != currentLiveStream) {
      _liveStream = currentLiveStream;
      _previousStream = _liveStream.getProperty(widget.propertyKey);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final liveStream = widget.liveStream ?? (LiveStreamProvider.of<B>(context));
    if (_liveStream != liveStream) {
      _liveStream = liveStream;
      _previousStream = _liveStream.getProperty(widget.propertyKey);
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return LiveStreamListener<B, S>(
      liveStream: _liveStream,
      listener: (context, state) => setState(() => _liveStreamState = state),
      propertyKey: widget.propertyKey,
      child: widget.build(context, _liveStreamState),
    );
  }
}
