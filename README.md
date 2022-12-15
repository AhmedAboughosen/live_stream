# Live Stream 


A lightweight, yet powerful way to bind your application state with your business logic.




## Quick  Live Stream 

Lets take a look at how to use LiveStreamProvider to provide a CounteLiveStream to a CounterPage and react to state changes with LiveStreamBuilder.


```dart
 class CounterLiveStream extends LiveStream {
  @override
  void init() {
  //register your state
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

```
## Register your state



```dart
//decalre your key
 registerProperty<int>(
        #counter,
        BindableProperty.$value<int>(
          initial: 0,
        ));

```

## main.dart

Stream Fluent Validation  also supports multiple validation checks   like this:

```dart

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



```

## counter_page.dart 

```dart

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
 ```  
 
## LiveStreamBuilder 
LiveStreamBuilder is a Flutter widget which requires a key and a builder function. LiveStreamBuilder handles building the widget in response to new states. LiveStreamBuilder is very similar to StreamBuilder but has a more simple API to reduce the amount of boilerplate code needed. The builder function will potentially be called many times and should be a pure function that returns a widget in response to the state.

```dart


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
 ```  
 
 ## LiveStreamListener 
LiveStreamListener is a Flutter widget which takes a LiveStreamWidgetListener and an optional liveStream and invokes the listener in response to state changes in the liveStream. It should be used for functionality that needs to occur once per state change such as navigation, showing a SnackBar, showing a Dialog, etc...

listener is only called once for each state change ( including the initial state) live  builder in LiveStreamBuilder and is a LiveStreamBuilder function.

```dart


    @override
  Widget build(BuildContext context) {
    return LiveStreamProvider<LiveStream>(
      create: liveStream,
      child: Scaffold(
          appBar: AppBar(),
          body: LiveStreamListener<LoginLiveStream, State>(
            listener: (context, ValueListenable state) {

              print("state");
            },
            propertyKey: #api,
            child: Column(
              children: const [
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          )),
    );
  }
 ```  
 ## LiveStreamProvider  
LiveStreamProvider is a Flutter widget which provides a liveStream to its children via LiveStreamProvider.of<T>(context). It is used as a dependency injection (DI) widget so that a single instance of a liveStream can be provided to multiple widgets within a subtree.
```dart


    @override
  Widget build(BuildContext context) {
    return LiveStreamProvider<LiveStream>(
      create: liveStream,
      child : ChildA()
    );
  }
 ```  

 ## MultiLiveStreamListener 
MultiLiveStreamListener is a Flutter widget that merges multiple LiveStreamListener widgets into one. MultiLiveStreamListener improves the readability and eliminates the need to nest multiple LiveStreamListener.

 ## MultiLiveStreamProvider
MultiLiveStreamProvider is a Flutter widget that merges multiple LiveStreamProvider widgets into one. MultiLiveStreamProvider improves the readability and eliminates the need to nest multiple LiveStreamProvider.



## Contributing
Feel free to do a pull request with any ideas and I will check each one.
¬ Rad
