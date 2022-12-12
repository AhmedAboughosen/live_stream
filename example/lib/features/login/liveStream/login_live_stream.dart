import 'package:example/features/login/repositories/login_model.dart';
import 'package:injectable/injectable.dart';
import 'package:live_stream/live_stream.dart';

import '../repositories/login_repository_impl.dart';

@Injectable()
class LoginLiveStream extends LiveStream {
  final LoginRepositoryImpl loginRepository;

  LoginLiveStream({
    required this.loginRepository,
  });

  void login() {
    print("email");
    print(getValue<String>(#email)!.isNotEmpty );
    print("password");
    print(getValue<String>(#password)!.isNotEmpty );


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
        ));

    registerProperty<String>(
        #password,
        BindableProperty.$value<String>(
          initial: "",
        ));

    registerProperty<LoginModel>(
        #loginApi, BindableProperty.$async<LoginModel>());
    // registerProperty(#password, BindableProperty.$async());
  }
}
