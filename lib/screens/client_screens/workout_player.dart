import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/next_workout.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'dart:async';

class WorkoutPlayer extends StatefulWidget {
  const WorkoutPlayer({Key? key}) : super(key: key);

  @override
  State<WorkoutPlayer> createState() => _WorkoutPlayerState();
}

class _WorkoutPlayerState extends State<WorkoutPlayer> {
  late Timer _timer;

  double _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(
            () {
              timer.cancel();
            },
          );
        } else {
          setState(
            () {
              _start--;
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
         
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Workout Title',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '$_start',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '10 reps, 1 set',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 5),
          Image.network(
            'https://images.unsplash.com/photo-1598971457999-ca4ef48a9a71?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
            height: 292,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          LinearProgressIndicator(
            value: _start * 0.1,
            color: const Color(0xFFff7f3f),
            backgroundColor: const Color(0xFFFBFBFB),
            minHeight: 14,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                '10 reps, 1 set',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'PREV',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'prev-btn',
                  onPressed: () {},
                  backgroundColor: const Color(0xFFFBFBFB),
                  child: const Icon(
                    Icons.skip_previous,
                    color: Color(0xFFE9BE0C),
                    size: 32,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'play-btn',
                  onPressed: () {
                    startTimer();
                  },
                  backgroundColor: const Color(0xFFE9BE0C),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'next-btn',
                  onPressed: () {},
                  backgroundColor: const Color(0xFFFBFBFB),
                  child: const Icon(
                    Icons.skip_next,
                    color:  Color(0xFFE9BE0C),
                    size: 32,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const NextWorkout();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'NEXT',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
