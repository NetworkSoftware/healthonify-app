import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/get_clients.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/patients.dart';
import 'package:healthonify_mobile/providers/experts/patients_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/consult_now_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/client_details/expert_clientdetails_screen.dart';
import 'package:healthonify_mobile/screens/succes_screens/successful_update.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class ExpertConnectedClients extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? data;
  final bool isFromAddNew;
  const ExpertConnectedClients({
    Key? key,
    this.title = "Connected Clients",
    this.data,
    this.isFromAddNew = false,
  }) : super(key: key);

  @override
  State<ExpertConnectedClients> createState() => _ExpertConnectedClientsState();
}

class _ExpertConnectedClientsState extends State<ExpertConnectedClients> {
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
    log("top level exp $topLExp");
    if (topLExp == "Dietitian") {
      pData["type"] = "weightManagement";
    }

    if (topLExp == "Health Care") {
      pData["type"] = "healthCare";
    }

    _noContent = await GetClients().getPatientData(context, pData);
  }

  Future<void> _initFreeConsultation(String userId) async {
    LoadingDialog().onLoadingDialog("Initiating", context);
    widget.data!["userId"] = userId;
    try {
      await Provider.of<ConsultNowData>(context, listen: false)
          .initiateFreeConsultNowForm(widget.data!);
      onSubmitSucess.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submit consultation form$e");
      Fluttertoast.showToast(msg: "Appointment request failed");
    } finally {
      Navigator.of(context).pop();
    }
  }

  void onSubmitSucess() {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SuccessfulUpdate(
          onSubmit: (ctx) {
            Navigator.of(ctx).pop();
          },
          title: "Appointment Initiated Succesfully",
          buttonTitle: "Back"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: widget.title,
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
                        : ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: data.patientData.length,
                                itemBuilder: (_, index) => _clientCard(
                                    context, data.patientData[index]),
                              ),
                              const SizedBox(
                                height: 70,
                              ),
                            ],
                          ),
                  ),
      ),
    );
  }

  Widget _clientCard(BuildContext context, Patients data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Card(
          child: InkWell(
        onTap: () {
          log(data.firstName.toString() + data.clientId.toString());
          if (widget.isFromAddNew) {
            _initFreeConsultation(data.clientId!);
            return;
          }
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
                    //add age and gender of the client here
                    // Text(
                    //   "Add age, gender",
                    //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    //         color: Theme.of(context).textTheme.bodySmall!.color,
                    //       ),
                    // )
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
