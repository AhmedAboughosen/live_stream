import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'login_model.dart';

@Injectable()
class LoginRepositoryImpl {
  Stream<LoginModel> login(String userName, String password) => TimerStream(
      LoginModel(id: 1, title: "ahmed Aboughosen", userId: 512),
      Duration(seconds: 10));
}
