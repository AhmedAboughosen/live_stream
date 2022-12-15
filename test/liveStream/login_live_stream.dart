import 'package:reactive_live_stream/live_stream.dart';
import 'package:rxdart/streams.dart';

class LoginLiveStream extends LiveStream {
  final ILoginRepository loginRepository;

  LoginLiveStream({
    required this.loginRepository,
  });

  void login() {

    if (!isValid()) {
      print("error");
      return;
    }

    updateAsync<LoginModel>(
        #loginApi, () => loginRepository.login("ahmed", "naser"));
  }

  bool isValid() {
    return getValue<String>(#email)!.isNotEmpty &&
        getValue<String>(#password)!.isNotEmpty;
  }

  void emailChange(String email) {
    updateValue(#email, (p0) {
      if (RegExp(
              '^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})\$')
          .hasMatch(email)) {
        return email;
      }
      return "";
    });
  }

  void passwordChange(String pin) {
    updateValue(#password, (p0) {
      if (pin.isNotEmpty && pin.length == 4) {
        return pin;
      }
      return "";
    });
  }

  @override
  void init() {
    registerProperty<String>(
      #email,
      BindableProperty.$value<String>(
        initial: "",
      ),
    );

    registerProperty<String>(
        #password,
        BindableProperty.$value<String>(
          initial: "",
        ));

    registerProperty<LoginModel>(
        #loginApi, BindableProperty.$async<LoginModel>());
  }
}


abstract class ILoginRepository{
  Stream<LoginModel> login(String userName, String password);

}

class LoginModel {
  final int? userId;
  final int? id;
  final String? title;

  LoginModel({
    this.userId,
    this.id,
    this.title,
  });
}
