import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WeightCard extends StatelessWidget {
  const WeightCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      width: MediaQuery.of(context).size.width * 0.45,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const WeightScreen();
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Row(
                  children: [
                    Text(
                      'Weight',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child:  Icon(
                        Icons.accessibility_new_rounded,
                        color: Color(0xFFE80945),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 82,
                    animation: true,
                    animationDuration: 2000,
                    progressColor: const Color(0xFFE80945),
                    backgroundColor: Colors.white,
                    lineWidth: 18,
                    percent: 0.25,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  '1 ',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Text(
                      'of 4 kg lost',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFFF6666),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
