import 'dart:math';

import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/batches/batches_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/batch_providers/batch_provider.dart';
import 'package:healthonify_mobile/providers/start_live_session.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/client_details/expert_connected_clients.dart';
import 'package:healthonify_mobile/screens/expert_screens/my_clients.dart';
import 'package:healthonify_mobile/screens/expert_screens/view_appoinments.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:provider/provider.dart';

class HomeTopAppointmentsCard extends StatefulWidget {
  const HomeTopAppointmentsCard({Key? key}) : super(key: key);

  @override
  State<HomeTopAppointmentsCard> createState() =>
      _HomeTopAppointmentsCardState();
}

class _HomeTopAppointmentsCardState extends State<HomeTopAppointmentsCard> {
  bool isLoading = true;
  late String expertId;
  List<BatchModel> batches = [];

  Future<void> getAllBatches() async {
    expertId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      batches = await Provider.of<BatchProvider>(context, listen: false)
          .getBatches(expertId);
    } on HttpException {
      // log(e.toString());
      Fluttertoast.showToast(msg: 'Error fetching batches');
      return;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching batches');
      return;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  String? meetingAndConsultationId;

  Map<String, dynamic> startLiveSessionMap = {};

  Future<void> startLive() async {
    try {
      await Provider.of<StartLiveSessionProvider>(context, listen: false)
          .startSession(startLiveSessionMap);

      goToVideoScreen();
      Fluttertoast.showToast(msg: "Live session started");
    } on HttpException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unable to initiate live session');
      // dev.log(e.toString());
    }
  }

  void goToVideoScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return VideoCall1(
        onVideoCallEnds: () {},
        meetingId: meetingAndConsultationId,
      );
    }));
  }

  void onSubmit(String sessionName, List<String> users) {
    meetingAndConsultationId = getRandomString(10);

    startLiveSessionMap['expertId'] = expertId;
    if (users.isNotEmpty) {
      startLiveSessionMap['userId'] = users;
    } else {
      Fluttertoast.showToast(msg: 'Select clients');
      return;
    }
    startLiveSessionMap['date'] =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    startLiveSessionMap['time'] = DateFormat('HH:mm').format(DateTime.now());
    startLiveSessionMap['meetingLink'] = meetingAndConsultationId;
    startLiveSessionMap['screen'] = 'videoCall';
    startLiveSessionMap['consultationId'] = meetingAndConsultationId;
    startLiveSessionMap['sessionName'] = sessionName;

    startLive();
  }

  @override
  void initState() {
    super.initState();
    getAllBatches();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flexible(
                //   child: Text(
                //     "Today's appointments",
                //     style: Theme.of(context).textTheme.labelLarge,
                //   ),
                // ),
                // Flexible(
                //   child: TextButton.icon(
                //     onPressed: () {
                //       showDatePicker(
                //         context: context,
                //         builder: (context, child) {
                //           return Theme(
                //             data: datePickerDarkTheme,
                //             child: child!,
                //           );
                //         },
                //         initialDate: DateTime.now(),
                //         firstDate: DateTime(1800),
                //         lastDate: DateTime(2200),
                //       ).then((value) {
                //         if (value != null) {
                //           timePicker(context, value);
                //         }
                //         // Navigator.of(context, /*rootnavigator: true*/)
                //         //     .push(MaterialPageRoute(builder: (context) {
                //         //   return const AddAppointmentScreen();
                //         // }));
                //       });
                //     },
                //     icon: const Icon(
                //       Icons.add,
                //     ),
                //     label: Text(
                //       'Add new',
                //       style: Theme.of(context).textTheme.bodySmall!.copyWith(
                //             color: orange,
                //           ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const ViewAppointmentScreen();
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Your Appointments',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: whiteColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showBottomDialog(context);
                      // _joinMeeting();
                    },
                    icon: const Icon(
                      Icons.live_tv_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Start live session',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: whiteColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showBottomDialog(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).canvasColor,
      builder: (context) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add session topic',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: orange,
                        size: 26,
                      ),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                textFields(context, 'Enter topic name'),
                // textFi elds(context, 'Zoom/Google Meet link (optional)'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: GradientButton(
                    title: 'SUBMIT',
                    func: () {
                      Navigator.pop(context);
                      showPopUp(context);
                    },
                    gradient: orangeGradient,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPopUp(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Select an option',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: Theme.of(context).canvasColor,
                          elevation: 0,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(
                                context, /*rootnavigator: true*/
                              ).push(MaterialPageRoute(builder: (context) {
                                return MyClientScreen(
                                  sessionName: sessionName!,
                                );
                              }));
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Select Clients',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: Theme.of(context).canvasColor,
                          elevation: 0,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              showSecondSheet(context);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Select a Batch',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSecondSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Batch',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: orange,
                        size: 26,
                      ),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
              batches.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Text('No Batches available'),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: batches.length,
                      itemBuilder: (context, index) {
                        DateTime sTime = DateFormat('HH:mm')
                            .parse(batches[index].startTime!);
                        DateTime eTime =
                            DateFormat('HH:mm').parse(batches[index].endTime!);

                        String startTime = DateFormat('h:mm a').format(sTime);
                        String endTime = DateFormat('h:mm a').format(eTime);
                        return InkWell(
                          onTap: batches[index].userIds!.isEmpty
                              ? () {
                                  Fluttertoast.showToast(
                                    msg: 'No Users enrolled',
                                  );
                                  return;
                                }
                              : () {
                                  onSubmit(
                                    batches[index].name!,
                                    batches[index].userIds!,
                                  );
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      batches[index].name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                    Text(
                                      'Time : $startTime to $endTime',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      '${batches[index].userIds!.length} Clients enrolled',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  String? sessionName;

  Widget textFields(context, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          fillColor: Theme.of(context).canvasColor,
          filled: true,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xFF717579),
              ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: whiteColor,
        onChanged: (value) {
          setState(() {
            sessionName = value;
          });
        },
      ),
    );
  }

  void timePicker(context, DateTime date) {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        Map<String, dynamic> data = {
          "userId": "",
          "startTime": "${value.hour}:${value.minute}:00",
          "startDate": DateFormat("yyyy-MM-dd").format(date),
          "type": "free",
          "status": "initiated",
          "durationInMinutes": "30",
          "expertId": Provider.of<UserData>(context, listen: false).userData.id,
        };

        Navigator.of(
          context, /*rootnavigator: true*/
        ).push(
          MaterialPageRoute(
              builder: (context) => ExpertConnectedClients(
                    data: data,
                    isFromAddNew: true,
                    title: "Select a client",
                  )),
        );
        // log(data.toString());
      }
    });
  }
}
