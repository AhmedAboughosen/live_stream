import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'live_stream_listener.dart';

/// {@template multi_live_stream_listener}
/// Merges multiple [LiveStreamListener] widgets into one widget tree.
///
/// [MultiLiveStreamListener] improves the readability and eliminates the need
/// to nest multiple [LiveStreamListener]s.
///
/// By using [MultiLiveStreamListener] we can go from:
///
/// ```dart
/// LiveStreamListener(
///   listener: (context, state) {},
///     propertyKey : key
///   child: LiveStreamListener(
///     listener: (context, state) {},
///     propertyKey : key
///     child: LiveStreamListener(
///       listener: (context, state) {},
///        propertyKey : key
///       child: ChildA(),
///     ),
///   ),
/// )
/// ```
///
/// to:
///
/// ```dart
/// MultiLiveStreamListener(
///   listeners: [
///     LiveStreamListener(
///       listener: (context, state) {},
///       propertyKey : key
///     ),
///     LiveStreamListener(
///       listener: (context, state) {},
///          propertyKey : key
///     ),
///     LiveStreamListener(
///       listener: (context, state) {},
///         propertyKey : key
///     ),
///   ],
///   child: ChildA(),
/// )
/// ```
///
/// [MultiLiveStreamListener] converts the [LiveStreamListener] list into a tree of nested
/// [LiveStreamListener] widgets.
/// As a result, the only advantage of using [MultiLiveStreamListener] is improved
/// readability due to the reduction in nesting and boilerplate.
/// {@endtemplate}
class MultiLiveStreamListener extends MultiProvider {
  /// {@macro multi_live_stream_listener}
  MultiLiveStreamListener({
    Key? key,
    required List<LiveStreamListenerSingleChildWidget> listeners,
    required Widget child,
  }) : super(key: key, providers: listeners, child: child);
}
