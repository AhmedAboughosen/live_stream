import 'package:live_stream/src/stream/async_live_stream.dart';
import 'package:live_stream/src/stream/value_live_stream.dart';

import '../../live_stream.dart';
import 'error/errors.dart';
import 'live_stream.dart';

abstract class BindableObject {
  StreamBase<State> getProperty<State>(
    Object propertyKey,
  );

  StreamBase<State> registerProperty<State>(
    Object propertyKey,
    StreamBase<State> property,
  );
}

/// BindableObjectValueMixin
///
mixin BindableObjectValueMixin on BindableObject {
  void updateValue<State>(
    Object propertyKey,
    State Function(State?) updator,
  ) {

    var property = getProperty(propertyKey);

    if (property is! ValueLiveStream<State>) {
      throw NotfoundPropertyException(propertyKey);
    }

    State newState = updator(property.state);

    property.update(newState);
  }
}

/// BindableObjectAsyncValueMixin
///
mixin BindableObjectAsyncValueMixin on BindableObject {
  Stream<AsyncState<State>> updateAsync<State>(
    Object propertyKey,
    Stream<State> localStream,
  ) {
    var property = getProperty(propertyKey);

    if (property is! AsyncLiveStream<State>) {
      throw NotfoundPropertyException(propertyKey);
    }

    if (localStream is Stream<State>) {
      return property.emit(localStream);
    }

    // if (localStream is Future<State>) {
    //   return property.emit(localStream.asStream());
    // }

    throw Exception("object should be stream or future");
  }

  Stream<AsyncState<State>> addAsync<State>(
    Object propertyKey,
    State state,
  ) {
    var property = getProperty(propertyKey);

    if (property is! AsyncLiveStream<State>) {
      throw NotfoundPropertyException(propertyKey);
    }

    return property.add(state);
  }

  Stream<AsyncState<State>> addErrorAsync<State>(
    Object propertyKey,
    Object error,
  ) {
    var property = getProperty(propertyKey);

    if (property is! AsyncLiveStream<State>) {
      throw NotfoundPropertyException(propertyKey);
    }

    return property.addError(error);
  }

  Stream<AsyncState<State>> updateLoading<State>(
    Object propertyKey,
  ) {
    var property = getProperty(propertyKey);

    if (property is! AsyncLiveStream<State>) {
      throw NotfoundPropertyException(propertyKey);
    }

    return property.loading();
  }
}
