import 'package:flutter/material.dart';
import 'package:live_stream/src/live_stream_provider.dart';

import '../../liveStream/login_live_stream.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        LiveStreamProvider.of<LoginLiveStream>(context).login();
      },
      color: Colors.blue,
      child: const Text(
        "Login",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
