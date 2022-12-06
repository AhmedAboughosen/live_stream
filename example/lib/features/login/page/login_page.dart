import 'package:example/features/login/liveStream/login_live_stream.dart';
import 'package:example/features/login/repositories/login_model.dart';
import 'package:example/features/login/repositories/login_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/src/live_stream_listener.dart';
import 'package:live_stream/src/live_stream_provider.dart';
import 'package:live_stream/src/live_stream.dart';

import '../../validation/login_validation.dart';
import 'components/email_input.dart';
import 'components/submit_button.dart';

class LoginPage extends StatelessWidget {
   LoginPage({Key? key}) : super(key: key);
 static var liveStream = LoginLiveStream(
      loginValidation: LoginValidation(),
      loginRepository: LoginRepositoryImpl());

  @override
  Widget build(BuildContext context) {



    return LiveStreamProvider<LoginLiveStream>(
      create: liveStream,
      child: Scaffold(
          appBar: AppBar(),
          body: LiveStreamListener<LoginLiveStream, LoginModel>(
            listener: (context, StreamState state) {
              if (state.state is OnLoading) {
                print("${(state.state as OnLoading<LoginModel?>)}");
              }
              if (state.state is OnData) {
                print("${(state.state as OnData<LoginModel?>).content?.title}");
              }
              if (state.state is OnError) {
                print("${(state.state as OnError<LoginModel?>)}");

              }

              if (state.state is Pure) {
                print("${(state.state as Pure<LoginModel?>)}");

              }

              print("state");
              // print("${(state.state as OnData<LoginModel?>).state?.title}");
              print("${state.error}");
            },
            state: liveStream.loginApi,
            liveStream: liveStream,
            child: Column(
              children: const [
                SizedBox(
                  height: 30,
                ),
                EmailInput(),
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
