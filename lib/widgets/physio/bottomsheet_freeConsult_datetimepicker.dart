import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/consult_now_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/succes_screens/successful_update.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';

import 'package:intl/intl.dart';

import 'dart:developer';

import 'package:provider/provider.dart';

class BottomsheetFreeConsultDatetimePicker extends StatefulWidget {
  final Map<String, dynamic> data;
  const BottomsheetFreeConsultDatetimePicker({Key? key, required this.data})
      : super(key: key);

  @override
  State<BottomsheetFreeConsultDatetimePicker> createState() =>
      _BottomSheetContentState();
}

class _BottomSheetContentState
    extends State<BottomsheetFreeConsultDatetimePicker> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _submit() {
    if (_selectedDate == null) {
      Fluttertoast.showToast(msg: "Please choose a date");
      return;
    }
    if (_selectedTime == null) {
      Fluttertoast.showToast(msg: "Please choose a time");
      return;
    }
    //format date to 24hr format
    var df = DateFormat("h:mm a").parse(_selectedTime!.format(context));
    String finalFormattedDate = DateFormat('HH:mm:ss').format(df);

    widget.data["startDate"] = DateFormat("M/d/y").format(_selectedDate!);
    widget.data["startTime"] = finalFormattedDate;
    widget.data["type"] = "free";
    widget.data["status"] = "initiateFreeConsultation";
    widget.data["durationInMinutes"] = 60;

    _submitConsultForm();
  }

  void onSubmitSucess() {
    Navigator.of(context).pop();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SuccessfulUpdate(
          onSubmit: (ctx) {
            Navigator.of(ctx).pop();
          },
          title:
              "Consultation Initiated. A expert will be assigned to you shortly",
          buttonTitle: "Back"),
    ));
  }

  Future<void> _submitConsultForm() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<ConsultNowData>(context, listen: false)
          .initiateFreeConsultation(widget.data);
      // Fluttertoast.showToast(
      //     msg: "Consultation requested!!", toastLength: Toast.LENGTH_LONG);
      onSubmitSucess.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submit free consultation form$e");
      Fluttertoast.showToast(msg: "Consultation request failed");
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserData>(context).userData.id!;
    widget.data["userId"] = userId;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Select your date and time",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _datePicker();
              },
              child: Text(
                "Choose a date",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Text(
              _selectedDate == null
                  ? ""
                  : DateFormat("MM/dd/yyyy").format(_selectedDate!),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _timePicker();
              },
              child: Text(
                "Choose a time",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Text(
              _selectedTime == null ? "" : _selectedTime!.format(context),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        _isLoading
            ? const CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                    title: 'Consult Now',
                    func: () {
                      _submit();
                    },
                    gradient: orangeGradient,
                  ),
                ],
              ),
        // : ElevatedButton(
        //     onPressed: () {
        //       _submit();
        //     },
        //     child: const Text("Consult Expert"),
        //     style: ButtonStyle(
        //       elevation: MaterialStateProperty.all(0),
        //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //         RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //       ),
        //       backgroundColor: MaterialStateProperty.all<Color>(
        //         const Color(0xFFff7f3f),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  void _datePicker() {
    var maxDate = DateTime.now().add(const Duration(days: 31));
    showDatePicker(
            context: context,
            builder: (context, child) {
              return Theme(
                data:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? datePickerDarkTheme
                        : datePickerLightTheme,
                child: child!,
              );
            },
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: maxDate)
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        log(value.toString());
        _selectedDate = value;
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
        log(value.toString());
        _selectedTime = value;
      });
    });
  }
}
