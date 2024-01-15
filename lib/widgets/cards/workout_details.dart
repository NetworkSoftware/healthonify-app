import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WorkoutDetailsCard extends StatelessWidget {
  const WorkoutDetailsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 188,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '200 Cal',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                Text(
                  'out of 300 Cal burnt',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 150,
                  animation: true,
                  animationDuration: 2000,
                  progressColor: const Color(0xFFff7f3f),
                  backgroundColor: Colors.white,
                  center: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFff7f3f),
                    size: 42,
                  ),
                  lineWidth: 30,
                  percent: 0.66,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
