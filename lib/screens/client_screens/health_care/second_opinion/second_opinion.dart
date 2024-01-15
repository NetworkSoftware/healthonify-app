import 'dart:developer';

import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/health_care/hc_consultations_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class SecondOpinionScreen extends StatefulWidget {
  const SecondOpinionScreen({super.key});

  @override
  State<SecondOpinionScreen> createState() => _SecondOpinionScreenState();
}

class _SecondOpinionScreenState extends State<SecondOpinionScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  // List<CompletedConsultations> completedConsultations = [];
  late String userId, userName, userMobile, userEmail;

  // bool isLoading = true;

  // Future<void> getCompletedConsultations() async {
  //   try {
  //     completedConsultations =
  //         await Provider.of<SecondOpinionProvider>(context, listen: false)
  //             .getCompletedUserConsultations(userId);
  //     log('fetched completed user hc consultations');
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: e.message);
  //   } catch (e) {
  //     log("Error getting completed user hc consultations $e");
  //     Fluttertoast.showToast(
  //         msg: "Unable to get completed user hc consultations");
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  List<Expertise> specialities = [];

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
    User userData = Provider.of<UserData>(context, listen: false).userData;
    LoadingDialog().onLoadingDialog("Uploading...", context);

    try {
      if (pickedFile != null) {
        await uploadFile(pickedFile!, userData);
      }
      log(consultationData.toString());
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(consultationData);
      Fluttertoast.showToast(msg: 'Second opinion scheduled successfully');
      popFunction();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error request appointment $e");
      Fluttertoast.showToast(msg: "Not able to submit your request");
    } finally {
      Navigator.pop(context);
    }
  }

  void onSubmit() {
    consultationData['userId'] = userId;
    consultationData['name'] = userName ?? "";
    consultationData['email'] = userEmail ?? "";
    consultationData['contactNumber'] = userMobile ?? "";
    consultationData['flow'] = "healthCare";
    consultationData['category'] = "Health Care";
    consultationData['comments'] = "SecondOpinion";
    if (speciality != null) {
      consultationData['expertiseId'] = speciality;
      consultationData['enquiryFor'] = specialityName;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation speciality');
      return;
    }
    if (startDate != null) {
      consultationData['startDate'] = startDate;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation date');
      return;
    }
    if (startTime != null) {
      consultationData['startTime'] = startTime;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation time');
      return;
    }

    if (description != null) {
      consultationData['message'] = description;
    } else {
      Fluttertoast.showToast(
          msg: 'Please enter a brief description for your consultation');
      return;
    }

    submitForm();
  }

  void popFunction() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    userName =
        Provider.of<UserData>(context, listen: false).userData.firstName!;
    userEmail = Provider.of<UserData>(context, listen: false).userData.email!;
    userMobile = Provider.of<UserData>(context, listen: false).userData.mobile!;
    getSpeciality().then((value) {
      specialities =
          Provider.of<ExpertiseData>(context, listen: false).expertise;
      setState(() {});
      // getCompletedConsultations();
    });
    dateController.text = DateFormat("d MMM yyyy").format(DateTime.now());
  }

  PlatformFile? pickedFile;
  bool isPicked = false;
  bool isLoading = true;

  String uploadText = 'Add Prescription';

  void chooseFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'heif', 'pdf', 'doc'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          pickedFile = file;
          uploadText = pickedFile!.name;
        });
      } else {
        //! User cancelled the picker
      }
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Failed to choose file!');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isSubmitting = true;

  Future<void> uploadFile(PlatformFile file, User userData) async {

    print("File size : ${file.size}");
    if (file.size > 7000000) {
      Fluttertoast.showToast(msg: "File size shouldn't exceed 7 mb");
      return;
    }
    var dio = Dio();
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        ),
      });

      String? medLink;
      var response = await dio.post("${ApiUrl.wm}upload", data: formData);
      var responseData = response.data;
      String url = responseData["data"]["location"];
      medLink = url;
      consultationData['prescription'] = medLink;

      log("prescription uploaded : ${consultationData['prescription']}");
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to upload record");
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Second Opinion'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ListView.builder(
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: completedConsultations.length,
            //   itemBuilder: (context, index) {
            //     return completedConsultationCard(
            //         completedConsultations[index]);
            //   },
            // ),
            Padding(
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: DropdownButtonFormField(
                      isDense: true,
                      items: specialities
                          .map<DropdownMenuItem<String>>((Expertise value) {
                        return DropdownMenuItem(
                          value: value.id!,
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

                        for (int i = 0; i < specialities.length; i++) {
                          if (specialities[i].id == speciality) {
                            specialityName = specialities[i].name;
                          }
                        }
                        log(speciality!);
                        log(specialityName!);
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
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
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ListTile(
                      onTap: () {
                        chooseFile();
                      },
                      title: Text(
                        uploadText,
                        style: uploadText != "Add Prescription"
                            ? Theme.of(context).textTheme.bodySmall
                            : Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          chooseFile();
                        },
                        child: Text(
                          "Upload prescription",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: orange),
                        ),
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
                          onSubmit();
                          // log(consultationData.toString());
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
            )
          ],
        ),
      ),
    );
  }

  Widget completedConsultationCard(
      CompletedConsultations completedConsultations) {
    final date = StringDateTimeFormat()
        .stringtDateFormat3(completedConsultations.startDate!);
    final time = StringDateTimeFormat()
        .stringToTimeOfDay(completedConsultations.startTime!);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          completedConsultations.expertFirstName ?? "",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          completedConsultations.expertLastName ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.videocam_outlined,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              completedConsultations.status ?? "",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.event_outlined,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              date,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.schedule_rounded,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              time,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 36,
                    backgroundImage: AssetImage(
                      "assets/icons/user.png",
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    showSpecialistBottomSheet();
                  },
                  child: const Text('Get second opinion'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? speciality;
  String? specialityName;
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
                        value: value.id,
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
                        onSubmit();
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

      log(ymdFormat.toString());
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
      setState(() {
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);
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
