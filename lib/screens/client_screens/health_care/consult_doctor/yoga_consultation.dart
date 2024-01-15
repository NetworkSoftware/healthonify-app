import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/text%20fields/support_text_fields.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/user.dart';

class YogaConsultation extends StatefulWidget {
  const YogaConsultation({Key? key}) : super(key: key);

  @override
  State<YogaConsultation> createState() => _YogaConsultationState();
}

class _YogaConsultationState extends State<YogaConsultation> {
  final _form = GlobalKey<FormState>();
  String? startTime;
  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat = DateFormat('yyyy-MM-dd').format(
      DateFormat('MM/dd/yyyy').parse(DateFormat.yMd().format(DateTime.now())));
  String? startDate;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String? selectedValue;

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
      if (ymdFormat.toString() == todayDate[0]) {
        print("ValueHour : ${value.hour}");
        if (value.hour < (DateTime.now().hour + 3)) {
          Fluttertoast.showToast(
              msg:
              'Consultation time must be atleast 3 hours after current time');

          return;
        }
      }
      setState(() {
        var format24hrTime =
            '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}:00';
        startTime = format24hrTime;
        log('24h time: $startTime');
        controller.text = value.format(context);
      });
    });
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
      // var todayDate = DateTime.now().toString().split(' ');
      //
      // log(todayDate[0]);
      //
      // log(ymdFormat.toString());
      //
      //   print("ValueHour : ${value.hour}");
      //   if (value.hour < (DateTime.now().hour + 3)) {
      //     Fluttertoast.showToast(
      //         msg:
      //         'Consultation time must be atleast 3 hours after current time');
      //
      //     return;
      //   }

      setState(() {
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);

        // if (temp.isBefore(DateTime.now())) {
        //   Fluttertoast.showToast(msg: 'Please select a valid date');
        //   return;
        // }

        startDate = DateFormat('yyyy/MM/dd').format(temp);
        log('start date:  $startDate');
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }

  final Map<String, String> data = {
    "name": "",
    "email": "",
    "contactNumber": "",
    "userId": "",
    "enquiryFor": "",
    "message": "",
    "category": "yoga",
  };

  @override
  void initState() {
    super.initState();
    User userData = Provider.of<UserData>(context, listen: false).userData;
    setData(userData);
  }


  Future<void> submitForm() async {
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(data);
      Fluttertoast.showToast(
          msg: "Appointment Requested, an expert will get back to you soon");
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      // Fluttertoast.showToast(msg: "Not able to submit your request");
    } finally {
      Navigator.of(context).pop();
    }
  }

  void setData(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNumber"] = userData.mobile ?? "";
    data["enquiryFor"] = "generalEnquiry";
    data["category"] = "yoga";
    data["userId"] = userData.id!;
  }

  void onSubmit() {
    if (!_form.currentState!.validate()) {
      // setState(() => isLoading = false);
      return;
    }
    if (selectedValue == null) {
      Fluttertoast.showToast(msg: "Please choose a value from the dropdown");
    }
    data["category"] = selectedValue!;
    _form.currentState!.save();
    log(data.toString());
    submitForm();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Yoga Consultation'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const ExpertsTopList(),
            CustomCarouselSlider(imageUrls: [
              {
                'image': 'assets/images/consultexp/consultexp1.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/consultexp/consultexp2.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/consultexp/consultexp3.jpg',
                'route': () {},
              },
            ]),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Appointments",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Book and view your consultations here',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints:
                            const BoxConstraints(minWidth: 70, minHeight: 40),
                            decoration: BoxDecoration(
                              gradient: purpleGradient,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: InkWell(
                              onTap: () {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) {
                                //       return const HealthCareAppointmentsScreen();
                                //     }));
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Text(
                                  'View',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: whiteColor),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            constraints:
                            const BoxConstraints(minWidth: 90, minHeight: 40),
                            decoration: BoxDecoration(
                              gradient: purpleGradient,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: InkWell(
                              onTap: () {
                                _showBottomSheet();
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Request',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: whiteColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        elevation: 10,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Form(
              key: _form,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 1),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      "Request Appointment",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Text(
                          "Category : ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                            width: 10
                        ),
                        Text(
                          "Yoga",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Explain your issue",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IssueField(getValue: (value) {
                          data["message"] = value;
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Center(
                      child: SaveButton(
                        isLoading: false,
                        submit: onSubmit,
                        title: "Request Now",
                      )),
                ]),
              ),
            ),
          ),
        ));
  }
}