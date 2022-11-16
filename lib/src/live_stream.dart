import 'package:rxdart/rxdart.dart';

abstract class StreamBase<T> {
  void onClose();

  ValueStream<T?> get listener;
}
