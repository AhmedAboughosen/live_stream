import 'package:live_stream/live_stream.dart';

class CounterLiveStream extends LiveStream {
  @override
  void init() {
    registerProperty<int>(
        #counter,
        BindableProperty.$value<int>(
          initial: 0,
        ));
  }

  void increment() {
    updateValue<int>(#counter, (old) {
      int newValue = old! + 1;
      return newValue;
    });
  }

  void decrement() {
    updateValue<int>(#counter, (old) {
      int newValue = old! - 1;
      return newValue;
    });
  }
}
