import 'package:example/features/login/liveStream/login_live_stream.dart';
import 'package:example/features/login/repositories/login_model.dart';
import 'package:example/features/login/repositories/login_repository_impl.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/src/live_stream_listener.dart';
import 'package:live_stream/src/live_stream_provider.dart';
import 'package:live_stream_base/live_stream.dart';

import '../../validation/login_validation.dart';
import 'components/email_input.dart';
import 'components/password_input.dart';
import 'components/submit_button.dart';
import 'package:live_stream/src/sync_live_stream.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _liveStream = LoginLiveStream(
      loginValidation: LoginValidation(),
      loginRepository: LoginRepositoryImpl()
    );

    return LiveStreamProvider<LoginLiveStream>(
      create: _liveStream,
      child: Scaffold(
          appBar: AppBar(),
          body: LiveStreamListener<LoginLiveStream, LoginModel>(
            listener: (context, StreamBase<LoginModel?> state) {
              print("state");
              var newState = state as SyncLiveStream<LoginModel?>;
              print("${newState.state!.title}");
              print("${state.status}");
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
