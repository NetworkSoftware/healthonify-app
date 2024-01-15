import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class SurgicalHistoryScreen extends StatefulWidget {
  final String? userId;
  const SurgicalHistoryScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<SurgicalHistoryScreen> createState() => _SurgicalHistoryScreenState();
}

class _SurgicalHistoryScreenState extends State<SurgicalHistoryScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();

  late String userId;
  String? surgeryName;
  String? docOrHospitalName;
  String? comments;

  Map<String, dynamic> surgeryData = {};

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    surgeryData['userId'] = userId;
    surgeryData['date'] = ymdFormat;
    surgeryData['name'] = surgeryName;
    surgeryData['hospitalNameOrDoctorName'] = docOrHospitalName;
    if (comments!.isNotEmpty) {
      surgeryData['comments'] = comments;
    }

    log(surgeryData.toString());
    postSurgeryLog();
  }

  void popfunction() {
    Navigator.pop(context);
  }

  Future<void> postSurgeryLog() async {
    try {
      await Provider.of<MedicalHistoryProvider>(context, listen: false)
          .postSurgicalHistory(surgeryData);
      popfunction();
      Fluttertoast.showToast(msg: 'Surgery log added succesfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to post surgery log');
    }
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userId ??
        Provider.of<UserData>(context, listen: false).userData.id!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Surgical History'),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                hint: 'Surgery Name',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    surgeryName = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please add the surgery name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      hintText: 'Surgery date',
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color(0xFF717579),
                              ),
                      suffixIcon: TextButton(
                        onPressed: () {
                          datePicker(dateController);
                        },
                        child: Text(
                          'PICK',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: orange),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                    cursorColor: whiteColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please choose the surgery date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                hint: 'Doctor/Hospital name',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    docOrHospitalName = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please add the doctor or hospital name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                hint: 'Comments (Optional)',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    comments = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onSubmit();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Add',
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
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
