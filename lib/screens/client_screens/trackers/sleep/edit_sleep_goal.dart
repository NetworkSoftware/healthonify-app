import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/sleep_tracker.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class EditSleepGoal extends StatefulWidget {
  final String? defaultBedtime;
  final String? defaultWaketime;
  const EditSleepGoal(
      {required this.defaultBedtime, required this.defaultWaketime, Key? key})
      : super(key: key);

  @override
  State<EditSleepGoal> createState() => _EditSleepGoalState();
}

class _EditSleepGoalState extends State<EditSleepGoal> {
  String? selectedTime1;
  String? selectedTime2;
  bool _isLoading = false;

  void popFunc() {
    Navigator.of(context).pop();
  }

  void updateSleepTime() {
    Provider.of<UserData>(context, listen: false)
        .updateSleepTime(selectedTime2!, selectedTime1!);
  }

  Future<void> putSleepGoal(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (selectedTime1!.isEmpty || selectedTime2!.isEmpty) {
        Fluttertoast.showToast(
            msg: "Please enter your sleep time and wakeup time");
        return;
      }
      String userId =
          Provider.of<UserData>(context, listen: false).userData.id!;
      Map<String, dynamic> sleepGoal = {
        "set": {
          "sleepTime": selectedTime1,
          "wakeupTime": selectedTime2,
        }
      };
      await Provider.of<SleepTrackerProvider>(context, listen: false)
          .putSleepGoal(sleepGoal, userId);

      updateSleepTime();
      popFunc();
    } on HttpException catch (e) {
      log("sleep goal error http $e");
      Fluttertoast.showToast(msg: "Unable to update sleep goal");
    } catch (e) {
      log("sleep goal error $e");
      Fluttertoast.showToast(msg: 'Unable to update sleep goal');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedTime1 = widget.defaultBedtime;
    selectedTime2 = widget.defaultWaketime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Setup your Sleep Tracker'),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Padding(
            //   padding: const EdgeInsets.only(top: 30),
            //   child: Text(
            //     StringDateTimeFormat().subtractTime(
            //         widget.defaultBedtime!, widget.defaultWaketime!),
            //     style: Theme.of(context).textTheme.headlineLarge,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 16),
            //   child: Text(
            //     'Not recommended',
            //     style: Theme.of(context).textTheme.bodySmall,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '7-9 hours is the recommended amount of sleep for all adults from age 18-64, according to sleepfoundation.org',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 12,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    child: InkWell(
                      onTap: () {
                        timePicker1(context);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.46,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.bedtime_outlined,
                                color: orange,
                                size: 34,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  selectedTime1!.isEmpty
                                      ? "Add"
                                      : selectedTime1 == null
                                          ? StringDateTimeFormat()
                                              .stringToTimeOfDay(
                                                  widget.defaultBedtime!)
                                          : StringDateTimeFormat()
                                              .stringToTimeOfDay(
                                                  selectedTime1!),
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Regular sleeping time',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  timePicker1(context);
                                },
                                child: const Text('Edit'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        timePicker2(context);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.46,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.light_mode_outlined,
                                color: orange,
                                size: 34,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  selectedTime2!.isEmpty
                                      ? "Add"
                                      : selectedTime2 == null
                                          ? StringDateTimeFormat()
                                              .stringToTimeOfDay(
                                                  widget.defaultWaketime!)
                                          : StringDateTimeFormat()
                                              .stringToTimeOfDay(
                                                  selectedTime2!),
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Regular waking time',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  timePicker2(context);
                                },
                                child: const Text('Edit'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: orangeGradient,
        ),
        child: TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  putSleepGoal(context);
                  // Navigator.pop(
                  //   context,
                  //   [selectedTime1, selectedTime2],
                  // );
                },
          child: Text(
            'DONE',
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }

  void timePicker1(context) {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        // log(value.hour.toString() + ":" + value.minute.toString() + ":00");
        selectedTime1 = "${value.hour}:${value.minute}:00";
      });
    });
  }

  void timePicker2(context) {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        selectedTime2 = "${value.hour}:${value.minute}:00";
        log(selectedTime2.toString());
      });
    });
  }
}
