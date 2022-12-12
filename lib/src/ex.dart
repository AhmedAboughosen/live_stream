import 'package:live_stream/src/property.dart';
import 'package:rxdart/rxdart.dart';

import 'live_stream.dart';

class ExampleBloc extends LiveStream {
  @override
  void init() {
    registerProperty(#counter, BindableProperty.$value(initial: 0));
    registerProperty(#loginApi, BindableProperty.$async());

    updateValue<int>(#counter, (value) => null);

    // LiveStreamListener(
    //   listener: (context,LoginModel state) {
    //
    //
    //   }, propertyKey: #key,
    // );
    ReplaySubject<int> replaySubject = ReplaySubject<int>();

    updateAsync<LoginModel>(#loginApi, () => login());
  }

  Stream<LoginModel> login() {
    return Stream.periodic(const Duration(seconds: 10))
        .map((event) => LoginModel());
  }
}

class LoginModel {}
