import "dart:developer";

import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:healthonify_mobile/constants/theme_data.dart";
import "package:healthonify_mobile/func/string_date_format.dart";
import "package:healthonify_mobile/models/appointment_consultation/appointment_session_model.dart";
import "package:healthonify_mobile/providers/all_consultations_data.dart";
import "package:healthonify_mobile/providers/user_data.dart";
import "package:healthonify_mobile/screens/client_screens/client_session_comment.dart";
import "package:healthonify_mobile/screens/video_call_1.dart";
import "package:healthonify_mobile/widgets/cards/custom_appbar.dart";
import "package:provider/provider.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

import "../../models/http_exception.dart";

class AppointmentViewSessionByEnquiry extends StatefulWidget {
  AppointmentViewSessionByEnquiry({Key? key, required this.ticketNumber,required this.flow}) : super(key: key);
  String ticketNumber;
  String flow;
  @override
  State<AppointmentViewSessionByEnquiry> createState() => _AppointmentViewSessionByEnquiryState();
}

class _AppointmentViewSessionByEnquiryState extends State<AppointmentViewSessionByEnquiry> {
  bool _isLoading = false;
  int currentPage = 0;
  var snackBar = const SnackBar(
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text('No Data Found'),
    ),
    duration: Duration(milliseconds: 1000),
  );
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    getSessionConsultations();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: widget.ticketNumber),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Consumer<AllConsultationsData>(
        builder: (context, value, child) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10),
              child: Text(
                "Session Details",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: value.sessionConsultationList.length,
                itemBuilder: (context, index) {
                var list = value.sessionConsultationList..sort((a, b) => a.order.compareTo(b.order));
                  return consultCard(
                      context, list[index]);
                }),
          ],
        ),
      ),
    );
  }

  Widget consultCard(
      BuildContext context, AppointmentSessionConsultation consult) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoRow(
                      title: 'Session Number',
                      value: consult.sessionNumber!),
                  infoRow(
                      title: 'Status',
                      value: consult.status!),
                  consult.startDate != "" ?
                  infoRow(
                      title: 'Date',
                      value: consult.startDate!) : const SizedBox(),
                  consult.startTime != "" ?
                  infoRow(
                      title: 'Time',
                      value: consult.startTime!) : const SizedBox(),
                  const SizedBox(height: 20),
                  consult.status == "scheduled" ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: StringDateTimeFormat()
                            .checkForVideoCallValidation(
                            consult.startTime!,
                            consult.startDate!)
                            ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VideoCall1(
                                meetingId: consult.id,
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
                    ],
                  ) :
                      const SizedBox(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        bool result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return ClientSessionComment(
                                comment: consult.comment!,
                              );
                            }));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: orange,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: const Text(
                            "Comments",
                            style:
                            TextStyle(color: Colors.white),
                          )),
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getSessionConsultations() async {
    log(currentPage.toString());
    setState(() {
      _isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<AllConsultationsData>(context, listen: false)
          .getUserSessionConsultationsData(widget.ticketNumber,widget.flow);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting consultations $e");
      Fluttertoast.showToast(msg: "Unable to fetch consultations");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
