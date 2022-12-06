import 'package:example/features/login/liveStream/login_live_stream.dart';
import 'package:example/features/login/repositories/login_model.dart';
import 'package:example/features/login/repositories/login_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/src/live_stream_listener.dart';
import 'package:live_stream/src/live_stream_provider.dart';
import 'package:live_stream/src/live_stream.dart';

class LoginPage extends StatelessWidget {
   LoginPage({Key? key}) : super(key: key);
 static var liveStream = LoginLiveStream(
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

//
// class EmailInput extends StatelessWidget {
//   const EmailInput({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) =>
//       LiveStreamBuilder<LoginLiveStream,String>(
//         state: LiveStreamProvider.of<LoginLiveStream>(context)
//             .loginValidation
//             .email,
//         liveStream: LoginPage.liveStream,
//         builder: (BuildContext context, StreamState state) {
//           return TextField(
//             keyboardType: TextInputType.emailAddress,
//             onChanged: (LiveStreamProvider.of<LoginLiveStream>(context))
//                 .loginValidation
//                 .email
//                 .valueChange,
//             decoration: InputDecoration(
//                 labelText: "Email address",
//                 hintText: "you@example.com",
//                 errorText: state.error != null ? "${state.error}" : null),
//           );
//         },
//       );
// }

// import 'package:example/features/login/liveStream/login_live_stream.dart';
// import 'package:flutter/material.dart';
// import 'package:live_stream/src/live_stream_builder.dart';
// import 'package:live_stream/src/live_stream_provider.dart';
// import 'package:live_stream_base/live_stream.dart';
//
// class PasswordInput extends StatelessWidget {
//   const PasswordInput({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) =>
//       LiveStreamBuilder<LoginLiveStream, String>(
//         state: LiveStreamProvider.of<LoginLiveStream>(context)
//             .loginValidation
//             .password,
//         builder: (BuildContext context, StreamBase<String?> state) {
//           return TextField(
//             keyboardType: TextInputType.visiblePassword,
//             onChanged: (LiveStreamProvider.of<LoginLiveStream>(context))
//                 .loginValidation
//                 .email
//                 .valueChange,
//             decoration: InputDecoration(
//                 labelText: "Password ",
//                 hintText: "*******",
//                 errorText: state.hasError ? "${state.error}" : null),
//           );
//         },
//       );
// }

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        LiveStreamProvider.of<LoginLiveStream>(context).login();
      },
      color: Colors.blue,
      child: const Text(
        "Login",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
