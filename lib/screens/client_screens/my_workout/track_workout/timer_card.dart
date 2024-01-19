import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:healthonify_mobile/constants/theme_data.dart';

class ElapsedTime {
  final int? hundreds;
  final int? seconds;
  final int? minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle =
      const TextStyle(fontSize: 40.0, fontFamily: "Bebas Neue");
  final Stopwatch stopwatch = Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}

class TimerCard extends StatefulWidget {
  final Function saveTime;
  const TimerCard({Key? key, required this.saveTime}) : super(key: key);

  @override
  TimerCardState createState() => TimerCardState();
}

class TimerCardState extends State<TimerCard> {
  final Dependencies dependencies = Dependencies();

  @override
  void initState() {
    super.initState();
    rightButtonPressed();
  }

  void leftButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        log("${dependencies.stopwatch.elapsedMilliseconds}");
      } else {
        dependencies.stopwatch.reset();
      }
    });
  }

  void rightButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        dependencies.stopwatch.stop();
      } else {
        dependencies.stopwatch.start();
      }
    });
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
        const TextStyle(fontSize: 14.0, color: Colors.white);
    return TextButton(
        onPressed: callback, child: Text(text, style: roundTextStyle));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(child: TimerText(dependencies: dependencies)),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: buildFloatingButton(
                    dependencies.stopwatch.isRunning ? "stop" : "resume",
                    rightButtonPressed),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                dependencies.stopwatch.stop();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: const Text('Do you wish to end this workout?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          dependencies.stopwatch.start();
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          var data = dependencies.stopwatch.elapsedMilliseconds;
                          int minutes = (data / 60000).ceil();
                          widget.saveTime(minutes.toString());
                        },
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Finish workout"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class TimerText extends StatefulWidget {
  const TimerText({Key? key, required this.dependencies}) : super(key: key);
  final Dependencies? dependencies;

  @override
  TimerTextState createState() => TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({required this.dependencies});
  final Dependencies? dependencies;
  Timer? timer;
  int? milliseconds;

  @override
  void initState() {
    timer = Timer.periodic(
        Duration(milliseconds: dependencies!.timerMillisecondsRefreshRate),
        callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies!.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies!.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds! / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies!.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RepaintBoundary(
          child: SizedBox(
            child: MinutesAndSeconds(dependencies: dependencies!),
          ),
        ),
        RepaintBoundary(
          child: SizedBox(
            child: Hundreds(dependencies: dependencies!),
          ),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  const MinutesAndSeconds({Key? key, required this.dependencies})
      : super(key: key);
  final Dependencies? dependencies;

  @override
  MinutesAndSecondsState createState() =>
      MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({required this.dependencies});
  final Dependencies? dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies!.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes!;
        seconds = elapsed.seconds!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(3, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    // log(minutes.toString());
    if (minutes > 60) {
      minutesStr = "$minutes";
    }
    return Text('$minutesStr:$secondsStr.', style: dependencies!.textStyle.copyWith(color: whiteColor,fontSize: 24));
  }
}

class Hundreds extends StatefulWidget {
  const Hundreds({Key? key, required this.dependencies}) : super(key: key);
  final Dependencies? dependencies;

  @override
  HundredsState createState() => HundredsState(dependencies: dependencies!);
}

class HundredsState extends State<Hundreds> {
  HundredsState({required this.dependencies});
  final Dependencies? dependencies;

  int hundreds = 0;

  @override
  void initState() {
    dependencies!.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    // log(hundredsStr);
    return Text(hundredsStr, style: dependencies!.textStyle.copyWith(color: whiteColor,fontSize: 24));
  }
}
