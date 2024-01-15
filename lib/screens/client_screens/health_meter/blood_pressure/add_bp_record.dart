import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/vitals/blood_pressure_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class AddBpRecord extends StatefulWidget {
  const AddBpRecord({Key? key}) : super(key: key);

  @override
  State<AddBpRecord> createState() => _AddBpRecordState();
}

class _AddBpRecordState extends State<AddBpRecord> {
  int selectedVal1 = 0;
  int selectedVal2 = 0;
  int selectedVal3 = 0;
  bool _isLoading = false;

  DateTime dateTime = DateTime.now();

  Map<String, String> data = {
    "userId": "",
    "date": "",
    "time": "",
    "systolic": "",
    "diastolic": "",
    "pulse": ""
  };

  onSubmit(BuildContext context) {
    log(selectedVal1.toString());
    log(selectedVal2.toString());
    log(selectedVal3.toString());

    String date = DateFormat("MM-dd-yyyy").format(dateTime);
    log(date);

    String time = DateFormat("HH:mm:ss").format(dateTime);
    log(time);

    if (selectedVal1 == 0) {
      Fluttertoast.showToast(msg: "Your systolic reading cannot be 0");
      return;
    }
    if (selectedVal2 == 0) {
      Fluttertoast.showToast(msg: "Your diastolic reading cannot be 0");
      return;
    }
    if (selectedVal3 == 0) {
      Fluttertoast.showToast(msg: "Your pulse reading cannot be 0");
      return;
    }

    data["systolic"] = selectedVal1.toString();
    data["diastolic"] = selectedVal2.toString();
    data["pulse"] = selectedVal3.toString();
    data["date"] = date;
    data["time"] = time;

    storeBp(context, data);
  }

  void popFunc() {
    Navigator.of(context).pop();
  }

  Future<void> storeBp(BuildContext context, Map<String, String> data) async {
    setState(() {
      _isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    data["userId"] = userId;

    log(data.toString());
    try {
      await Provider.of<BloodPressureData>(context, listen: false)
          .storeBpData(data);
      popFunc();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to store logs");
    } catch (e) {
      log("Error bp widget $e");
      Fluttertoast.showToast(msg: "Unable to store logs");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void getSelectedVal1(int value) => selectedVal1 = value;

  void getSelectedVal2(int value) => selectedVal2 = value;

  void getSelectedVal3(int value) => selectedVal3 = value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add BP Record'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: darkGrey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 222,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                'Systolic',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                'mmHg',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 20),
                              cupertinoPicker(context, getSelectedVal1, 120),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                'Diastolic',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                'mmHg',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 20),
                              cupertinoPicker(context, getSelectedVal2, 70),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                'Pulse',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                'BPM',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 20),
                              cupertinoPicker(context, getSelectedVal3, 70),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.deepOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Hypertension Stage 1',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.help_outline_outlined,
                    color: whiteColor,
                    size: 22,
                  ),
                  splashRadius: 20,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'SYS 130-139 or DIA 80-89',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 42,
                child: Center(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      List colors = [
                        Colors.red,
                        Colors.green,
                        Colors.blue,
                        Colors.cyan,
                        Colors.pink,
                        Colors.yellow,
                      ];
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.175,
                          decoration: BoxDecoration(
                            color: colors[index],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'If you have 3 or more readings in an area, please consult a doctor regarding prescriptions.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Date & Time',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: const Text('Note +'),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: darkGrey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StatefulBuilder(
                  builder: (context, thisState) => CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle:
                            Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    child: CupertinoDatePicker(
                      initialDateTime: dateTime,
                      maximumDate: dateTime,
                      use24hFormat: false,
                      onDateTimeChanged: (DateTime newDateTime) {
                        thisState(() {
                          dateTime = newDateTime;
                          // log(dateTime.toString());
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GradientButton(
                      title: 'SAVE',
                      func: () {
                        // Navigator.pop(context);
                        onSubmit(context);
                      },
                      gradient: orangeGradient,
                    ),
            ),
            const SizedBox(height: 10),
            bloodPressureTable(context),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '''Blood pressure is the pressure of blood pushing against the walls of your arteries. Blood pressure is measured using two numbers:
The first number, called systolic blood pressure, measures the pressure in
your arteries when your heart beats.
The second number, called diastolic blood pressure, measures the pressure
in your arteries when your heart rests between beats.
Hence, BP 120/80 mm Hg means 120 is the systolic number, and 80 is
the diastolic number.

High blood pressure is more likely to cause:

Heart attack
Stroke
Heart failure
Vision loss
Kidney failure
Dementia
Erectile dysfunction
''',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.blue[500], fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bloodPressureTable(BuildContext context) {
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
                      child: Text('Category', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Systolic (mmHg)', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Diastolic (mmHg)', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Management', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Normal', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('120 or less', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('80 or less', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('N/A', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Elevated', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('120 - 129', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('80 or less', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                          'People with elevated blood pressure are at risk of high blood pressure unless steps are taken to control it.',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child:
                          Text('Hypertension stage I', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('130 - 139', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('80 - 89', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                          'Doctors may prescribe blood pressure medications and some lifestyle changes to reduce the risk of heart diseases and stroke.',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child:
                          Text('Hypertension stage II', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('140 - 159', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('90 - 99', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                          'Doctors may prescribe a combination of both medications and lifestyle changes.',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Hypertensive Crisis', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('180 or higher', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('120 or higher', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                          'This is the most critical condition and requires emergency medical attention.',
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

  Widget cupertinoPicker(context, Function getFunc, int initialValue) {
    return Expanded(
      flex: 1,
      child: CupertinoPicker(
        scrollController:
            FixedExtentScrollController(initialItem: initialValue),
        magnification: 1.25,
        squeeze: 1.5,
        useMagnifier: true,
        itemExtent: 36,
        onSelectedItemChanged: (value) {
          getFunc(value);
        },
        children: List<Widget>.generate(
          499,
          (int index) => Center(
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          growable: false,
        ),
      ),
    );
  }
}
