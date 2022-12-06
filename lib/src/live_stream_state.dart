enum Status { error, success, none }

/// A [Streamable] that provides synchronous access to the current [state].
abstract class StateStreamable<State> {}

abstract class AsyncState<State> extends StateStreamable<State> {


  bool isOnLoading() => this is OnLoading<State>;

  bool isOnData() => this is OnData<State>;

  bool isOnError() => this is OnError<State>;

  State? get state => (this as OnData<State>).content;

  Object get error => (this as OnError<State>).messages;


}

class OnData<State> extends AsyncState<State> {
  final State? content;

  OnData({
    this.content,
  });
}

class OnLoading<State> extends AsyncState<State> {
  OnLoading();
}

class Pure<State> extends AsyncState<State> {
  Pure();
}

class OnError<State> extends AsyncState<State> {
  final Object messages;

  OnError({required this.messages});
}

///  * [ValueListenable], a widget that uses a builder callback to
///    rebuild whenever a [ValueListenable] object triggers its notifications,
///    providing the builder with the value of the object.
class ValueListenable<State> {

  /// The current value of the object. When the value changes, the callbacks
  final State value;

  ValueListenable({required this.value});
}
