import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_live_stream/live_stream.dart';
import 'package:rxdart/rxdart.dart';

import 'liveStream/login_live_stream.dart';

const delay = Duration(milliseconds: 30);

Future<void> wait({updatedDelay = const Duration(milliseconds: 30)}) =>
    Future.delayed(updatedDelay);

Future<void> tick() => Future.delayed(Duration.zero);

class SuccessMockLoginRepositoryImpl extends ILoginRepository {
  @override
  Stream<LoginModel> login(String userName, String password) => TimerStream(
      LoginModel(id: 1, title: "ahmed Aboughosen", userId: 512),
      const Duration(milliseconds: 40));
}

class ErrorMockLoginRepositoryImpl extends ILoginRepository {
  @override
  Stream<LoginModel> login(String userName, String password) =>
      Stream.error(Exception("it's me"));
}

void main() {
  test('processes events concurrently by default', () async {
    SuccessMockLoginRepositoryImpl loginRepositoryImpl =
        SuccessMockLoginRepositoryImpl();

    final liveStream = LoginLiveStream(loginRepository: loginRepositoryImpl);
    liveStream.init();

    final emailStates = <dynamic>[];
    final passwordStates = <dynamic>[];
    final loginApiStates = <AsyncState<LoginModel>>[];

    liveStream.getProperty(#email).stream.listen(emailStates.add);
    liveStream.getProperty(#password).stream.listen(passwordStates.add);
    liveStream.getProperty(#loginApi).stream.listen((e) {
      loginApiStates.add(e);
    });

    await tick();
    await wait();

    expect(emailStates, equals([""]));
    expect(passwordStates, equals([""]));
    expect(1, loginApiStates.length);

    expect(loginApiStates[0].isOnPure(), isTrue);
  });

  test('add text into email and password', () async {
    SuccessMockLoginRepositoryImpl loginRepositoryImpl =
        SuccessMockLoginRepositoryImpl();

    final liveStream = LoginLiveStream(loginRepository: loginRepositoryImpl);
    liveStream.init();

    final emailStates = <dynamic>[];
    final passwordStates = <dynamic>[];
    final loginApiStates = <AsyncState<LoginModel>>[];

    liveStream.getProperty(#email).stream.listen(emailStates.add);
    liveStream.getProperty(#password).stream.listen(passwordStates.add);
    liveStream.getProperty(#loginApi).stream.listen((e) {
      loginApiStates.add(e);
    });

    liveStream.emailChange("ahmed@a.com");
    liveStream.passwordChange("1234");

    await tick();
    await wait();

    expect(emailStates, equals(["", "ahmed@a.com"]));
    expect(passwordStates, equals(["", "1234"]));
    expect(1, loginApiStates.length);

    expect(loginApiStates[0].isOnPure(), isTrue);
  });

  test('call api login success response', () async {
    SuccessMockLoginRepositoryImpl loginRepositoryImpl =
        SuccessMockLoginRepositoryImpl();

    final liveStream = LoginLiveStream(loginRepository: loginRepositoryImpl);
    liveStream.init();

    final emailStates = <dynamic>[];
    final passwordStates = <dynamic>[];
    final loginApiStates = <AsyncState<LoginModel>>[];

    liveStream.getProperty(#email).stream.listen(emailStates.add);
    liveStream.getProperty(#password).stream.listen(passwordStates.add);
    liveStream.getProperty(#loginApi).stream.listen((e) {
      loginApiStates.add(e);
    });

    liveStream.emailChange("ahmed@a.com");
    liveStream.passwordChange("1234");
    liveStream.login();

    await tick();
    await wait(updatedDelay: const Duration(seconds: 1));

    expect(emailStates, equals(["", "ahmed@a.com"]));
    expect(passwordStates, equals(["", "1234"]));
    expect(3, loginApiStates.length);

    expect(loginApiStates[0].isOnPure(), isTrue);
    expect(loginApiStates[1].isOnLoading(), isTrue);
    expect(loginApiStates[2].isOnData(), isTrue);
    expect("ahmed Aboughosen", loginApiStates[2].state!.title);
    expect(512, loginApiStates[2].state!.userId);
  });

  test('call api login error response', () async {
    ErrorMockLoginRepositoryImpl loginRepositoryImpl =
        ErrorMockLoginRepositoryImpl();

    final liveStream = LoginLiveStream(loginRepository: loginRepositoryImpl);
    liveStream.init();

    final emailStates = <dynamic>[];
    final passwordStates = <dynamic>[];
    final loginApiStates = <AsyncState<LoginModel>>[];

    liveStream.getProperty(#email).stream.listen(emailStates.add);
    liveStream.getProperty(#password).stream.listen(passwordStates.add);
    liveStream.getProperty(#loginApi).stream.listen((e) {
      loginApiStates.add(e);
    }, onError: (e) {
      loginApiStates.add(e);
    });

    liveStream.emailChange("ahmed@a.com");
    liveStream.passwordChange("1234");
    liveStream.login();

    await tick();
    await wait(updatedDelay: const Duration(seconds: 1));

    expect(emailStates, equals(["", "ahmed@a.com"]));
    expect(passwordStates, equals(["", "1234"]));
    expect(3, loginApiStates.length);

    expect(loginApiStates[0].isOnPure(), isTrue);
    expect(loginApiStates[1].isOnLoading(), isTrue);
    expect(loginApiStates[2].isOnError(), isTrue);
    expect((loginApiStates[2].error as Exception).toString(),
        'Exception: it\'s me');
  });

  test('close all stream', () async {
    ErrorMockLoginRepositoryImpl loginRepositoryImpl =
        ErrorMockLoginRepositoryImpl();

    final liveStream = LoginLiveStream(loginRepository: loginRepositoryImpl);
    liveStream.init();

    await tick();
    await wait();

    liveStream.dispose();
    expect(liveStream.properties, []);
  });
}
