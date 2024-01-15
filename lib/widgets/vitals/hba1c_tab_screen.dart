import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/vitals/all_vitals.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/vitals/hba1c_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:provider/provider.dart';

class Hba1cTabScreen extends StatefulWidget {
  final String dateType;
  final bool isYearlyTab;

  const Hba1cTabScreen(
      {Key? key, required this.dateType, this.isYearlyTab = false})
      : super(key: key);

  @override
  State<Hba1cTabScreen> createState() => _Hba1cTabScreenState();
}

class _Hba1cTabScreenState extends State<Hba1cTabScreen>
    with AutomaticKeepAliveClientMixin {
  HbA1c _hbA1cData = HbA1c();

  Future<void> getHba1c() async {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      _hbA1cData = await Provider.of<HbA1cData>(context, listen: false)
          .getHba1cData(userId, widget.dateType);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error hba1c $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> editHbA1c(String hba1cID) async {
    try {
      await Provider.of<HbA1cData>(context, listen: false)
          .editHba1cData(editHba1cMap, hba1cID);

      popFunction();
      Fluttertoast.showToast(msg: 'Successfully edited hbA1c log');
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

  late String userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: getHba1c(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(10),
                    //   child: Text(
                    //     widget.isYearlyTab ? 'This Year' : 'This Month',
                    //     style: Theme.of(context).textTheme.labelLarge,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Average HbA1c Level',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              _hbA1cData.averageData![
                                                      "hba1cAverage"] ??
                                                  "_",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            Text(
                                              ' %',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!widget.isYearlyTab)
                                    Text(
                                      DateFormat("MMMM").format(DateTime.now()),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Logs',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: orange),
                      ),
                    ),
                    if (_hbA1cData.recentLogs != null ||
                        _hbA1cData.recentLogs!.isNotEmpty)
                      SizedBox(
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _hbA1cData.recentLogs!.length,
                          itemBuilder: (context, index) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                color: double.parse(_hbA1cData
                                    .recentLogs![index]
                                    .hba1cLevel!) <=
                                    6
                                    ? const Color(0xFF92d050)
                                    : double.parse(_hbA1cData
                                    .recentLogs![
                                index]
                                    .hba1cLevel!) >
                                    6 &&
                                    double.parse(_hbA1cData
                                        .recentLogs![
                                    index]
                                        .hba1cLevel!) <=
                                        8
                                    ? const Color(0xFFffc000)
                                    : Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        _hbA1cData.recentLogs![index].hba1cLevel!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!,
                                      ),
                                      Text(
                                        ' %',
                                        style:
                                            Theme.of(context).textTheme.bodySmall,
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            StringDateTimeFormat()
                                                .stringtDateFormatLogWeight(
                                                    _hbA1cData.recentLogs![index]
                                                        .date!),
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                ,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _hbA1cData.recentLogs![index].time!,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      IconButton(
                                        onPressed: () {
                                          dateController.text =
                                              StringDateTimeFormat()
                                                  .stringDateBloodGlucoseFormat(
                                                      _hbA1cData
                                                          .recentLogs![index]
                                                          .date!);
                                          selectedDate = DateFormat("MM/dd/yyyy")
                                              .parse(_hbA1cData
                                                  .recentLogs![index].date!);
                                          timeController.text =
                                              _hbA1cData.recentLogs![index].time!;
                                          selectedTime =
                                              _hbA1cData.recentLogs![index].time!;
                                          levelController.text = _hbA1cData
                                              .recentLogs![index].hba1cLevel!;
                                          hba1cLevel = _hbA1cData
                                              .recentLogs![index].hba1cLevel!;
                                          edithba1clevel(
                                              _hbA1cData.recentLogs![index].id!);
                                        },
                                        icon: const Icon(
                                          Icons.edit_note_rounded,
                                          //color: Theme.of(context).colorScheme.onBackground,
                                          color: Colors.black,
                                          size: 34,
                                        ),
                                        splashRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          separatorBuilder: (context, index) {
                            return Divider(color: Colors.grey[600]);
                          },
                        ),
                      ),
                  ],
                ),
              );
      },
    );
  }

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController levelController = TextEditingController();

  Map<String, dynamic> editHba1cMap = {"set": {}};

  void onEditSubmit(String hba1cId) {
    if (selectedTime == null) {
      Fluttertoast.showToast(msg: "Please choose a time");
      return;
    }
    editHba1cMap["set"]["userId"] = userId;
    editHba1cMap["set"]["time"] = selectedTime;
    editHba1cMap["set"]["date"] =
        DateFormat("yyyy-MM-dd").format(selectedDate!);
    if (hba1cLevel!.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your Hba1c value");
      return;
    }
    editHba1cMap["set"]["hba1cLevel"] = hba1cLevel;

    log(editHba1cMap.toString());

    editHbA1c(hba1cId);
  }

  void edithba1clevel(String id) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      // backgroundColor: Colors.black,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => datePicker(),
                child: IgnorePointer(
                  child: TextFormField(
                    controller: dateController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: grey,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: orange,
                        ),
                      ),
                      suffixIcon: TextButton(
                        onPressed: () {
                          datePicker();
                        },
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: orange,
                          size: 28,
                        ),
                      ),
                      hintText: "Choose log date",
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    onSaved: (value) {
                      log(selectedDate.toString());
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your logging date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => timePicker(),
                child: IgnorePointer(
                  child: TextFormField(
                    controller: timeController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: grey,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: orange,
                        ),
                      ),
                      suffixIcon: TextButton(
                        onPressed: () {
                          timePicker();
                        },
                        child: const Icon(
                          Icons.schedule_rounded,
                          color: orange,
                          size: 28,
                        ),
                      ),
                      hintText: "Choose log time",
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    onSaved: (value) {
                      log(selectedTime.toString());
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your logging time';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'HbA1C (%)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  inputFields('HbA1c Level'),
                  const SizedBox(width: 16),
                  Text(
                    '%',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: GradientButton(
                func: () {
                  onEditSubmit(id);
                },
                title: 'Log',
                gradient: orangeGradient,
              ),
            ),
          ],
        );
      },
    );
  }

  DateTime? selectedDate;

  void datePicker() {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: datePickerDarkTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        log(value.toString());
        selectedDate = value;
        dateController.text = DateFormat('dd-MMM-yyyy').format(selectedDate!);
      });
    });
  }

  String? selectedTime;

  void timePicker() {
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
        var selection = value;
        var format24hrTime =
            '${selection.hour.toString().padLeft(2, "0")}:${selection.minute.toString().padLeft(2, "0")}:00';
        selectedTime = selection.format(context);
        timeController.text = selectedTime!;
        log('selected time in 24 hrs -> $format24hrTime');
        log('selected time -> ${selectedTime!}');
      });
    });
  }

  String? hba1cLevel;

  Widget inputFields(String glucoseLevel) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: levelController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFC3CAD9),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: grey,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: orange,
          ),
        ),
        constraints: BoxConstraints(
          // maxHeight: 40,
          maxWidth: MediaQuery.of(context).size.width * 0.4,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        hintText: glucoseLevel,
        hintStyle: const TextStyle(
          color: Color(0xFF959EAD),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'OpenSans',
        ),
      ),
      onChanged: (value) {
        hba1cLevel = value;
      },
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $glucoseLevel ';
        }
        return null;
      },
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    int val = value.toInt();
    var dt = DateTime.fromMillisecondsSinceEpoch(val);
    String dss = DateFormat("E").format(dt);
    String v = DateFormat("dd MMM").format(dt);

    const style = TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 12,
    );
    Widget text;
    switch (dss) {
      case "Mon":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Tue":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Wed":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Thu":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Fri":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Sat":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Sun":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      default:
        text = const Text(
          '',
          style: style,
          textScaleFactor: 1,
        );
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
