import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Request Appointment'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Day : 2nd August 2022',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                child: SizedBox(
                  height: 420,
                  child: CalendarCarousel(
                    pageSnapping: true,
                    customGridViewPhysics: const NeverScrollableScrollPhysics(),
                    weekendTextStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: orange),
                    weekdayTextStyle: Theme.of(context).textTheme.bodyMedium,
                    daysTextStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                    thisMonthDayBorderColor: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                'Preferred Time',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          timePicker(context, fromTimeController);
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: fromTimeController,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).canvasColor,
                              filled: true,
                              hintText: 'From',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: const Color(0xFF717579),
                                  ),
                              suffixIcon: TextButton(
                                onPressed: () {
                                  timePicker(context, fromTimeController);
                                },
                                child: const Text('PICK'),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                            cursorColor: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          timePicker(context, toTimeController);
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: toTimeController,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).canvasColor,
                              filled: true,
                              hintText: 'To',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: const Color(0xFF717579),
                                  ),
                              suffixIcon: TextButton(
                                onPressed: () {
                                  timePicker(context, toTimeController);
                                },
                                child: const Text('PICK'),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                            cursorColor: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: SizedBox(
                child: TextFormField(
                  maxLines: 5,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).canvasColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Color(0xFFff7f3f),
                      ),
                    ),
                    hintText: 'Describe your issue',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: GradientButton(
                title: 'REQUEST',
                func: () {
                  showPopup(context);
                },
                gradient: orangeGradient,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void timePicker(context, TextEditingController controller) {
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
        controller.text = value.format(context);
        // startTime = value;
        // endTime = value;
      });
    });
  }

  void showPopup(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Thank you for your request. Our health coach will get in touch with you shortly.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientButton(
                        title: 'OK',
                        func: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        gradient: orangeGradient,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
