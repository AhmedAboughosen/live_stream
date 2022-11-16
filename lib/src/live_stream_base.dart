import 'package:live_stream_base/live_stream.dart';

abstract class LiveStreamBase {
  List<StreamBase> liveStreamList = [];

  void dispose() {
    for (int i = 0; i < liveStreamList.length; ++i) {
      liveStreamList[i].onClose();
    }
  }
}
