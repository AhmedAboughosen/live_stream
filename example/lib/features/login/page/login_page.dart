import 'package:example/features/login/liveStream/login_live_stream.dart';
import 'package:example/features/login/repositories/login_model.dart';
import 'package:example/features/login/repositories/login_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:reactive_live_stream/live_stream.dart';


LoginLiveStream liveStream =
    LoginLiveStream(loginRepository: LoginRepositoryImpl());

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiveStreamProvider<LoginLiveStream>(
      create: liveStream,
      child: Scaffold(
          appBar: AppBar(),
          body: LiveStreamListener<LoginLiveStream, LoginModel>(
            listener: (context, ValueListenable state) {
              LiveStreamListenerVoidCallback(
                onLoading: () {
                  print("${(state.value as OnLoading<LoginModel?>)}");
                },
                onData: () {
                  print(
                      "${(state.value as OnData<LoginModel?>).content?.title}");
                },
                onError: () {
                  print("${(state.value as OnError<LoginModel>).messages}");
                },
                onPure: () {
                  print("${(state.value as Pure<LoginModel?>)}");
                },
                asyncState: state.value,
              );

              print("state");
            },
            propertyKey: #loginApi,
            child: Column(
              children: const [
                SizedBox(
                  height: 30,
                ),
                EmailInput(),
                SizedBox(
                  height: 30,
                ),
                PasswordInput(),
                SizedBox(
                  height: 30,
                ),
                SubmitButton()
              ],
            ),
          )),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context_) =>
      LiveStreamBuilder<LoginLiveStream, String>(
        propertyKey: #email,
        builder: (context, ValueListenable state) {
          return TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged:
                (LiveStreamProvider.of<LoginLiveStream>(context)).emailChange,
            decoration: InputDecoration(
                labelText: "Email address",
                hintText: "you@example.com",
                errorText: state.value.toString().isEmpty
                    ? "please enter your email"
                    : null),
          );
        },
      );
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context_) =>
      LiveStreamBuilder<LoginLiveStream, String>(
        propertyKey: #password,
        builder: (context, ValueListenable state) {
          return TextField(
            keyboardType: TextInputType.visiblePassword,
            onChanged: (LiveStreamProvider.of<LoginLiveStream>(context))
                .passwordChange,
            decoration: InputDecoration(
                labelText: "Password ",
                hintText: "*******",
                errorText: state.value.toString().isEmpty
                    ? "please enter password at least 4 character"
                    : null),
          );
        },
      );
}

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
