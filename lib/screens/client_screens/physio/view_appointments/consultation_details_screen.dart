import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/get_subscriptions.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/consultation.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/experts/subscriptions_data.dart';
import 'package:healthonify_mobile/providers/get_consultation.dart';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ConsultationDetailsScreen extends StatelessWidget {
  final Consultation consultationData;
  ConsultationDetailsScreen({Key? key, required this.consultationData})
      : super(key: key);

  bool noContent = false;

  Future<void> getConsultationDetails(
      BuildContext context, String id, Function onSuccess) async {
    try {
      await Provider.of<GetConsultation>(context, listen: false)
          .getConsultationBasedOnId(id);
      await onSuccess.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error appointment details screen $e");
      Fluttertoast.showToast(msg: "Unable to fetch consultation details");
    }
  }

  Future<void> getSub(
      BuildContext context, String id, String consultationId) async {
    noContent = await GetSubscription()
        .getPhysioSubs(context, "userId=$id&consultationId=$consultationId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
      ),
      body: FutureBuilder(
        future: getConsultationDetails(context, consultationData.id!, () async {
          await getSub(
              context, consultationData.user![0]["_id"], consultationData.id!);
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
      children: [
        Consumer<GetConsultation>(
            builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          if (consultationData.status != "initiated")
                            Flexible(
                              child: CircleAvatar(
                                backgroundColor: Colors.blue[100],
                                radius: 44,
                                backgroundImage: !consultationData.expertId!
                                            .containsKey("imageUrl") ||
                                        consultationData
                                                .expertId!["imageUrl"] ==
                                            ""
                                    ? const AssetImage(
                                        "assets/icons/user.png",
                                      ) as ImageProvider
                                    : NetworkImage(
                                        consultationData.expertId!["imageUrl"]!,
                                      ),
                              ),
                            ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: consultationData.status != "initiated"
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${value.consultationDetails.user![0]["firstName"]} ${value.consultationDetails.user![0]["lastName"]}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        if (consultationData.status !=
                                            "initiated")
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Text(
                                                consultationData
                                                        .expertiseId!.isNotEmpty
                                                    ? consultationData
                                                        .expertiseId![0]["name"]
                                                    : "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge),
                                          ),
                                      ],
                                    )
                                  : const Text("Free Consultation"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (consultationData.status != "initiated")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(consultationData.expertiseId!.isNotEmpty
                            ? consultationData.expertiseId![0]["name"]
                            : ""),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (consultationData.status != "initiated")
                            InkWell(
                              onTap: () {
                                // log(consultationData.expertId!["_id"]);
                                // log(value.consultationDetails.userId!);
                                log("Enable dash chat");

                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) {
                                //     return ChatScreen(
                                //       expertId:
                                //           consultationData.expertId!["_id"],
                                //       consultationId: consultationData.id!,
                                //       userId:
                                //           value.consultationDetails.userId!);
                                //   },
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
                          if (consultationData.status ==
                                  "meetingLinkGenerated" ||
                              consultationData.status == "expertAssigned")
                            InkWell(
                              onTap: !StringDateTimeFormat()
                                      .checkForVideoCallValidation(
                                          consultationData.startTime!,
                                          consultationData.startDate!)
                                  ? () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => VideoCall1(
                                            onVideoCallEnds: () {},
                                            meetingId: value.consultationDetails
                                                .meetingLink,
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
                        ],
                      ),
                    ),
                    Consumer<SubscriptionsData>(
                      builder: (context, value, child) => ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.subsData.length,
                        itemBuilder: (context, index) => Card(
                          child: Column(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
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
                                      value.subsData[index].packageName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        value.subsData[index].status! ==
                                                "paymentReceived"
                                            ? const Text("Paid")
                                            : const Text("Payment Pending"),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            "\u{20B9}${value.subsData[index].netAmount!}"),
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
                                          Text(value.subsData[index].startDate!)
                                        ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
      ],
    );
  }
}
