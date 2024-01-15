import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/workout_player.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class TodaysWorksout extends StatelessWidget {
  const TodaysWorksout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: "Today's Workout",
         
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                'Warm Up',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Column(
                children: [
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const WorkoutPlayer();
                              },
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(13),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1597586594276-456f8c50b82d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
                                  height: 74,
                                  width: 74,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Warm Up title'),
                                          Icon(Icons.chevron_right_rounded),
                                        ],
                                      ),
                                      Text('10 reps, 1 set'),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Workout',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Column(
                children: [
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1597586594276-456f8c50b82d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
                                height: 74,
                                width: 74,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Workout title'),
                                        Icon(Icons.chevron_right_rounded),
                                      ],
                                    ),
                                    Text('10 reps, 1 set'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
