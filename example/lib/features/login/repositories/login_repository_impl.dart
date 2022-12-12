import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'login_model.dart';

@Injectable()
class LoginRepositoryImpl {


  // Stream<LoginModel> login(String userName, String password) => TimerStream(
  //     LoginModel(id: 1, title: "ahmed Aboughosen", userId: 512),
  //     Duration(seconds: 4));


  // Stream<LoginModel> login(String userName, String password){
  //   final BehaviorSubject<LoginModel> _streamController =
  //   BehaviorSubject<LoginModel>();
  //
  //   _streamController.add(LoginModel(id: 1, title: "ahmed Aboughosen", userId: 512));
  //   return _streamController.stream;
  // }

  Stream<LoginModel> login(String userName, String password) => Stream.error(Exception("it's me"));

}
