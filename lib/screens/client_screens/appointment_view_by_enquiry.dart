import "dart:developer";

import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:healthonify_mobile/constants/theme_data.dart";
import "package:healthonify_mobile/func/string_date_format.dart";
import "package:healthonify_mobile/models/appointment_consultation/appointment_consultation_model.dart";
import "package:healthonify_mobile/models/http_exception.dart";
import "package:healthonify_mobile/providers/all_consultations_data.dart";
import "package:healthonify_mobile/providers/user_data.dart";
import "package:healthonify_mobile/screens/pay_now.dart";
import "package:healthonify_mobile/screens/video_call_1.dart";
import "package:healthonify_mobile/widgets/cards/custom_appBar.dart";
import "package:provider/provider.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

class AppointmentViewByEnquiry extends StatefulWidget {
  AppointmentViewByEnquiry(
      {Key? key, required this.ticketNumber, required this.flow})
      : super(key: key);
  String ticketNumber;
  String flow;

  @override
  State<AppointmentViewByEnquiry> createState() =>
      _AppointmentViewByEnquiryState();
}

class _AppointmentViewByEnquiryState extends State<AppointmentViewByEnquiry> {
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
    getConsultations();
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
                      "Consultation Details",
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
                      itemCount: value.consultationList.length,
                      itemBuilder: (context, index) {
                        return consultCard(
                            context, value.consultationList[index]);
                      }),
                ],
              ),
            ),
    );
  }

  Widget consultCard(BuildContext context, AppointmentConsultation consult) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${consult.expert!.first['firstName']} ${consult.expert!.first['lastName']}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text("${consult.expertiseId!.first['name']}")
                        ],
                      ),
                      // CircleAvatar(
                      //   backgroundColor: Colors.lightBlue,
                      //   backgroundImage: consult.expert!.first['imageUrl'].isEmpty
                      //       ? const AssetImage(
                      //           "assets/icons/user.png",
                      //         ) as ImageProvider
                      //       : NetworkImage(
                      //           consult.expert!.first['imageUrl'],
                      //         ),
                      //   radius: 35,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  infoRow(title: 'Ticket Number', value: consult.ticketNumber!),
                  infoRow(title: 'Date', value: consult.startDate!),
                  infoRow(title: 'Time', value: consult.startTime!),
                  infoRow(
                      title: 'Sub Category',
                      value: "${consult.subExpertiseId!.first['name']}"),
                  //infoRow(title: 'Type', value: consult.type!),
                  infoRow(
                      title: 'ConsultationCharge',
                      value: consult.consultationCharge!),
                  infoRow(title: 'Status', value: consult.status!),
                  const SizedBox(height: 20),
                  consult.status == "paymentRequested"
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () async {
                              bool result = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PayNowScreen(
                                    paymentUrl: consult.paymentLink!);
                              }));

                              if (result == true) {
                                getConsultations();
                              }
                              //launchUrl(Uri.parse(consult.paymentLink!));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: orange),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: const Text(
                                "Pay Now",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : consult.status == "consulationCompleted"
                          ? const SizedBox()
                          : consult.status == "closed" ? const SizedBox() :
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
                                        // const SizedBox(height: 10),
                                        // const Text('Chat'),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: StringDateTimeFormat()
                                          .checkForVideoCallSessionValidation(
                                              consult.startTime!,
                                              consult.startDate!)
                                      ? () {
                                          // Navigator.of(context).push(
                                          //   MaterialPageRoute(
                                          //     builder: (context) => VideoCall(
                                          //       meetingId: consult.id,
                                          //       onVideoCallEnds: () {},
                                          //     ),
                                          //   ),
                                          // );
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
                                        // const SizedBox(height: 10),
                                        // const Text('Video Call'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Comments from Expert",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          consult.comments!.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Text(consult.comments![index]["message"]),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 5),
                  itemCount: consult.comments!.length)
              : const Text(
                  "No Comment added yet",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, color: orange),
                ),
        ],
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

  Future<void> getConsultations() async {
    log(currentPage.toString());
    setState(() {
      _isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<AllConsultationsData>(context, listen: false)
          .getUserAllConsultationsData(widget.ticketNumber, widget.flow);
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
}
