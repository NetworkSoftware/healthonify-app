import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/get_subscriptions.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/consultation.dart';
import 'package:healthonify_mobile/models/experts/subscriptions.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/experts/subscriptions_data.dart';
import 'package:healthonify_mobile/providers/get_consultation.dart';
import 'package:healthonify_mobile/providers/physiotherapy/session_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/physio/expert_physio_assign_session.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/client_details/expert_client_sessions.dart';
import 'package:healthonify_mobile/screens/expert_screens/physio/expert_physio_packages_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/physio/physio_prescription.dart';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/buttons/customappbar_action_btns.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ExpertPhysioConsultationDetailsScreen extends StatelessWidget {
  final Consultation consultationData;
  ExpertPhysioConsultationDetailsScreen(
      {Key? key, required this.consultationData})
      : super(key: key);
  bool noContent = false;

  Future<void> getConsultationDetails(
      BuildContext context, String id, Function onSuccess) async {
    try {
      await Provider.of<GetConsultation>(context, listen: false)
          .getConsultationBasedOnId(id);

      log("user id ${consultationData.user![0]["_id"]}");

      await onSuccess.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error appointment details screen $e");
      Fluttertoast.showToast(msg: "Unable to fetch consultation details");
    }
  }

  Future<void> getSub(BuildContext context, String id) async {
    noContent = await GetSubscription().getPhysioSubs(context,
        "userId=$id&status=paymentReceived&consultationId=${consultationData.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: '',
        widgetRight: CustomAppBarTextBtn(
            onClick: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExpertPhysioPackagesScreen(
                        userIdToAssign: consultationData.user![0]["_id"],
                        consultationId: consultationData.id!,
                      )));
            },
            title: "Assign Package"),
      ),
      body: FutureBuilder(
        future: getConsultationDetails(context, consultationData.id!, () async {
          await getSub(context, consultationData.user![0]["_id"]);
        }),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : consultationCard(context),
      ),
    );
  }

  Widget consultationCard(
    BuildContext context,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Consumer<GetConsultation>(
            builder: (context, value, child) => Column(
              children: [
                if (consultationData.status != "initiated")
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    radius: 70,
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
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: consultationData.status != "initiated"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${value.consultationDetails.user![0]["firstName"]} ${value.consultationDetails.user![0]["lastName"]}",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            if (consultationData.status != "initiated")
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                    consultationData.expertiseId!.isNotEmpty
                                        ? consultationData.expertiseId![0]
                                            ["name"]
                                        : "Free Consultation",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                          ],
                        )
                      : const Text("Free Consultation"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (consultationData.status != "initiated")
                        InkWell(
                          onTap: () {
                            log(consultationData.expertId!["_id"]);
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) => ChatScreen(
                            //       expertId: consultationData.expertId!["_id"],
                            //       consultationId: consultationData.id!,
                            //       userId: value.consultationDetails.userId!),
                            // ));
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
                      if (consultationData.status == "meetingLinkGenerated" ||
                          consultationData.status == "expertAssigned")
                        InkWell(
                          onTap: StringDateTimeFormat()
                                  .checkForVideoCallValidation(
                                      consultationData.startTime!,
                                      consultationData.startDate!)
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VideoCall1(
                                        onVideoCallEnds: () {},
                                        meetingId: value
                                            .consultationDetails.meetingLink,
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
                                const SizedBox(height: 10),
                                const Text('Video Call'),
                              ],
                            ),
                          ),
                        ),
                      InkWell(
                        onTap: () async {
                          // log("${consultation.}");
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return PhysioPrescriptionScreen(
                              consultationId: consultationData.id!,
                              clientId: consultationData.user![0]["_id"],
                            );
                          }));
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
                                'Assign\nPrescription',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Consumer<SubscriptionsData>(
          builder: (context, value, child) => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: value.subsData.length,
            itemBuilder: (context, index) => Card(
              child: PackCard(
                  subsData: value.subsData[index],
                  clientID: consultationData.user![0]["_id"]),
            ),
          ),
        )
      ],
    );
  }
}

class PackCard extends StatefulWidget {
  final Subscriptions subsData;
  final String clientID;

  const PackCard({Key? key, required this.subsData, required this.clientID})
      : super(key: key);

  @override
  State<PackCard> createState() => _PackCardState();
}

class _PackCardState extends State<PackCard> {
  bool _isLoading = false;

  void pushScreen(MaterialPageRoute route) {
    Navigator.of(context).push(route);
  }

  Future<void> fetchSessions(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      bool value = await Provider.of<SessionData>(context, listen: false)
          .getAllSessions(data: "?subscriptionId=${widget.subsData.id}");
      if (value == true) {
        Fluttertoast.showToast(msg: "Sessions already assigned");
        pushScreen(
          MaterialPageRoute(
            builder: (context) => ExpertClientSessions(
              clientId: widget.clientID,
              subscriptionId: widget.subsData.id,
            ),
          ),
        );
      } else {
        pushScreen(
          MaterialPageRoute(
            builder: (context) =>
                ExpertPhysioAssignSession(subId: widget.subsData.id),
          ),
        );
      }
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get sessions $e");
      // Fluttertoast.showToast(msg: "Unable to get your sessions");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.subsData.packageName!,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  widget.subsData.status! == "paymentReceived"
                      ? const Text("Paid")
                      : const Text("Payment Pending"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("\u{20B9}${widget.subsData.netAmount!}"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(children: [
                    const Icon(Icons.date_range),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.subsData.startDate!)
                  ]),
                ],
              ),
              if (widget.subsData.status! == "paymentReceived")
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _isLoading
                        ? const Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: CircularProgressIndicator(),
                          )
                        : GradientButton(
                            title: "Sessions",
                            func: () async {
                              fetchSessions(context);
                            },
                            gradient: orangeGradient,
                          ),
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }
}
