import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class SessionTimingsScreen extends StatefulWidget {
  const SessionTimingsScreen({Key? key}) : super(key: key);

  @override
  State<SessionTimingsScreen> createState() => _SessionTimingsScreenState();
}

class _SessionTimingsScreenState extends State<SessionTimingsScreen> {
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();

  List sessions = [
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
  ];
  String? selectedDay;
  List weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  bool isCopy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Session Timings'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Theme(
              data: ThemeData(
                unselectedWidgetColor: whiteColor,
              ),
              child: CheckboxListTile(
                value: isCopy,
                title: Text(
                  'Copy to all days of the week',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onChanged: (value) {
                  setState(() {
                    isCopy = !isCopy;
                  });
                },
                activeColor: const Color(0xFFff7f3f),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: Text(
            //     'Monday',
            //     style: Theme.of(context).textTheme.labelLarge,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: DropdownButtonFormField(
                isDense: true,
                items: weekDays.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDay = newValue!;
                  });
                },
                value: selectedDay,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: false,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.25,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.25,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    maxHeight: 56,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
                hint: Text(
                  'Choose day',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sessions.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              sessions[index],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    fromToTimePickers(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget fromToTimePickers() {
    return Expanded(
      flex: 4,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  timePicker(fromTimeController);
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: fromTimeController,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
                      filled: true,
                      hintText: 'Time',
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color(0xFF717579),
                              ),
                      suffixIcon: TextButton(
                        onPressed: () {
                          timePicker(fromTimeController);
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
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'to',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  timePicker(toTimeController);
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: toTimeController,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
                      filled: true,
                      hintText: 'Time',
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color(0xFF717579),
                              ),
                      suffixIcon: TextButton(
                        onPressed: () {
                          timePicker(toTimeController);
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
      setState(() {
        controller.text = value.format(context);
      });
    });
  }
}
