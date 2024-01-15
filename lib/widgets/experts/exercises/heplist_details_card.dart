import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/patients.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/experts/patients_data.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:provider/provider.dart';

class HEPlistDetailsCard extends StatefulWidget {
  final WorkoutModel workoutModel;
  final Function func;
  final bool isSelectClient;
  final String clientId;
  const HEPlistDetailsCard({
    Key? key,
    required this.workoutModel,
    required this.func,
    this.isSelectClient = false,
    this.clientId = "",
  }) : super(key: key);

  @override
  State<HEPlistDetailsCard> createState() => _HEPlistDetailsCardState();
}

class _HEPlistDetailsCardState extends State<HEPlistDetailsCard> {
  List<Patients> data = [];
  String companyId = "";

  void setPatientsData() {
    data = Provider.of<PatientsData>(context, listen: false).patientData;
  }

  // Future<void> getClientList(String keyword) async {
  //   Map<String, String> pData = {
  //     "flow": "consultation",
  //   };

  //   String topLExp =
  //       Provider.of<UserData>(context, listen: false).userData.topLevelExpName!;
  //   if (topLExp == "Dietitian") {
  //     pData["type"] = "weightManagement";
  //   } else {
  //     pData["type"] = "physio";
  //   }

  //   await GetClients().getPatientData(context, pData);
  //   setPatientsData.call();
  // }

  void popScreen() {
    Navigator.of(context).pop();
  }

  Future<void> assignWorkoutPlan() async {
    try {
      await Provider.of<WorkoutProvider>(context, listen: false)
          .assignWorkoutPlan({
        "workoutPlanId": widget.workoutModel.id,
        "userId": widget.clientId,
      });
      popScreen();
    } on HttpException catch (e) {
      log("error assigning user ${e.toString}");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error assigning user ${e.toString}");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  void saveCompanyDropdownId(String id) => companyId = id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 5,
      ),
      child: Card(
        child: InkWell(
          onTap: () {
            widget.func();
          },
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 120),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/03/19/18/idoh-exercise.jpg?width=1200"),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.workoutModel.name ?? "",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        widget.workoutModel.description ?? "",
                        maxLines: 3,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (widget.isSelectClient)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        showSendDialog(context));
                              },
                              child: const Text("Assign"),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Dialog showSendDialog(BuildContext context) {
    return Dialog(
      backgroundColor: darkGrey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Prescribe to client"),
            const SizedBox(
              height: 10,
            ),
            const Text("Are you sure you want to assign this to this client?"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    assignWorkoutPlan();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Send"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
