import 'package:live_stream/src/property.dart';

import 'live_stream.dart';
import 'live_stream_listener.dart';

class ExampleBloc extends LiveStream {


  @override
  void init() {
    registerProperty(#counter, BindableProperty.$value(initial: 0));
    registerProperty(#loginApi, BindableProperty.$async());

    updateValue<int>(#counter, (value) => value! + 1);


    // LiveStreamListener(
    //   listener: (context,LoginModel state) {
    //
    //
    //   }, propertyKey: #key,
    // );
    updateAsync<LoginModel>(#loginApi, login());
  }

  Stream<LoginModel> login() {
    return Stream.periodic(const Duration(seconds: 10))
        .map((event) => LoginModel());
  }
}

class LoginModel {}
