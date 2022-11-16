// import 'package:example/features/login/liveStream/login_live_stream.dart';
// import 'package:flutter/material.dart';
// import 'package:live_stream/src/live_stream_builder.dart';
// import 'package:live_stream/src/live_stream_provider.dart';
// import 'package:live_stream_base/live_stream.dart';
//
// class EmailInput extends StatelessWidget {
//   const EmailInput({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) =>
//       LiveStreamBuilder<LoginLiveStream, String>(
//         state: LiveStreamProvider.of<LoginLiveStream>(context)
//             .loginValidation
//             .email,
//         builder: (BuildContext context, StreamBase<String?> state) {
//           return TextField(
//             keyboardType: TextInputType.emailAddress,
//             onChanged: (LiveStreamProvider.of<LoginLiveStream>(context))
//                 .loginValidation
//                 .email
//                 .valueChange,
//             decoration: InputDecoration(
//                 labelText: "Email address",
//                 hintText: "you@example.com",
//                 errorText: state.hasError ? "${state.error}" : null),
//           );
//         },
//       );
// }
