import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/food_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({Key? key}) : super(key: key);

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
                  return FoodScreen();
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
                      'Calories',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.restaurant,
                        color: Color(0xFFff7f3f),
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
                    progressColor: const Color(0xFFff7f3f),
                    backgroundColor: Colors.white,
                    lineWidth: 18,
                    percent: 0.6,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  '1200',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Text(
                      'of 2000 cal eaten',
                      style: Theme.of(context).textTheme.bodySmall,
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
