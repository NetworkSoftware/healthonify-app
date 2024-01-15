import 'dart:developer' as dev;
import 'dart:math';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/get_clients.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/experts/patients_data.dart';
import 'package:healthonify_mobile/providers/start_live_session.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class MyClientScreen extends StatefulWidget {
  final String? sessionName;
  const MyClientScreen({this.sessionName, Key? key}) : super(key: key);

  @override
  State<MyClientScreen> createState() => _MyClientScreenState();
}

class _MyClientScreenState extends State<MyClientScreen> {
  getUserData() async {
    SharedPrefManager prefs = SharedPrefManager();
    expertId = await prefs.getUserID();
  }

  String topLExp = "";
  bool isLoading = false;
  final Map<String, String> pData = {
    'expertId': '',
    "flow": 'consultation',
    "type": "physio",
  };
  bool _noContent = false;
  Future<void> getClientList(BuildContext context) async {
    topLExp = Provider.of<UserData>(context).userData.topLevelExpName!;
    if (topLExp == "Dietitian") {
      pData["type"] = "weightManagement";
    }

    if (topLExp == "Health Care") {
      pData["type"] = "healthCare";
    }

    _noContent = await GetClients().getPatientData(context, pData);
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

  List<String> userId = [];

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
      dev.log(e.toString());
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

  void onSubmit() {
    meetingAndConsultationId = getRandomString(10);

    startLiveSessionMap['expertId'] = expertId;
    if (userId.isNotEmpty) {
      startLiveSessionMap['userId'] = userId;
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
    startLiveSessionMap['sessionName'] = widget.sessionName;

    print(startLiveSessionMap.toString());
    startLive();
  }

  late String expertId;
  var userData;

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'My Clients',
      ),
      body: FutureBuilder(
        future: getClientList(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _noContent
                ? _showWhenNoClients(context)
                : Consumer<PatientsData>(
                    builder: (context, data, child) => data.patientData.isEmpty
                        ? _showWhenNoClients(context)
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                // ClientSearchBar(),
                                // Container(
                                //   height: 50,
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.95,
                                //   decoration: BoxDecoration(
                                //     border: Border.all(
                                //       color: const Color(0xFFAAAAAA),
                                //       width: 1,
                                //     ),
                                //     borderRadius: BorderRadius.circular(13),
                                //   ),
                                //   child: TextButton.icon(
                                //     onPressed: () {},
                                //     icon: const Icon(
                                //       Icons.person_add_alt,
                                //       color: Color(0xFFff7f3f),
                                //       size: 28,
                                //     ),
                                //     label: Text(
                                //       'Add Your Client',
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .bodySmall!
                                //           .copyWith(
                                //             color: Theme.of(context)
                                //                 .colorScheme
                                //                 .secondary,
                                //           ),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(height: 16),
                                ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.patientData.length,
                                  itemBuilder: (context, index) {
                                    return checkboxTile(
                                      false,
                                      "${data.patientData[index].firstName!} ${data.patientData[index].lastName!}",
                                      () {},
                                      index,
                                      data.patientData[index].clientId!,
                                    );
                                    // return ClientCard();
                                  },
                                ),
                              ],
                            ),
                          ),
                  ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: orangeGradient,
        ),
        child: TextButton(
          onPressed: () {
            onSubmit();
          },
          child: Text(
            'PROCEED',
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }

  Widget checkboxTile(bool isChecked, String? listTitle, Function updateAnswers,
      int index, String patientId) {
    return StatefulBuilder(
      builder: (context, newState) => Theme(
        data: ThemeData(
          unselectedWidgetColor: orange,
        ),
        child: CheckboxListTile(
          value: isChecked,
          title: Text(
            listTitle!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onChanged: (isTapped) {
            newState(() {
              isChecked = !isChecked;
            });
            if (isChecked == true) {
              userId.add(patientId);
            } else if (userId.isNotEmpty && isChecked == false) {
              userId.remove(patientId);
            } else {}

            print(userId.toString());
          },
          activeColor: const Color(0xFFff7f3f),
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }

  Widget _showWhenNoClients(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Icon(
              Icons.person,
              size: 75,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            Text(
              "You're not connected to any clients! Please connect to one using the dashboard",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
