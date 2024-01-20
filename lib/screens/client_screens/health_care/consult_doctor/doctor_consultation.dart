import 'dart:developer';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/expert.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/health_care/health_care_plans/health_care_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/experts_data.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_plans/health_care_plans_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/expert_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/browse_hc_plans.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/widgets/hc_plan_card.dart';

class DoctorConsultationScreen extends StatefulWidget {
  const DoctorConsultationScreen({Key? key}) : super(key: key);

  @override
  State<DoctorConsultationScreen> createState() =>
      _DoctorConsultationScreenState();
}

class _DoctorConsultationScreenState extends State<DoctorConsultationScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String? userId;
  List<Expertise> specialities = [];
  List<HealthCarePlansModel> healthCarePlans = [];
  bool isLoading = true;
  List<Expert> experts = [];
  User? userData;

  Future<void> getSpeciality() async {
    try {
      await Provider.of<ExpertiseData>(context, listen: false)
          .fetchExpertise("6343acb2f427d20b635ec853");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get fetch speciality $e");
      Fluttertoast.showToast(msg: "Unable to fetch speciality");
    }
  }

  Map<String, dynamic> consultationData = {};

  Future<void> submitForm() async {
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(consultationData);
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

  // Future<void> submitForm() async {
  //   popFunction();
  //   LoadingDialog().onLoadingDialog("Please wait.....", context);
  //   try {
  //     await Provider.of<HealthCareProvider>(context, listen: false)
  //         .consultSpecialist(consultationData);
  //     Fluttertoast.showToast(msg: 'Consultation scheduled successfully');
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: e.message);
  //   } catch (e) {
  //     log("Error request appointment $e");
  //     Fluttertoast.showToast(msg: "Not able to submit your request");
  //   } finally {
  //     popFunction();
  //   }
  // }

  void onSubmit(bool isSpecialist) {
    consultationData["name"] = userData!.firstName!;
    consultationData["email"] = userData!.email!;
    consultationData["contactNumber"] = userData!.mobile ?? "";
    consultationData["userId"] = userData!.id ?? "";
    consultationData["flow"] = "healthCare";
    if (isSpecialist == true) {
      consultationData["enquiryFor"] = speciality;
    } else {
      consultationData["enquiryFor"] = "gp";
    }
    consultationData["category"] = 'Health Care';
    if (startTime != null) {
      consultationData['startTime'] = startTime;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation time');
      return;
    }
    if (startDate != null) {
      consultationData['startDate'] = startDate;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation date');
      return;
    }
    if (isSpecialist == true) {
      if (speciality != null) {
        consultationData['expertiseId'] = speciality;
      } else {
        Fluttertoast.showToast(msg: 'Please select a consultation speciality');
        return;
      }
    } else {
      consultationData['expertiseId'] = '63452ce8f427d20b635ed3b8';
    }
    if (description != null) {
      consultationData['message'] = description;
    } else {
      Fluttertoast.showToast(
          msg: 'Please enter a brief description for your consultation');
      return;
    }

    log(consultationData.toString());
    submitForm();
  }

  void popFunction() {
    Navigator.pop(context);
  }

  Future<void> getExperts() async {
    try {
      experts = await Provider.of<ExpertsData>(context, listen: false)
          .fetchHealthCareExperts();
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log("Error get fetch experts $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchHealthCarePlans() async {
    try {
      healthCarePlans =
          await Provider.of<HealthCarePlansProvider>(context, listen: false)
              .getHealthCarePlans();
      setState(() {});
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching plans');
    }
  }

  @override
  void initState() {
    super.initState();
    userData = Provider.of<UserData>(context, listen: false).userData;
    // userId = Provider.of<UserData>(context, listen: false).userData.id;
    getSpeciality().then((value) {
      specialities =
          Provider.of<ExpertiseData>(context, listen: false).expertise;
    });
    getExperts();
    fetchHealthCarePlans();

    dateController.text = DateFormat("d MMM yyyy").format(DateTime.now());
    startDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    log("start date: $startDate");
    List imgs = [
      // 'assets/images/Picture12.jpg',
      {
        'image': 'assets/images/livewell/livebanner1.jpg',
        'route': () {},
      },
    ];
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Doctor Consultation'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Online Doctor Consultation',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  CustomCarouselSlider(imageUrls: imgs),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showSpecialistBottomSheet();
                                },
                                child: Text(
                                  'Consult a Specialist',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: whiteColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8E4CED),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showGpBottomSheet();
                                },
                                child: Text(
                                  'Consult a GP',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: whiteColor),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // ExpertsHorizontalList(
                  //   title: 'Our Doctors',
                  // ),
                  if (experts.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Our Doctors",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  if (experts.isNotEmpty)
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: experts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(
                                      context, /*rootnavigator: true*/
                                    ).push(
                                        MaterialPageRoute(builder: (context) {
                                      return ExpertScreen(
                                        expertId: experts[index].id!,
                                      );
                                    }));
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  // child: const CircleAvatar(
                                  //   backgroundImage: AssetImage(
                                  //       'assets/icons/expert_pfp.png'),
                                  //   radius: 32,
                                  // ),
                                  child: experts[index].imageUrl == null
                                      ? const CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'assets/icons/expert_pfp.png'),
                                          radius: 32,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              experts[index].imageUrl!),
                                          radius: 32,
                                        ),
                                ),
                                Text(experts[index].firstName!),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  if (healthCarePlans.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Our Plans',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BrowseHealthCarePlans(),
                                  ),
                                );
                              },
                              child: const Text("View all"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: healthCarePlans.length >= 3
                                ? 3
                                : healthCarePlans.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  showHcPlanBottomSheet(
                                      index, healthCarePlans[index]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: SizedBox(
                                    width: 200,
                                    child: Card(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${healthCarePlans[index].name}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }

  showHcPlanBottomSheet(int index, HealthCarePlansModel healthCarePlan) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return HcPlanCard(
            healthCarePlansModel: healthCarePlan,
            planName: "doctorconsult",
          );
        });
  }

  String? speciality;
  List doctorSpecialities = [
    'Speciality 1',
    'Speciality 2',
    'Speciality 3',
    'Speciality 4',
    'Speciality 5',
  ];

  String? description;
  Expertise? specialityId;

  void showSpecialistBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).canvasColor,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Select Speciality',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: DropdownButtonFormField(
                    isDense: true,
                    items: specialities
                        .map<DropdownMenuItem<String>>((Expertise value) {
                      return DropdownMenuItem(
                        value: value.name,
                        child: Text(
                          value.name!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        speciality = newValue!;
                      });
                      log(speciality!);
                    },
                    value: speciality,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.25,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
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
                      'Speciality',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: SizedBox(
                    child: TextFormField(
                      maxLines: 5,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).canvasColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Describe your issue',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey),
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                      onChanged: (value) {
                        description = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        onSubmit(true);
                      },
                      child: Text(
                        'Request Appointment',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        });
  }

  void showGpBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Theme.of(context).canvasColor,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8),
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: SizedBox(
                      child: TextFormField(
                        maxLines: 5,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Describe your issue',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey),
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          onSubmit(false);
                        },
                        child: Text(
                          'Request Appointment',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  String? startTime;
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

  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat = DateFormat('yyyy-MM-dd').format(
      DateFormat('MM/dd/yyyy').parse(DateFormat.yMd().format(DateTime.now())));
  String? startDate;

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
}
