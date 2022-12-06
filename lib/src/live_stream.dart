import 'package:flutter/material.dart';
import 'package:live_stream/src/stream/async_live_stream.dart';
import 'package:live_stream/src/stream/value_live_stream.dart';

import 'error/errors.dart';
import 'object.dart';

abstract class LiveStream extends LiveStreamBase
    with BindableObjectValueMixin, BindableObjectAsyncValueMixin {}

abstract class LiveStreamBase implements BindableObject {
  Map<Object, StreamBase>? _properties;

  @override
  StreamBase<State> registerProperty<State>(
      Object propertyKey, StreamBase<State> property) {
    (_properties ?? <Object, StreamBase<State>>{})[propertyKey] = property;
    return property;
  }

  @override
  StreamBase<State> getProperty<State>(
    Object propertyKey,
  ) {
    if (!((_properties ?? <Object, StreamBase<State>>{})
        .containsKey(propertyKey))) {
      throw NotfoundPropertyException(propertyKey);
    }

    var property = _properties?[propertyKey] as StreamBase<State>;

    return property;
  }

  @protected
  @mustCallSuper
  void init() ;

  /// dispose
  void dispose() {
    if (_properties == null) return;
    if (!_properties!.isNotEmpty) {
      for (var prop in _properties!.values) {
        prop.onClose();
      }
    }
    _properties = null;
  }
}

enum Status { error, success, none }

/// A [Streamable] that provides synchronous access to the current [state].
abstract class StateStreamable<State> {}

/// An object that provides access to a stream of states over time.
abstract class StreamBase<State> {
  void onClose();

  /// The current [stream] of states.
  Stream get stream;

  bool isAsyncLiveStream()=> this is AsyncLiveStream;

  AsyncLiveStream asyncLiveStream()=> this as AsyncLiveStream;

  ValueLiveStream valueLiveStream()=> this as ValueLiveStream;

  bool isValueLiveStream()=> this is ValueLiveStream;

}

abstract class AsyncState<State> extends StateStreamable<State> {
  bool isOnLoading() => this is OnLoading<State>;

  bool isOnData() => this is OnData<State>;

  bool isOnError() => this is OnError<State>;

  State? get state => (this as OnData<State>).content;

  Object get error => (this as OnError<State>).messages;
}

class OnData<State> extends AsyncState<State> {
  final State? content;

  OnData({
    this.content,
  });
}

class OnLoading<State> extends AsyncState<State> {
  OnLoading();
}

class Pure<State> extends AsyncState<State> {
  Pure();
}

class OnError<State> extends AsyncState<State> {
  final Object messages;

  OnError({required this.messages});
}
