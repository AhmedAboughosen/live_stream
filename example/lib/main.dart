import 'package:example/features/login/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/live_stream.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
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
    updateValue<int>(#counter, (old) {
      int newValue = old! + 1;
      return newValue;
    });
  }

  void decrement() {
    updateValue<int>(#counter, (old) {
      int newValue = old! - 1;
      return newValue;
    });
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LiveStreamProvider<CounterLiveStream>(
      create: CounterLiveStream(),
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
