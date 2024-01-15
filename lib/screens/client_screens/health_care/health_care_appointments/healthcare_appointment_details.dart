import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/health_care/hc_consultations_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_provider.dart';
// import 'package:healthonify_mobile/screens/video_call.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class HealthcareAppointmentDetails extends StatefulWidget {
  final HealthCareConsultations healthCareConsultations;
  const HealthcareAppointmentDetails(
      {required this.healthCareConsultations, super.key});

  @override
  State<HealthcareAppointmentDetails> createState() =>
      _HealthcareAppointmentDetailsState();
}

class _HealthcareAppointmentDetailsState
    extends State<HealthcareAppointmentDetails> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> ratingMap = {};

  void onComplete() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    ratingMap['consultationId'] = widget.healthCareConsultations.id;
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
      Fluttertoast.showToast(msg: 'Consultation review submitted successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submitting review $e");
      Fluttertoast.showToast(msg: "Not able to submit your review");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Details'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            consultationDetails(),
          ],
        ),
      ),
    );
  }

  Widget consultationDetails() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Center(
          child: CircleAvatar(
            backgroundColor: Colors.blue[100],
            radius: 44,
            backgroundImage:
                widget.healthCareConsultations.expertId![0].imageUrl == null ||
                        widget.healthCareConsultations.expertId![0].imageUrl!
                            .isEmpty
                    ? const AssetImage(
                        "assets/icons/user.png",
                      ) as ImageProvider
                    : NetworkImage(
                        widget.healthCareConsultations.expertId![0].imageUrl!,
                      ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${widget.healthCareConsultations.expertId![0].firstName} ${widget.healthCareConsultations.expertId![0].lastName}",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(widget.healthCareConsultations.expertiseId![0].name ?? ""),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                log("Enable dash chat");

                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => ChatScreen(
                //         expertId:
                //             widget.healthCareConsultations.expertId![0].id!,
                //         consultationId: widget.healthCareConsultations.id!,
                //         userId: widget.healthCareConsultations.userId![0].id!),
                //   ),
                // );
              },
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
            const SizedBox(width: 50),
            InkWell(
              onTap: () {
                showRatingSheet();
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => VideoCall(
                //       onVideoCallEnds: () {},
                //       meetingId: widget.healthCareConsultations.meetingLink,
                //     ),
                //   ),
                // );
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
          ],
        ),
      ],
    );
  }

  int? rating;
  String? review;
  void showRatingSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        onComplete();
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
