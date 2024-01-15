import 'dart:developer';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/health_care/hc_consultation.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_consultations_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/prescription_screen.dart';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ExpertViewHcConsultations extends StatefulWidget {
  final String? clientId;
  final bool isHomeFlow;
  final String? title;

  const ExpertViewHcConsultations(
      {Key? key,
      required this.clientId,
      this.isHomeFlow = false,
      this.title = "My Consultations"})
      : super(key: key);

  @override
  State<ExpertViewHcConsultations> createState() =>
      _ExpertViewHcConsultationsState();
}

class _ExpertViewHcConsultationsState extends State<ExpertViewHcConsultations> {
  bool _isLoading = false;
  List<HcConsultation> data = [];
  var snackBar = const SnackBar(
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text('No more Appointments!'),
    ),
    duration: Duration(milliseconds: 1000),
  );
  int currentPage = 0;

  final RefreshController _refreshController = RefreshController();
  ZIMRoomInfo roomInfo = ZIMRoomInfo();
  late String expertId;

  @override
  void initState() {
    //added the pagination function with listener
    expertId = Provider.of<UserData>(context, listen: false).userData.id!;
    getData(firstTime: true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  void getData({bool firstTime = false}) async {
    setState(() {
      _isLoading = true;
    });
    await getConsultations(
      context,
      firstTime,
    );
    setState(() {
      _isLoading = false;
    });
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  List<HcConsultation> hcConsultation = [];

  Future<bool> getConsultations(
    BuildContext context,
    bool firstTime, {
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentPage = 0;
    }
    log(currentPage.toString());

    try {
      String urlExt = "expertId=$expertId&userId=${widget.clientId}";
      if (widget.isHomeFlow) {
        urlExt = "expertId=$expertId";
      }
      hcConsultation = await Provider.of<HealthCareConsultationProvider>(
              context,
              listen: false)
          .getConsultation(urlExt, currentPage.toString());

      log(hcConsultation.length.toString());

      if (isRefresh) {
        data = hcConsultation;
        return true;
      }
      if (hcConsultation.length != 20) {
        if (currentPage == 0 && !firstTime) {
          data = hcConsultation;
          _refreshController.loadNoData();
          showSnackBar();
          return true;
        } else {
          // log("hey");
          data.addAll(hcConsultation);
        }
      } else {
        data.addAll(hcConsultation);
      }

      currentPage = currentPage + 1;
      setState(() {});
      return true;
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      return false;
    } catch (e) {
      log("Error getting consultations $e");
      Fluttertoast.showToast(msg: "Unable to fetch consultations");
      return false;
    } finally {
      // setState(() {
      //   _isPaginationLoading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: "${widget.title}"),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : data.isEmpty
              ? const Center(
                  child: Text("No appointments available"),
                )
              : SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  footer: footer,
                  onRefresh: () async {
                    final result =
                        await getConsultations(context, false, isRefresh: true);
                    if (result) {
                      _refreshController.refreshCompleted();
                    } else {
                      _refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async {
                    final result = await getConsultations(context, false);
                    if (result) {
                      _refreshController.loadComplete();
                    } else {
                      _refreshController.loadFailed();
                    }
                  },
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        if (data[index].status == "initiated") {
                          // return expertCardFree(context, data[index]);
                          return expertCardPaid(context, data[index], index);
                        }
                        return expertCardPaid(context, data[index], index);

                        // return expertCardPaid(context, data[index]);
                      }),
                ),
    );
  }

  Widget expertCardPaid(
      BuildContext context, HcConsultation consultationData, int index) {
    final date = StringDateTimeFormat()
        .stringtDateFormatLogWeight(consultationData.startDate!);
    final time =
        StringDateTimeFormat().stringToTimeOfDay(consultationData.startTime!);

    print("Time : $time");
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
                        const SizedBox(height: 8),
                        Text(
                          "Ticket Number : ${consultationData.ticketNumber!}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.videocam_outlined,
                              size: 20,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              consultationData.status!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontSize: 15),
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
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
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
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          consultationData.description ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 36,
                        backgroundImage: !consultationData.expert![0]
                                    .containsKey("imageUrl") ||
                                consultationData.expert![0]["imageUrl"] == ""
                            ? const AssetImage(
                                "assets/icons/user.png",
                              ) as ImageProvider
                            : NetworkImage(
                                consultationData.expert![0]["imageUrl"]!,
                              ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        consultationData.userId![0]["firstName"] +
                            " " +
                            consultationData.userId![0]["lastName"],
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    print("name : ${widget.clientId}");

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ZIMKitMessageListPage(
                        conversationID: widget.clientId!,
                        conversationType: ZIMConversationType.peer,
                      );
                    }));

                    // roomInfo.roomID = consultationData.ticketNumber!;
                    // roomInfo.roomName = consultationData.ticketNumber!;
                    //
                    // ZIMRoomAdvancedConfig advancedConfig =
                    //     ZIMRoomAdvancedConfig();
                    // ZIM
                    //     .getInstance()!
                    //     .enterRoom(roomInfo, advancedConfig)
                    //     .then((value) => {
                    //       print("Value: ${value.roomInfo}")
                    //
                    //         })
                    //     .catchError((onError) {
                    //   // enter This will be triggered when operation failed.
                    // });
                    // ZIMKit().showDefaultNewPeerChatDialog(context);
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
                const SizedBox(width: 40),
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
                                onVideoCallEnds: () {
                                  //! add prescription screen
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return PrescriptionScreen(
                                      consultationId: consultationData.id!,
                                      expertId: expertId,
                                      userId: hcConsultation[index].userId![0]
                                          ["_id"],
                                      ticketNumber:
                                          consultationData.ticketNumber!,
                                    );
                                  }));
                                },
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
                const SizedBox(width: 30),
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PrescriptionScreen(
                        consultationId: consultationData.id!,
                        expertId: expertId,
                        userId: hcConsultation[index].userId![0]["_id"],
                        ticketNumber: consultationData.ticketNumber!,
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
                        const Text('Prescription'),
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

  CustomFooter footer = CustomFooter(
    builder: (context, mode) {
      Widget? body;
      if (mode == LoadStatus.idle) {
        body = const Text("");
      } else if (mode == LoadStatus.loading) {
        body = const CupertinoActivityIndicator();
      } else if (mode == LoadStatus.failed) {
        body = const Text("Load Failed!Click retry!");
      } else if (mode == LoadStatus.canLoading) {
        body = const Text("Release to load more");
      } else if (mode == LoadStatus.noMore) {
        body = const Text("No more Appointments");
      } else {
        body = const Text("No more Data");
      }
      return SizedBox(
        height: 55.0,
        child: Center(child: body),
      );
    },
  );
}
