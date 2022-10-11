import 'package:flutter/material.dart';

import 'package:huawei_map/map.dart';
import 'package:huawei_push/huawei_push.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _token = '';

  void _onTokenEvent(String event) {
    // Requested tokens can be obtained here
    setState(() {
      _token = event;
    });
    print("TokenEvent!: " + _token);
  }

  void _onTokenError(Object error) {
    //PlatformException e = error;
    print("TokenErrorEvent!: " + error.toString());
  }

  void _onMessageReceived(RemoteMessage remoteMessage) {
    // Called when a data message is received
    String? data = remoteMessage.data;
    print("Push Notification:: " + data.toString());
  }

  void _onMessageReceiveError(Object error) {
    // Called when an error occurs while receiving the data message
  }

  void initState() {
    //HuaweiMapInitializer.initializeMap();
    super.initState();
    initTokenStream();
    initMessageStream();
    initMessageStreamForBackground();
    getToken();
    subscribe();
  }

  Future<void> initTokenStream() async {
    if (!mounted) return;
    Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
  }

  Future<void> initMessageStream() async {
    if (!mounted) return;
    Push.onMessageReceivedStream
        .listen(_onMessageReceived, onError: _onMessageReceiveError);
  }

  Future<void> initMessageStreamForBackground() async {
    //print("idkidk");
    bool backgroundMessageHandler =
        await Push.registerBackgroundMessageHandler(backgroundMessageCallback);
    print("backgroundMessageHandler registered: $backgroundMessageHandler");
  }

  static void backgroundMessageCallback(RemoteMessage remoteMessage) async {
    String? data = remoteMessage.data;

    Push.localNotification({
      HMSLocalNotificationAttr.TITLE: '[Headless] DataMessage Received',
      HMSLocalNotificationAttr.MESSAGE: data
    });
  }

  void getToken() async {
    // Call this method to request for a token
    print("___Request for a token !!!!!!!!!");
    Push.getToken("");
  }

  void subscribe() async {
    String topic = "testTopic";
    String result = await Push.subscribe(topic);
    print("pushsubscribe token !!");
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Stack(
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            const HuaweiMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(41.012959, 28.997438),
                zoom: 12,
              ),
              mapType: MapType.normal,
              tiltGesturesEnabled: true,
            )
          ]),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
