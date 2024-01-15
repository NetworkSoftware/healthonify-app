
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/assign_workout.dart';
import 'package:healthonify_mobile/widgets/cards/assign_training_card.dart';

class MyClientDetailsScreen extends StatelessWidget {
  const MyClientDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 375,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFFDE8750),
              child: Stack(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12, left: 18),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.5),
                              radius: 18,
                              child: const Icon(
                                Icons.chevron_left_rounded,
                                color:  Color(0xFF717579),
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child:  CircleAvatar(
                            backgroundImage:  NetworkImage(
                              'https://images.unsplash.com/photo-1577565177023-d0f29c354b69?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                            ),
                            radius: 82,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Client Name',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: whiteColor),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'HLTFY - 1270',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: whiteColor),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'PT Client',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: whiteColor),
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ExpertHomeCards(
                  cardTitle: 'Assign Training Program',
                  cardSubTitle: 'View Training Program details',
                  imagePath: 'assets/icons/dumbell.png',
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AssignWorkoutScreen();
                        },
                      ),
                    );
                  },
                ),
                ExpertHomeCards(
                  cardTitle: 'Current Diet Plan',
                  cardSubTitle: 'View your diet plans',
                  imagePath: 'assets/icons/apple.png',
                  onPress: () {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ExpertHomeCards(
                  cardTitle: 'Check In',
                  cardSubTitle: 'Check in with your clients',
                  imagePath: 'assets/icons/dumbell.png',
                  onPress: () {},
                ),
                ExpertHomeCards(
                  cardTitle: 'Personal Training',
                  cardSubTitle: 'View your diet plans',
                  imagePath: 'assets/icons/man.png',
                  onPress: () {},
                ),
              ],
            ),
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
