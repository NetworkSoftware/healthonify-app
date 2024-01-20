import 'dart:developer';
import 'package:healthonify_mobile/main.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/vitals/vitals_list.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/vitals/all_vitals.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/vitals/blood_pressure_data.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/blood_pressure/add_bp_record.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/vitals/blood_pressure_top_card.dart';
import 'package:provider/provider.dart';

class BloodPressureScreen extends StatefulWidget {
  final String? userId;

  const BloodPressureScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  int? _value = 0;
  List<Map<String, String>> items = [
    {
      'key': "Today",
      'value': "today",
    },
    {
      'key': "Week",
      'value': "weekly",
    },
    {
      'key': "Month",
      'value': "monthly",
    },
    {
      'key': "Year",
      'value': "yearly",
    },
  ];

  late String userId;

  Future<void> getbloodPressure(BuildContext context) async {
    userId = widget.userId == null
        ? Provider.of<UserData>(context, listen: false).userData.id!
        : widget.userId!;
    try {
      await Provider.of<BloodPressureData>(context, listen: false)
          .getBpData(userId, items[_value!]["value"]!);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error enquiry widget $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> editBp(BuildContext context, String bpId) async {
    try {
      await Provider.of<BloodPressureData>(context, listen: false)
          .editBpData(editBpMap, bpId);

      popFunction();
      Fluttertoast.showToast(msg: 'Successfully edited blood pressure log');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to edit logs");
    } catch (e) {
      log("Error bp widget $e");
      Fluttertoast.showToast(msg: "Unable to edit logs");
    } finally {
      setState(() {});
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  List<int> intList = List.generate(
    12,
    (int index) => index * 20,
    growable: false,
  );

  var evenNumbers = [];

  @override
  void initState() {
    super.initState();
    for (var ele in intList) {
      evenNumbers.add(ele);
    }
    evenNumbers = evenNumbers.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: 'Blood Pressure',
        actionWIdget2: preferences.getString("role") != "ROLE_EXPERT"
            ? GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AddBpRecord();
                  })).then((value) {
                    setState(() {});
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: whiteColor,
                        size: 25,
                      ),
                      Text(
                        'Add Log',
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 14),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ),
      body: FutureBuilder(
        future: getbloodPressure(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<BloodPressureData>(builder: (context, value, child) {
                String systolicValue = value.bpData.latestData != null
                    ? value.bpData.latestData!['systolic']
                    : '0';
                String diastolicValue = value.bpData.latestData != null
                    ? value.bpData.latestData!['diastolic']
                    : '0';
                String pulseValue = value.bpData.latestData != null
                    ? value.bpData.latestData!['pulse']
                    : '0';
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BloodPressureTopCard(data: value.bpData),
                      Container(
                        height: 46,
                        width: MediaQuery.of(context).size.width * 0.93,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          // color: darkGrey,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List<Widget>.generate(
                            4,
                            (int index) {
                              return Expanded(
                                child: ChoiceChip(
                                  label: Text(items[index]["key"]!),
                                  selected: _value == index,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _value = selected ? index : null;
                                    });
                                  },
                                  selectedColor:
                                      Theme.of(context).colorScheme.secondary,
                                  backgroundColor: Colors.grey[800],
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: whiteColor,
                                      ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      Stack(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            physics: const BouncingScrollPhysics(),
                            child: Container(
                              height: 360,
                              width: MediaQuery.of(context).size.width * 0.93,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Theme.of(context).canvasColor,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 40),
                                child: BarChart(
                                  BarChartData(
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(),
                                      rightTitles: AxisTitles(),
                                      topTitles: AxisTitles(),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          getTitlesWidget: getTitles,
                                          reservedSize: 40,
                                          showTitles: true,
                                        ),
                                      ),
                                    ),
                                    maxY: 320,
                                    barGroups: [
                                      BarChartGroupData(
                                        barsSpace: 20,
                                        x: 1,
                                        barRods: [
                                          BarChartRodData(
                                            toY: double.parse(systolicValue),
                                            width: 20.0,
                                            color: orange,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        barsSpace: 20,
                                        x: 2,
                                        barRods: [
                                          BarChartRodData(
                                            toY: double.parse(diastolicValue),
                                            width: 20.0,
                                            color: const Color.fromARGB(
                                                255, 41, 132, 44),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        barsSpace: 20,
                                        x: 3,
                                        barRods: [
                                          BarChartRodData(
                                            toY: double.parse(pulseValue),
                                            width: 20.0,
                                            color: Colors.blue[300],
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              height: 400,
                              width: 40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: evenNumbers.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6.5,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text(
                                              '${evenNumbers[index]}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                              textAlign: TextAlign.right,
                                              textScaleFactor: 1,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 50,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: bpLevels.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Container(
                                padding: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).canvasColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: bpcolors[index],
                                      radius: 5,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        bpLevels[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(fontSize: 12),
                                        // textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recently',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: orange),
                            ),
                            TextButton(
                              onPressed: () {
                                showAllBpLogs(value);
                              },
                              child: Text(
                                'Show all',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: orange,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (value.bpData.recentLogs != null ||
                          value.bpData.recentLogs!.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: value.bpData.recentLogs!.length > 5
                              ? 5
                              : value.bpData.recentLogs!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: bpCard(
                                context,
                                value.bpData.recentLogs![index],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              }),
      ),
    );
  }

  void showAllBpLogs(BloodPressureData value) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.black,
      builder: (context) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 32,
                      ),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
              value.bpData.recentLogs != null ||
                      value.bpData.recentLogs!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.bpData.recentLogs!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          child: bpCard(
                            context,
                            value.bpData.recentLogs![index],
                          ),
                        );
                      },
                    )
                  : const Text('No logs available'),
            ],
          ),
        );
      },
    );
  }

  Map<String, Color> backgroundColors = {
    'Hypotension': Colors.red,
    'Normal': Colors.green,
    'Elevated': Colors.orange,
    'Hypertension Stage 1': Colors.blue,
    'Hypertension Stage 2': Colors.yellow,
    'Hypertension Stage 3': Colors.redAccent,
    //'Hypertensive': Colors.purple,
    'Hypertensive Crisis': Colors.purple,
  };

  getbpTypeData(int systolic) {}

  Widget bpCard(context, BpRecentLogs data) {
    var bpdate = data.date;
    var tempBpDate = DateFormat('MM/dd/yyyy').parse(bpdate!);
    var bpLogDate = DateFormat('dd MMM yyyy').format(tempBpDate);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: int.parse(data.systolic!) < 120
                  ? backgroundColors['Normal']
                  : (int.parse(data.systolic!) >= 120 &&
                          int.parse(data.systolic!) < 130)
                      ? backgroundColors['Elevated']
                      : (int.parse(data.systolic!) >= 130 &&
                              int.parse(data.systolic!) < 140)
                          ? backgroundColors['Hypertension Stage 1']
                          : (int.parse(data.systolic!) >= 140 &&
                                  int.parse(data.systolic!) < 160)
                              ? backgroundColors['Hypertension Stage 2']
                              : (int.parse(data.systolic!) >= 160 &&
                                      int.parse(data.systolic!) < 180)
                                  ? backgroundColors['Hypertension Stage 3']
                                  : (int.parse(data.systolic!) >= 180)
                                      ? backgroundColors['Hypertensive Crisis']
                                      : Colors.white,
              radius: 22,
              child: Text(
                '${data.systolic}\n${data.diastolic}',
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: int.parse(data.systolic!) <= 120
                          ? backgroundColors['Normal']
                          : (int.parse(data.systolic!) >= 120 &&
                                  int.parse(data.systolic!) < 130)
                              ? backgroundColors['Elevated']
                              : (int.parse(data.systolic!) >= 130 &&
                                      int.parse(data.systolic!) < 140)
                                  ? backgroundColors['Hypertension Stage 1']
                                  : (int.parse(data.systolic!) >= 140 &&
                                          int.parse(data.systolic!) < 160)
                                      ? backgroundColors['Hypertension Stage 2']
                                      : (int.parse(data.systolic!) >= 160 &&
                                              int.parse(data.systolic!) < 180)
                                          ? backgroundColors[
                                              'Hypertension Stage 3']
                                          : (int.parse(data.systolic!) >= 180)
                                              ? backgroundColors[
                                                  'Hypertensive Crisis']
                                              : Colors.white,
                      radius: 5,
                    ),
                    const SizedBox(width: 8),
                    if (int.parse(data.systolic!) <= 120) const Text('Normal'),
                    if (int.parse(data.systolic!) >= 120 &&
                        int.parse(data.systolic!) < 130)
                      const Text('Elevated'),
                    if (int.parse(data.systolic!) >= 130 &&
                        int.parse(data.systolic!) < 140)
                      const Text('Hypertension Stage I'),
                    if (int.parse(data.systolic!) >= 140 &&
                        int.parse(data.systolic!) < 160)
                      const Text('Hypertension Stage II'),
                    if (int.parse(data.systolic!) >= 160 &&
                        int.parse(data.systolic!) < 180)
                      const Text('Hypertension Stage III'),
                    if (int.parse(data.systolic!) >= 180)
                      const Text('Hypertensive Crisis'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$bpLogDate, ${data.pulse} BPM,${data.time.toString()}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                editBpLog(
                  data.id!,
                  int.parse(data.systolic!),
                  int.parse(data.diastolic!),
                  int.parse(data.pulse!),
                );
              },
              icon: Icon(
                Icons.edit_note_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 34,
              ),
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  DateTime dateTime = DateTime.now();
  int? systolic;
  int? diastolic;
  int? pulse;

  Map<String, dynamic> editBpMap = {"set": {}};

  void getSystolic(int value) => systolic = value;

  void getDiastolic(int value) => diastolic = value;

  void getPulse(int value) => pulse = value;

  void onEditSubmit(String bloodPressureId) {
    editBpMap["set"]["userId"] = userId;

    String date = DateFormat("MM-dd-yyyy").format(dateTime);
    log(date);

    String time = DateFormat("HH:mm:ss").format(dateTime);
    log(time);

    if (systolic == 0) {
      Fluttertoast.showToast(msg: "Your systolic reading cannot be 0");
      return;
    }
    if (diastolic == 0) {
      Fluttertoast.showToast(msg: "Your diastolic reading cannot be 0");
      return;
    }
    if (pulse == 0) {
      Fluttertoast.showToast(msg: "Your pulse reading cannot be 0");
      return;
    }

    editBpMap["set"]["date"] = date;
    editBpMap["set"]["systolic"] = systolic;
    editBpMap["set"]["diastolic"] = diastolic;
    editBpMap["set"]["pulse"] = pulse;
    editBpMap["set"]["time"] = time;

    log(editBpMap.toString());
    editBp(context, bloodPressureId);
  }

  void editBpLog(String bpId, int systolic, int diastolic, int pulse) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Colors.black
              : whiteColor,
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 32,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
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
                              cupertinoPicker(context, getSystolic, systolic),
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
                              cupertinoPicker(context, getDiastolic, diastolic),
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
                              cupertinoPicker(context, getPulse, pulse),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientButton(
                  title: 'SAVE',
                  func: () {
                    onEditSubmit(bpId);
                  },
                  gradient: orangeGradient,
                ),
              ],
            ),
          ],
        );
      },
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
          599,
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

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 20,
      child: Text(
        value == 1.0
            ? 'Systolic'
            : value == 2.0
                ? 'Diastolic'
                : 'Pulse',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
