import 'dart:developer';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/consultation.dart';
import 'package:healthonify_mobile/models/health_care/ayurveda_models/ayurveda_conditions_model.dart';
import 'package:healthonify_mobile/models/health_care/hc_consultations_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/models/wm/wm_consultation.dart';
import 'package:healthonify_mobile/providers/all_consultations_data.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/health_care/ayurveda_provider/ayurveda_provider.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_provider.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/appointment_view_by_enquiry.dart';
import 'package:healthonify_mobile/screens/client_screens/appointment_view_package_by_enquiry.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_form/fitness_request_appointment.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/consult_doctor/doctor_consultation.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/view_appointments/consultation_details_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/user_prescription_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/weight_loss_enquiry.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/wm_consultation_details.dart';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/support_text_fields.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class AllAppointmentsScreen extends StatefulWidget {
  AllAppointmentsScreen({Key? key, required this.flow}) : super(key: key);
  String flow;

  @override
  State<AllAppointmentsScreen> createState() => _AllAppointmentsScreenState();
}

class _AllAppointmentsScreenState extends State<AllAppointmentsScreen> {
  bool _isLoading = false;

  //List<WmConsultation> data = [];
  var snackBar = const SnackBar(
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text('No more Appointments!'),
    ),
    duration: Duration(milliseconds: 1000),
  );
  int currentPage = 0;

  final RefreshController _refreshController = RefreshController();

  final Map<String, String> data = {
    "name": "",
    "email": "",
    "contactNumber": "",
    "userId": "",
    "enquiryFor": "",
    "message": "",
    "category": "",
    "flow": "",
  };

  List options = [
    "Live Well",
    "Weight Management",
    "Fitness",
    "Health Care",
    "Physiotherapy",
    "Dietitian",
  ];

  String? selectedValue;
  List treatmentConditions = [];
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = Provider
        .of<UserData>(context, listen: false)
        .userData
        .id!;
    if (widget.flow == '') {
      getConsultations();
    } else {
      getFlowConsultations();
    }

    fetchAyurvedaConditions().then(
          (value) {
        for (var ele in ayurvedaConditions) {
          treatmentConditions.add(ele.name);
        }
        log(treatmentConditions.toString());
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  Future<List<HealthCarePrescription>> getHCPrescriptions(String consultationId,
      int index) async {
    LoadingDialog().onLoadingDialog("Please wait", context);
    try {
      List<HealthCarePrescription> prescriptions =
      await Provider.of<HealthCareProvider>(context, listen: false)
          .getHealthCarePrescription(consultationId);
      log('fetched user hc consultation prescriptions');
      return prescriptions;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
      return [];
    } catch (e) {
      log("Error getting user hc consultations $e");
      Fluttertoast.showToast(
          msg: "Unable to user hc consultation prescriptions");
      return [];
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> getConsultations() async {
    log(currentPage.toString());
    setState(() {
      _isLoading = true;
    });
    String userId = Provider
        .of<UserData>(context, listen: false)
        .userData
        .id!;
    try {
      await Provider.of<AllConsultationsData>(context, listen: false)
          .getUserAllEnquiryData(userId, "");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting consultations $e");
      Fluttertoast.showToast(msg: "Unable to fetch consultations");
    } finally {
      // setState(() {
      //   _isPaginationLoading = false;
      // });
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getFlowConsultations() async {
    log(currentPage.toString());
    setState(() {
      _isLoading = true;
    });
    String userId = Provider
        .of<UserData>(context, listen: false)
        .userData
        .id!;
    try {
      await Provider.of<AllConsultationsData>(context, listen: false)
          .getUserAllEnquiryData(userId, widget.flow);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting consultations $e");
      Fluttertoast.showToast(msg: "Unable to fetch consultations");
    } finally {
      // setState(() {
      //   _isPaginationLoading = false;
      // });
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> submitForm() async {
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(data);
      Fluttertoast.showToast(
          msg: "Appointment Requested, an expert will get back to you soon");
      if (widget.flow == '') {
        getConsultations();
      } else {
        getFlowConsultations();
      }
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

  String? startDate;
  String? startTime;

  void onSubmit() {
    if (!_form.currentState!.validate()) {
      // setState(() => isLoading = false);
      return;
    }
    if (selectedValue == null) {
      Fluttertoast.showToast(msg: "Please choose a value from the dropdown");
    }
    data["category"] = selectedValue!;
    if (selectedValue == "Live Well") {
      data["flow"] = "liveWell";
    } else if (selectedValue == "Weight Management") {
      data["flow"] = "manageWeight";
    } else if (selectedValue == "Fitness") {
      data["flow"] = "fitness";
    } else if (selectedValue == "Physiotherapy") {
      data["flow"] = "physioTherapy";
    } else if (selectedValue == "Health Care") {
      data["flow"] = "healthCare";
    } else {
      data["flow"] = "diet";
    }
    _form.currentState!.save();
    log(data.toString());
    submitForm();
  }

  void setData(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNumber"] = userData.mobile ?? "";
    data["enquiryFor"] = "generalEnquiry";
    data["category"] = "";
    data["userId"] = userData.id!;
    data["flow"] = "";
  }

  Future<void> submitLiveWellForm() async {
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

  void setDataLiveWell(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNumber"] = userData.mobile ?? "";
    data["enquiryFor"] = "generalEnquiry";
    data["category"] = "";
    data["userId"] = userData.id!;
    data["message"] = "";
    data["date"] = "";
    data["time"] = "";
    data["flow"] = "liveWell";
  }

  void onSubmitLiveWell() {
    if (!_form.currentState!.validate()) {
      // setState(() => isLoading = false);
      return;
    }
    if (selectedValue == null) {
      Fluttertoast.showToast(msg: "Please choose a value from the dropdown");
    }
    if (dateController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please choose any date");
    }
    if (timeController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please choose time");
    }
    data["enquiryFor"] = selectedValue!;
    data["category"] = "Live Well";
    data["date"] = startDate!;
    data["time"] = startTime!;
    _form.currentState!.save();
    log(data.toString());
    submitLiveWellForm();
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider
        .of<UserData>(context)
        .userData;
    setData(userData);
    setDataLiveWell(userData);
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: "My Appointments"),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Consumer<AllConsultationsData>(
        builder: (context, value, child) =>
            ListView(
              children: [
                // const Padding(
                //   padding: EdgeInsets.only(left: 8.0, top: 10),
                //   child: Text("Enquiries"),
                // ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () async {
                          if (widget.flow == "healthCare") {
                            bool result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return const DoctorConsultationScreen();
                                }));

                            if (result == true) {
                              if (widget.flow == '') {
                                getConsultations();
                              } else {
                                getFlowConsultations();
                              }
                            }
                          } else if (widget.flow == "manageWeight") {
                            bool result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return const WeightLossEnquiry(
                                      isFitnessFlow: false);
                                }));

                            if (result == true) {
                              if (widget.flow == '') {
                                getConsultations();
                              } else {
                                getFlowConsultations();
                              }
                            }
                          } else if (widget.flow == "fitness") {
                            bool result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return const FitnessRequestAppointment(
                                      isFitnessFlow: true);
                                }));

                            if (result == true) {
                              if (widget.flow == '') {
                                getConsultations();
                              } else {
                                getFlowConsultations();
                              }
                            }
                          } else if (widget.flow == "physioTherapy") {
                            showDatePicker(
                              context: context,
                              builder: (context, child) {
                                return Theme(
                                  data: MediaQuery
                                      .of(context)
                                      .platformBrightness ==
                                      Brightness.dark
                                      ? datePickerDarkTheme
                                      : datePickerLightTheme,
                                  child: child!,
                                );
                              },
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2200),
                            ).then((value) {
                              if (widget.flow == '') {
                                getConsultations();
                              } else {
                                getFlowConsultations();
                              }
                            });
                          } else if (widget.flow == "healer") {
                            _showBottomSheetLiveWell();
                          } else if (widget.flow == "liveWell") {
                            _showBottomSheetLiveWell();
                          } else if (widget.flow == "ayurveda") {
                            requestAppointment(context);
                          }
                          else {
                            _showBottomSheet();
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: orange,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: const Text(
                              "+ Request Appointment",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.enquiryList.length,
                    itemBuilder: (context, index) {
                      return enquiryCard(context, value.enquiryList[index]);
                    }),
              ],
            ),
      ),
    );
  }

  Widget consultationCard(HealthCareConsultations consultation, int index) {
    final date =
    StringDateTimeFormat().stringtDateFormat(consultation.startDate!);
    final time =
    StringDateTimeFormat().stringToTimeOfDay(consultation.startTime!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (consultation.expertId!.isNotEmpty)
                                Text(
                                  consultation.expertId![0].firstName!,
                                  style:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                              Text(
                                consultation.expertiseId![0].name!,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium,
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
                                    consultation.status ==
                                        "meetingLinkGenerated" ||
                                        consultation.status ==
                                            "expertAssigned" ||
                                        consultation.status == "scheduled"
                                        ? "Scheduled"
                                        : 'Meeting yet to schedule',
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .bodySmall,
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
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .bodySmall,
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
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     TextButton(
                    //       onPressed: () {
                    //         Navigator.push(context,
                    //             MaterialPageRoute(builder: (context) {
                    //           return HealthcareAppointmentDetails(
                    //             healthCareConsultations: consultation,
                    //           );
                    //         }));
                    //       },
                    //       child: const Text('View details'),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                if (consultation.expertId!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 36,
                      backgroundImage:
                      consultation.expertId![0].imageUrl == null
                          ? const AssetImage(
                        "assets/icons/user.png",
                      ) as ImageProvider
                          : NetworkImage(
                        consultation.expertId![0].imageUrl!,
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/chat.png',
                          height: 46,
                          width: 46,
                        ),
                        const SizedBox(height: 10),
                        const Text('Chat'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: StringDateTimeFormat().checkForVideoCallValidation(
                      consultation.startTime!, consultation.startDate!)
                      ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoCall1(
                              meetingId: consultation.id,
                              onVideoCallEnds: () {},
                            ),
                      ),
                    );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => VideoCall1(
                    //       meetingId: consultation.id,
                    //       meetingPassword: "",
                    //       onVideoCallEnds: () {},
                    //     ),
                    //   ),
                    // );
                  }
                      : () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => VideoCall(
                    //       meetingId: consultation.id,
                    //       onVideoCallEnds: () {
                    //         showRatingSheet(consultation.id!);
                    //       },
                    //     ),
                    //   ),
                    // );
                    Fluttertoast.showToast(
                      msg:
                      "Video call will be available 15 mins before and till 1 hour after the assigned time ",
                      toastLength: Toast.LENGTH_LONG,
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/video_meeting.png',
                          height: 46,
                          width: 46,
                        ),
                        const SizedBox(height: 10),
                        const Text('Video Call'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    // log("${consultation.}");
                    var prescription =
                    await getHCPrescriptions(consultation.id!, index);

                    if (prescription.isNotEmpty) {
                      launchUrl(
                        Uri.parse(
                            prescription[0].healthCarePrescriptionUrl ?? ""),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/prescription.png',
                          height: 46,
                          width: 46,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Download\nPrescription',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget expertCardPaidWm(BuildContext context,
      WmConsultation consultationData) {
    final date =
    StringDateTimeFormat().stringtDateFormat(consultationData.startDate!);
    final time =
    StringDateTimeFormat().stringToTimeOfDay(consultationData.startTime!);

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultationData.expert != null &&
                            consultationData.expert!.isNotEmpty
                            ? " ${consultationData.expert![0]["firstName"] ??
                            ""}"
                            : "",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall,
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
                            consultationData.status == "meetingLinkGenerated" ||
                                consultationData.status == "expertAssigned"
                                ? "Scheduled"
                                : 'Meeting yet to schedule',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 36,
                    backgroundImage: consultationData.expert == null ||
                        consultationData.expert!.isEmpty ||
                        !consultationData.expert![0]
                            .containsKey("imageUrl") ||
                        consultationData.expert![0]["imageUrl"] == ""
                        ? const AssetImage(
                      "assets/icons/user.png",
                    ) as ImageProvider
                        : NetworkImage(
                      consultationData.expert![0]["imageUrl"]!,
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return WmConsultationDetailsScreen(
                            consultationData: consultationData,
                          );
                        }));
                  },
                  child: const Text('View details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget enquiryCard(BuildContext context, Enquiry enquiries) {
    final date =
    StringDateTimeFormat().stringtDateFormatLogWeight(enquiries.date!);
    final time = StringDateTimeFormat().stringToTimeOfDay(enquiries.time!);

    String status = "";
    if (enquiries.status == "Interested") {
      status = "Review in Progress";
    } else if (enquiries.status == "generalEnquiryInitiated") {
      status = "Review in Progress";
    } else if (enquiries.status == "initiated") {
      status = "Review in Progress";
    } else if (enquiries.status == "packagePaymentRequested") {
      status = "View Package Details";
    } else if (enquiries.status == "packageSubscribed") {
      //  status = "View Sessions";
      status = "View Subscription";
    } else {
      status = "View Details";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   enquiries.enquiryName ?? "",
              //   style: Theme.of(context).textTheme.headlineSmall,
              // ),
              // const SizedBox(height: 10),
              infoRow(title: 'Ticket Number', value: enquiries.ticketNumber!),
              const SizedBox(height: 10),
              //  infoRow(title: 'Contact Number',value: enquiries.contactNumber!),
              infoRow(title: 'Category', value: enquiries.category!),
              const SizedBox(height: 10),
              infoRow(title: 'Date', value: date ?? ""),
              const SizedBox(height: 10),
              infoRow(title: 'Time', value: time ?? ""),
              // const SizedBox(height: 10),
              // infoRow(title: 'Status', value: enquiries.status! ?? ""),
              const SizedBox(height: 10),
              enquiries.comments != null
                  ?
              infoRow(title: 'Status', value: enquiries.comments!)
                  : const SizedBox(),
              const SizedBox(height: 20),
              status == "View Details"
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  enquiries.flow == "healthCare"
                      ? GestureDetector(
                    onTap: () async {
                      bool result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return PrescriptionUserScreen(
                              ticketNumber: enquiries.ticketNumber!,
                            );
                          }));

                      if (result == true) {
                        if (widget.flow == '') {
                          getConsultations();
                        } else {
                          getFlowConsultations();
                        }
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: orange,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: const Text(
                          "Prescription",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  )
                      : const SizedBox(),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      bool result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return AppointmentViewByEnquiry(
                              flow: enquiries.flow!,
                              ticketNumber: enquiries.ticketNumber!,
                            );
                          }));

                      if (result == true) {
                        if (widget.flow == '') {
                          getConsultations();
                        } else {
                          getFlowConsultations();
                        }
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: orange,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          status,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              )
                  : status == "View Package Details"
                  ? Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    bool result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return AppointmentViewPackageByEnquiry(
                            flow: enquiries.flow!,
                            ticketNumber: enquiries.ticketNumber!,
                          );
                        }));

                    if (result == true) {
                      if (widget.flow == '') {
                        getConsultations();
                      } else {
                        getFlowConsultations();
                      }
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: orange,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Text(
                        status,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              )
                  : status == "View Subscription"
                  ? Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    bool result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return AppointmentViewPackageByEnquiry(
                            flow: enquiries.flow!,
                            ticketNumber: enquiries.ticketNumber!,
                          );
                        }));

                    if (result == true) {
                      if (widget.flow == '') {
                        getConsultations();
                      } else {
                        getFlowConsultations();
                      }
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: orange,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Text(
                        status,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              )
                  : Align(
                alignment: Alignment.centerRight,
                child: Text(
                  status ?? "",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoRow({required String title, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value ?? "",
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget expertCardFreePhysio(BuildContext context,
      Consultation consultationData) {
    final date =
    StringDateTimeFormat().stringtDateFormat(consultationData.startDate!);
    final time =
    StringDateTimeFormat().stringToTimeOfDay(consultationData.startTime!);

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Free Consultation",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall,
                      ),
                      const SizedBox(height: 8),
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Expert will be assigned soon",
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelMedium,
                  ),
                )
                // TextButton(
                //   onPressed: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) {
                //       return ConsultationDetailsScreen(
                //         consultationData: consultationData,
                //       );
                //     }));
                //   },
                //   child: const Text('View details'),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget expertCardPaidPhysio(BuildContext context,
      Consultation consultationData) {
    final date =
    StringDateTimeFormat().stringtDateFormat(consultationData.startDate!);
    final time =
    StringDateTimeFormat().stringToTimeOfDay(consultationData.startTime!);

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultationData.expertId!["firstName"] ?? "",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall,
                      ),
                      Text(
                        consultationData.expertiseId!.isNotEmpty
                            ? consultationData.expertiseId![0]["name"]
                            : "",
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
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
                            consultationData.status == "meetingLinkGenerated" ||
                                consultationData.status == "expertAssigned"
                                ? "Scheduled"
                                : 'Meeting yet to schedule',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 36,
                    backgroundImage:
                    !consultationData.expertId!.containsKey("imageUrl") ||
                        consultationData.expertId!["imageUrl"] == ""
                        ? const AssetImage(
                      "assets/icons/user.png",
                    ) as ImageProvider
                        : NetworkImage(
                      consultationData.expertId!["imageUrl"]!,
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return ConsultationDetailsScreen(
                            consultationData: consultationData,
                          );
                        }));
                  },
                  child: const Text('View details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final _form = GlobalKey<FormState>();

  void getMessage(String message) => data["message"] = message;

  void _showBottomSheet() {
    showModalBottomSheet(
        elevation: 10,
        isScrollControlled: true,
        context: context,
        builder: (ctx) =>
            SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Form(
                  key: _form,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery
                            .of(ctx)
                            .viewInsets
                            .bottom + 1),
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
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall,
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
                              "Explain your issue",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,
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
                      StatefulBuilder(
                        builder: (context, newState) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: DropdownButtonFormField(
                                isDense: true,
                                items:
                                options.map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  newState(() {
                                    selectedValue = newValue!;
                                  });
                                },
                                value: selectedValue,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
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
                                  'Select',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
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

  void _showBottomSheetLiveWell() {
    showModalBottomSheet(
        elevation: 10,
        isScrollControlled: true,
        context: context,
        builder: (ctx) =>
            SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Form(
                  key: _form,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery
                            .of(ctx)
                            .viewInsets
                            .bottom + 1),
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
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      StatefulBuilder(
                        builder: (context, newState) =>
                            Consumer<ExpertiseData>(
                              builder: (context, data, child) {
                                List<String> options = [];
                                List<String> id = [];
                                for (var element in data.expertise) {
                                  options.add(element.name!);
                                  id.add(element.id!);
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: DropdownButtonFormField(
                                    isDense: true,
                                    items:
                                    options.map<DropdownMenuItem<String>>((
                                        value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      newState(() {
                                        selectedValue = newValue!;
                                      });
                                    },
                                    value: selectedValue,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyMedium,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
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
                                      'Select',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ),
                                );
                              },
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    datePicker(dateController);
                                  },
                                  child: IgnorePointer(
                                    child: TextFormField(
                                      controller: dateController,
                                      decoration: InputDecoration(
                                        fillColor: Theme
                                            .of(context)
                                            .canvasColor,
                                        filled: true,
                                        hintText: 'Date',
                                        hintStyle: Theme
                                            .of(context)
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
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(color: orange),
                                          ),
                                        ),
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 8),
                                      ),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodySmall,
                                      cursorColor: whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    timePicker(timeController);
                                  },
                                  child: IgnorePointer(
                                    child: TextFormField(
                                      controller: timeController,
                                      decoration: InputDecoration(
                                        fillColor: Theme
                                            .of(context)
                                            .canvasColor,
                                        filled: true,
                                        hintText: 'Time',
                                        hintStyle: Theme
                                            .of(context)
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
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(color: orange),
                                          ),
                                        ),
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 8),
                                      ),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodySmall,
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
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,
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
                            submit: onSubmitLiveWell,
                            title: "Request Now",
                          )),
                    ]),
                  ),
                ),
              ),
            ));
  }

  void requestAppointment(context) {
    showModalBottomSheet(
      backgroundColor: Theme
          .of(context)
          .canvasColor,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Treatment Condition',
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: treatmentConditions
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      requestCondition = newValue!;
                    });
                  },
                  value: requestCondition,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
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
                    'Condition',
                    style: Theme
                        .of(context)
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
                                fillColor: Theme
                                    .of(context)
                                    .canvasColor,
                                filled: true,
                                hintText: 'Date',
                                hintStyle: Theme
                                    .of(context)
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
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: orange),
                                  ),
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall,
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
                                fillColor: Theme
                                    .of(context)
                                    .canvasColor,
                                filled: true,
                                hintText: 'Time',
                                hintStyle: Theme
                                    .of(context)
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
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: orange),
                                  ),
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall,
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
                      fillColor: Theme
                          .of(context)
                          .canvasColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Describe your issue',
                      hintStyle: Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall,
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
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
                      onAyurvedaSubmit();
                    },
                    child: Text(
                      'Request Appointment',
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  String? selectedTime;
  String? description;
  String? requestCondition;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

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

      var todayDate = DateTime.now().toString().split(' ');

      log(todayDate[0]);

      log(ymdFormat.toString());
      if (ymdFormat.toString() == todayDate[0]) {
        print("ValueHour : ${value.hour}");
        if (value.hour < (DateTime
            .now()
            .hour + 3)) {
          Fluttertoast.showToast(
              msg:
              'Consultation time must be atleast 3 hours after current time');

          return;
        }
      }
      setState(() {
        var format24hrTime =
            '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString()
            .padLeft(2, "0")}:00';
        selectedTime = format24hrTime;
        startTime = format24hrTime;
        log('24h time: $selectedTime');
        controller.text = value.format(context);
      });
    });
  }

  List<AyurvedaConditionsModel> ayurvedaConditions = [];
  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat;

  void datePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: MediaQuery
              .of(context)
              .platformBrightness == Brightness.dark
              ? datePickerDarkTheme
              : datePickerLightTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
        startDate = DateFormat('yyyy/MM/dd').format(temp);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }

  Future<void> fetchAyurvedaConditions() async {
    try {
      ayurvedaConditions =
      await Provider.of<AyurvedaProvider>(context, listen: false)
          .getAyurvedaConditions();

      log('fetched ayurveda conditions');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching ayurveda conditions');
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  Map<String, dynamic> consultationData = {};

  void onAyurvedaSubmit() {
    consultationData['userId'] = userId;
    if (selectedTime != null) {
      consultationData['startTime'] = selectedTime;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation time');
      return;
    }
    if (ymdFormat != null) {
      consultationData['startDate'] = ymdFormat;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation date');
      return;
    }
    consultationData['expertiseId'] = '6368b1870a7fad5713edb4b4';

    if (description != null) {
      consultationData['description'] = description;
    } else {
      Fluttertoast.showToast(
          msg: 'Please enter a brief description for your consultation');
      return;
    }

    log(consultationData.toString());
    submitAyurvedaForm();
  }

  Future<void> submitAyurvedaForm() async {
    LoadingDialog().onLoadingDialog("Please wait....", context);
    try {
      await Provider.of<HealthCareProvider>(context, listen: false)
          .consultSpecialist(consultationData);
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Consultation scheduled successfully');
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
}
