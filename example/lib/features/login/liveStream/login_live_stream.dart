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
    // if (!loginValidation.validate()) return;

    updateAsync(#loginApi, loginRepository.login("ahmed", "naser"));

    // loginRepository.login(
    //     "loginValidation.email.state"," loginValidation.password.state").listen((event) {
    //       print(event);
    // });
  }

  @override
  void init() {
    registerProperty(#loginApi, BindableProperty.$async());
    registerProperty(#userName, BindableProperty.$async());
    registerProperty(#password, BindableProperty.$async());
  }
}
