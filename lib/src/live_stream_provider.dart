import 'package:flutter/material.dart';

import 'live_stream_base.dart';

/// Function used to customize the update policy
typedef UpdateShouldNotify<T> = bool Function(
    T bloc, _LiveStreamProvider oldWidget);

/// The `LiveStreamProvider` class depends on `InheritedWidget`.
/// It accepts a liveStream and a widget.
class LiveStreamProvider<T extends LiveStreamBase> extends StatefulWidget {
  /// The  liveStream this provider will be hosting
  final T create;

  /// The widget that the [LiveStreamProvider] will wrap
  final Widget child;

  /// Allows you to override the default update policy
  ///
  /// Default implementation:
  ///
  /// ```dart
  ///    @override
  ///    bool updateShouldNotify(_LiveStreamProvider oldWidget) =>
  ///       updateShouldNotifyOverride != null
  ///           ? updateShouldNotifyOverride(bloc, oldWidget)
  ///           : oldWidget.bloc != bloc;
  /// ```
  final UpdateShouldNotify<T>? updateShouldNotifyOverride;

  /// Builds a [LiveStreamProvider].
  ///
  /// [child] is the widget that the [LiveStreamProvider] will wrap.
  /// [LiveStream] is the LiveStream this provider will be hosting.
  /// [updateShouldNotifiyOverride] is an optional parameter that will allow you
  /// to override the default behaviour.
  /// This is the default implementation of the `updateShouldNotify` method:
  ///
  /// ```dart
  ///    @override
  ///    bool updateShouldNotify(_LiveStreamProvider oldWidget) =>
  ///       updateShouldNotifyOverride != null
  ///           ? updateShouldNotifyOverride(bloc, oldWidget)
  ///           : oldWidget.bloc != bloc;
  /// ```
  LiveStreamProvider({
    Key? key,
    required this.child,
    required this.create,
    this.updateShouldNotifyOverride,
  }) : super(key: key);

  /// Whenever you want to get your `LiveStream`, you can decide wether to attach the context of your widget to the `InheritedWidget` or not.
  /// In order to control this behavior, the static method `of` has an optional boolean argument (which is true by default) which determines wether your context will be attached or not.
  /// Basically, if you don't provide it or you just set it to `true`, [dependOnInheritedWidgetOfExactType](https://api.flutter.dev/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html) will be used.
  /// If you set
  static T of<T extends LiveStreamBase>(BuildContext context,
          [bool attachContext = true]) =>
      _LiveStreamProvider.of(context, attachContext);

  /// Creates the state
  @override
  _LiveStreamProviderState<T> createState() => _LiveStreamProviderState<T>();
}

class _LiveStreamProviderState<T extends LiveStreamBase>
    extends State<LiveStreamProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return _LiveStreamProvider(
      liveStream: widget.create,
      updateShouldNotifyOverride: widget.updateShouldNotifyOverride,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.create.dispose();
    super.dispose();
  }
}

class _LiveStreamProvider<T extends LiveStreamBase> extends InheritedWidget {
  final T liveStream;
  final Widget child;
  final UpdateShouldNotify<T>? updateShouldNotifyOverride;

  _LiveStreamProvider({
    required this.liveStream,
    required this.child,
    this.updateShouldNotifyOverride,
  }) : super(child: child);

  static T of<T extends LiveStreamBase>(
      BuildContext context, bool attachContext) {
    _LiveStreamProvider<T>? blocProvider;

    if (attachContext) {
      blocProvider =
          context.dependOnInheritedWidgetOfExactType<_LiveStreamProvider<T>>();
    } else {
      var element = context
          .getElementForInheritedWidgetOfExactType<_LiveStreamProvider<T>>();
      if (element != null) {
        blocProvider = element.widget as _LiveStreamProvider<T>;
      }
    }

    if (blocProvider == null) {
      final type = _typeOf<_LiveStreamProvider<T>>();
      throw FlutterError('Unable to find BLoC of type $type.\n'
          'Context provided: $context');
    }
    return blocProvider.liveStream;
  }

  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(_LiveStreamProvider oldWidget) =>
      updateShouldNotifyOverride != null
          ? updateShouldNotifyOverride!(liveStream, oldWidget)
          : oldWidget.liveStream != liveStream;
}
