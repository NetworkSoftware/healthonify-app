import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/health_record_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/health_records/health_record_provider.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class EditHealthRecord extends StatefulWidget {
  final String recordId;
  final HealthRecord healthRecord;
  const EditHealthRecord(
      {required this.recordId, required this.healthRecord, Key? key})
      : super(key: key);

  @override
  State<EditHealthRecord> createState() => _EditHealthRecordState();
}

class _EditHealthRecordState extends State<EditHealthRecord> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List reportTypes = [
    'Thyrocare Report',
    'SRL Report',
    'Lab Report',
    'Prescription',
    'HRA',
    'ECG',
    'Hospital Records',
    'Other',
  ];
  String? reportType;
  String? reportName;

  Map<String, dynamic> editRecord = {"set": {}};

  void popFunc() {
    Navigator.pop(context);
  }

  Future editRecordData() async {
    try {
      await Provider.of<HealthRecordProvider>(context, listen: false)
          .updateHealthRecord(widget.recordId, editRecord);
      popFunc();
      Fluttertoast.showToast(msg: 'Health Record edited successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to edit health record');
    }
  }

  void onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (ymdFormat == null) {
      Fluttertoast.showToast(msg: 'Please choose a date');
      return;
    }
    if (selectedTime == null) {
      Fluttertoast.showToast(msg: 'Please choose a time');
      return;
    }

    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    editRecord["set"]["userId"] = userId;
    editRecord["set"]["reportName"] = reportName;
    editRecord["set"]["reportType"] = reportType;
    editRecord["set"]["date"] = ymdFormat;
    editRecord["set"]["time"] = selectedTime;

    log(editRecord.toString());
    editRecordData();
  }

  void getReportName(String val) => reportName = val;

  @override
  void initState() {
    super.initState();

    String autofillDate =
        DateFormat('d MMM yyyy').format(widget.healthRecord.date!);
    dateController.text = autofillDate;
    DateTime tempTime = DateFormat('HH:mm').parse(widget.healthRecord.time!);
    String autofillTime = DateFormat('h:mm a').format(tempTime);
    timeController.text = autofillTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Edit Health Record'),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Theme.of(context).canvasColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Color(0xFFC3CAD9),
                    ),
                  ),
                  hintText: widget.healthRecord.reportName,
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                style: Theme.of(context).textTheme.bodySmall,
                onSaved: (value) {
                  getReportName(value!);
                  // log(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a record name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                isDense: true,
                items: reportTypes.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    reportType = newValue!;
                  });
                },
                value: reportType,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).canvasColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.25,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
                hint: Text(
                  widget.healthRecord.reportType ?? "Report Type",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a report type';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  datePicker(dateController);
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
                      filled: true,
                      hintText: 'Date',
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color(0xFF717579),
                              ),
                      suffixIcon: const Icon(
                        Icons.event_rounded,
                        color: orange,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                    cursorColor: whiteColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please choose a date';
                      } else {}
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  timePicker(timeController);
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: timeController,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
                      filled: true,
                      hintText: 'Time',
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color(0xFF717579),
                              ),
                      suffixIcon: const Icon(
                        Icons.schedule_rounded,
                        color: orange,
                        size: 28,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                    cursorColor: whiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: GradientButton(
                title: 'Update',
                func: () {
                  onSubmit();
                },
                gradient: orangeGradient,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? selectedTime;
  void timePicker(TextEditingController controller) {
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
        selectedTime =
            '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}';
        controller.text = value.format(context);
      });
    });
  }

  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat;

  void datePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? datePickerDarkTheme
              : datePickerLightTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        // log(value.toString());
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        // log(ymdFormat!);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }
}
