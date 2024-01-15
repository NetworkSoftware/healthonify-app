// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/session_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/succes_screens/successful_update.dart';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:provider/provider.dart';

import '../../models/experts/upcoming_sessions.dart';

class SessionCard extends StatelessWidget {
  final UpcomingSessions data;
  SessionCard({Key? key, required this.data}) : super(key: key);

  bool _isloading = false;

  void pushScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SuccessfulUpdate(
          onSubmit: (ctx) {
            Navigator.of(ctx).pop();
          },
          buttonTitle: "Back",
          title:
              "Your session was updated succesfully. Next Session is assigned.",
        ),
      ),
    );
  }

  Future<void> _updateSession(BuildContext context, Map<String, dynamic> data,
      VoidCallback onSuccess) async {
    log(data.toString());
    String flow =
        Provider.of<UserData>(context, listen: false).userData.topLevelExpName!;
    try {
      await Provider.of<SessionData>(context, listen: false)
          .updateSession(data, flow);

      onSuccess.call();
    } on HttpException catch (e) {
      log("session card expert $e");
      Fluttertoast.showToast(msg: "Unable to update session");
      rethrow;
    } catch (e) {
      log("session card expert $e");
      Fluttertoast.showToast(msg: "Unable to update session");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    String id = Provider.of<UserData>(context, listen: false).userData.id!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SizedBox(
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(data.name!,
                          style: Theme.of(context).textTheme.displayLarge!),
                    ),
                    IconButton(
                      onPressed: StringDateTimeFormat()
                              .checkForVideoCallValidation(
                                  data.startTime!, data.startDate!)
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VideoCall1(
                                    onVideoCallEnds: () {},
                                    meetingId: data.videoCallLink,
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
                      icon: const Icon(
                        Icons.video_call,
                        size: 28,
                        color: Color(0xFF717579),
                      ),
                    ),
                  ],
                ),
                Text(
                  data.description!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(Icons.date_range),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Session ${data.order!}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(Icons.date_range),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            StringDateTimeFormat()
                                .stringtDateFormat(data.startDate!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(Icons.hourglass_top),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            data.durationInMinutes!.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(Icons.schedule),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            StringDateTimeFormat()
                                .stringToTimeOfDay(data.startTime!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(Icons.inventory),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      data.packageName!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            data.clientName!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    // const Spacer(),
                    data.status != "sessionEnded"
                        ? StatefulBuilder(builder: (context, setState) {
                            return Flexible(
                              child: _isloading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: () async {
                                        setState(
                                          () => _isloading = true,);
                                        String subId =
                                            data.subscription!["_id"];
                                        String newString =
                                            subId.substring(subId.length - 4);

                                        try {
                                          await _updateSession(context, {
                                            "sessionId": data.id,
                                            "startTime": data.startTime,
                                            "startDate": data.startDate,
                                            "userId": id,
                                            "status": "sessionEnded",
                                            "subscriptionId":
                                                data.subscription!["_id"],
                                            "specialExpertId":
                                                data.specialExpertId,
                                            "videoCallLink": DateTime.now()
                                                    .millisecondsSinceEpoch
                                                    .toString() +
                                                newString
                                          }, () {
                                            pushScreen(context);
                                          });
                                        } catch (e) {
                                          log(e.toString());
                                        } finally {
                                          setState(
                                            () => _isloading = false,);
                                        }
                                      },
                                      child: const Text("Mark As done")),
                            );
                          })
                        : const Flexible(child: Text("Completed")),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
