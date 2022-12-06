// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
//
// import 'live_stream_provider.dart';
//
// /// {@template multi_live_stream_provider}
// /// Merges multiple [LiveStreamProvider] widgets into one widget tree.
// ///
// /// [MultiLiveStreamProvider] improves the readability and eliminates the need
// /// to nest multiple [LiveStreamProvider]s.
// ///
// /// By using [MultiLiveStreamProvider] we can go from:
// ///
// /// ```dart
// /// LiveStreamProvider<LiveStreamA>(
// ///   create: (BuildContext context) => LiveStreamA(),
// ///   child: LiveStreamProvider<LiveStreamB>(
// ///     create: (BuildContext context) => LiveStreamB(),
// ///     child: LiveStreamProvider<LiveStreamC>(
// ///       create: (BuildContext context) => LiveStreamC(),
// ///       child: ChildA(),
// ///     )
// ///   )
// /// )
// /// ```
// ///
// /// to:
// ///
// /// ```dart
// /// MultiLiveStreamProvider(
// ///   providers: [
// ///     LiveStreamProvider<LiveStreamA>(
// ///       create: (BuildContext context) => LiveStreamA(),
// ///     ),
// ///     LiveStreamProvider<LiveStreamB>(
// ///       create: (BuildContext context) => LiveStreamB(),
// ///     ),
// ///     LiveStreamProvider<LiveStreamC>(
// ///       create: (BuildContext context) => LiveStreamC(),
// ///     ),
// ///   ],
// ///   child: ChildA(),
// /// )
// /// ```
// ///
// /// [MultiLiveStreamProvider] converts the [LiveStreamProvider] list into a tree of nested
// /// [LiveStreamProvider] widgets.
// /// As a result, the only advantage of using [MultiLiveStreamProvider] is improved
// /// readability due to the reduction in nesting and boilerplate.
// /// {@endtemplate}
// class MultiLiveStreamProvider extends MultiProvider {
//   /// {@macro multi_live_stream_provider}
//   MultiLiveStreamProvider({
//     Key? key,
//     required List<LiveStreamSingleChildWidget> providers,
//     required Widget child,
//   }) : super(key: key, providers: providers, child: child);
// }
