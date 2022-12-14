import 'package:flutter/material.dart';
import 'package:live_stream/src/stream/async_live_stream.dart';
import 'package:live_stream/src/stream/value_live_stream.dart';

import '../live_stream.dart';
import 'error/errors.dart';
import 'object.dart';

abstract class LiveStream extends LiveStreamBase
    with BindableObjectValueMixin, BindableObjectAsyncValueMixin {}

abstract class LiveStreamBase implements BindableObject {
  Map<Object, StreamBase<dynamic>>? _properties;

  @visibleForTesting
  @protected
  Iterable<MapEntry<Object, StreamBase>> get properties =>
      _properties?.entries ?? [];

  @override
  StreamBase<State> registerProperty<State>(
    Object propertyKey,
    StreamBase<State> property,
  ) {
    (_properties ??= <Object, StreamBase<dynamic>>{})[propertyKey] = property;
    return property;
  }

  @override
  StreamBase<State> getProperty<State>(
    Object propertyKey,
  ) {
    var property = _properties?[propertyKey] as StreamBase<State>?;
    if (property == null) {
      throw NotfoundPropertyException(propertyKey);
    }
    return property;
  }

  @protected
  @mustCallSuper
  void init();

  /// dispose
  void dispose() {
    if (_properties == null) return;
    if (_properties!.isNotEmpty) {
      for (var prop in _properties!.values) {
        prop.onClose();
      }
    }
    _properties = null;
  }
}

/// An object that provides access to a stream of states over time.
abstract class StreamBase<State> {
  void onClose();

  /// The current [stream] of states.
  Stream get stream;

  bool isAsyncLiveStream() => this is AsyncLiveStream;

  AsyncLiveStream asyncLiveStream() => this as AsyncLiveStream;

  ValueLiveStream valueLiveStream() => this as ValueLiveStream;

  bool isValueLiveStream() => this is ValueLiveStream;
}
