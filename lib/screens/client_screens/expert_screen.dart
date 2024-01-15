import 'dart:developer';
import 'dart:io';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/widgets/other/certificate_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/health_care/health_care_expert/health_care_expert.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/experts_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/pdf_viewing_screen.dart';
import 'package:provider/provider.dart';

class ExpertScreen extends StatefulWidget {
  final String? expertId;

  const ExpertScreen({this.expertId, Key? key}) : super(key: key);

  @override
  State<ExpertScreen> createState() => _ExpertScreenState();
}

class _ExpertScreenState extends State<ExpertScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final Map<String, String> data = {
    "name": "",
    "email": "",
    "contactNumber": "",
    "userId": "",
    "enquiryFor": "",
    "message": "",
    "category": "",
  };
  List options = [
    "Physiotherapy",
    "Weight Management",
    "Fitness",
    "Travel",
    "Health Care",
    "Auyrveda",
    "De-stress",
    "Others"
  ];
  String? selectedValue;

  bool isLoading = true;

  bool isFormSubmitting = false;

  List<HealthCareExpert> expertData = [];

  Future<void> getExperts() async {
    try {
      expertData = await Provider.of<ExpertsData>(context, listen: false)
          .fetchHealthCareExpertsData(widget.expertId!);

      if (expertData.isNotEmpty) {
        await Provider.of<ExpertiseData>(context, listen: false)
            .fetchExpertise(expertData[0].topExpertiseId!);
      }
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

  Future<void> getSpeciality() async {
    try {} on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get fetch speciality $e");
      Fluttertoast.showToast(msg: "Unable to fetch speciality");
    }
  }

  late String userId;
  String? topLevelExpertise;
  List<TopLevelExpertise> expertiseList = [];
  late String expertise;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    expertise = Provider.of<ExpertiseData>(context, listen: false)
            .expertise
            .isEmpty
        ? ""
        : Provider.of<ExpertiseData>(context, listen: false).expertise[0].name!;

    getExperts();
  }

  String? description;
  Map<String, dynamic> requestAppointment = {};

  void onRequestAppointment() {
    requestAppointment['userId'] = userId;
    requestAppointment['contactNumber'] = expertData[0].mobileNo;
    requestAppointment['name'] =
        expertData[0].firstName! + expertData[0].lastName!;
    requestAppointment['email'] = expertData[0].email;
    requestAppointment['enquiryFor'] = 'generalEnquiry';
    requestAppointment['category'] = topLevelExpertise;
    requestAppointment['flow'] = expertData[0].topExpertiseFlow!;
    if (descController.text != null) {
      requestAppointment['message'] = descController.text;
    } else {
      Fluttertoast.showToast(
          msg: 'Please enter a brief description for your consultation');
      return;
    }

    log(requestAppointment['message'].toString());
    submitForm();
  }

  Future<void> submitForm() async {
    // popFunction();
    setState(() {
      LoadingDialog().onLoadingDialog("Please wait....", context);
    });
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(requestAppointment);
      popFunction();
      Fluttertoast.showToast(msg: 'Consultation scheduled successfully');
    } on HttpException catch (e) {
      log("Error : ${e.toString()}");
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error request appointment $e");
      Fluttertoast.showToast(msg: "Not able to submit your request");
    } finally {
      popFunction();
      setState(() {
        isFormSubmitting = false;
      });
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: CustomAppBar(
              appBarTitle: expertData[0].firstName!,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: expertData[0].imageUrl == null
                        ? const CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                AssetImage('assets/icons/expert_pfp.png'),
                          )
                        : CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                              expertData[0].imageUrl!,
                            ),
                          ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "${expertData[0].firstName!} ${expertData[0].lastName!}",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      expertData[0].topExpertiseName!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )),
                  if (expertData[0].city != null && expertData[0].state != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Location :',
                              style: Theme.of(context).textTheme.labelMedium),
                          Text(
                              '${expertData[0].city!}, ${expertData[0].state!}',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  if (expertData[0].about != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 20),
                          child: Text('About :',
                              style: Theme.of(context).textTheme.labelMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 20),
                          child: Text(
                            expertData[0].about!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text('Certificates :',
                                style: Theme.of(context).textTheme.labelMedium),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          height: 120,
                          child: expertData[0].certificates == null
                              ? const Text('No Certificates available')
                              : ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: expertData[0].certificates!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        print(expertData[0].certificates![0]);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CertificateViewPdfScreen(
                                                      url: expertData[0]
                                                          .certificates!,
                                                    )));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/others/certificates.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<ExpertiseData>(builder: (context, data, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey)),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              icon: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.keyboard_arrow_down_rounded,
                                    color: Colors.black, size: 26),
                              ),
                              hint: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Select Category",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ),
                              underline: const SizedBox(),
                              items: data.expertise.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category.name,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(category.name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                  ),
                                );
                              }).toList(),
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  topLevelExpertise = newValue;
                                });
                              },
                              value: topLevelExpertise,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
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
                            controller: descController,
                            onChanged: (value) {
                              setState(() {
                                description = value;
                              });
                            },
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              onRequestAppointment();
                              //_showBottomSheet();
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: orange,
                                  border: Border.all(color: Colors.grey)),
                              child: const Center(
                                child: Text(
                                  "Book Appointment",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  }),
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
                  // key: _form,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Please enter a description for your enquiry",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 14),
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
                                  controller: descController,
                                  onChanged: (value) {
                                    setState(() {
                                      description = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                      // StatefulBuilder(
                      //   builder: (context, newState) => Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 16),
                      //     child: DropdownButtonFormField(
                      //       isDense: true,
                      //       items:
                      //           options.map<DropdownMenuItem<String>>((value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: Text(
                      //             value,
                      //             style: Theme.of(context)
                      //                 .textTheme
                      //                 .bodyMedium!
                      //                 .copyWith(
                      //                   color: Colors.grey,
                      //                 ),
                      //           ),
                      //         );
                      //       }).toList(),
                      //       onChanged: (String? newValue) {
                      //         newState(() {
                      //           selectedValue = newValue!;
                      //         });
                      //       },
                      //       value: selectedValue,
                      //       style: Theme.of(context).textTheme.bodyMedium,
                      //       decoration: InputDecoration(
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8),
                      //           borderSide: const BorderSide(
                      //             color: Colors.grey,
                      //             width: 1.25,
                      //           ),
                      //         ),
                      //         constraints: const BoxConstraints(
                      //           maxHeight: 56,
                      //         ),
                      //         contentPadding:
                      //             const EdgeInsets.symmetric(horizontal: 8),
                      //       ),
                      //       icon: const Icon(
                      //         Icons.keyboard_arrow_down_rounded,
                      //         color: Colors.grey,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //       hint: Text(
                      //         'Select',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .bodySmall!
                      //             .copyWith(color: Colors.grey),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              onRequestAppointment();
                            },
                            child: Text(
                              'Request Appointment',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ));
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
  String? ymdFormat;
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

        if (temp.isBefore(DateTime.now())) {
          Fluttertoast.showToast(msg: 'Please select a valid date');
          return;
        }

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

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/others/certificates.png'),
                fit: BoxFit.cover)),
      ),
    );
  }
}
