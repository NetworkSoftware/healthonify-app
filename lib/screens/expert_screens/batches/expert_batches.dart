import 'dart:math';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/get_clients.dart';
import 'package:healthonify_mobile/models/batches/batches_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/patients.dart';
import 'package:healthonify_mobile/providers/batch_providers/batch_provider.dart';
import 'package:healthonify_mobile/providers/experts/patients_data.dart';
import 'package:healthonify_mobile/providers/start_live_session.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/batches/create_batch.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class ExpertBatchesScreen extends StatefulWidget {
  const ExpertBatchesScreen({super.key});

  @override
  State<ExpertBatchesScreen> createState() => _ExpertBatchesScreenState();
}

class _ExpertBatchesScreenState extends State<ExpertBatchesScreen> {
  bool isLoading = true;
  List<BatchModel> batches = [];

  Future<void> getAllBatches() async {
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

  String topLExp = "";
  bool isloading = false;
  final Map<String, String> pData = {
    'expertId': '',
    "flow": 'consultation',
    "type": "physio",
  };

  bool noContent = false;
  Future<void> getClientList() async {
    topLExp =
        Provider.of<UserData>(context, listen: false).userData.topLevelExpName!;
    if (topLExp == "Dietitian") {
      pData["type"] = "weightManagement";
    }

    if (topLExp == "Health Care") {
      pData["type"] = "healthCare";
    }

    noContent = await GetClients().getPatientData(context, pData);
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

  late String expertId;

  @override
  void initState() {
    super.initState();

    expertId = Provider.of<UserData>(context, listen: false).userData.id!;

    getAllBatches().then((value) {
      getClientList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Batches'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : noContent
              ? showWhenNoClients(context)
              : Consumer<PatientsData>(
                  builder: (context, data, child) => data.patientData.isEmpty
                      ? showWhenNoClients(context)
                      : Column(
                          children: [
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: batches.length,
                                    itemBuilder: (context, index) {
                                      DateTime sTime = DateFormat('HH:mm')
                                          .parse(batches[index].startTime!);
                                      DateTime eTime = DateFormat('HH:mm')
                                          .parse(batches[index].endTime!);

                                      String startTime =
                                          DateFormat('h:mm a').format(sTime);
                                      String endTime =
                                          DateFormat('h:mm a').format(eTime);

                                      return Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${batches[index].name} (${batches[index].gender})',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          'Time : $startTime to $endTime',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          batches[index].info ??
                                                              "",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        addUserBottomSheet(
                                                          data.patientData,
                                                          batches[index].id!,
                                                        );
                                                      },
                                                      child: const Text(
                                                          'Add User'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: batches[index]
                                                              .userIds!
                                                              .isEmpty
                                                          ? () {
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg:
                                                                    'No Users enrolled',
                                                              );
                                                              return;
                                                            }
                                                          : () {
                                                              onSubmit(
                                                                batches[index]
                                                                    .name!,
                                                                batches[index]
                                                                    .userIds!,
                                                              );
                                                            },
                                                      child: const Text(
                                                          'Start live session'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: const BoxDecoration(
          color: orange,
        ),
        child: TextButton(
          onPressed: () {
            Navigator.of(
              context, /*rootnavigator: true*/
            ).push(MaterialPageRoute(builder: (context) {
              return const CreateBatchScreen();
            }));
          },
          child: Text(
            'Create Batch',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> joinBatch = {};
  void onJoin() {
    joinBatch['isActive'] = true;
    joinBatch['date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> joinBatches() async {
    try {
      await Provider.of<BatchProvider>(context, listen: false)
          .joinBatch(joinBatch);
      Fluttertoast.showToast(msg: 'User added to batch');
    } on HttpException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unable to add user to batch');
    }
  }

  void addUserBottomSheet(List<Patients> clients, String batchId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Client to Batch',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: clients.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${clients[index].firstName} ${clients[index].lastName}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            joinBatch['batchId'] = batchId;
                            joinBatch['userId'] = clients[index].clientId;
                          });
                          onJoin();
                          joinBatches();
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget showWhenNoClients(BuildContext context) {
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
