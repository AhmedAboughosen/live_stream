import 'package:injectable/injectable.dart';
import 'package:live_stream/src/live_stream.dart';

import '../repositories/login_model.dart';
import '../repositories/login_repository_impl.dart';

@Injectable()
class LoginLiveStream extends LiveStream {
  final LoginRepositoryImpl loginRepository;



  LoginLiveStream({
    required this.loginRepository,
  });

  void login() {
    // if (!loginValidation.validate()) return;

    // loginRepository.login(
    //     "loginValidation.email.state"," loginValidation.password.state").listen((event) {
    //       print(event);
    // });
    loginApi.emit(loginRepository.login(
        "loginValidation.email.state"," loginValidation.password.state"));
  }

  @override
  void init() {
    registerProperty(#loginApi, BindableProperty.$async());

  }
}
