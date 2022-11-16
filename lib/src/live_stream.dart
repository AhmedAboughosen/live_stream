import 'package:rxdart/rxdart.dart';

abstract class StreamBase<T> {
  void onClose();

  ValueStream get listener;
}
