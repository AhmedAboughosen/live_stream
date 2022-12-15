
import '../live_stream.dart';
import 'error/errors.dart';

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
    State? Function(State?) updator,
  ) {
    var property = getProperty(propertyKey);

    if (property is! ValueLiveStream<State>) {
      throw NotfoundPropertyException(propertyKey);
    }

    State? newState = updator(property.state);

    property.update(newState);
  }

  State? getValue<State>(
    Object propertyKey,
  ) {
    var property = getProperty(propertyKey);

    if (property is! ValueLiveStream<State>) {
      throw NotfoundPropertyException(propertyKey);
    }

    return property.state;
  }
}

/// BindableObjectAsyncValueMixin
///
mixin BindableObjectAsyncValueMixin on BindableObject {
  Stream<AsyncState<State>> updateAsync<State>(
    Object propertyKey,
    Stream<State> Function() localStream,
  ) {
    var property = getProperty(propertyKey);

    if (property is! AsyncLiveStream<State>) {
      throw NotfoundPropertyException(propertyKey);
    }

    return property.emit(localStream);
  }

  AsyncState<State>? getAsyncValue<State>(
    Object propertyKey,
  ) {
    var property = getProperty(propertyKey);

    if (property is! AsyncLiveStream<State>) {
      throw NotfoundPropertyException(propertyKey);
    }

    return property.state;
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
