import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MacacaApp());

class MacacaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Macaca App',
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
        primarySwatch: Colors.brown,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(title: "Mover's tools"),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainPage> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  String _banner = "";
  double _interval = 1.0;
  double _interimInterval = 1.0;
  int _variance = 0;
  double _interimVariance = 0;

  AnimationController _controller;
  CurvedAnimation _animation;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 10),
      reverseDuration: Duration(milliseconds: 400),
    );

    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showNewInstruction() {
    setState(() {
      _banner = "beat";
    });
    _controller.reset();
    _controller.forward().then<TickerFuture>((value) => _controller.reverse());
    if (_isPlaying) scheduleInstruction();
  }

  void scheduleInstruction() {
    const ms = const Duration(milliseconds: 1000);
    Random random = Random();
    var duration =
        ms * _interval * (1 + random.nextDouble() * (_variance / 100));
    _timer = new Timer(duration, showNewInstruction);
  }

  void runGadget() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (!_isPlaying) {
        _banner = "";
        _timer.cancel();
      }
    });
    if (_isPlaying) scheduleInstruction();
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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Time interval',
                      ),
                      Text(
                        _interimInterval.toStringAsFixed(1) + 's',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value: _interimInterval,
                    min: 0.5,
                    max: 7.5,
                    divisions: 70,
                    onChanged: (value) {
                      setState(() {
                        _interimInterval = value;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        _interval = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Rhythm Breaker',
                      ),
                      Text(
                        _interimVariance.toStringAsFixed(0) + '%',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value: _interimVariance,
                    min: 0,
                    max: 300,
                    divisions: 30,
                    onChanged: (value) {
                      setState(() {
                        _interimVariance = value;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        _variance = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: runGadget,
              tooltip: (_isPlaying ? 'Pause' : 'Play'),
              child: (_isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow)),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0xFF343A40)),
              child: FadeTransition(
                opacity: _animation,
                child: Text('$_banner'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF91FF00),
                      fontSize: 60,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
