import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live_stream/src/live_stream_provider.dart';
import 'package:live_stream/src/stream/async_live_stream.dart';
import 'package:live_stream/src/stream/value_live_stream.dart';
import 'package:nested/nested.dart';

import 'live_stream.dart';

/// Mixin which allows `MultiLiveStreamListener` to infer the types
/// of multiple [LiveStreamListener]s.
mixin LiveStreamListenerSingleChildWidget on SingleChildWidget {}

/// Signature for the `builder` function which takes the `BuildContext` and
/// [state] and is responsible for returning a VOID which is to be rendered.
/// This is analogous to the `builder` function in [StreamBuilder].
typedef StreamWidgetListener<S> = void Function(BuildContext context, S state);

/// {@template live_stream_listener}
/// Takes a [StreamWidgetListener] and an optional [liveStream] and [SyncLiveStream] invokes
/// the [listener] in response to `state` changes in the [SyncLiveStream].
/// It should be used for functionality that needs to occur only in response to
/// a `state` change such as navigation, showing a `SnackBar`, showing
/// a `Dialog`, etc...
/// The [listener] is guaranteed to only be called once for each `state` change
/// unlike the `builder` in `LiveStreamBuilder`.
///
/// If the [SyncLiveStream] parameter is omitted, [LiveStreamListener]
///
/// ```dart
/// LiveStreamListener(
///   listener: (context, state) {
///     // do stuff here based on LiveStream's state
///   },
///   child: Container(),
/// )
/// ```
/// Only specify the [LiveStream] if you wish to provide a [LiveStream] that is otherwise
/// not accessible via [LiveStreamProvider] and the current `BuildContext`.
///
/// ```dart
/// LiveStreamListener(
///   liveStream: LiveStreamA,
///   listener: (context, state) {
///     // do stuff here based on LiveStreamA's state
///   },
///   child: Container(),
/// )
/// ```
/// {@endtemplate}
///

class LiveStreamListener<B extends LiveStream, S>
    extends LiveStreamListenerBase<B, S> {
  const LiveStreamListener({
    Key? key,
    required Function listener,
    B? liveStream,
    Widget? child,
    required Object propertyKey,
  }) : super(
            key: key,
            child: child,
            listener: listener,
            liveStream: liveStream,
            propertyKey: propertyKey);
}

/// {@template live_stream_listener_Base}
/// Base class for widgets that listen to state changes in a specified [Stream].
///
/// A [LiveStreamListenerBase] is stateful and maintains the state subscription.
/// The type of the state and what happens with each state change
/// is defined by sub-classes.
/// {@endtemplate}
abstract class LiveStreamListenerBase<B extends LiveStream, S>
    extends SingleChildStatefulWidget with LiveStreamListenerSingleChildWidget {
  /// {@macro live_stream_listener_base}
  const LiveStreamListenerBase({
    Key? key,
    required this.listener,
    this.liveStream,
    this.child,
    required this.propertyKey,
  }) : super(key: key, child: child);

  /// The widget which will be rendered as a descendant of the
  /// [LiveStreamListenerBase].
  final Widget? child;

  /// The [liveStream] whose `state` will be listened to.
  /// Whenever the [stream]'s `state` changes, [listener] will be invoked.
  final B? liveStream;

  /// The [LiveStreamWidgetListener] which will be called on every `state` change.
  /// This [listener] should be used for any code which needs to execute
  /// in response to a `state` change.
  final Function listener;

  /// The [propertyKey] will be mapping  properties.
  final Object propertyKey;

  @override
  SingleChildState<LiveStreamListenerBase<B, S>> createState() =>
      _LiveStreamListenerBaseState<B, S>();
}

class _LiveStreamListenerBaseState<B extends LiveStream, S>
    extends SingleChildState<LiveStreamListenerBase<B, S>> {
  StreamSubscription? _subscription;
  late B _liveStream;
  late StreamBase<S> _previousStream;

  @override
  void initState() {
    super.initState();
    _liveStream = widget.liveStream ?? (LiveStreamProvider.of<B>(context));
    _previousStream = _liveStream.getProperty(widget.propertyKey);
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
        _previousStream = _liveStream.getProperty(widget.propertyKey);
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
        _previousStream = _liveStream.getProperty(widget.propertyKey);
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
    if (_previousStream is AsyncLiveStream) {
      _subscription = (_previousStream.stream.listen((newState) {
        widget.listener(context, newState);
      }, onError: (error) {
        widget.listener(context, OnError(messages: error));
      }));
      return;
    }

    if (_previousStream is ValueLiveStream) {
      _subscription = (_previousStream.stream.listen((newState) {
        widget.listener(context, newState);
      }));
    }
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
