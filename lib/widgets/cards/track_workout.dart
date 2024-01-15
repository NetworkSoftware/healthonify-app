import 'package:flutter/material.dart';

class TrackWorkoutCard extends StatelessWidget {
  const TrackWorkoutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundImage:  NetworkImage(
                              'https://images.unsplash.com/photo-1601986313624-28c11ac26334?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Column(
                            children: [
                              Text(
                                'Workout Name',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                '10 reps, 1 set',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '20 Cal',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color:  Color(0xFF7E8285),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
