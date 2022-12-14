import 'package:flutter/material.dart';

import '../../live_stream.dart';

typedef LiveStreamListenerWidgetCallback = Widget Function();
typedef LiveStreamListenerVoidCallbackFunction = void Function();

class LiveStreamListenerVoidCallback<State> {
  final AsyncState<State> asyncState;
  final LiveStreamListenerVoidCallbackFunction onLoading;
  final LiveStreamListenerVoidCallbackFunction onData;
  final LiveStreamListenerVoidCallbackFunction onError;
  final LiveStreamListenerVoidCallbackFunction onPure;

  LiveStreamListenerVoidCallback({
    Key? key,
    required this.asyncState,
    required this.onLoading,
    required this.onData,
    required this.onError,
    required this.onPure,
  }) {
    if (asyncState is OnLoading) {
      onLoading();
    }

    if (asyncState is OnData) {
      onData();
    }

    if (asyncState is OnError) {
      onError();
    }

    if (asyncState is Pure) {
      onPure();
    }
  }
}

class LiveStreamListenerCallback<State> extends StatelessWidget {
  final AsyncState<State> asyncState;
  final LiveStreamListenerWidgetCallback onLoading;
  final LiveStreamListenerWidgetCallback onData;
  final LiveStreamListenerWidgetCallback onError;
  final LiveStreamListenerWidgetCallback onPure;

  const LiveStreamListenerCallback({
    Key? key,
    required this.asyncState,
    required this.onLoading,
    required this.onData,
    required this.onError,
    required this.onPure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (asyncState is OnLoading) {
      return onLoading();
    }

    if (asyncState is OnData) {
      return onData();
    }

    if (asyncState is OnError) {
      return onError();
    }

    if (asyncState is Pure) {
      return onPure();
    }

    return Container();
  }
}
