import 'package:flutter/material.dart';
import 'package:reactive_live_stream/live_stream.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Stream Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterPage(),
    );
  }
}

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
    updateValue<int>(#counter, (old) => old! + 1);
  }

  void decrement() {
    updateValue<int>(#counter, (old) => old! - 1);
  }
}

final liveStream = CounterLiveStream();

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LiveStreamProvider<CounterLiveStream>(
      create: liveStream,
      child: Scaffold(
        appBar: AppBar(title: const Text('Live Stream Counter')),
        body: Center(child: const CounterText()),
        floatingActionButton: FloatingButton(),
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              LiveStreamProvider.of<CounterLiveStream>(context).increment();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              LiveStreamProvider.of<CounterLiveStream>(context).decrement();
            },
          ),
        ),
      ],
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      LiveStreamBuilder<CounterLiveStream, int>(
        propertyKey: #counter,
        builder: (context, ValueListenable state) {
          return Center(
            child: Text('${state.value}'),
          );
        },
      );
}
