import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:vibration/vibration.dart';

void main() {
  runApp(const MyApp());
}

class MyArc extends StatelessWidget {
  final double diameter;
  final double percent;

  const MyArc({super.key, this.diameter = 200, this.percent = 100.00});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      0,
      math.pi / 2,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  Timer? _timer;
  int _start = 60 * 1000;
  int _set = 0;

  void setNewTimer(int time) {
    setState(() {
      _start = time * 50;
      _set = time * 50;
    });

    startTimer();
  }

  Future<void> endTimer() async {
    setState(() {
      _start = 0;
      _timer!.cancel();
    });

    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(amplitude: 80, duration: 1000);
      await Future.delayed(const Duration(milliseconds: 500));
      Vibration.vibrate(amplitude: 80, duration: 1000);
      await Future.delayed(const Duration(milliseconds: 500));
      Vibration.vibrate(amplitude: 80, duration: 1000);
      await Future.delayed(const Duration(milliseconds: 500));
      Vibration.vibrate(amplitude: 80, duration: 1000);
    }
  }

  void startTimer() {
    const milliseconds = Duration(milliseconds: 20);
    _timer = Timer.periodic(
      milliseconds,
      (Timer timer) {
        if (_start <= 0) {
          endTimer();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
      backgroundColor: const Color.fromARGB(255, 36, 39, 44),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: SizedBox.expand(
        child: Builder(builder: (context) {
          if (_timer != null && _timer!.isActive) {
            return FractionallySizedBox(
              // widthFactor: 0.5,
              heightFactor: _timer!.tick / _set,
              alignment: FractionalOffset.topCenter,
              child: const DecoratedBox(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 74, 95, 124)),
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text('30 Seconds'),
                        onPressed: () => {setNewTimer(30)},
                      ),
                      ElevatedButton(
                        child: const Text('5 Minutes'),
                        onPressed: () => {setNewTimer(60 * 5)},
                      ),
                      ElevatedButton(
                        child: const Text('10 Minutes'),
                        onPressed: () => {setNewTimer(60 * 10)},
                      ),
                      ElevatedButton(
                        child: const Text('15 Minutes'),
                        onPressed: () => {setNewTimer(60 * 15)},
                      ),
                    ]),
              ),
            ],
          );
        }),
      )),
    );
  }
}
