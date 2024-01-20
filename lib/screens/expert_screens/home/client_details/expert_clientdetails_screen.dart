import 'dart:developer';

import 'package:healthonify_mobile/screens/edit_profile_screens.dart/edit_profile.dart';
import 'package:healthonify_mobile/screens/expert_screens/assigned_workout.dart';
import 'package:healthonify_mobile/screens/expert_screens/experts_all_appointment.dart';
import 'package:healthonify_mobile/screens/expert_screens/experts_prescription_screen.dart';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/expert/client_details_options_cardlist.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/patients.dart';
import 'package:healthonify_mobile/providers/start_live_session.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/body_measurements/body_measurements.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_form/view_fitness_form.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/medical_history.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/expert_consultation_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/expert_packages_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/my_diet_plans_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/hep/assign_hep.dart';
import 'package:healthonify_mobile/screens/expert_screens/medical_form_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/user_form_screen.dart';
import 'package:healthonify_mobile/screens/lifestyle_details.dart';
import 'package:healthonify_mobile/screens/my_diary/my_diary.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:provider/provider.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
//import 'package:sendbird_sdk/utils/string_utils.dart';

import '../../../client_screens/health_care/medical_reports/medical_reports.dart';
import '../../../client_screens/health_locker/health_locker.dart';
import '../../../client_screens/vitals_screens/vitals_screen.dart';

class ExpertClientDetails extends StatefulWidget {
  final String clientId;
  final String clientName;
  final Patients patientData;
  final String topLevelExp;
  const ExpertClientDetails(
      {Key? key,
      required this.clientId,
      required this.patientData,
      required this.topLevelExp,
      required this.clientName})
      : super(key: key);

  @override
  State<ExpertClientDetails> createState() => _ExpertClientDetailsState();
}

class _ExpertClientDetailsState extends State<ExpertClientDetails> {
  List checkTopLevel() {
    log("heyyyy ${widget.topLevelExp}");
    if (widget.topLevelExp == "Physiotherapy") {
      return optiondCardList;
    }
    if (widget.topLevelExp == "Dietitian") {
      return optiondCard2List;
    }

    if (widget.topLevelExp == "Health Care") {
      return optiondCard3List;
    }

    if (widget.topLevelExp == "Fitness" ||
        widget.topLevelExp == "Manage Weight") {
      return optiondCard4List;
    }
    return [];
  }

  List listOfCards = [];

  @override
  void initState() {
    super.initState();
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    String userName =
        Provider.of<UserData>(context, listen: false).userData.firstName!;

    ZIMKit().connectUser(id: userId, name: userName);
  }

  @override
  Widget build(BuildContext context) {
    listOfCards = checkTopLevel();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ZIMKitMessageListPage(
                  conversationID: widget.clientId,
                  conversationType: ZIMConversationType.peer,
                );
              }));
            },
            padding: const EdgeInsets.all(0),
            icon: const Icon(Icons.chat),
            splashRadius: 25,
          )
        ],
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        actionsIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        children: [
          ClientDetailsHeader(patientData: widget.patientData),
          // _clientAboutCard(context),
          _optionsCard(context),
          // _prescribedExercisesCard(context),
        ],
      ),
    );
  }

  Widget _clientAboutCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec quis lectus justo. Nam at vehicula massa.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionsCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          childAspectRatio: 2 / 1.5,
        ),
        itemCount: listOfCards.length,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Card(
            elevation: 0,
            child: InkWell(
              onTap: () {
                if (listOfCards[index]["title"] == "Consultation") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ExpertConsultationScreen(
                              clientId: widget.clientId,
                            )),
                  );
                }

                if (listOfCards[index]["title"] == "Packages") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExpertPackagesScreen(
                        clientId: widget.clientId,
                      ),
                    ),
                  );
                }
                if (listOfCards[index]["title"] == "Prescribe Hep") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AssignHep(
                        title: "HEP",
                        clientId: widget.clientId,
                      ),
                    ),
                  );
                }
                if (listOfCards[index]["title"] == "Workout") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AssignHep(
                        title: "HEP",
                        clientId: widget.clientId,
                      ),
                    ),
                  );
                }

                if (listOfCards[index]["title"] == "Diet Plan") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyDietPlans(
                          isFromClient: true, clientId: widget.clientId),
                    ),
                  );
                }

                if (listOfCards[index]["title"] == "Measurements") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BodyMeasurementsScreen(
                          isFromClient: true, clientId: widget.clientId),
                    ),
                  );
                }
                if (listOfCards[index]["title"] == "Prescription") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PrescriptionExpertsScreen(
                      userId: widget.clientId,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "User Diary") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyDiary(
                        isFromClient: true,
                        clientId: widget.clientId,
                      ),
                    ),
                  );
                }

                if (listOfCards[index]["title"] == "Weight Logs") {
                  Navigator.of(
                    context, /*rootnavigator: true*/
                  ).push(MaterialPageRoute(builder: (context) {
                    return WeightScreen(
                      isFromClient: true,
                      clientId: widget.clientId,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "Medical Form") {
                  Navigator.of(
                    context, /*rootnavigator: true*/
                  ).push(MaterialPageRoute(builder: (context) {
                    return MedicalFormScreen(
                      isFromClient: true,
                      clientId: widget.clientId,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "Live Session") {}
                if (listOfCards[index]["title"] == "User Form") {
                  Navigator.of(
                    context, /*rootnavigator: true*/
                  ).push(MaterialPageRoute(builder: (context) {
                    return UserFormScreen(clientId: widget.clientId);
                  }));
                }
                if (listOfCards[index]["title"] == "Assigned Workout") {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) {
                    return const AssignedWorkout();
                  }));
                }
                if (listOfCards[index]["title"] == "Appointments") {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) {
                    return const ExpertsAllAppointment();
                  }));
                }
                if (listOfCards[index]["title"] == "Fitness Form") {
                  Navigator.of(
                    context, /*rootnavigator: true*/
                  ).push(MaterialPageRoute(builder: (context) {
                    return ViewMyFitnessForm(
                      isFromClient: true,
                      clientId: widget.clientId,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "Lifestyle History") {
                  Navigator.of(
                    context, /*rootnavigator: true*/
                  ).push(MaterialPageRoute(builder: (context) {
                    return LifestyleDetailsScreen(clientId: widget.clientId);
                  }));
                }
                if (listOfCards[index]["title"] == "Lifestyle") {
                  Navigator.of(
                    context, /*rootnavigator: true*/
                  ).push(MaterialPageRoute(builder: (context) {
                    return LifestyleDetailsScreen(clientId: widget.clientId);
                  }));
                }

                if (listOfCards[index]["title"] == "Profile") {
                  Navigator.of(
                    context, /*rootnavigator: true*/
                  ).push(
                    MaterialPageRoute(
                      builder: (context) => const YourProfileScreen(),
                    ),
                  );
                }
                if (listOfCards[index]["title"] == "Medical Details") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MedicalHistoryScreen(
                      userId: widget.clientId,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "Vitals") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return VitalsScreen(
                      userId: widget.clientId,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "Health Locker") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HealthLockerScreen(
                      userId: widget.clientId,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "Lab Report") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyReportsScreen(
                      userId: widget.clientId,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "Weight Log") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WeightScreen(
                      clientId: widget.clientId,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "Measurement") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BodyMeasurementsScreen(
                      clientId: widget.clientId,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "Diary") {
                  log(widget.clientId);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyDiary(
                      clientId: widget.clientId,
                      isFromClient: false,
                    );
                  }));
                }
                if (listOfCards[index]["title"] == "Start Consultation") {
                  showBottomDialog();
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      listOfCards[index]["icon"],
                      size: 30,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      listOfCards[index]["title"],
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
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
      log(e.toString());
    }
  }

  Map<String, dynamic> startLiveSessionMap = {};
  String? meetingAndConsultationId;

  void onSubmit() {
    //  meetingAndConsultationId = getRandomString(10);
    startLiveSessionMap['expertId'] =
        Provider.of<UserData>(context, listen: false).userData.id!;

    startLiveSessionMap['userId'] = [widget.clientId];

    startLiveSessionMap['date'] =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    startLiveSessionMap['time'] = DateFormat('HH:mm').format(DateTime.now());
    startLiveSessionMap['meetingLink'] = meetingAndConsultationId;
    startLiveSessionMap['screen'] = 'videoCall';
    startLiveSessionMap['consultationId'] = meetingAndConsultationId;
    startLiveSessionMap['sessionName'] = sessionName;

    log(startLiveSessionMap.toString());
    startLive();
  }

  void goToVideoScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return VideoCall1(
        onVideoCallEnds: () {},
        meetingId: meetingAndConsultationId,
      );
    }));
  }

  void showBottomDialog() {
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
                      onSubmit();
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

  Widget _prescribedExercisesCard(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Theme.of(context).colorScheme.secondary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                "1 prescribed exercises",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: whiteColor),
              ),
            ),
          ),
        ),
        const Text("Code commented hep plans will come here check code"),
        // ListView.builder(
        //     shrinkWrap: true,
        //     itemCount: 2,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemBuilder: (_, index) =>  HEPlistDetailsCard()),
      ],
    );
  }
}

class ClientDetailsHeader extends StatelessWidget {
  final Patients patientData;

  const ClientDetailsHeader({
    Key? key,
    required this.patientData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 90,
            child: Icon(
              Icons.person,
              size: 100,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "${patientData.firstName} ${patientData.lastName}",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              // const SizedBox(
              //   height: 2,
              // ),
              // Text(
              //   patientData.mobileNo!,
              //   style: Theme.of(context).textTheme.labelLarge!.copyWith(
              //       color: Theme.of(context).textTheme.bodySmall!.color),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
