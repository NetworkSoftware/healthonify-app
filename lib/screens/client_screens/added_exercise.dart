import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class AddedWorkoutScreen extends StatelessWidget {
  const AddedWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAutoplay = false;
    return Scaffold(
      appBar:  CustomAppBar(
        appBarTitle: 'Exercise 1',
        widgetRight: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.delete_outline,
            color: whiteColor,
            size: 28,
          ),
          splashRadius: 20,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.teal[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Day Name : Abs',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      log('bruv!');
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.black,
                      size: 26,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              color: Colors.cyan[200],
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Enable Autoplay',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  const Spacer(),
                  StatefulBuilder(
                    builder: (context, newState) => Switch(
                      inactiveTrackColor: Colors.grey[600],
                      value: isAutoplay,
                      onChanged: (val) {
                        newState(() {
                          isAutoplay = !isAutoplay;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.black,
                      size: 26,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            ListTile(
              tileColor: Theme.of(context).canvasColor,
              onTap: () {},
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'No notes added',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.blue,
                    size: 28,
                  ),
                ],
              ),
            ),
            customExerciseCard(context),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 56,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 56,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Copy From Plan',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: whiteColor),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: orangeGradient,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Add New Exercise',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: whiteColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customExerciseCard(context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            Container(
              height: 46,
              decoration: const BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Round 1 (3 sets)',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset(
                      'assets/icons/image_placeholder.png',
                      // width: 90,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Bodyweight Leg Raise',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: orange,
                                  size: 22,
                                ),
                                splashRadius: 20,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: orange,
                                  size: 22,
                                ),
                                splashRadius: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Abs',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sequence No : 1',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '3 sets',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: Row(
                children: [
                  Text(
                    'Note: note',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
