import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/trackers/sleep_tracker.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class AddSleepLog extends StatefulWidget {
  const AddSleepLog({Key? key}) : super(key: key);

  @override
  State<AddSleepLog> createState() => _AddSleepLogState();
}

class _AddSleepLogState extends State<AddSleepLog> {
  String selectedTime1 = "";
  String selectedTime2 = "";
  String selectedDate1 = "";
  String selectedDate2 = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedDate1 =
        DateFormat.yMMMMd().format(DateTime.now().subtract(const Duration(days: 1)));
  }

  Map<String, dynamic> sleepLog = {
    "userId": "",
    "date": "",
    "sleepTime": "",
    "wakeupTime": ""
  };

  void popFunc() {
    Navigator.of(context).pop();
  }

  void localUpdateSleepCount(int value) {
    Provider.of<AllTrackersData>(context, listen: false).localUpdateSleepCount(
      value,
    );
  }

  Future<void> putSleepGoal(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (selectedTime1.isEmpty || selectedTime2.isEmpty) {
        Fluttertoast.showToast(msg: "Add your sleep time and wake up time");
        setState(() {
          _isLoading = false;
        });
        return;
      }
      String userId =
          Provider.of<UserData>(context, listen: false).userData.id!;
      sleepLog["userId"] = userId;
      sleepLog["date"] = DateFormat("yyyy-MM-dd").format(DateTime.now());
      sleepLog["sleepTime"] = selectedTime1;
      sleepLog["wakeupTime"] = selectedTime2;

      log(sleepLog.toString());

      await Provider.of<SleepTrackerProvider>(context, listen: false)
          .postSleepLogs(sleepLog);

      int value = StringDateTimeFormat()
          .subtractTimesToSeconds(selectedTime2, selectedTime1);
      // log("sleepsssss  " + value.toString());
      await Provider.of<AllTrackersData>(context, listen: false)
          .getAllTrackers(userId).then((response) {
        localUpdateSleepCount(value);
      });

      popFunc();
    } on HttpException catch (e) {
      log("sleep log error http $e");
      Fluttertoast.showToast(msg: "Unable to update sleep log");
    } catch (e) {
      log("sleep log error $e");
      Fluttertoast.showToast(msg: 'Unable to update sleep log');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add sleep log'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 30),
              //   child: Text(
              //     DateFormat.yMMMMd().format(DateTime.now()),
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
              // Padding(
              //   padding: const EdgeInsets.all(16),
              //   child: Text(
              //     '7-9 hours is the recommended amount of sleep for all adults from age 18-64, according to sleepfoundation.org',
              //     textAlign: TextAlign.center,
              //     style: Theme.of(context).textTheme.bodySmall!.copyWith(
              //           fontSize: 12,
              //         ),
              //   ),
              // ),
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
                                  child: Row(
                                    children: [
                                      Text(
                                        selectedDate1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          selectedDate1 = DateFormat.yMMMMd()
                                              .format(DateTime.now());
                                          setState(() {});
                                        },
                                        child: const Icon(Icons.arrow_forward),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    selectedTime1.isEmpty
                                        ? ""
                                        : StringDateTimeFormat()
                                            .stringToTimeOfDay(selectedTime1),
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Your sleep time',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    timePicker1(context);
                                  },
                                  child: Text(
                                      selectedTime1.isEmpty ? 'Add' : 'Edit'),
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
                                    DateFormat.yMMMMd().format(DateTime.now()),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    selectedTime2.isEmpty
                                        ? ""
                                        : StringDateTimeFormat()
                                            .stringToTimeOfDay(selectedTime2),
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Your wakeup time',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    timePicker2(context);
                                  },
                                  child: Text(
                                      selectedTime2.isEmpty ? 'Add' : 'Edit'),
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
              sleepTable(context),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                    '''The amount of sleep you need depends on various factors — especially your age. While
sleep needs vary significantly among individuals, consider these general guidelines for
different age groups .The American Academy of Sleep Medicine (AASM) and the Sleep Research Society (SRS) have recommended that adults aged 18 to 60 years should sleep seven or more hours per night on a regular basis for ideal sleep health.

Sleep disorders and chronic sleep loss can put you at risk for:

Heart disease.
Heart attack.
Heart failure.
Irregular heartbeat.
High blood pressure.
Stroke.
Diabetes.''',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading) const CircularProgressIndicator(),
            ],
          ),
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

  Widget sleepTable(BuildContext context) {
    var tableTextStyle = Theme.of(context).textTheme.bodySmall;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Table(
              border: TableBorder.all(
                color: Theme.of(context).textTheme.bodySmall!.color!,
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Age Group', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Recommended amount of sleep',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('3 to 5 years', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('10 to 13 hours per 24 hours including naps',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('6 to 12 years', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('9 to 12 hours per 24 hours',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('13 to 18 years', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('8 to 10 hours per 24 hours',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Adults', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('7 or more hours a night',
                          style: tableTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
