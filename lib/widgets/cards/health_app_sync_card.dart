import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/main.dart';

class SyncHealthAppCard extends StatefulWidget {
  const SyncHealthAppCard({Key? key}) : super(key: key);

  @override
  State<SyncHealthAppCard> createState() => _SyncHealthAppCardState();
}

class _SyncHealthAppCardState extends State<SyncHealthAppCard> {
  StepTrackerData stepsData = StepTrackerData();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.96,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You are connected via :',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      IconButton(
                        onPressed: () async {
                          preferences.setBool("isGoogleRequest", true);
                          DateTime startDate = DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day);
                          stepsData =
                              await StepTracker().initHealth(1, startDate);

                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.sync,
                          color: Color(0xFF0C9DE9),
                        ),
                        splashRadius: 16,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/health_icon.png',
                        height: 34,
                        width: 34,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Google Fit',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Text(
                  //   'Gadgets',
                  //   style: Theme.of(context).textTheme.labelMedium,
                  // ),
                  // Row(
                  //   children: [
                  //     Image.asset(
                  //       'assets/icons/gadgets.png',
                  //       height: 34,
                  //       width: 34,
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 8),
                  //       child: Text(
                  //         'Apple Watch',
                  //         style: Theme.of(context).textTheme.bodyMedium,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   // ignore: prefer_const_literals_to_create_immutables
                  //   children: [
                  //     Text(
                  //       'Last synced at : Today 10:20 am',
                  //       style: Theme.of(context).textTheme.bodyMedium,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
