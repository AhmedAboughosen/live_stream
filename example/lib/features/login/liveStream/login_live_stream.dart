import 'package:injectable/injectable.dart';
import 'package:live_stream/src/live_stream_base.dart';
import 'package:live_stream/src/sync_live_stream.dart';

import '../../validation/login_validation.dart';
import '../repositories/login_model.dart';
import '../repositories/login_repository_impl.dart';

@Injectable()
class LoginLiveStream extends LiveStreamBase {
  final LoginValidation loginValidation;
  final LoginRepositoryImpl loginRepository;

  final SyncLiveStream<LoginModel> loginApi = SyncLiveStream();

  LoginLiveStream({
    required this.loginValidation,
    required this.loginRepository,
    // required this.loginApi,
  });

  void login() {
    if (!loginValidation.validate()) return;

    loginApi.emit(loginRepository.login(
        loginValidation.email.state, loginValidation.password.state));
  }
}
