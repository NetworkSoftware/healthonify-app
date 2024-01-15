import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/vitals/hba1c_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class LogHbA1cScreen extends StatefulWidget {
  const LogHbA1cScreen({Key? key}) : super(key: key);

  @override
  State<LogHbA1cScreen> createState() => _LogBloodGlucoseState();
}

class _LogBloodGlucoseState extends State<LogHbA1cScreen> {
  bool isPostPrandial = false;
  String? _selectedTime;
  String _hba1cLevel = "";

  Map<String, String> data = {
    "userId": "",
    "date": "",
    "time": "",
    "hba1cLevel": ""
  };

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime? _selectedDate;

  void popFunc() {
    Navigator.of(context).pop();
  }

  Future<void> storeHba1c() async {
    setState(() {});
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    data["userId"] = userId;
    if (_selectedDate == null) {
      Fluttertoast.showToast(msg: 'Please choose a date');
      return;
    }
    if (_selectedTime == null) {
      Fluttertoast.showToast(msg: "Please choose a time");
      return;
    }

    data["time"] = _selectedTime!;
    data["date"] = DateFormat("MM/dd/yyyy").format(_selectedDate!);

    if (_hba1cLevel.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your Hba1c value");
      return;
    }
    if (double.parse(_hba1cLevel) > 100) {
      Fluttertoast.showToast(msg: 'Please enter a valid value');
      return;
    }
    data["hba1cLevel"] = _hba1cLevel;

    log(data.toString());
    try {
      await Provider.of<HbA1cData>(context, listen: false).storeHba1cData(data);
      Fluttertoast.showToast(msg: "Logs added");
      popFunc();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to store logs");
    } catch (e) {
      log("Error hba1c widget $e");
      Fluttertoast.showToast(msg: "Unable to store logs");
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(appBarTitle: 'Log your Hb1Ac %'),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   child: HorizCalendar(),
              // ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        log(_selectedDate.toString());
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _timePicker(),
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
                            _timePicker();
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
                        log(_selectedDate.toString());
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
                    storeHba1c();
                  },
                  title: 'Log',
                  gradient: orangeGradient,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/others/hb1ac.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '''
 Normal for person without diabetes: Less than 5.7%
 Official ADA recommendation for someone with diabetes: Less than 7.0%.

Recommended Blood Sugar Targets:
For people with type 1 diabetes, the American Diabetes Association recommends that blood sugar targets be :

Before meals, your blood sugar should be:

From 90 to 130 mg/dL (5.0 to 7.2 mmol/L) for adults

From 90 to 130 mg/dL (5.0 to 7.2 mmol/L) for children, 13 to 19 years old

From 90 to 180 mg/dL (5.0 to 10.0 mmol/L) for children, 6 to 12 years old

From 100 to 180 mg/dL (5.5 to 10.0 mmol/L) for children under 6 years old

After meals (1 to 2 hours after eating), your blood sugar should be:
Less than 180 mg/dL (10 mmol/L) for adults

For people with type 2 diabetes, the American Diabetes Association also recommends that blood sugar targets be :

Before meals, your blood sugar should be:
From 70 to 130 mg/dL (3.9 to 7.2 mmol/L) for adults

After meals (1 to 2 hours after eating), your blood sugar should be:
Less than 180 mg/dL (10.0 mmol/L) for adults.
          ''',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputFields(String glucoseLevel) {
    return TextFormField(
      keyboardType: TextInputType.phone,
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
        _hba1cLevel = value;
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
        _selectedDate = value;
        dateController.text = DateFormat('dd-MMM-yyyy').format(_selectedDate!);
      });
    });
  }

  void _timePicker() {
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
        _selectedTime = selection.format(context);
        timeController.text = _selectedTime!;
        log('selected time in 24 hrs -> $format24hrTime');
        log('selected time -> ${_selectedTime!}');
      });
    });
  }
}
