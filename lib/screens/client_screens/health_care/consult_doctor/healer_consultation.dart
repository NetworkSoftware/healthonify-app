import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/all_appointments_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/expert_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/support_text_fields.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/user.dart';

class HealerConsultation extends StatefulWidget {
  const HealerConsultation({Key? key}) : super(key: key);

  @override
  State<HealerConsultation> createState() => _HealerConsultationState();
}

class _HealerConsultationState extends State<HealerConsultation> {
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
    "category": "healer",
  };

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

  @override
  void initState() {
    super.initState();
    fetchExperts();
    User userData = Provider.of<UserData>(context, listen: false).userData;
    setData(userData);
  }

  void setData(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNumber"] = userData.mobile ?? "";
    data["enquiryFor"] = "generalEnquiry";
    data["category"] = "healer";
    data["userId"] = userData.id!;
  }

  void onSubmit() {
    if (!_form.currentState!.validate()) {
      return;
    }
    if (selectedValue == null) {
      Fluttertoast.showToast(msg: "Please choose a value from the dropdown");
    }
    // data["category"] = selectedValue!;
    _form.currentState!.save();
    log(data.toString());
    submitForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Healer Consultation'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
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
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: Card(
                    elevation: 5,
                    color: const Color(0xFFec6a13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(
                                context, /*rootnavigator: true*/
                              ).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AllAppointmentsScreen(flow: 'liveWell'),
                                ),
                              );
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color(0xFFec6a13))),
                                      child: const Center(
                                        child: Text(
                                          "View",
                                          style: TextStyle(
                                              color: Color(0xFFec6a13),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Appointments",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Book and View your appointments here',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            isloading == false
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Experts",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          liveWellExperts.isNotEmpty
                              ? SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: liveWellExperts.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(width: 10);
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ExpertScreen(
                                                expertId:
                                                    liveWellExperts[index].id!,
                                              );
                                            }));
                                          },
                                          child: liveWellExperts[index]
                                                          .imageUrl ==
                                                      null ||
                                                  liveWellExperts[index]
                                                          .imageUrl ==
                                                      ""
                                              ? const CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: AssetImage(
                                                      'assets/icons/expert_pfp.png'),
                                                )
                                              : CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: NetworkImage(
                                                    liveWellExperts[index]
                                                        .imageUrl!,
                                                  ),
                                                ),
                                        ),
                                        Text(
                                          liveWellExperts[index].firstName!,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text("No Experts Available")),
                                ),
                        ],
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  List<User> experts = [];
  List<User> liveWellExperts = [];
  bool isloading = true;

  Future<void> fetchExperts() async {
    try {
      experts =
          await Provider.of<UserData>(context, listen: false).getExperts();

      for (int i = 0; i < experts.length; i++) {
        if (experts[i].topExpertise == "Live Well") {
          liveWellExperts.add(experts[i]);
        }
      }
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting user details : $e");
      Fluttertoast.showToast(msg: "Unable to fetch user details");
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }
}
