import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/all_consultations_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/expert_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class MyExpertsScreen extends StatefulWidget {
  const MyExpertsScreen({Key? key}) : super(key: key);

  @override
  State<MyExpertsScreen> createState() => _MyExpertsScreenState();
}

class _MyExpertsScreenState extends State<MyExpertsScreen> {
  bool isLoading = false;
  Future<void> getConsultations() async {
    setState(() {
      isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<AllConsultationsData>(context, listen: false)
          .getAllConsultationsData(userId, status: "scheduled");
    } on HttpException catch (e) {
      log("fetch all consultations error http $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting consultations $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getConsultations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'My Experts'),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Consumer<AllConsultationsData>(
                builder: (context, value, child) =>
                value.physioConsultation.isEmpty && value.wmConsultation.isEmpty && value.healthCareConsultation.isEmpty ?
                const Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Text("No Experts Assigned"),
                  ),
                ) :
                    Column(
                  children: [
                    if(value.physioConsultation.isNotEmpty)
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.physioConsultation.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const ExpertScreen();
                                }));
                              },
                              leading: const CircleAvatar(
                                radius: 32,
                              ),
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${value.physioConsultation[index].expertId![0]["firstName"]} ${value.physioConsultation[index].expertId![0]["lastName"]}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.grey[700]);
                        },
                      ) ,
                    if(value.wmConsultation.isNotEmpty)
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.wmConsultation.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const ExpertScreen();
                                }));
                              },
                              leading: const CircleAvatar(
                                radius: 32,
                              ),
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${value.wmConsultation[index].expert![0]["firstName"]} ${value.wmConsultation[index].expert![0]["lastName"]}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.grey[700]);
                        },
                      ) ,
                    if(value.healthCareConsultation.isNotEmpty)

                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.healthCareConsultation.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const ExpertScreen();
                                }));
                              },
                              leading: const CircleAvatar(
                                radius: 32,
                              ),
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${value.healthCareConsultation[index].expertId![0].firstName} ${value.healthCareConsultation[index].expertId![0].lastName}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.grey[700]);
                        },
                      )
                  ],
                ),
              ),
            ),
    );
  }
}
