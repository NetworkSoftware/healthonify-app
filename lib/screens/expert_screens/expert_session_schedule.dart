import "dart:developer";

import "package:flutter/material.dart";
import "package:healthonify_mobile/constants/theme_data.dart";
import "package:healthonify_mobile/providers/all_consultations_data.dart";
import "package:healthonify_mobile/providers/user_data.dart";
import "package:healthonify_mobile/widgets/cards/custom_appBar.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class ExpertSessionSchedule extends StatefulWidget {
  ExpertSessionSchedule({Key? key, required this.ticketNumber,required this.sessionNumber})
      : super(key: key);
  String ticketNumber;
  String sessionNumber;

  @override
  State<ExpertSessionSchedule> createState() => _ExpertSessionScheduleState();
}

class _ExpertSessionScheduleState extends State<ExpertSessionSchedule> {
  TextEditingController nameController = TextEditingController();
  TextEditingController benefitsController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  String? startTime;
  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat = DateFormat('yyyy-MM-dd').format(
      DateFormat('MM/dd/yyyy').parse(DateFormat.yMd().format(DateTime.now())));
  String? startDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: widget.sessionNumber),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              textFormFieldUI(
                  hintText: "Enter Name", controller: nameController),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 00),
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
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
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
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                            cursorColor: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 00),
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
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: const Color(0xFF717579),
                                  ),
                              suffixIcon: TextButton(
                                onPressed: () {
                                  timePicker(timeController);
                                },
                                child: Text(
                                  'PICK',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(color: orange),
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                            cursorColor: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              textFormFieldUI(
                  hintText: "Enter Duration in minutes",
                  controller: durationController),
              const SizedBox(height: 10),
              textFormFieldUI(
                  hintText: "Enter Benefits", controller: benefitsController),
              const SizedBox(height: 10),
              textFormFieldUI(
                  hintText: "Enter Description", controller: descController),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: postSessionSchedule,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: orange,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: const Text(
                    'Schedule',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFormFieldUI(
      {required String hintText, required TextEditingController controller}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      height: 50,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  void datePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: datePickerDarkTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);

        // if (temp.isBefore(DateTime.now())) {
        //   Fluttertoast.showToast(msg: 'Please select a valid date');
        //   return;
        // }

        startDate = DateFormat('MM/dd/yyyy').format(temp);
        log('start date:  $startDate');
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }

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
      // DateTime tempDate = _selectedDate!;
      var todayDate = DateTime.now().toString().split(' ');

      log(todayDate[0]);

      log("qwee${ymdFormat.toString()}");
      // if (ymdFormat.toString() == todayDate[0]) {
      //   print("ValueHour : ${value.hour}");
      //   if (value.hour < (DateTime.now().hour + 3)) {
      //     Fluttertoast.showToast(
      //         msg:
      //             'Consultation time must be atleast 3 hours after current time');
      //
      //     return;
      //   }
      // }
      setState(() {
        var format24hrTime =
            '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}:00';
        startTime = format24hrTime;
        log('24h time: $startTime');
        controller.text = value.format(context);
      });
    });
  }

  Future<void> postSessionSchedule() async {
    var data = Provider.of<UserData>(context, listen: false).userData;
    Map<String, dynamic> payload = {
      "sessionNumber": widget.sessionNumber,
      "name": nameController.text,
      "startDate": startDate,
      "startTime": startTime,
      "description": descController.text,
      "benefits": benefitsController.text,
      "durationInMinutes": durationController.text,
      "ticketNumber": widget.ticketNumber,
    };

    print("payload : $payload");

    await Provider.of<AllConsultationsData>(context, listen: false)
        .postSessionSchedule(payload)
        .then((value) {
      Navigator.pop(context, true);
    });
  }
}
