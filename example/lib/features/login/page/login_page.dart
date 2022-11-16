import 'package:example/features/login/liveStream/login_live_stream.dart';
import 'package:example/features/login/repositories/login_model.dart';
import 'package:example/features/login/repositories/login_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/src/live_stream_listener.dart';
import 'package:live_stream/src/live_stream_provider.dart';
import 'package:live_stream/src/stream_state.dart';
import 'package:live_stream/src/live_state.dart';

import '../../validation/login_validation.dart';
import 'components/submit_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _liveStream = LoginLiveStream(
        loginValidation: LoginValidation(),
        loginRepository: LoginRepositoryImpl());

    return LiveStreamProvider<LoginLiveStream>(
      create: _liveStream,
      child: Scaffold(
          appBar: AppBar(),
          body: LiveStreamListener<LoginLiveStream,LoginModel>(
            listener: (context, StreamState state) {
              print("state");
              print("${(state.state as OnData<LoginModel?>).state?.title}");
              print("${state.error}");
            },
            state: _liveStream.loginApi,
            liveStream: _liveStream,
            child: Column(
              children: const [
                SizedBox(
                  height: 30,
                ),
                // EmailInput(),
                // SizedBox(
                //   height: 30,
                // ),
                // PasswordInput(),
                // SizedBox(
                //   height: 30,
                // ),
                SubmitButton()
              ],
            ),
          )),
    );
  }
}
