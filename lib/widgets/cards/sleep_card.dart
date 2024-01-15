import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/sleep/sleep_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SleepCard extends StatelessWidget {
  const SleepCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: SizedBox(
          height: 114,
          width: MediaQuery.of(context).size.width * 0.98,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SleepScreen();
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Sleep',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Image.asset(
                            'assets/icons/moon.png',
                            height: 18,
                            width: 18,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFFFF6666),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          '3 ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'of 6 hours slept',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: LinearPercentIndicator(
                      percent: 0.5,
                      progressColor: const Color(0xFF0C9DE9),
                      backgroundColor: Colors.white,
                      animation: true,
                      animationDuration: 2000,
                      lineHeight: 7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
