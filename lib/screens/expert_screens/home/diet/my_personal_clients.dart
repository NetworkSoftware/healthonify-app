import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/patients.dart';
import 'package:healthonify_mobile/providers/experts/patients_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/client_details/expert_clientdetails_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyPersonalClients extends StatelessWidget {
  MyPersonalClients({Key? key}) : super(key: key);

  final Map<String, String> pData = {
    'expertId': '',
    "flow": 'consultation',
    "type": "physio"
  };
  bool _noContent = false;

  Future<void> getPatientData(BuildContext context) async {
    String topLExp =
        Provider.of<UserData>(context, listen: false).userData.topLevelExpName!;

    log("top level exp set cards $topLExp");
    if (topLExp == "Dietitian") {
      pData["type"] = "weightManagement";
    }
    if (topLExp == "Physiotherapy") {
      pData["type"] = "physio";
    }
    if (topLExp == "Health Care") {
      pData["type"] = "healthCare";
    }

    String userid = Provider.of<UserData>(context, listen: false).userData.id!;
    pData['expertId'] = userid;
    // log(pData.toString());
    try {
      await Provider.of<PatientsData>(context, listen: false)
          .fetchPatientData(pData);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
      _noContent = true;
    } catch (e) {
      log("Error fetching patient data $e");
      Fluttertoast.showToast(msg: "Error : $e");
      _noContent = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: Text(
              'Select Client',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // actions: [
            //   // appBarBtn(context),
            // ],
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            iconTheme: Theme.of(context)
                .iconTheme
                .copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
            bottom: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              automaticallyImplyLeading: false,
              title: SizedBox(
                width: double.infinity,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 5),
                  child: TextField(
                    cursorColor: whiteColor,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: whiteColor),
                    decoration: InputDecoration(
                      fillColor: orange,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Search client',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: whiteColor),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Other Sliver Widgets
          SliverList(
            delegate: SliverChildListDelegate(
              [
                FutureBuilder(
                  future: getPatientData(context),
                  builder: (context, snapshot) => snapshot.connectionState ==
                          ConnectionState.waiting
                      ? const Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _noContent
                          ? const Center(
                              child: Text("No patients available"),
                            )
                          : Consumer<PatientsData>(
                              builder: (context, data, child) {
                                return ListView(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: data.patientData.length,
                                      itemBuilder: (_, index) => _clientCard(
                                          context, data.patientData[index]),
                                    ),
                                    const SizedBox(
                                      height: 70,
                                    ),
                                  ],
                                );
                              },
                              //     ListView.builder(
                              //   shrinkWrap: true,
                              //   physics: const BouncingScrollPhysics(),
                              //   itemCount: data.patientData.length,
                              //   itemBuilder: (context, index) {
                              //     return Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //         horizontal: 10,
                              //         vertical: 5,
                              //       ),
                              //       child: DietClientCard(
                              //         clientId:
                              //             data.patientData[index].clientId!,
                              //         imageUrl: data.patientData[index]
                              //                 .imageUrl ??
                              //             "",
                              //         patientName:
                              //             '${data.patientData[index].firstName!} ${data.patientData[index].lastName!}',
                              //         patientEmail:
                              //             data.patientData[index].email!,
                              //         patientContact:
                              //             data.patientData[index].mobileNo!,
                              //         location: "" ', ' "" ', ' "",
                              //       ),
                              //     );
                              //   },
                              // ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String topLExp = "";
  Widget _clientCard(BuildContext context, Patients data) {
    topLExp = Provider.of<UserData>(context).userData.topLevelExpName!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Card(
          child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExpertClientDetails(
                clientId: data.clientId!,
                clientName: data.firstName!,
                patientData: data,
                topLevelExp: topLExp,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data.firstName} ${data.lastName}",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // Text(
                    //   data.mobileNo!,
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "This is the about of the client",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).textTheme.bodySmall!.color,
                          ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Flexible(
                flex: 1,
                child: CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 70,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
