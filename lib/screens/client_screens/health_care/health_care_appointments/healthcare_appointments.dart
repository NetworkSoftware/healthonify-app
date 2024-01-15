import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/health_care/hc_consultations_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthCareAppointmentsScreen extends StatefulWidget {
  final bool isFromAyurveda;
  const HealthCareAppointmentsScreen({super.key, this.isFromAyurveda = false});

  @override
  State<HealthCareAppointmentsScreen> createState() =>
      _HealthCareAppointmentsScreenState();
}

class _HealthCareAppointmentsScreenState
    extends State<HealthCareAppointmentsScreen> {
  String? userId;
  List<HealthCareConsultations> consultations = [];

  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> ratingMap = {};

  void onComplete(String consultationId) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    ratingMap['consultationId'] = consultationId;
    ratingMap['status'] = 'completed';
    ratingMap['rate'] = rating;
    ratingMap['review'] = review;

    log(ratingMap.toString());
    submitRating();
  }

  void popFunction() {
    Navigator.pop(context);
  }

  Future<void> submitRating() async {
    try {
      await Provider.of<HealthCareProvider>(context, listen: false)
          .consultationRating(ratingMap);
      popFunction();
      popFunction();

      Fluttertoast.showToast(msg: 'Consultation review submitted successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submitting review $e");
      Fluttertoast.showToast(msg: "Not able to submit your review");
    }
  }

  bool isLoading = true;

  Future<void> getConsultations() async {
    try {
      if (widget.isFromAyurveda) {
        consultations = await Provider.of<HealthCareProvider>(context,
                listen: false)
            .getUserConsultations(
                data: "userId=$userId&expertiseId=6368b1870a7fad5713edb4b4");
      } else {
        consultations =
            await Provider.of<HealthCareProvider>(context, listen: false)
                .getUserConsultations(data: "userId=$userId");
      }
      log('fetched user hc consultations');
      // log(consultations.toString());
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong!");
    } catch (e) {
      log("Error getting user hc consultations $e");
      Fluttertoast.showToast(msg: "Unable to user hc consultations");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<HealthCarePrescription>> getHCPrescriptions(
      String consultationId, int index) async {
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

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id;

    getConsultations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Appointments'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : consultations.isEmpty
              ? const Center(child: Text('No Consultations scheduled'))
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: consultations.length,
                        itemBuilder: (context, index) {
                          return consultationCard(
                            consultations[index],
                            index,
                          );
                        },
                      ),
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
                              Text(
                                consultation.expertId == null ||
                                        consultation.expertId!.isEmpty
                                    ? ""
                                    : consultation.expertId![0].firstName!,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                consultation.expertiseId![0].name!,
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
                                    consultation.status ==
                                                "meetingLinkGenerated" ||
                                            consultation.status ==
                                                "expertAssigned" ||
                                            consultation.status == "scheduled"
                                        ? "Scheduled"
                                        : 'Meeting yet to schedule',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                                        Theme.of(context).textTheme.bodySmall,
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
                                        Theme.of(context).textTheme.bodySmall,
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 36,
                    backgroundImage: consultation.expertId == null ||
                            consultation.expertId!.isEmpty ||
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
                // InkWell(
                //   onTap: () {},
                //   borderRadius: BorderRadius.circular(10),
                //   child: Padding(
                //     padding: const EdgeInsets.all(4),
                //     child: Column(
                //       children: [
                //         Image.asset(
                //           'assets/icons/chat.png',
                //           height: 46,
                //           width: 46,
                //         ),
                //         const SizedBox(height: 10),
                //         const Text('Chat'),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(width: 30),
                if (consultation.status == "meetingLinkGenerated" ||
                    consultation.status == "expertAssigned" ||
                    consultation.status == "scheduled")
                  InkWell(
                    onTap: StringDateTimeFormat().checkForVideoCallValidation(
                            consultation.startTime!, consultation.startDate!)
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VideoCall1(
                                  meetingId: consultation.id,
                                  onVideoCallEnds: () {},
                                ),
                              ),
                            );
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
                if (consultation.status == "meetingLinkGenerated" ||
                    consultation.status == "expertAssigned" ||
                    consultation.status == "scheduled")
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

  int? rating;
  String? review;
  void showRatingSheet(String consultationId) {
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      'Feedback',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomTextField(
                      keyboard: TextInputType.phone,
                      hint: 'Rate your consultation experience (1 to 5)',
                      hintBorderColor: Colors.grey,
                      onSaved: (value) {
                        setState(() {
                          rating = int.parse(value!);
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please add a rating';
                        }
                        if (int.parse(value) > 5 || int.parse(value) < 1) {
                          return 'Enter a rating between 1 and 5';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomTextField(
                      hint: 'Review',
                      hintBorderColor: Colors.grey,
                      onSaved: (value) {
                        setState(() {
                          review = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please add a review';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        onComplete(consultationId);
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
