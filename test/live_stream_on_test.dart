import 'package:flutter_test/flutter_test.dart';

import 'liveStream/Counter_live_stream.dart';

const delay = Duration(milliseconds: 30);

Future<void> wait() => Future.delayed(delay);

Future<void> tick() => Future.delayed(Duration.zero);

void main() {
  late final CounterLiveStream liveStream;

  setUp(() {
    liveStream = CounterLiveStream();

    liveStream.init();
  });

  test('processes events concurrently by default', () async {
    final states = <dynamic>[];
    liveStream.getProperty(#counter).stream.listen(states.add);

    await tick();
    await wait();

    expect(states, equals([0]));
  });

  test('should get 0 1  for the number from the counter state', () async {
    final states = <dynamic>[];
    liveStream.getProperty(#counter).stream.listen(states.add);

    liveStream.increment();
    await tick();
    await wait();

    expect(states, equals([0, 1]));
  });

  test('should get 0 1 2 1  for the number from the counter state', () async {
    final states = <dynamic>[];
    liveStream.getProperty(#counter).stream.listen(states.add);

    liveStream.increment();
    liveStream.increment();
    liveStream.decrement();
    await tick();
    await wait();

    expect(states, equals([0, 1, 2, 1]));
  });

  test('close all stream', () async {
    liveStream.dispose();

    expect(liveStream.properties, []);
  });
}
