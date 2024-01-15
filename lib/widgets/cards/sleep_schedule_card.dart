import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/sleep/edit_sleep_goal.dart';
import 'package:provider/provider.dart';

class SleepScheduleCard extends StatelessWidget {
  const SleepScheduleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserData>(context).userData;
    String bedTime =
        StringDateTimeFormat().stringToTimeOfDay(userData.sleepTime!);
    String wakeUp =
        StringDateTimeFormat().stringToTimeOfDay(userData.wakeupTime!);
    return bedTime.isEmpty || wakeUp.isEmpty
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.96,
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Set your sleep goal",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditSleepGoal(
                                  defaultBedtime: userData.sleepTime!,
                                  defaultWaketime: userData.wakeupTime!,
                                );
                              }));
                              // bedTime = result[0];
                              // wakeUp = result[1];
                            },
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Edit',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: orange,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width * 0.96,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Every Day',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.king_bed_outlined,
                                  color: Color(0xFF7E8285),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'BED TIME',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Text(
                              bedTime,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.notifications_outlined,
                                  color: Color(0xFF7E8285),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'WAKE UP',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Text(
                              wakeUp,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EditSleepGoal(
                                defaultBedtime: userData.sleepTime!,
                                defaultWaketime: userData.wakeupTime!,
                              );
                            }));
                            // bedTime = result[0];
                            // wakeUp = result[1];
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Edit',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: orange,
                                  ),
                            ),
                          ),
                        ),
                        // Text(editScreenData.selection1),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
