import 'package:example/features/login/liveStream/login_live_stream.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/src/live_stream_builder.dart';
import 'package:live_stream/src/live_stream_provider.dart';
import 'package:live_stream/src/live_stream.dart';

import '../login_page.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      LiveStreamBuilder<LoginLiveStream,String>(
        state: LiveStreamProvider.of<LoginLiveStream>(context)
            .loginValidation
            .email,
        liveStream: LoginPage.liveStream,
        builder: (BuildContext context, StreamState state) {
          return TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (LiveStreamProvider.of<LoginLiveStream>(context))
                .loginValidation
                .email
                .valueChange,
            decoration: InputDecoration(
                labelText: "Email address",
                hintText: "you@example.com",
                errorText: state.error != null ? "${state.error}" : null),
          );
        },
      );
}
