import 'package:example/features/login/liveStream/login_live_stream.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/src/live_stream_builder.dart';
import 'package:live_stream/src/live_stream_provider.dart';
import 'package:live_stream_base/live_stream.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      LiveStreamBuilder<LoginLiveStream, String>(
        state: LiveStreamProvider.of<LoginLiveStream>(context)
            .loginValidation
            .password,
        builder: (BuildContext context, StreamBase<String?> state) {
          return TextField(
            keyboardType: TextInputType.visiblePassword,
            onChanged: (LiveStreamProvider.of<LoginLiveStream>(context))
                .loginValidation
                .email
                .valueChange,
            decoration: InputDecoration(
                labelText: "Password ",
                hintText: "*******",
                errorText: state.hasError ? "${state.error}" : null),
          );
        },
      );
}
