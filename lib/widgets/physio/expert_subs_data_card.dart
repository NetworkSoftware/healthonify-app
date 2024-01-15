import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/physiotherapy/consultation_session.dart';
import 'package:healthonify_mobile/screens/video_call_1.dart';

class ExpertSubsDataCard extends StatelessWidget {
  final Session session;
  const ExpertSubsDataCard({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Session ${session.data["order"]}",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.label_important_outline),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${session.data["name"]!}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.punch_clock),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            StringDateTimeFormat()
                                .stringToTimeOfDay(session.data["startTime"]!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.date_range),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                StringDateTimeFormat().stringtDateFormat(
                                    session.data["startDate"]!),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timelapse),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${session.data["durationInMinutes"]!.toString()} mins",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (session.data["status"] == "stored" ||
                        session.data["status"] == "created")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Session Created",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          InkWell(
                            onTap: () {
                              // log(session.data.toString());
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VideoCall1(
                                    onVideoCallEnds: () {},
                                    meetingId: session.data["videoCallLink"],
                                  ),
                                ),
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
                        ],
                      ),
                    if (session.data["status"] == "sessionEnded")
                      Text(
                        "Session completed",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateVideoCall() {
    String time = session.data["startTime"];
    log(StringDateTimeFormat().stringToTimeOfDay(time));
    var result = StringDateTimeFormat()
        .checkForVideoCallValidation(time, session.data["startDate"]);

    return result;
  }
}
