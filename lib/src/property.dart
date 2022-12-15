

import '../../live_stream.dart';

typedef PropertyValueChanged<State> = void Function(State value);

abstract class BindableProperty<State> {


  static StreamBase<State> $value<State>({State? initial, bool? sync}) =>
      ValueLiveStream<State>(sync: sync ?? false, seedValue: initial);

  static StreamBase<State> $async<State>({State? initial, bool? sync}) =>
      AsyncLiveStream<State>(sync: sync ?? false, seedValue: initial);
}
