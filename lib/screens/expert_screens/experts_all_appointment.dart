import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/wm_consultation.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_consultations_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/assign_package.dart';
import 'package:healthonify_mobile/screens/expert_screens/consultation_comment.dart';
import 'package:healthonify_mobile/screens/expert_screens/expert_appointment_view_session_by_enquiry.dart';
import 'package:healthonify_mobile/screens/prescription_screen.dart';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class ExpertsAllAppointment extends StatefulWidget {
  const ExpertsAllAppointment({Key? key}) : super(key: key);

  @override
  State<ExpertsAllAppointment> createState() => _ExpertsAllAppointmentState();
}

class _ExpertsAllAppointmentState extends State<ExpertsAllAppointment> {
  bool _noContent = false;
  List<WmConsultation> resultData = [];

  Future<void> _getFunc(BuildContext context) async {
    String id = Provider.of<UserData>(context, listen: false).userData.id!;
    String flow =
        Provider.of<UserData>(context, listen: false).userData.topLevelExpName!;
    log(flow);

    try {
      resultData = [];
      resultData = await Provider.of<WmConsultationData>(context, listen: false)
          .getExpertConsultation(
        "expertId=$id",
        "0",
      );
      // if (flow == "Dietitian") {
      _noContent = false;
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      _noContent = true;
    } catch (e) {
      log("Error get view appointments widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch orders");
      _noContent = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: "Appointments",
      ),
      body: FutureBuilder(
        future: _getFunc(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: resultData.length,
                    itemBuilder: (context, index) {
                      if (resultData[index].status == "initiated") {
                        // return expertCardFree(context, data[index]);
                        return expertCardPaid(context, resultData[index]);
                      }
                      return expertCardPaid(context, resultData[index]);

                      // return expertCardPaid(context, data[index]);
                    },
                  ),
      ),
    );
  }

  Widget expertCardPaid(BuildContext context, WmConsultation consultationData) {
    const date = "";
    // final date =
    // StringDateTimeFormat().stringtDateFormatLogWeight(consultationData.startDate!);
    final time =
        StringDateTimeFormat().stringToTimeOfDay(consultationData.startTime!);

    String status = "";
    if (consultationData.status == "Interested") {
      status = "Review in Progress";
    } else if (consultationData.status == "generalEnquiryInitiated") {
      status = "Review in Progress";
    } else if (consultationData.status == "paymentRequested") {
      status = "Payment requested";
    } else if (consultationData.status == "consultationScheduled") {
      status = "Consultation scheduled";
    } else if (consultationData.status == "packageSubscribed") {
      status = "View Sessions";
    } else {
      status = "Consultation completed";
    }

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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "Ticket Number :",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            consultationData.ticketNumber! ?? "",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Client :",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${consultationData.userId!.first['firstName']} ${consultationData.userId!.first['lastName']}" ??
                                "",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam_outlined,
                            size: 30,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          // Text(
                          //   consultationData.status == "meetingLinkGenerated" ||
                          //           consultationData.status == "expertAssigned"
                          //       ? "Scheduled"
                          //       : 'Meeting yet to schedule',
                          //   style: Theme.of(context).textTheme.headlineSmall,
                          // ),
                          Text(
                            consultationData.expertiseId!.first['name'],
                            style: Theme.of(context).textTheme.headlineSmall,
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Status :',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            consultationData.status!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 36,
                    backgroundImage:
                        !consultationData.expert![0].containsKey("imageUrl") ||
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
                consultationData.status == "consultationScheduled"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: StringDateTimeFormat()
                                    .checkForVideoCallSessionValidation(
                                        consultationData.startTime!,
                                        consultationData.startDate!)
                                ? () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => VideoCall1(
                                          meetingId: consultationData.id,
                                          onVideoCallEnds: () {},
                                        ),
                                      ),
                                    );
                                  }
                                : () {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Video call will be available 15 mins before and till 1 hour after the assigned time ",
                                        toastLength: Toast.LENGTH_LONG);
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
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {
                              bool result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ConsultationComment(
                                    ticketNumber:
                                        consultationData.ticketNumber!,
                                    flow: consultationData.flow!,
                                    comment: consultationData.comment!,
                                  ),
                                ),
                              );

                              if (result == true) {
                                _getFunc(context);
                                setState(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: orange,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: const Text(
                                'Comment/Close',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      )
                    : consultationData.status == "consulationCompleted"
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return PrescriptionScreen(
                                      consultationId: consultationData.id!,
                                      expertId:
                                          consultationData.expert!.first["_id"],
                                      userId:
                                          consultationData.userId!.first["_id"],
                                      ticketNumber:
                                          consultationData.ticketNumber!,
                                    );
                                  }));
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         const PrescriptionScreen(),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: orange,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: const Text(
                                    'Prescription',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  bool result =
                                      await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ConsultationComment(
                                        ticketNumber:
                                            consultationData.ticketNumber!,
                                        flow: consultationData.flow!,
                                        comment: consultationData.comment!,
                                      ),
                                    ),
                                  );

                                  if (result == true) {
                                    _getFunc(context);
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: orange,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: const Text(
                                    'Comment/Close',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : consultationData.status == "closed"
                            ? Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return PrescriptionScreen(
                                          consultationId: consultationData.id!,
                                          expertId: consultationData
                                              .expert!.first["_id"],
                                          userId: consultationData
                                              .userId!.first["_id"],
                                          ticketNumber:
                                              consultationData.ticketNumber!,
                                        );
                                      }));
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         const PrescriptionScreen(),
                                      //   ),
                                      // );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: orange,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: const Text(
                                        'Prescription',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      bool result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  PackageListScreen(
                                                    flowName:
                                                        consultationData.flow!,
                                                    expertId: consultationData
                                                        .expert![0]["_id"],
                                                    userId: consultationData
                                                        .userId![0]["_id"],
                                                    ticketNumber:
                                                        consultationData
                                                            .ticketNumber!,
                                                  )));

                                      if (result == true) {
                                        _getFunc(context);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: orange,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: const Text(
                                        'Assign Package',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : consultationData.status == "packageSubscribed"
                                ? GestureDetector(
                                    onTap: () async {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ExpertAppointmentViewSessionByEnquiry(
                                          ticketNumber:
                                              consultationData.ticketNumber!,
                                          flow: consultationData.flow!,
                                        );
                                      }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: orange,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: const Text(
                                        'View Sessions',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : const SizedBox(), // An empty space for other cases
              ],
            ),
            const SizedBox(height: 10),
          ],
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
