import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import 'live_stream.dart';

/// Function used to customize the update policy
typedef UpdateShouldNotify<T> = bool Function(
    T liveStream, _LiveStreamProvider oldWidget);

/// Mixin which allows `MultiLiveStreamProvider` to infer the types
/// of multiple [LiveStreamProvider]s.
mixin LiveStreamSingleChildWidget on SingleChildWidget {}

/// The `LiveStreamProvider` class depends on `InheritedWidget`.
/// It accepts a liveStream and a widget.

class LiveStreamProvider<LS extends LiveStream>
    extends LiveStreamProviderBase<LS> {
  LiveStreamProvider({
    Key? key,
    required LS create,
    required Widget child,
    UpdateShouldNotify<LS>? updateShouldNotifyOverride,
  }) : super(
            key: key,
            create: create,
            child: child,
            updateShouldNotifyOverride: updateShouldNotifyOverride);

  /// Whenever you want to get your `LiveStream`, you can decide wether to attach the context of your widget to the `InheritedWidget` or not.
  /// In order to control this behavior, the static method `of` has an optional boolean argument (which is true by default) which determines wether your context will be attached or not.
  /// Basically, if you don't provide it or you just set it to `true`, [dependOnInheritedWidgetOfExactType](https://api.flutter.dev/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html) will be used.
  /// If you set
  static T of<T extends LiveStream>(BuildContext context,
          [bool attachContext = true]) =>
      _LiveStreamProvider.of(context, attachContext);
}

abstract class LiveStreamProviderBase<LS extends LiveStream>
    extends SingleChildStatefulWidget with LiveStreamSingleChildWidget {
  /// The  liveStream this provider will be hosting
  final LS create;

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
  ///           ? updateShouldNotifyOverride(create, oldWidget)
  ///           : oldWidget.create != create;
  /// ```
  final UpdateShouldNotify<LS>? updateShouldNotifyOverride;

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
  ///           ? updateShouldNotifyOverride(create, oldWidget)
  ///           : oldWidget.create != create;
  /// ```
  LiveStreamProviderBase({
    Key? key,
    required this.child,
    required this.create,
    this.updateShouldNotifyOverride,
  }) : super(key: key);

  /// Creates the state
  @override
  SingleChildState<LiveStreamProviderBase<LS>> createState() =>
      _LiveStreamProviderBaseState<LS>();
}

class _LiveStreamProviderBaseState<T extends LiveStream>
    extends SingleChildState<LiveStreamProviderBase<T>> {

  @override
  void initState() {
    widget.create.init();
    super.initState();
  }


  @override
  void dispose() {
    widget.create.dispose();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    // TODO: implement buildWithChild
    return _LiveStreamProvider(
      liveStream: widget.create,
      updateShouldNotifyOverride: widget.updateShouldNotifyOverride,
      child: widget.child,
    );
  }
}

class _LiveStreamProvider<T extends LiveStream> extends InheritedWidget {
  final T liveStream;
  final Widget child;
  final UpdateShouldNotify<T>? updateShouldNotifyOverride;

  _LiveStreamProvider({
    required this.liveStream,
    required this.child,
    this.updateShouldNotifyOverride,
  }) : super(child: child);

  static T of<T extends LiveStream>(BuildContext context, bool attachContext) {
    _LiveStreamProvider<T>? liveStreamProvider;

    if (attachContext) {
      liveStreamProvider =
          context.dependOnInheritedWidgetOfExactType<_LiveStreamProvider<T>>();
    } else {
      var element = context
          .getElementForInheritedWidgetOfExactType<_LiveStreamProvider<T>>();
      if (element != null) {
        liveStreamProvider = element.widget as _LiveStreamProvider<T>;
      }
    }

    if (liveStreamProvider == null) {
      final type = _typeOf<_LiveStreamProvider<T>>();
      throw FlutterError('Unable to find LiveStream of type $type.\n'
          'Context provided: $context');
    }
    return liveStreamProvider.liveStream;
  }

  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(_LiveStreamProvider oldWidget) =>
      updateShouldNotifyOverride != null
          ? updateShouldNotifyOverride!(liveStream, oldWidget)
          : oldWidget.liveStream != liveStream;
}
